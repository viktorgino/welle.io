/******************************************************************************\
 * Copyright (c) 2016 Albrecht Lohofener <albrechtloh@gmx.de>
 *
 * Author(s):
 * Albrecht Lohofener
 *
 * Description:
 * Uses the cross correlation to find the OFDM spectrum inside the signal
 *
 *
 ******************************************************************************
 *
 * This program is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation; either version 2 of the License, or (at your option) any later
 * version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
 * details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program; if not, write to the Free Software Foundation, Inc.,
 * 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 *
\******************************************************************************/
#include "find_ofdm_spectrum.h"


	find_ofdm_spectrum::find_ofdm_spectrum (int16_t T_u,
	                                        int16_t carriers) {
	this	-> T_u		= T_u;
	this	-> carriers	= carriers;

	signal_buffer		= new DSPCOMPLEX [T_u];
	idealspectrum_buffer	= new DSPCOMPLEX [T_u * 2 - 1];
	correlation_buffer	= new DSPCOMPLEX [T_u * 2 - 1];

	memset (signal_buffer, 0, sizeof (DSPCOMPLEX) * T_u);
	memset (correlation_buffer, 0, sizeof (DSPCOMPLEX) * (T_u * 2 - 1));
	memset (idealspectrum_buffer, 0, sizeof (DSPCOMPLEX) * (T_u*2-1));

	this -> SpectrumPlan = fftwf_plan_dft_1d (T_u,
	                      reinterpret_cast <fftwf_complex *>(signal_buffer),
	                      reinterpret_cast <fftwf_complex *>(signal_buffer),
	                      FFTW_FORWARD, FFTW_ESTIMATE);

	this -> Spectrum2nPlan = fftwf_plan_dft_1d (T_u * 2 - 1,
                         reinterpret_cast <fftwf_complex *>(correlation_buffer),
                         reinterpret_cast <fftwf_complex *>(correlation_buffer),
                             FFTW_FORWARD, FFTW_ESTIMATE);

	this -> IdealSpectrumPlan = fftwf_plan_dft_1d (T_u * 2 - 1,
                       reinterpret_cast <fftwf_complex *>(idealspectrum_buffer),
                       reinterpret_cast <fftwf_complex *>(idealspectrum_buffer),
                             FFTW_FORWARD, FFTW_ESTIMATE);

	this -> CorrelationPlan = fftwf_plan_dft_1d (T_u * 2 - 1,
                       reinterpret_cast <fftwf_complex *>(correlation_buffer),
                       reinterpret_cast <fftwf_complex *>(correlation_buffer),
                            FFTW_BACKWARD, FFTW_ESTIMATE);

//	Add an ideal spectrum into the idealspectrum_buffer
	for (int i = 0; i < carriers; i++) {
	   DSPCOMPLEX number (1,0);
	   idealspectrum_buffer [(T_u - carriers)/2 + i] = DSPCOMPLEX (1, 0);
	}

//	Calculate the effective value of the zero padded idealspectrum_eff
	this -> idealspectrum_eff = 0;
	for (int i = 0; i < T_u * 2 - 1; i++)
	   idealspectrum_eff += jan_abs (idealspectrum_buffer [i]) *
	                                  jan_abs (idealspectrum_buffer [i]);

//	We can calculated the ideal spectrum FFT because it is always the same
	fftwf_execute (IdealSpectrumPlan);
}

	find_ofdm_spectrum::~find_ofdm_spectrum (void) {
	delete this -> signal_buffer;
	delete this -> idealspectrum_buffer;
	delete this -> correlation_buffer;

	fftwf_destroy_plan (this -> SpectrumPlan);
	fftwf_destroy_plan (this -> Spectrum2nPlan);
	fftwf_destroy_plan (this -> IdealSpectrumPlan);
	fftwf_destroy_plan (this -> CorrelationPlan);
}

float find_ofdm_spectrum::FindSpectrum(void) {
float spectrum_eff		= 0;
float correlation_buffer_abs [T_u * 2 - 1];
float max_value = 0;

//	setlocale(LC_NUMERIC, "en_US.UTF-8");
//	FILE *pFile = fopen ("data_signal.m","w");*/

//  fprintf(stderr,"checkSignal\n");

//	Clear buffer
	memset (correlation_buffer, 0, sizeof(DSPCOMPLEX) * (T_u * 2 - 1));

//	Calculate the spectrum
	fftwf_execute(SpectrumPlan);
//	Filter the DC 0 Hz

	DSPCOMPLEX cmplx_zero (0,0);
	for (int i = 0; i < 10; i++)
	   signal_buffer[i] = cmplx_zero;

	for (int i = T_u - 10; i<T_u; i++)
	   signal_buffer[i] = cmplx_zero;

//	Zero padding and reorder FFT output to get the correct spectrum
	for (int i = 0; i < T_u; i++) {
	   DSPCOMPLEX number (jan_abs (signal_buffer [(i + T_u/2) % (T_u)]),0);
	   correlation_buffer [i] = number;
	}

//	Calculate the effective value of the zero padded correlation_buffer
	spectrum_eff = 0;
	for (int i = 0; i < T_u * 2 - 1; i++)
	   spectrum_eff += jan_abs (correlation_buffer[i]) *
	                       jan_abs (correlation_buffer[i]);

//	fprintf(pFile,"signal_buffer=[");
//	for (int i = 0; i < T_u; i++) {
//	   fprintf (pFile,
//	            "%f+%fi ...\n",
//	            signal_buffer [i]. real (),
//	            signal_buffer [i]. imag ());
//	}
//	fprintf (pFile,"];");
//	fprintf (pFile,"idealspectrum_buffer=[");
//	   for (int i = 0; i < T_u * 2 - 1; i++) {
//	      fprintf (pFile,
//	               "%f+%fi ...\n",
//	               idealspectrum_buffer [i]. real (),
//	               idealspectrum_buffer [i]. imag ());
//	}
//	fprintf (pFile,"];");
//	fprintf (pFile, "correlation_buffer=[");
//	   for (int i = 0; i < T_u * 2 - 1; i++) {
//	      fprintf (pFile,
//	               "%f+%fi ...\n",
//	               correlation_buffer [i]. real (),
//	               correlation_buffer [i]. imag ());
//	}
//	fprintf (pFile, "];");
//	fclose(pFile);

	fftwf_execute (Spectrum2nPlan);
//	Do the cross correlation
	for (int i = 0; i < 2 * T_u - 1; i++) {
	   correlation_buffer[i] = correlation_buffer [i] *
	                           conj (idealspectrum_buffer [i]);
	}

	fftwf_execute (CorrelationPlan);

//	Reorder data because the 0-frequency is middle after the FFT
	memset (correlation_buffer_abs, 0, sizeof (correlation_buffer_abs));
	for (int i = 0; i < 2 * T_u - 1; i++) {
//	Make value absolute and reorder it
	   correlation_buffer_abs [i] = jan_abs (correlation_buffer[(i + T_u) %
	                                                (2 * T_u - 1)]);

//	Scale to the power
	   correlation_buffer_abs [i]  /= sqrt (spectrum_eff*idealspectrum_eff) *
	                                         (T_u*2-1);
	}

//	Looking for maximum
	max_value = 0;
	for (int i = 0; i < T_u * 2 - 1; i++) {
	   if (correlation_buffer_abs [i] >= max_value)
	      max_value = correlation_buffer_abs [i];
	}

//	Check it peak of the cross correlation.
//	1 is the maximum similarity, 0 means the signals are not similar.
//	Experiments showed that 0.82 simiarity detects a real OFDM spectrum
	return max_value;
}

DSPCOMPLEX **find_ofdm_spectrum::GetBuffer (void) {
	return &signal_buffer;
}

int32_t find_ofdm_spectrum::GetBufferSize (void) {
	return T_u;
}

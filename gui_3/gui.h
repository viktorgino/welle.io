#
/*
 *    Copyright (C)  2010, 2011, 2012
 *    Jan van Katwijk (J.vanKatwijk@gmail.com)
 *    Lazy Chair Programming
 *
 *    This file is part of the SDR-J.
 *    Many of the ideas as implemented in SDR-J are derived from
 *    other work, made available through the GNU general Public License. 
 *    All copyrights of the original authors are recognized.
 *
 *    SDR-J is free software; you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation; either version 2 of the License, or
 *    (at your option) any later version.
 *
 *    SDR-J is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with SDR-J; if not, write to the Free Software
 *    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

#ifndef _GUI
#define _GUI

#include	"dab-constants.h"
#include	<sndfile.h>
#include    <QComboBox>
#include    <QLabel>

#ifdef	GUI_3
#include	<QTimer>
#include    <QtQml/QQmlApplicationEngine>
#include    <QQmlContext>
#include    "stationelement.h"
#include    "motimageprovider.h"
#endif
#include	"ofdm-processor.h"
#include	"ringbuffer.h"

class	QSettings;
class	virtualInput;
class	audioBase;

class	mscHandler;
class	ficHandler;

class	common_fft;


/*
 *	GThe main gui object. It inherits from
 *	QDialog and the generated form
 */
class RadioInterface: public QObject{
Q_OBJECT

public:
        RadioInterface		(QSettings	*, QQmlApplicationEngine *,
                                     QObject *parent = NULL);
		~RadioInterface		();

private:
	QSettings	*dabSettings;
    QQmlApplicationEngine *engine;
    bool		autoStart;
	int16_t		threshold;
	int32_t		vfoFrequency;
	void		setupChannels		(QComboBox *s, uint8_t band);
	void		setModeParameters	(uint8_t);
	void		clear_showElements	(void);
	DabParams	dabModeParameters;
	uint8_t		isSynced;
	uint8_t		dabBand;
	bool		running;
	virtualInput	*inputDevice;
	ofdmProcessor	*my_ofdmProcessor;
	ficHandler	*my_ficHandler;
	mscHandler	*my_mscHandler;
	audioBase	*soundOut;
	RingBuffer<int16_t>	*audioBuffer;
	bool		autoCorrector;
const	char		*get_programm_type_string (uint8_t);
const	char		*get_programm_language_string (uint8_t);
	QLabel		*pictureLabel;
	QString		ipAddress;
	int32_t		port;
	bool		show_crcErrors;
	void		init_your_gui		(void);
	void		dumpControlState	(QSettings *);
    int16_t		ficBlocks;
    int16_t		ficSuccess;
#ifdef	GUI_3
    QTimer      CheckFICTimer;
    QTimer      ScanChannelTimer;
    MOTImageProvider *MOTImage;

    QString     CurrentChannel;
    QString     CurrentStation;
    bool        isFICCRC;

    int         BandIIIChannelIt;
    int         BandLChannelIt;
#endif

public slots:
	void	set_fineCorrectorDisplay	(int);
	void	set_coarseCorrectorDisplay	(int);
	void	clearEnsemble		(void);
	void	addtoEnsemble		(const QString &);
	void	nameofEnsemble		(int, const QString &);
	void	show_successRate	(int);
	void	show_ficCRC		(bool);
	void	show_snr		(int);
	void	setSynced		(char);
	void	showLabel		(QString);
	void	showMOT			(QByteArray, int);
	void	sendDatagram		(char *, int);
	void	changeinConfiguration	(void);
	void	newAudio		(int);
//
	void	show_mscErrors		(int);
	void	show_ipErrors		(int);
    void    setStereo		(bool isStereo);
    void    setSignalPresent (bool isSignal);
private slots:
//
//	Somehow, these must be connected to the GUI
//	We assume that any GUI will need these three:
    void	setStart		(void);
    void	TerminateProcess	(void);
    void	set_channelSelect	(QString);
#ifdef	GUI_3
    void	updateTimeDisplay	(void);

    void	autoCorrector_on	(void);

    void	set_modeSelect		(const QString &);
    void	set_bandSelect		(QString);
    void	setDevice		(QString);
    void	selectService		(QModelIndex);
    void	set_dumping		(void);
    void	set_audioDump		(void);
    void    CheckFICTimerTimeout    (void);
    void    channelClick(QString, QString);
    void    startChannelScanClick(void);
    void    stopChannelScanClick(void);
    void    scanChannelTimerTimeout(void);
#endif
signals:
    void currentStation(QString text);
    void signalFlag(bool active);
    void syncFlag(bool active);
    void ficFlag(bool active);
    void dabType(QString text);
    void bitrate(int bitrate);
    void audioType(bool isStereo);
    void stationType(QString text);
    void languageType(QString text);
    void signalPower(int power);
    void motChanged(void);
    void channelScanStopped(void);
    void channelScanProgress(int progress);
};

#endif


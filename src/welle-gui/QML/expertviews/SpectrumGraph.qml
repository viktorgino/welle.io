import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.1
import Qt.labs.settings 1.0

// Import custom styles
import "../texts"
import "../components"

ViewBaseFrame {
    id: test
    labelText: qsTr("Spectrum")


    Settings {
        property alias isSpectrumWaterfall: spectrum.isWaterfall
    }

    content: WSpectrum {
        id: spectrum
        yAxisText: qsTr("Amplitude")
    }


    Connections{
        target: WelleIoPlugin.GUIHelper

        onSetSpectrumAxis: {
            spectrum.yMax = Ymax
            spectrum.freqMin = Xmin
            spectrum.freqMax = Xmax
        }

        onNewDebugOutput: {
            spectrum.waterfallObject.plotMessage(text)
        }
    }

    Connections {
        target: spectrum

        onIsWaterfallChanged: {
            __registerSeries();
        }
    }

    Timer {
        id: refreshTimer
        interval: 1 / 10 * 1000 // 10 Hz
        running: parent.visible ? true : false // Trigger new data only if spectrum is showed
        repeat: true
        onTriggered: {
           WelleIoPlugin.GUIHelper.updateSpectrum();
        }
    }

    Component.onCompleted: {
        __registerSeries();
    }

    function __registerSeries() {
       if(spectrum.isWaterfall)
           WelleIoPlugin.GUIHelper.registerSpectrumWaterfall(spectrum.waterfallObject);
       else
           WelleIoPlugin.GUIHelper.registerSpectrumSeries(spectrum.spectrumObject.series(0))
    }
}

import QtQuick 2.0
import QtQuick.Layouts 1.1
import Qt.labs.settings 1.0

// Import custom styles
import "../texts"
import "../components"

ViewBaseFrame {
    labelText: qsTr("Null Symbol")

    Settings {
        property alias isNullSymbolWaterfall: spectrum.isWaterfall
    }

    content: WSpectrum {
        id: spectrum
        yAxisText: qsTr("Amplitude")
    }

    Connections{
        target: WelleIoPlugin.GUIHelper

        onSetNullSymbolAxis: {
            spectrum.yMax = Ymax
            spectrum.freqMin = Xmin
            spectrum.freqMax = Xmax
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
           WelleIoPlugin.GUIHelper.updateNullSymbol();
        }
    }

    Component.onCompleted: {
        __registerSeries();
    }

    function __registerSeries() {
       if(spectrum.isWaterfall)
           WelleIoPlugin.GUIHelper.registerNullSymbolWaterfall(spectrum.waterfallObject);
       else
           WelleIoPlugin.GUIHelper.registerNullSymbolSeries(spectrum.spectrumObject.series(0))
    }
}

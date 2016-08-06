import QtQuick 2.2
import QtQuick.Layouts 1.1

// Import custom styles
import "style"

Item {
    width: Units.dp(400)
    height: Units.dp(400)
    Layout.fillWidth: true
    Layout.fillHeight: true

    ColumnLayout {
        width: parent.width
        height: parent.height
        anchors.left: parent.left
        anchors.top: parent.top

        anchors.topMargin: Units.dp(5)
        anchors.leftMargin: Units.dp(5)

        TextExpert {
            id: displayCurrentChannel
            name: "Current channel:"
        }

        TextExpert {
            id: displayFreqCorr
            name: "Frequency correction:"
        }

        TextExpert {
            id: displaySNR
            name: "SNR:"
        }

        TextExpert {
            id: displayMSCErrors
            name: "MSC errors:"
        }

        SpectrumView {
            width: parent.width
            Layout.fillWidth: true
            Layout.fillHeight: true
            height: parent.height
        }
    }

    Connections{
        target: cppGUI
        onDisplayCurrentChannel:{
            displayCurrentChannel.text = Channel + " (" + Frequency/1e6 + " MHz)"
        }

        onSignalPower:{
            displaySNR.text = power + " dB"
        }

        onDisplayFreqCorr:{
            displayFreqCorr.text = Freq + " Hz"
        }

        onDisplayMSCErrors:{
            displayMSCErrors.text = Errors
        }
    }
}

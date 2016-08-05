import QtQuick 2.2
import QtQuick.Layouts 1.1

Item {
    width: u.dp(400)
    height: u.dp(400)
    Layout.fillWidth: true
    Layout.fillHeight: true

    ColumnLayout {
        width: parent.width
        height: parent.height
        anchors.left: parent.left
        anchors.top: parent.top

        anchors.topMargin: u.dp(5)
        anchors.leftMargin: u.dp(5)

        RowLayout{
            Text{
                text: "Current channel:"
                font.pixelSize: u.em(1.3)
                color: "white"
            }
            Text{
                id: displayCurrentChannel
                font.pixelSize: u.em(1.3)
                color: "white"
            }
        }

        RowLayout{
            Text{
                text: "Frequency correction:"
                font.pixelSize: u.em(1.3)
                color: "white"
            }
            Text{
                id: displayFreqCorr
                font.pixelSize: u.em(1.3)
                color: "white"
            }
        }

        RowLayout{
            Text{
                text: "SNR:"
                font.pixelSize: u.em(1.3)
                color: "white"
            }
            Text{
                id: displaySNR
                font.pixelSize: u.em(1.3)
                color: "white"
            }
        }

        RowLayout{
            Text{
                text: "MSC errors:"
                font.pixelSize: u.em(1.3)
                color: "white"
            }
            Text{
                id: displayMSCErrors
                font.pixelSize: u.em(1.3)
                color: "white"
            }
        }

        SpectrumView{
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

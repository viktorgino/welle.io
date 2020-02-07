import QtQuick 2.2
import QtQuick.Layouts 1.1

// Import custom styles
import "../texts"
import "../components"


ViewBaseFrame {
    labelText: qsTr("Service Details")

    content: ColumnLayout {
        anchors.fill: parent
        Layout.margins: Units.dp(50)

        TextExpert {
            name: qsTr("Device") + ":"
            text: WelleIoPlugin.RadioController.deviceName
        }

        TextExpert {
            name: qsTr("Current channel") + ":"
            text: WelleIoPlugin.RadioController.channel + " (" + (WelleIoPlugin.RadioController.frequency > 0 ? WelleIoPlugin.RadioController.frequency/1e6 :  "N/A") + " MHz)"
        }

        RowLayout {
            Rectangle{
                height: Units.dp(16)
                width: Units.dp(16)
                color: WelleIoPlugin.RadioController.isSync ? "green" : "red"
            }

            TextExpert {
                name: qsTr("Frame sync")  + ":"
                text: WelleIoPlugin.RadioController.isSync ? qsTr("OK") : qsTr("Not synced")
            }

        }

        RowLayout {
            Rectangle{
                height: Units.dp(16)
                width: Units.dp(16)
                color: WelleIoPlugin.RadioController.isFICCRC ? "green" : "red"
            }

            TextExpert {
                name: qsTr("FIC CRC")  + ":"
                text: WelleIoPlugin.RadioController.isFICCRC ? qsTr("OK") : qsTr("Error")
            }
        }

        RowLayout {
            Rectangle{
                height: Units.dp(16)
                width: Units.dp(16)
                color: (WelleIoPlugin.RadioController.frameErrors === 0
                        && WelleIoPlugin.RadioController.isSync
                        && WelleIoPlugin.RadioController.isFICCRC) ? "green" : "red"
            }

            TextExpert {
                name: qsTr("Frame errors")  + ":"
                text: WelleIoPlugin.RadioController.frameErrors
            }
        }

        TextExpert {
            name: qsTr("Frequency correction") + ":"
            text: WelleIoPlugin.RadioController.frequencyCorrection + " Hz (" + (WelleIoPlugin.RadioController.frequency > 0 ? WelleIoPlugin.RadioController.frequencyCorrectionPpm.toFixed(2) : "N/A") + " ppm)"
        }

        TextExpert {
            name: qsTr("SNR") + ":"
            text: WelleIoPlugin.RadioController.snr + " dB"
        }

        TextExpert {
            name: qsTr("RS errors") + ":"
            text: WelleIoPlugin.RadioController.rsErrors
        }

        TextExpert {
            name: qsTr("AAC errors") + ":"
            text: WelleIoPlugin.RadioController.aacErrors
        }

        TextExpert {
            name: qsTr("DAB date and time") + ":"
            text: WelleIoPlugin.RadioController.dateTime.toUTCString()
        }
    }
}

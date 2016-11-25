import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtQuick.Layouts 1.1

// Import custom styles
import "style"

Item {
    id: settingsPage

    property alias showChannelState : showChannel.checked
    property alias enableFullScreenState : enableFullScreen.checked
    property alias enableExpertModeState : enableExpertMode.checked

    Connections{
        target: cppGUI
        onChannelScanStopped:{
            startChannelScanButton.enabled = true
            stopChannelScanButton.enabled = false
        }

        onChannelScanProgress:{
            channelScanProgressBar.value = progress
        }

        onFoundChannelCount:{
            channelScanProgressBar.text = "Found channels: " + channelCount;
        }
    }

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: Units.dp(20)

        spacing: Units.dp(30)
        width: parent.width - 2 * anchors.margins
        height: parent.height

        Column{
            anchors.top: parent.top
            anchors.margins: parent.anchors.margins
            spacing: Units.dp(20)
            width: parent.width

            Column{
                width: parent.width
                spacing: parent.spacing / 2
                RowLayout {
                    width: parent.width
                    spacing: Units.dp(20)
                    TextStandart {
                        Behavior on x { NumberAnimation{ easing.type: Easing.OutCubic} }
                        text: "Channel scan"
                        //anchors.left: parent.left
                    }

                    TouchButton {
                        id: startChannelScanButton
                        text: "Start"
                        implicitWidth: Units.dp(80)
                        anchors.horizontalCenter: parent.horizontalCenter
                        onClicked: {
                            startChannelScanButton.enabled = false
                            stopChannelScanButton.enabled = true
                            mainWindow.startChannelScanClicked()
                        }
                    }

                    TouchButton {
                        id: stopChannelScanButton
                        text: "Stop"
                        implicitWidth: Units.dp(80)
                        enabled: false
                        anchors.right: parent.right
                        onClicked: {
                            startChannelScanButton.enabled = true
                            stopChannelScanButton.enabled = false
                            mainWindow.stopChannelScanClicked()
                        }
                    }
                }

                TouchProgressBar{
                    id: channelScanProgressBar
                    minimumValue: 0
                    maximumValue: 38
                    text: "Found channels: 0"
                }
            }

            TouchSwitch {
                id: showChannel
                name: "Show channel in station list"
                objectName: "showChannel"
                checked: false
            }

            TouchSwitch {
                id: enableFullScreen
                name: "Enable full screen mode"
                objectName: "enableFullScreen"
                checked: false
            }

            TouchSwitch {
                id: enableExpertMode
                name: "Enable expert mode"
                objectName: "enableExpertMode"
                checked: false
            }


            TouchButton {
                id: inputSettingsButton
                text: "Input settings"
                width: parent.width
            }
        }

        TouchButton {
            id: exitAppButton
            text: "Exit dab-rpi"
            implicitWidth: parent.width
            onClicked:  mainWindow.exitApplicationClicked()
        }
    }
}

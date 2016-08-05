import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtQuick.Layouts 1.1

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
            channelScanProgressBarText.text = "Found channels: " + channelCount;
        }
    }

    ColumnLayout {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        height: parent.height

        ColumnLayout{
            spacing: u.dp(30)

            ColumnLayout{
                spacing: u.dp(10)
                RowLayout {
                    spacing: u.dp(20)
                    Text {
                        font.pixelSize: u.em(1.3)
                        Behavior on x { NumberAnimation{ easing.type: Easing.OutCubic} }
                        color: "white"
                        text: "Channel scan"
                    }
                    Button {
                        id: startChannelScanButton
                        text: "Start"
                        style: touchStyle
                        implicitWidth: u.dp(80)
                        onClicked: {
                            startChannelScanButton.enabled = false
                            stopChannelScanButton.enabled = true
                            mainWindow.startChannelScanClicked()
                        }
                    }
                    Button {
                        id: stopChannelScanButton
                        text: "Stop"
                        style: touchStyle
                        implicitWidth: u.dp(80)
                        enabled: false
                        onClicked: {
                            startChannelScanButton.enabled = true
                            stopChannelScanButton.enabled = false
                            mainWindow.stopChannelScanClicked()
                        }
                    }
                }

                ProgressBar{
                    id: channelScanProgressBar
                    style: progressBarStyle
                    minimumValue: 0
                    maximumValue: 38
                    implicitWidth: parent.width
                    Text {
                        id: channelScanProgressBarText
                        text: "Found channels: 0"
                        font.pixelSize: u.em(1.2)
                        color: "white"
                        anchors.centerIn: parent
                    }
                }
            }

            Row {
                spacing: u.dp(20)
                Text {
                    width: u.dp(212)
                    font.pixelSize: u.em(1.3)
                    Behavior on x { NumberAnimation{ easing.type: Easing.OutCubic} }
                    color: "white"
                    text: "Show channel in station list"
                }
                Switch {
                    style: switchStyle
                    id: showChannel
                    objectName: "showChannel"
                    checked: false
                }
            }

            Row{
                spacing: u.dp(20)
                Text {
                    width: u.dp(212)
                    font.pixelSize: u.em(1.3)
                    Behavior on x { NumberAnimation{ easing.type: Easing.OutCubic} }
                    color: "white"
                    text: "Enable full screen mode"
                }
                Switch {
                    style: switchStyle
                    id: enableFullScreen
                    objectName: "enableFullScreen"
                    checked: false
                }
            }

            Row{
                spacing: u.dp(20)
                Text {
                    width: u.dp(212)
                    font.pixelSize: u.em(1.3)
                    Behavior on x { NumberAnimation{ easing.type: Easing.OutCubic} }
                    color: "white"
                    text: "Enable expert mode"
                }
                Switch {
                    style: switchStyle
                    id: enableExpertMode
                    objectName: "enableExpertMode"
                    checked: false
                }
            }
        }

        Button {
            id: exitAppButton
            text: "Exit dab-rpi"
            style: touchStyle
            implicitWidth: parent.width
            anchors.bottom: parent.bottom
            anchors.bottomMargin: u.dp(10)
            onClicked:  mainWindow.exitApplicationClicked()
        }

        /*Slider {
            anchors.margins: u.dp(20)
            style: sliderStyle
            value: 1.0
        }*/
    }


    /******* Styles *******/

    /* Button Style */
    Component {
        id: touchStyle
        ButtonStyle {
            panel: Item {
                implicitHeight: u.dp(25)
                implicitWidth: u.dp(160)
                BorderImage {
                    anchors.fill: parent
                    antialiasing: true
                    border.bottom: u.dp(8)
                    border.top: u.dp(8)
                    border.left: u.dp(8)
                    border.right: u.dp(8)
                    anchors.margins: control.pressed ? u.dp(-4) : 0
                    source: control.pressed ? "images/button_pressed.png" : "images/button_default.png"
                    Text {
                        text: control.text
                        anchors.centerIn: parent
                        color: control.enabled ? "white" : "grey"
                        font.pixelSize: u.em(1.3)
                        renderType: Text.NativeRendering
                    }
                }
            }
        }
    }

    /* Slider Style */
    Component {
        id: sliderStyle
        SliderStyle {
            handle: Rectangle {
                width: u.dp(15)
                height: u.dp(15)
                radius: height
                antialiasing: true
                color: Qt.lighter("#468bb7", 1.2)
            }

            groove: Item {
                implicitWidth: u.dp(200)
                Rectangle {
                    height: u.dp(4)
                    width: parent.width
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#444"
                    opacity: 0.8
                    Rectangle {
                        antialiasing: true
                        radius: 1
                        color: "#468bb7"
                        height: parent.height
                        width: parent.width * control.value / control.maximumValue
                    }
                }
            }
        }
    }

    /* Switch Style */
    Component {
        id: switchStyle
        SwitchStyle {

            groove: Rectangle {
                implicitHeight: u.dp(25)
                implicitWidth: u.dp(70)
                Rectangle {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    width: parent.width/2 - u.dp(2)
                    height: u.dp(20)
                    anchors.margins: u.dp(2)
                    color: control.checked ? "#468bb7" : "#222"
                    Behavior on color {ColorAnimation {}}
                    Text {
                        font.pixelSize: u.em(1.1)
                        color: "white"
                        anchors.centerIn: parent
                        text: "ON"
                    }
                }
                Item {
                    width: parent.width/2
                    height: parent.height
                    anchors.right: parent.right
                    Text {
                        font.pixelSize: u.em(1.1)
                        color: "white"
                        anchors.centerIn: parent
                        text: "OFF"
                    }
                }
                color: "#222"
                border.color: "#444"
                border.width: u.dp(2)
            }
            handle: Rectangle {
                width: parent.parent.width/2
                height: control.height
                color: "#444"
                border.color: "#555"
                border.width: u.dp(2)
            }
        }
    }

    /* ProgressBar Style */
    Component {
        id: progressBarStyle
        ProgressBarStyle {
            panel: Rectangle {
                implicitHeight: u.dp(25)
                implicitWidth: u.dp(400)
                color: "#444"
                opacity: 0.8
                Rectangle {
                    antialiasing: true
                    radius: u.dp(1)
                    color: "#468bb7"
                    height: parent.height
                    width: parent.width * control.value / control.maximumValue
                }
            }
        }
    }

}

import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4

Item {

    ListModel{
        id: dataModel
        ListElement{ name: "Day" }
        ListElement{ name: "Week" }
        ListElement{ name: "Month" }
        ListElement{ name: "Year" }
    }

    Column {
        spacing: 40
        anchors.centerIn: parent

        Row {
            spacing: 20
            Text {
                font.pixelSize: 16
                Behavior on x { NumberAnimation{ easing.type: Easing.OutCubic} }
                color: "white"
                text: "Input"
            }
            Button {
                id: comboButton
                checkable: true
                text: "Input"
                style: touchStyle
            }
        }


        Row {
            spacing: 20
            Text {
                font.pixelSize: 16
                Behavior on x { NumberAnimation{ easing.type: Easing.OutCubic} }
                color: "white"
                text: "AGC"
            }
            Switch {
                style: switchStyle
            }
        }

        Slider {
            anchors.margins: 20
            style: sliderStyle
            value: 1.0
        }

        Button {
            text: "Channel Scan"
            style: touchStyle
        }

        Button {
            style: touchStyle
            text: "Press me too"
        }

        Button {
            anchors.margins: 20
            style: touchStyle
            text: "Don't press me"
            onClicked: if (stackView) stackView.pop()
        }

        Row {
            spacing: 20
            Switch {
                style: switchStyle
            }
            Switch {
                style: switchStyle
            }
        }

    }


    /******* Styles *******/

    /* Button Style */
    Component {
        id: touchStyle
        ButtonStyle {
            panel: Item {
                implicitHeight: 25
                implicitWidth: 160
                BorderImage {
                    anchors.fill: parent
                    antialiasing: true
                    border.bottom: 8
                    border.top: 8
                    border.left: 8
                    border.right: 8
                    anchors.margins: control.pressed ? -4 : 0
                    source: control.pressed ? "images/button_pressed.png" : "images/button_default.png"
                    Text {
                        text: control.text
                        anchors.centerIn: parent
                        color: "white"
                        font.pixelSize: 16
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
                width: 15
                height: 15
                radius: height
                antialiasing: true
                color: Qt.lighter("#468bb7", 1.2)
            }

            groove: Item {
                //implicitHeight: 50
                implicitWidth: 200
                Rectangle {
                    height: 4
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
                implicitHeight: 25
                implicitWidth: 70
                Rectangle {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    width: parent.width/2 - 2
                    height: 20
                    anchors.margins: 2
                    color: control.checked ? "#468bb7" : "#222"
                    Behavior on color {ColorAnimation {}}
                    Text {
                        font.pixelSize: 16
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
                        font.pixelSize: 16
                        color: "white"
                        anchors.centerIn: parent
                        text: "OFF"
                    }
                }
                color: "#222"
                border.color: "#444"
                border.width: 2
            }
            handle: Rectangle {
                width: parent.parent.width/2
                height: control.height
                color: "#444"
                border.color: "#555"
                border.width: 2
            }
        }
    }

}

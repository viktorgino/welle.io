import QtQuick 2.5
import QtQuick.Layouts 1.1

Item{
    height: 150
    width: 320
    Layout.minimumWidth: 150

    RowLayout{
        anchors.top: parent.top
        anchors.topMargin: 5
        Layout.fillWidth : true
        Layout.fillHeight: true
        width: parent.width

        RowLayout{
            Layout.fillWidth : true
            Layout.fillHeight: true
            anchors.left: parent.left
            anchors.leftMargin: 5
            spacing: 2

            Rectangle{
                height: 4
                width: 4
                color: "green"
            }
            Rectangle{
                height: 8
                width: 4
                color: "green"
            }
            Rectangle{
                height: 12
                width: 4
                color: "green"
            }
            Rectangle{
                height: 16
                width: 4
                color: "green"
            }

            Rectangle{
                height: 20
                width: 4
                color: "green"
            }
        }

        Text {
            text: "96 kbps"
            color: "white"
            font.pixelSize: 13
        }

        Text {
            text: "DAB+"
            color: "white"
            font.pixelSize: 13
        }

        Text {
           /* anchors.right: flags.left
            anchors.rightMargin: 5*/
            text: "Stereo"
            color: "white"
            font.pixelSize: 13
        }

        /* Flags */
        RowLayout{
            id: flags
            Layout.fillWidth : true
            Layout.fillHeight: true
            anchors.right: parent.right
            anchors.rightMargin: 5
            spacing: 2

            Rectangle{
                id: signal
                height: 16
                width: 16
                color: "red"
            }
            Rectangle{
                id: sync
                height: 16
                width: 16
                color: "red"
            }
            Rectangle{
                id: fic
                height: 16
                width: 16
                color: "red"
            }
        }
    }

    /* Station Text */
    Text {
        id: currentStation
        anchors.centerIn: parent
        text: "WDR"
        color: "white"
        font.pixelSize: 24
    }

    Connections{
        target: cppGUI
        onTestSignal:{
            currentStation.text = text
        }

        onSyncFlag:{
            if(active)
                sync.color = "green"
            else
                sync.color = "red"
        }

        onFicFlag:{
            if(active)
                fic.color = "green"
            else
                fic.color = "red"
        }
    }

    RowLayout{
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        Layout.fillWidth : true
        Layout.fillHeight: true
        width: parent.width

        Text {
            anchors.left: parent.left
            anchors.leftMargin: 5
            text: "German"
            color: "white"
            font.pixelSize: 13
        }

        Text {
            anchors.right: parent.right
            anchors.rightMargin: 5
            text: "Information"
            color: "white"
            font.pixelSize: 13
        }

    }

}

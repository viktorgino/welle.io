import QtQuick 2.2
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
                id: signalBar1
                height: 4
                width: 4
                color: "grey"
            }
            Rectangle{
                id: signalBar2
                height: 8
                width: 4
                color: "grey"
            }
            Rectangle{
                id: signalBar3
                height: 12
                width: 4
                color: "grey"
            }
            Rectangle{
                id: signalBar4
                height: 16
                width: 4
                color: "grey"
            }

            Rectangle{
                id: signalBar5
                height: 20
                width: 4
                color: "grey"
            }
        }

        Text {
            id: bitrateText
            text: "96 kbps"
            color: "white"
            font.pixelSize: 13
        }

        Text {
            id: dabTypeText
            text: "DAB+"
            color: "white"
            font.pixelSize: 13
        }

        Text {
            id: audioTypeText
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
        onCurrentStation:{
            currentStation.text = text
        }

        onSignalFlag:{
            if(active)
                signal.color = "green"
            else
                signal.color = "red"
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

        onBitrate: {
            bitrateText.text = bitrate +  " kbps"
        }

        onDabType: {
            dabTypeText.text = text
        }

        onAudioType: {
            if(isStereo)
                audioTypeText.text = "Stereo"
            else
                audioTypeText.text = "Mono"
        }

        onStationType: {
            stationTypeText.text = text
        }

        onLanguageType: {
            languageTypeText.text = text
        }

        onSignalPower: {
            if(power > 15) signalBar5.color = "green"; else signalBar5.color = "grey"
            if(power > 11) signalBar4.color = "green"; else signalBar4.color = "grey"
            if(power > 8) signalBar3.color = "green"; else signalBar3.color = "grey"
            if(power > 5) signalBar2.color = "green"; else signalBar2.color = "grey"
            if(power > 2) signalBar1.color = "green"; else signalBar1.color = "grey"
        }
    }

    RowLayout{
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        Layout.fillWidth : true
        Layout.fillHeight: true
        width: parent.width

        Text {
            id: languageTypeText
            anchors.left: parent.left
            anchors.leftMargin: 5
            text: "German"
            color: "white"
            font.pixelSize: 13
        }

        Text {
            id: stationTypeText
            anchors.right: parent.right
            anchors.rightMargin: 5
            text: "Information"
            color: "white"
            font.pixelSize: 13
        }

    }

}

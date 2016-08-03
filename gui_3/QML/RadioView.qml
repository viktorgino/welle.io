import QtQuick 2.2
import QtQuick.Layouts 1.1

Item{
    height: u.dp(180)
    width: u.dp(320)
    Layout.minimumWidth: u.dp(150)

    RowLayout{
        anchors.top: parent.top
        anchors.topMargin: u.dp(5)
        Layout.fillWidth : true
        Layout.fillHeight: true
        width: parent.width

        RowLayout{
            Layout.fillWidth : true
            Layout.fillHeight: true
            anchors.left: parent.left
            anchors.leftMargin: u.dp(5)
            spacing: u.dp(2)

            Rectangle{
                id: signalBar1
                height: u.dp(4)
                width: u.dp(4)
                color: "grey"
            }
            Rectangle{
                id: signalBar2
                height: u.dp(8)
                width: u.dp(4)
                color: "grey"
            }
            Rectangle{
                id: signalBar3
                height: u.dp(12)
                width: u.dp(4)
                color: "grey"
            }
            Rectangle{
                id: signalBar4
                height: u.dp(16)
                width: u.dp(4)
                color: "grey"
            }

            Rectangle{
                id: signalBar5
                height: u.dp(20)
                width: u.dp(4)
                color: "grey"
            }
        }

        Text {
            id: bitrateText
            text: "96 kbps"
            color: "white"
            font.pixelSize: u.em(1.2)
        }

        Text {
            id: dabTypeText
            text: "DAB+"
            color: "white"
            font.pixelSize: u.em(1.2)
        }

        Text {
            id: audioTypeText
            text: "Stereo"
            color: "white"
            font.pixelSize: u.em(1.2)
        }

        /* Flags */
        RowLayout{
            id: flags
            Layout.fillWidth : true
            Layout.fillHeight: true
            anchors.right: parent.right
            anchors.rightMargin: u.dp(5)
            spacing: 2

            Rectangle{
                id: signal
                height: u.dp(16)
                width: u.dp(16)
                color: "red"
            }
            Rectangle{
                id: sync
                height: u.dp(16)
                width: u.dp(16)
                color: "red"
            }
            Rectangle{
                id: fic
                height: u.dp(16)
                width: u.dp(16)
                color: "red"
            }
        }
    }

    ColumnLayout {
        anchors.centerIn: parent

        /* Station Name */
        Text {
            id: currentStation
            anchors.horizontalCenter: parent.horizontalCenter
            text: "No Station"
            color: "white"
            font.pixelSize: u.em(2.3)
        }

        /* Station Text */
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: u.dp(10)
            id: stationText
            Layout.maximumWidth: parent.parent.width
            width: parent.parent.width
            wrapMode: Text.WordWrap
            color: "white"
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: u.em(1.2)
        }
    }

    Connections{
        target: cppGUI
        onCurrentStation:{
            currentStation.text = text
        }

        onStationText:{
            stationText.text = text
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
        anchors.bottomMargin: u.dp(5)
        Layout.fillWidth : true
        Layout.fillHeight: true
        width: parent.width

        Text {
            id: languageTypeText
            anchors.left: parent.left
            anchors.leftMargin: u.dp(5)
            text: "German"
            color: "white"
            font.pixelSize: u.em(1.2)
        }

        Text {
            id: stationTypeText
            anchors.right: parent.right
            anchors.rightMargin: u.dp(5)
            text: "Information"
            color: "white"
            font.pixelSize: u.em(1.2)
        }

    }

}

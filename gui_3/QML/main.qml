/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

ApplicationWindow {
    signal stationClicked(string statio, string channel)
    signal startChannelScanClicked
    signal stopChannelScanClicked
    signal exitApplicationClicked
    signal exitSettingsClicked

    id: mainWindow
    visible: true
    width: u.dp(700)
    height: u.dp(465)
    visibility: settingsPageLoader.settingsPage.enableFullScreenState ? "FullScreen" : "Windowed"

    Units {
         id: u
     }

    Loader {
        id: settingsPageLoader
        anchors.topMargin: u.dp(10)
        readonly property SettingsPage settingsPage: item
        source: Qt.resolvedUrl("SettingsPage.qml")
    }

    Rectangle {
        x: 0
        color: "#212126"
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        anchors.fill: parent
    }

    toolBar: BorderImage {
        border.bottom: u.dp(10)
        source: "images/toolbar.png"
        width: parent.width
        height: u.dp(40)

        Rectangle {
            id: backButton
            width: opacity ? u.dp(60) : 0
            anchors.left: parent.left
            anchors.leftMargin: u.dp(20)
            anchors.verticalCenter: parent.verticalCenter
            antialiasing: true
            radius: u.dp(4)
            color: backmouse.pressed ? "#222" : "transparent"
            Behavior on opacity { NumberAnimation{} }
            Image {
                anchors.verticalCenter: parent.verticalCenter
                source: stackView.depth > 1 ? "images/navigation_previous_item.png" : "images/icon-settings.png"
                height: stackView.depth > 1 ? u.dp(20) : u.dp(23)
                fillMode: Image.PreserveAspectFit
            }
            MouseArea {
                id: backmouse
                scale: 1
                anchors.fill: parent
                anchors.margins: u.dp(-20)
                onClicked: {
                    if(stackView.depth > 1) {
                        stackView.pop();
                        exitSettingsClicked();
                    }
                    else
                        stackView.push(settingsPageLoader)
                }
            }
        }

        Text {
            font.pixelSize: u.em(2)
            Behavior on x { NumberAnimation{ easing.type: Easing.OutCubic} }
            x: backButton.x + backButton.width + u.dp(20)
            anchors.verticalCenter: parent.verticalCenter
            color: "white"
            text: "dab-rpi"
        }

        Text {
            font.pixelSize: u.em(1.3)
            Behavior on x { NumberAnimation{ easing.type: Easing.OutCubic} }
            //x: exitButton.x - exitButton.width - u.dp(20)
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: u.dp(5)
            color: "white"
            text: "01.01.2016 00:00"
            id: dateTimeDisplay
        }

        /*Rectangle {
            id: exitButton
            width: opacity ? u.dp(40) : 0
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            antialiasing: true
            radius: u.dp(4)
            color: backmouse.pressed ? "#222" : "transparent"
            Image {
                anchors.verticalCenter: parent.verticalCenter
                source: stackView.depth > 1 ? "images/icon-exit.png" : ""
                height: u.dp(23)
                fillMode: Image.PreserveAspectFit
            }
            MouseArea {
                id: exitmouse
                scale: 1
                anchors.fill: parent
                anchors.margins: u.dp(-20)
                onClicked: stackView.depth > 1 ? mainWindow.exitApplicationClicked() : {}
            }
        }*/
    }

    SplitView {
        anchors.fill: parent
        orientation: Qt.Horizontal

        StackView {
            id: stackView
            clip: true
            //anchors.fill: parent
            width: u.dp(200)
            //Layout.minimumHeight: u.dp(200)
            Layout.fillWidth: true
            // Implements back key navigation
            focus: true
            Keys.onReleased: if (event.key === Qt.Key_Back && stackView.depth > 1) {
                                 stackView.pop();
                                 event.accepted = true;
                             }

            initialItem: Item {
                width: parent.width
                height: parent.height
                ListView {
                    property bool showChannelState: settingsPageLoader.settingsPage.showChannelState
                    //property bool showChannelState: false
                    anchors.rightMargin: 0
                    anchors.bottomMargin: 0
                    anchors.leftMargin: 0
                    anchors.topMargin: 0
                    model: stationModel
                    anchors.fill: parent
                    delegate: StationDelegate {
                        stationNameText: stationName
                        channelNameText: channelName
                        onClicked: mainWindow.stationClicked(stationName, channelName)
                    }

                }
            }
        }

        SplitView {
            orientation: Qt.Vertical
            width: u.dp(320)
            Layout.maximumWidth: u.dp(320)
            Layout.minimumWidth: u.dp(320)

            // Radio
            RadioView {}

            // MOT image
            Rectangle {
                id: motImageRec
                height: u.dp(240)
                color: "#212126"
                Image {
                    id: motImage
                    //source: "file://"+ encodeURIComponent(workingDir) + "0BF2.jpg"
                }
            }
        }
    }

    Connections{
        target: cppGUI
        onMotChanged:{
            motImage.source = "file://" + encodeURIComponent(workingDir) + name
        }

        onNewDateTime:{
            dateTimeDisplay.text = u.pad(Day,2) + "." + u.pad(Month,2) + "." + Year + " " + u.pad(Hour,2) + ":" + u.pad(Minute,2)
        }
    }
}

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
    signal qmlSignal(string statio, string channel)

    id: mainWindow
    visible: true
    width: 800
    height: 480

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
        border.bottom: 10
        source: "images/toolbar.png"
        width: parent.width
        height: 40

        Rectangle {
            id: backButton
            width: opacity ? 60 : 0
            anchors.left: parent.left
            anchors.leftMargin: 20
            opacity: stackView.depth > 1 ? 1 : 0
            anchors.verticalCenter: parent.verticalCenter
            antialiasing: true
            //height: 20
            radius: 4
            color: backmouse.pressed ? "#222" : "transparent"
            Behavior on opacity { NumberAnimation{} }
            Image {
                anchors.verticalCenter: parent.verticalCenter
                source: "images/navigation_previous_item.png"
                height: 30
                fillMode: Image.PreserveAspectFit
            }
            MouseArea {
                id: backmouse
                scale: 1
                anchors.fill: parent
                anchors.margins: -10
                onClicked: stackView.pop()
            }
        }

        Text {
            font.pixelSize: 20
            Behavior on x { NumberAnimation{ easing.type: Easing.OutCubic} }
            x: backButton.x + backButton.width + 20
            anchors.verticalCenter: parent.verticalCenter
            color: "white"
            text: "dab-rpi"
        }

        Rectangle {
            id: seetingsButton
            width: opacity ? 40 : 0
            anchors.right: parent.right
            anchors.rightMargin: 5
            opacity: stackView.depth > 1 ? 0 : 1
            anchors.verticalCenter: parent.verticalCenter
            antialiasing: true
            //height: 20
            radius: 4
            color: backmouse.pressed ? "#222" : "transparent"
            Behavior on opacity { NumberAnimation{} }
            Image {
                anchors.verticalCenter: parent.verticalCenter
                source: "images/icon-settings.png"
                height: 20
                fillMode: Image.PreserveAspectFit
            }
            MouseArea {
                id: backmouse2
                scale: 1
                anchors.fill: parent
                anchors.margins: -10
                onClicked: stackView.push(Qt.resolvedUrl("SettingsPage.qml"))
            }
        }
    }

    SplitView {
        anchors.fill: parent
        //orientation: parent.width > 300 ? Qt.Horizontal : Qt.Vertical
        orientation: Qt.Horizontal

        StackView {
            id: stackView

            //x: 0
            clip: true
            //anchors.fill: parent
            width: 200
            Layout.minimumHeight: 200
            //Layout.maximumWidth: 400
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
                    anchors.rightMargin: 0
                    anchors.bottomMargin: 0
                    anchors.leftMargin: 0
                    anchors.topMargin: 0
                    model: stationModel
                    anchors.fill: parent
                    delegate: AndroidDelegate {
                        stationNameText: stationName
                        channelNameText: channelName
                        onClicked: mainWindow.qmlSignal(stationName, channelName)
                    }
                }
            }
        }

        SplitView {
            //anchors.right: parent
            orientation: Qt.Vertical
            width: 320
            Layout.maximumWidth: 320

            RadioView {}

            Rectangle {
                width: 320
                height: 280
                //color: "lightgreen"
                Text {
                    text: "MOT slideshow"
                    //text: parent.parent.parent.parent.width
                    anchors.centerIn: parent
                }
            }
        }
    }
}

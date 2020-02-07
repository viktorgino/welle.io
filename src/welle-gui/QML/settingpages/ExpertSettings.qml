import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.1
import Qt.labs.settings 1.0

import "../texts"
import "../components"

Item {
    id: expertSettings

    anchors.fill: parent
    implicitHeight: layout.implicitHeight

    Settings {
        property alias enableExpertModeState : enableExpertMode.checked
        property alias disableCoarseState: disableCoarse.checked
        property alias enableDecodeTIIState: enableDecodeTII.checked
        property alias freqSyncMethodBoxState: freqSyncMethodBox.currentIndex
        property alias fftWindowPlacement: fftPlacementBox.currentIndex
    }

    property alias enableExpertModeState : enableExpertMode.checked

    ColumnLayout{
        id: layout
        anchors.fill: parent
        spacing: Units.dp(20)

        SettingSection {
            id: settingsFrame
            isNotFirst: false
            text: qsTr("Global")

            WSwitch {
                id: enableExpertMode
                text: qsTr("Expert mode")
                checked: false
            }
        }

        SettingSection {
            text: qsTr("Backend")
            enabled: enableExpertMode.checked

            WSwitch {
                id: disableCoarse
                Layout.fillWidth: true

                text: qsTr("Enable coarse corrector (for receivers with >1kHz error)")
                checked: true
                onCheckedChanged: {
                    WelleIoPlugin.RadioController.disableCoarseCorrector(!checked)
                }

                Component.onCompleted: WelleIoPlugin.RadioController.disableCoarseCorrector(!checked)
            }

            RowLayout {
                enabled: disableCoarse.checked

                WComboBox {
                    id: freqSyncMethodBox
                    model: [ "GetMiddle", "CorrelatePRS", "PatternOfZeros" ];
                    currentIndex: 1
                    onCurrentIndexChanged: {
                        WelleIoPlugin.RadioController.setFreqSyncMethod(currentIndex)
                    }

                    Component.onCompleted: WelleIoPlugin.RadioController.setFreqSyncMethod(currentIndex)
                }

                TextStandart {
                    text: qsTr("Coarse corrector algorithm")
                    Layout.fillWidth: true
                }
            }

            WSwitch {
                id: enableDecodeTII
                Layout.fillWidth: true
                text: qsTr("Enable TII decoding to console log (increases CPU usage)")
                checked: false
                onCheckedChanged: {
                    WelleIoPlugin.RadioController.enableTIIDecode(checked)
                }

                Component.onCompleted: WelleIoPlugin.RadioController.enableTIIDecode(checked)
            }

            RowLayout {
                Layout.fillWidth: true
                WComboBox {
                    id: fftPlacementBox
                    model: [ "Strongest Peak", "Earliest Peak With Binning", "Threshold Before Peak" ];
                    currentIndex: 1
                    onCurrentIndexChanged: {
                        WelleIoPlugin.RadioController.selectFFTWindowPlacement(currentIndex)
                    }

                    Component.onCompleted: WelleIoPlugin.RadioController.selectFFTWindowPlacement(currentIndex)
                }

                TextStandart {
                    text: qsTr("FFT Window placement algorithm")
                    Layout.fillWidth: true
                }
            }
        }
    }
}

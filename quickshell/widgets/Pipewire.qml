import QtQuick
import QtQuick.Controls
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Services.Pipewire

import "../config/"
import "../fonts/"
import "../themes/"

WidgetBackground {
    PwObjectTracker {
        id: sinkTracker
        objects: [Pipewire.defaultAudioSink]
    }

    Item {
        implicitWidth: 40
        implicitHeight: Config.widgetContentHeight

        Text {
            id: volumeText

            anchors.fill: parent

            text: Math.round(Pipewire.defaultAudioSink.audio.volume * 100) + "%"

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            color: Colors.text

            font {
                family: Fonts.family
                pixelSize: Fonts.size
            }

            visible: !Pipewire.defaultAudioSink.audio.muted && Pipewire.defaultAudioSink.audio.volume > 0
        }

        Button {
            id: volumeIcon

            anchors.fill: parent
            anchors.margins: 5

            background: null

            icon.source: Pipewire.defaultAudioSink.audio.muted ? Qt.resolvedUrl("../assets/volume-off.svg") : Qt.resolvedUrl("../assets/volume-x.svg")

            icon.color: Colors.workspaceActive

            visible: Pipewire.defaultAudioSink.audio.muted || Pipewire.defaultAudioSink.audio.volume <= 0
        }

        MouseArea {
            anchors.fill: parent
            z: 1

            acceptedButtons: Qt.LeftButton | Qt.MiddleButton

            onClicked: function (mouse) {
                if (mouse.button === Qt.LeftButton) {
                    pavucontrol.running = true;
                } else if (mouse.button === Qt.MiddleButton) {
                    Pipewire.defaultAudioSink.audio.muted = !Pipewire.defaultAudioSink.audio.muted;
                }
            }
        }
    }

    Process {
        id: pavucontrol

        command: ["pavucontrol"]
        running: false
    }
}

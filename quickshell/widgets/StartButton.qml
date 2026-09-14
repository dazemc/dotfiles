import QtQuick
import Quickshell.Io
import Quickshell.Widgets

import "../config/"

Rectangle {

    property bool clicked: false
    WidgetGradient {
        id: background
    }
    WidgetGradientActive {
        id: activeBackground
    }
    implicitWidth: 30
    implicitHeight: 30
    color: "transparent"
    gradient: drun.running ? activeBackground : background
    bottomRightRadius: Config.bottomRightRadius
    bottomLeftRadius: Config.bottomLeftRadius

    IconImage {
        anchors.fill: parent
        anchors.margins: 5
        source: Qt.resolvedUrl("../assets/archLogo.png")
    }
    Process {
        id: drun
        command: ["rofi", "-show", "drun", "-click-to-exit"]
        running: false
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            parent.clicked = !parent.clicked;
            drun.running = true;
        }
    }
}

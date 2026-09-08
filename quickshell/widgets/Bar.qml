import Quickshell
import QtQuick
import "../themes/"
import "../config/"

Scope {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData

            margins {
                // top: Config.barTopMargin
                left: Config.barLeftMargin
                right: Config.barRightMargin
                bottom: Config.barBottomMargin
            }
            color: Colors.bar
            implicitHeight: 30

            anchors {
                top: true
                left: true
                right: true
            }

            Row {
                spacing: 5
                StartButton {}
            }
            Row {
                spacing: 5
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                WorkspaceWidget {}
            }
            Row {
                spacing: 5
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                Pipewire {}
                ClockWidget {}
            }
        }
    }
}

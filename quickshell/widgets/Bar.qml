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
                top: Config.barTopMargin
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

            StartButton {
                anchors.verticalCenter: parent.verticalCenter
            }

            WorkspaceWidget {
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
            ClockWidget {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}

import QtQuick
import Quickshell.Hyprland

import "../themes/"
import "../config/"
import "../fonts/"

Row {
    spacing: 5

    Repeater {
        model: Hyprland.workspaces
        Rectangle {
            id: workspaceButton
            required property var modelData

            WidgetGradient {
                id: unFocusedGradient
            }
            WidgetGradientActive {
                id: focusedGradient
            }

            height: Config.widgetContentHeight
            width: Config.widgetContentHeight * 1.25
            radius: Config.widgetRadius
            gradient: workspaceButton.modelData.focused ? focusedGradient : unFocusedGradient

            Text {
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                    verticalCenterOffset: -8
                    horizontalCenterOffset: -10
                }
                font {
                    pixelSize: Fonts.size
                    family: Fonts.family
                }
                text: workspaceButton.modelData.id
                color: Colors.text
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    for (const ws of Hyprland.workspaces.values) {
                        if (ws.id === workspaceButton.modelData.id) {
                            ws.activate();
                            return;
                        }
                    }
                }
            }
        }
    }
}

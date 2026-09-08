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

            height: workspaceButton.modelData.focused ? Config.widgetContentHeight : Config.widgetContentHeight - 10
            width: workspaceButton.modelData.focused ? Config.widgetContentHeight * 1.25 : Config.widgetContentHeight * 1.25 - 10

            bottomRightRadius: Config.bottomRightRadius
            bottomLeftRadius: Config.bottomLeftRadius
            gradient: workspaceButton.modelData.focused ? focusedGradient : unFocusedGradient

            Text {
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                }
                font {
                    pixelSize: Fonts.size
                    family: Fonts.family
                }
                text: workspaceButton.modelData.id
                color: Colors.text
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
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

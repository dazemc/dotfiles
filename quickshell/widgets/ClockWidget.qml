import QtQuick

import "../services/"
import "../themes/"
import "../fonts/"

WidgetBackground {
    Calender {
        id: calendar
        anchorItem: clock
    }

    Text {
        id: clock
        text: Time.time
        color: Colors.text

        font {
            pixelSize: Fonts.size
            family: Fonts.family
        }

        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
            verticalCenterOffset: 3.5
        }

        MouseArea {
            anchors.fill: parent

            onClicked: calendar.visible = !calendar.visible
        }
    }
}

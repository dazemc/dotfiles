import QtQuick

import "../services/"
import "../themes/"
import "../fonts/"

WidgetBackground {
    implicitWidth: 160
    implicitHeight: 30

    Calender {
        id: calendar
        anchorItem: clock
    }

    Text {
        id: clock
        text: Time.time
        color: Colors.text
        height: 30
        width: 100
        font {
            pixelSize: Fonts.size
            family: Fonts.family
        }

        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        MouseArea {
            anchors.fill: parent

            onClicked: calendar.visible = !calendar.visible
        }
    }
}

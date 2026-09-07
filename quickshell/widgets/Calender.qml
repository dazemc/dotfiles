import QtQuick
import QtQuick.Controls
import Quickshell

import "../themes/"
import "../config/"
import "../fonts"

PopupWindow {
    id: root

    property Item anchorItem: null

    visible: false

    implicitWidth: 300
    implicitHeight: 300

    color: "transparent"

    anchor {
        item: root.anchorItem
        edges: Edges.Bottom
        gravity: Edges.Bottom

        margins {
            top: 30
            left: 10
        }
    }

    Rectangle {
        anchors.fill: parent

        WidgetGradient {
            id: inactiveGradient
        }

        WidgetGradientActive {
            id: activeGradient
        }

        gradient: inactiveGradient
        radius: Config.widgetRadius

        Column {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 5

            // Month and year
            Text {
                width: parent.width
                height: 30

                text: Qt.formatDate(new Date(), "MMMM yyyy")

                color: Colors.text

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                font {
                    pixelSize: Fonts.size
                    family: Fonts.family
                }
            }

            // Weekday names
            DayOfWeekRow {
                width: parent.width
                height: 25

                locale: Qt.locale()

                delegate: Text {
                    required property var model

                    text: model.shortName

                    color: Colors.text

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    font {
                        pixelSize: Fonts.size
                        family: Fonts.family
                    }
                }
            }

            // Calendar days
            MonthGrid {
                width: parent.width
                height: parent.height - 75

                month: new Date().getMonth()
                year: new Date().getFullYear()
                locale: Qt.locale()

                delegate: Rectangle {
                    required property var model

                    color: "transparent"

                    radius: width / 2

                    gradient: model.today ? activeGradient : null

                    Text {
                        anchors.centerIn: parent
                        anchors.horizontalCenterOffset: +3
                        anchors.verticalCenterOffset: -1

                        text: model.day

                        color: Colors.text

                        font {
                            pixelSize: Fonts.size
                            family: Fonts.family
                        }
                    }
                }
            }
        }
    }
}

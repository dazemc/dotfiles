import QtQuick
import Quickshell.Widgets

import "../themes/"
import "../config/"

WrapperRectangle {
    // margin: Config.widgetMargin
    leftMargin: 8
    rightMargin: 8
    height: Config.widgetContentHeight
    anchors.verticalCenter: parent.verticalCenter
    radius: Config.widgetRadius
    color: Colors.widget
    gradient: WidgetGradient {}
}

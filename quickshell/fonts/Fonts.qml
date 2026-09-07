pragma Singleton

import QtQuick
import Quickshell

Singleton {
    readonly property string family: aspire.name
    readonly property int size: 22
    FontLoader {
        id: aspire
        source: "../assets/AspireDemibold-YaaO.ttf"
    }
}

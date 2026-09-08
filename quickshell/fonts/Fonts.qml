pragma Singleton

import QtQuick
import Quickshell

Singleton {
    readonly property string family: aspire.name
    readonly property int size: 14
    FontLoader {
        id: aspire
        source: "../assets/XanhMono-Regular.ttf"
    }
}

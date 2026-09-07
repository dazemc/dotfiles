import QtQuick
import "../themes/"

Gradient {
    GradientStop {
        position: 0.0
        color: Colors.widgetGradientTop
    }
    GradientStop {
        position: 0.3
        color: Colors.widget
    }

    GradientStop {
        position: 1.5
        color: Colors.widgetGradientBottom
    }
}

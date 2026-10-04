// Text in the shell's font: Google Sans Flex with caelestia's axes.
import QtQuick

Text {
    property int pointSize: Theme.size.medium

    color: Theme.m3onSurface
    font.family: Theme.sans
    font.pointSize: pointSize
    font.variableAxes: ({ ROND: 25, opsz: pointSize })
    renderType: Text.NativeRendering
    verticalAlignment: Text.AlignVCenter
}

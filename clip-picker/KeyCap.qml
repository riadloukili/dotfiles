// One key of a shortcut, drawn as a keycap: a rounded face over a slightly
// darker base that shows below it, like the key's side.
import QtQuick

Item {
    id: root

    property alias text: label.text

    implicitWidth: Math.max(implicitHeight, label.implicitWidth + Theme.padding.small * 1.5)
    implicitHeight: label.implicitHeight + 6 + depth

    readonly property int depth: 2

    Rectangle {
        anchors.fill: parent
        radius: Theme.rounding.small - 2
        color: Theme.m3outlineVariant
    }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: parent.height - root.depth
        radius: Theme.rounding.small - 2
        color: Theme.m3surfaceContainerHigh

        Label {
            id: label

            anchors.centerIn: parent
            color: Theme.m3onSurfaceVariant
            pointSize: Theme.size.small - 1
            font.weight: Font.Medium
        }
    }
}

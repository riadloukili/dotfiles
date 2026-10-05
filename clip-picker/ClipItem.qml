// One history entry, laid out like caelestia's launcher items: an icon, the
// text with fzf's matched characters picked out, and a dimmer line under it.
// In delete mode the icon becomes a checkbox and marked entries turn red.
import QtQuick
import "markup.js" as Markup

Item {
    id: root

    required property var modelData
    required property int index
    readonly property var entry: modelData.item

    property bool deleteMode
    property bool marked

    signal activated

    implicitHeight: Theme.itemHeight

    Rectangle {
        anchors.fill: parent
        radius: Theme.rounding.large
        color: root.marked ? Theme.m3error : Theme.m3onSurface
        opacity: root.marked ? 0.12 : hover.containsMouse ? 0.08 : 0

        Behavior on opacity {
            NumberAnimation { duration: Theme.effectsDuration }
        }
    }

    MouseArea {
        id: hover

        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.activated()
    }

    Rectangle {
        id: badge

        anchors.left: parent.left
        anchors.leftMargin: Theme.padding.medium
        anchors.verticalCenter: parent.verticalCenter
        implicitWidth: Math.round(Theme.itemHeight * 0.7)
        implicitHeight: implicitWidth
        radius: Theme.rounding.medium
        color: root.marked ? Theme.m3errorContainer : Qt.alpha(Theme.m3secondaryContainer, 0.6)

        Behavior on color {
            ColorAnimation { duration: Theme.effectsDuration }
        }

        Icon {
            anchors.centerIn: parent
            text: !root.deleteMode ? root.entry.icon : root.marked ? "check_box" : "check_box_outline_blank"
            fill: root.marked ? 1 : 0
            color: root.marked ? Theme.m3onErrorContainer : Theme.m3onSecondaryContainer
        }
    }

    Column {
        anchors.left: badge.right
        anchors.leftMargin: Theme.spacing.medium
        anchors.right: openHint.visible ? openHint.left : parent.right
        anchors.rightMargin: Theme.padding.medium
        anchors.verticalCenter: parent.verticalCenter

        Label {
            width: parent.width
            text: root.entry.image ? root.entry.title : Markup.highlighted(root.entry.text, root.modelData.positions, Theme.m3primary)
            textFormat: root.entry.image ? Text.PlainText : Text.StyledText
            font.strikeout: root.marked
            opacity: root.marked ? 0.7 : 1
            elide: Text.ElideRight
            maximumLineCount: 1
        }

        Label {
            width: parent.width
            text: root.entry.detail
            color: root.marked ? Theme.m3error : Theme.m3outline
            pointSize: Theme.size.small
            elide: Text.ElideRight
        }
    }

    // Links and paths open with Ctrl+O.
    Icon {
        id: openHint

        anchors.right: parent.right
        anchors.rightMargin: Theme.padding.medium
        anchors.verticalCenter: parent.verticalCenter
        visible: root.entry.openable && !root.deleteMode
        text: "open_in_new"
        color: Theme.m3outline
        pointSize: Theme.size.medium
    }
}

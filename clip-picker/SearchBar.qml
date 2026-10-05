// The launcher's search pill: search icon, the field, a match counter and a
// clear button. In delete mode the icon and placeholder say so, in red.
import QtQuick

Rectangle {
    id: root

    property alias input: input
    property alias text: input.text
    property string counter
    property bool deleteMode
    property string placeholder: qsTr("Search clipboard")

    implicitHeight: input.implicitHeight + 14 * 2
    radius: height / 2
    color: Qt.alpha(Theme.m3surfaceContainer, Theme.alpha)

    Icon {
        id: searchIcon

        anchors.left: parent.left
        anchors.leftMargin: Theme.padding.large
        anchors.verticalCenter: parent.verticalCenter
        text: root.deleteMode ? "delete" : "search"
        color: root.deleteMode ? Theme.m3error : Theme.m3onSurfaceVariant
        pointSize: Math.round(Theme.size.icon * 0.9)
    }

    TextInput {
        id: input

        anchors.left: searchIcon.right
        anchors.leftMargin: Theme.spacing.medium
        anchors.right: count.left
        anchors.rightMargin: Theme.spacing.medium
        anchors.verticalCenter: parent.verticalCenter

        color: Theme.m3onSurface
        selectionColor: Qt.alpha(Theme.m3primary, 0.4)
        selectedTextColor: Theme.m3onSurface
        font.family: Theme.sans
        font.pointSize: Theme.size.medium
        font.variableAxes: ({ ROND: 25, opsz: Theme.size.medium })
        renderType: Text.NativeRendering
        clip: true
        focus: true

        Label {
            anchors.fill: parent
            text: root.deleteMode ? qsTr("Mark entries to delete") : root.placeholder
            color: root.deleteMode ? Qt.alpha(Theme.m3error, 0.8) : Theme.m3outline
            opacity: input.text ? 0 : 1

            Behavior on opacity {
                NumberAnimation { duration: Theme.effectsDuration }
            }
        }
    }

    Label {
        id: count

        anchors.right: clear.left
        anchors.rightMargin: Theme.spacing.small
        anchors.verticalCenter: parent.verticalCenter
        text: root.counter
        color: Theme.m3outline
        pointSize: Theme.size.small
    }

    Icon {
        id: clear

        anchors.right: parent.right
        anchors.rightMargin: Theme.padding.large
        anchors.verticalCenter: parent.verticalCenter
        text: "close"
        pointSize: Math.round(Theme.size.icon * 0.9)
        opacity: input.text ? 1 : 0

        Behavior on opacity {
            NumberAnimation { duration: Theme.effectsDuration }
        }

        MouseArea {
            anchors.fill: parent
            anchors.margins: -Theme.padding.small
            enabled: input.text
            cursorShape: Qt.PointingHandCursor
            onClicked: input.clear()
        }
    }
}

// A row of shortcuts: keycaps for each key of the combination, then what it
// does. items: [{ keys: ["Ctrl", "D"], label: "delete" }, ...]
import QtQuick

Row {
    id: root

    property var items: []

    spacing: Theme.spacing.large

    Repeater {
        model: root.items

        Row {
            required property var modelData

            spacing: Theme.spacing.small

            Row {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 3

                Repeater {
                    model: modelData.keys

                    KeyCap {
                        required property string modelData

                        text: modelData
                    }
                }
            }

            Label {
                anchors.verticalCenter: parent.verticalCenter
                text: modelData.label
                color: Theme.m3outline
                pointSize: Theme.size.small
            }
        }
    }
}

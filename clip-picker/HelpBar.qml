// Shortcuts as keycaps, then what each does, wrapped onto as many centred
// lines as maxWidth needs. items: [{ keys: ["Ctrl", "D"], label: "delete" }, ...]
//
// Flow would wrap but cannot centre its lines, so the shortcuts are measured
// in a hidden row first and split greedily into lines, each a centred Row; a
// shortcut is never broken across lines.
import QtQuick

Column {
    id: root

    property var items: []
    property real maxWidth: 800
    readonly property int gap: Theme.spacing.large

    readonly property var lines: {
        measurer.count; // re-split once the measuring row has its items
        const out = [];
        let line = [];
        let width = 0;
        for (let i = 0; i < items.length; i++) {
            const w = measurer.itemAt(i)?.implicitWidth ?? 0;
            if (line.length && width + gap + w > maxWidth) {
                out.push(line);
                line = [];
                width = 0;
            }
            width += (line.length ? gap : 0) + w;
            line.push(items[i]);
        }
        if (line.length)
            out.push(line);
        return out;
    }

    spacing: Theme.spacing.small

    Row {
        visible: false

        Repeater {
            id: measurer

            model: root.items
            delegate: shortcut
        }
    }

    Repeater {
        model: root.lines

        Row {
            required property var modelData

            anchors.horizontalCenter: parent.horizontalCenter
            spacing: root.gap

            Repeater {
                model: parent.modelData
                delegate: shortcut
            }
        }
    }

    Component {
        id: shortcut

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

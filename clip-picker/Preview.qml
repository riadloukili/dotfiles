// The highlighted entry in full: scrollable, selectable text, or the image.
// Decoding waits for the selection to settle, and every decode is its own
// process tagged with its entry, so a slow one never paints over a newer pick.
import QtQuick
import Quickshell
import Quickshell.Io

Rectangle {
    id: root

    property var entry: null
    readonly property string cacheDir: `${Quickshell.env("XDG_RUNTIME_DIR")}/clip-picker`
    readonly property int maxChars: 20000

    property string textBody
    property int textLength
    property string imagePath
    property bool loading

    radius: Theme.rounding.large
    color: Qt.alpha(Theme.m3surfaceContainer, Theme.alpha)
    clip: true

    // Text and image keep separate slots, so drop the other kind's content at
    // once: going text -> image -> text must not flash the first text while
    // the second decodes (or image 1 on the way to image 2). Within one kind
    // the old content stays, dimmed, until the new one is in.
    onEntryChanged: {
        if (entry?.image) {
            textBody = "";
            textLength = 0;
        } else {
            imagePath = "";
        }
        loading = true;
        settle.restart();
    }

    Timer {
        id: settle

        interval: 60
        onTriggered: root.decode()
    }

    function decode(): void {
        const e = entry;
        if (!e) {
            loading = false;
            return;
        }
        if (e.image) {
            const file = `${cacheDir}/${e.id}.${e.image.format}`;
            job.createObject(root, {
                entryId: e.id,
                command: ["sh", "-c", 'mkdir -p "$(dirname "$2")"; [ -s "$2" ] || printf "%s" "$1" | cliphist decode > "$2"', "sh", e.line, file],
                callback: () => {
                    imagePath = `file://${file}`;
                    loading = false;
                }
            });
        } else {
            // First line: the full length; then at most maxChars of the text.
            job.createObject(root, {
                entryId: e.id,
                command: ["sh", "-c", 'c=$(printf "%s" "$1" | cliphist decode); printf "%s\\n" "${#c}"; printf "%s" "$c" | head -c "$2"', "sh", e.line, String(maxChars)],
                callback: out => {
                    const nl = out.indexOf("\n");
                    textLength = parseInt(out.slice(0, nl)) || 0;
                    textBody = out.slice(nl + 1);
                    loading = false;
                }
            });
        }
    }

    Component {
        id: job

        Process {
            id: proc

            property string entryId
            property var callback

            running: true
            stdout: StdioCollector {
                onStreamFinished: {
                    if (root.entry && root.entry.id === proc.entryId)
                        proc.callback(text);
                    proc.destroy();
                }
            }
        }
    }

    // Header: what this is.
    Row {
        id: header

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: Theme.padding.large
        spacing: Theme.spacing.small

        // Centred on the label's capitals, not its line box (which also holds
        // the descenders, so the icon would sit low next to "PNG · ...").
        Icon {
            y: summary.y + capMetrics.ascent + capBounds.tightBoundingRect.y + capBounds.tightBoundingRect.height / 2 - height / 2
            text: root.entry?.icon ?? "content_paste"
            color: Theme.m3primary
            pointSize: Theme.size.medium + 2
        }

        FontMetrics {
            id: capMetrics

            font: summary.font
        }

        TextMetrics {
            id: capBounds

            font: summary.font
            text: "H"
        }

        Label {
            id: summary

            text: !root.entry ? "" : root.entry.image ? root.entry.detail : root.textSummary()
            color: Theme.m3onSurfaceVariant
            pointSize: Theme.size.small
        }
    }

    function textSummary(): string {
        if (loading && !textBody)
            return "";
        const lines = textBody ? textBody.split("\n").length : 0;
        const chars = textLength.toLocaleString(Qt.locale(), "f", 0);
        const more = textLength > maxChars ? qsTr(" · preview cut at %1").arg(maxChars.toLocaleString(Qt.locale(), "f", 0)) : "";
        return qsTr("%1 · %2 characters · %3 %4").arg(entry.detail).arg(chars).arg(lines).arg(lines === 1 ? qsTr("line") : qsTr("lines")) + more;
    }

    Item {
        id: body

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        anchors.margins: Theme.padding.large
        anchors.topMargin: Theme.spacing.medium

        opacity: root.loading ? 0.4 : 1

        Behavior on opacity {
            NumberAnimation { duration: Theme.effectsDuration }
        }

        Flickable {
            id: flick

            anchors.fill: parent
            visible: root.entry && !root.entry.image
            contentHeight: textView.implicitHeight
            clip: true
            boundsBehavior: Flickable.StopAtBounds

            TextEdit {
                id: textView

                width: flick.width
                text: root.textBody
                readOnly: true
                selectByMouse: true
                wrapMode: TextEdit.Wrap
                color: Theme.m3onSurface
                selectionColor: Qt.alpha(Theme.m3primary, 0.4)
                selectedTextColor: Theme.m3onSurface
                font.family: Theme.sans
                font.pointSize: Theme.size.medium
                font.variableAxes: ({ ROND: 25, opsz: Theme.size.medium })
                renderType: Text.NativeRendering
            }
        }

        Image {
            anchors.fill: parent
            visible: root.entry?.image ?? false
            source: visible ? root.imagePath : ""
            fillMode: Image.PreserveAspectFit
            asynchronous: true
            cache: false
            smooth: true
            mipmap: true
        }
    }
}

// Clipboard picker: cliphist's history, searched with fzf's algorithm
// (fzf-for-js, the copy caelestia's launcher uses) and shown with a preview
// of the highlighted entry, in the look of caelestia's launcher.
//
//   qs -p ~/.config/clip-picker                    start it
//   qs -p ~/.config/clip-picker ipc call picker toggle   close a running one
//
// Enter or click copies and closes; Ctrl+O opens a link or path with
// xdg-open; Ctrl+D deletes the highlighted entry. Ctrl+Shift+D enters delete
// mode: Tab (or a click) marks, Ctrl+A marks everything shown, Enter deletes
// what is marked and the picker stays open. Esc clears the search, then
// leaves delete mode, then closes. Up/Down and Ctrl+J/K/N/P move. Ctrl+H
// shows or hides a line of these keys. fzf's search syntax works: 'exact
// ^start end$ !not a|b.
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import "fzf.js" as Fzf

ShellRoot {
    id: root

    property var entries: []
    property var finder: null
    property bool closing

    property bool deleteMode
    property bool showHelp
    property var marked: ({}) // entry id -> true; replaced, never mutated, so bindings update
    readonly property int markedCount: Object.keys(marked).length

    readonly property var results: {
        const q = search.text.trim();
        if (!finder)
            return [];
        // Sets do not survive the trip into a delegate's modelData; arrays do.
        return finder.find(q).map(r => ({ item: r.item, positions: Array.from(r.positions) }));
    }

    readonly property var current: list.currentItem?.entry ?? null

    // "[[ binary data 18 KiB png 498x73 ]]" for images, the text otherwise.
    // cliphist list cuts text at 100 characters, so anything acting on the
    // whole entry decodes it first.
    function parse(line: string): var {
        const tab = line.indexOf("\t");
        const id = line.slice(0, tab);
        const text = line.slice(tab + 1);
        const img = text.match(/^\[\[ binary data (.+?) (\w+) (\d+)x(\d+) \]\]$/);
        if (img)
            return {
                id, line, text,
                image: { size: img[1], format: img[2] },
                openable: false,
                icon: "image",
                title: qsTr("%1 image").arg(img[2].toUpperCase()),
                detail: `${img[2].toUpperCase()} · ${img[3]}×${img[4]} · ${img[1]}`
            };
        const link = /^\s*(https?|ftp|file):\/\/\S+\s*$/.test(text);
        const path = /^\s*(~|\/)\S*\s*$/.test(text);
        return {
            id, line, text,
            image: null,
            openable: link || path,
            icon: link ? "link" : path ? "folder" : "notes",
            detail: link ? qsTr("Link") : path ? qsTr("Path") : qsTr("Text")
        };
    }

    function load(): void {
        lister.running = true;
    }

    function copy(entry: var): void {
        if (!entry)
            return;
        // Always name the type: left to guess, wl-copy sniffs the content and
        // can label text as something else (a font, once), which nothing pastes.
        const type = entry.image ? `image/${entry.image.format}` : "text/plain;charset=utf-8";
        Quickshell.execDetached(["sh", "-c", 'printf "%s" "$1" | cliphist decode | wl-copy --type "$2"', "sh", entry.line, type]);
        close();
    }

    // Links go straight to xdg-open; paths (~ expanded) only if they exist,
    // with a notification otherwise rather than xdg-open's silent failure.
    function open(entry: var): void {
        if (!entry?.openable)
            return;
        Quickshell.execDetached(["sh", "-c", `
            t=$(printf "%s" "$1" | cliphist decode | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
            case $t in "~" | "~/"*) t="$HOME\${t#"~"}" ;; esac
            case $t in
                *://*) ;;
                *) [ -e "$t" ] || { notify-send -a Clipboard "Nothing to open" "$t does not exist"; exit 1; } ;;
            esac
            exec xdg-open "$t"`, "sh", entry.line]);
        close();
    }

    function remove(targets: var): void {
        const lines = targets.filter(e => e).map(e => e.line);
        if (!lines.length)
            return;
        deleter.command = ["sh", "-c", 'printf "%s\\n" "$@" | cliphist delete', "sh", ...lines];
        deleter.running = true;
    }

    function toggleMark(entry: var): void {
        if (!entry)
            return;
        const next = Object.assign({}, marked);
        if (next[entry.id])
            delete next[entry.id];
        else
            next[entry.id] = true;
        marked = next;
    }

    // Ctrl+A: mark everything the search shows, or clear if all of it is marked.
    function markAllShown(): void {
        const shown = results.map(r => r.item);
        const all = shown.length && shown.every(e => marked[e.id]);
        const next = Object.assign({}, marked);
        for (const e of shown) {
            if (all)
                delete next[e.id];
            else
                next[e.id] = true;
        }
        marked = next;
    }

    function setDeleteMode(on: bool): void {
        deleteMode = on;
        marked = {};
    }

    function close(): void {
        if (closing)
            return;
        closing = true;
        hideAnim.start();
    }

    IpcHandler {
        target: "picker"

        function toggle(): void {
            root.close();
        }
    }

    Process {
        id: lister

        command: ["cliphist", "list"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.entries = text.split("\n").filter(l => l.includes("\t")).map(root.parse);
                root.finder = new Fzf.Finder(root.entries, {
                    selector: e => e.text,
                    match: Fzf.extendedMatch,
                    fuzzy: "v2",
                    casing: "smart-case"
                });
            }
        }
    }

    Process {
        id: deleter

        onExited: {
            const keep = list.currentIndex;
            root.setDeleteMode(false);
            root.load();
            list.currentIndex = Math.max(0, Math.min(keep, list.count - 1));
        }
    }

    Component.onCompleted: load()

    PanelWindow {
        id: win

        screen: Quickshell.screens.find(s => s.name === Hyprland.focusedMonitor?.name) ?? Quickshell.screens[0]
        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }
        color: "transparent"

        WlrLayershell.namespace: "clip-picker"
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: root.closing ? WlrKeyboardFocus.None : WlrKeyboardFocus.Exclusive
        WlrLayershell.exclusionMode: ExclusionMode.Ignore

        // A click anywhere outside the panel closes.
        MouseArea {
            anchors.fill: parent
            onClicked: root.close()
        }

        Rectangle {
            id: panel

            anchors.centerIn: parent
            width: content.width + Theme.padding.large * 2
            height: content.height + Theme.padding.large * 2
            radius: Theme.rounding.extraLarge
            color: Qt.alpha(Theme.m3surface, Theme.alpha)

            // Pops in like caelestia's launcher rule does for fuzzel ("popin 80%"),
            // on M3's emphasized-decelerate curve.
            opacity: 0
            scale: 0.8

            // Swallow clicks so they do not reach the close-on-outside area.
            MouseArea {
                anchors.fill: parent
            }

            Column {
                id: content

                anchors.centerIn: parent
                spacing: Theme.padding.large

                Row {
                    spacing: Theme.padding.large

                    Item {
                        width: Theme.listWidth
                        height: (Theme.itemHeight + Theme.spacing.small) * Theme.maxShown - Theme.spacing.small

                        ListView {
                            id: list

                            anchors.fill: parent
                            clip: true
                            spacing: Theme.spacing.small
                            model: root.results
                            boundsBehavior: Flickable.StopAtBounds
                            keyNavigationEnabled: false
                            highlightFollowsCurrentItem: false
                            highlightRangeMode: ListView.ApplyRange
                            preferredHighlightBegin: 0
                            preferredHighlightEnd: height
                            onModelChanged: currentIndex = 0

                            highlight: Rectangle {
                                radius: Theme.rounding.large
                                color: Theme.m3onSurface
                                opacity: 0.08
                                y: list.currentItem?.y ?? 0
                                width: list.width
                                height: list.currentItem?.height ?? 0

                                Behavior on y {
                                    NumberAnimation {
                                        duration: Theme.effectsDuration * 2
                                        easing.type: Easing.BezierSpline
                                        easing.bezierCurve: Theme.emphasizedDecel
                                    }
                                }
                            }

                            delegate: ClipItem {
                                width: list.width
                                deleteMode: root.deleteMode
                                marked: root.marked[modelData.item.id] === true
                                onActivated: {
                                    if (root.deleteMode) {
                                        list.currentIndex = index;
                                        root.toggleMark(modelData.item);
                                    } else {
                                        root.copy(modelData.item);
                                    }
                                }
                            }
                        }

                        // Nothing to show: caelestia's "no results" row.
                        Row {
                            anchors.centerIn: parent
                            spacing: Theme.spacing.medium
                            visible: list.count === 0 && !lister.running

                            Icon {
                                anchors.verticalCenter: parent.verticalCenter
                                text: root.entries.length ? "manage_search" : "content_paste_off"
                                pointSize: Theme.size.large * 2
                            }

                            Column {
                                anchors.verticalCenter: parent.verticalCenter

                                Label {
                                    text: root.entries.length ? qsTr("No results") : qsTr("Clipboard history is empty")
                                    color: Theme.m3onSurfaceVariant
                                    pointSize: Theme.size.large
                                    font.weight: Font.Medium
                                }

                                Label {
                                    text: root.entries.length ? qsTr("Try searching for something else") : qsTr("Copy something first")
                                    color: Theme.m3outline
                                    pointSize: Theme.size.small
                                }
                            }
                        }
                    }

                    Preview {
                        width: Theme.previewWidth
                        height: parent.height
                        entry: root.current
                    }
                }

                // The search bar, and under it the shortcuts (Ctrl+H), which
                // grow and fade in rather than appear. Grouped without spacing so
                // the hidden help leaves no gap below the bar.
                Column {

                    SearchBar {
                        id: search

                        width: Theme.listWidth + Theme.padding.large + Theme.previewWidth
                        deleteMode: root.deleteMode
                        counter: {
                            if (!root.entries.length)
                                return "";
                            const shown = `${list.count}/${root.entries.length}`;
                            return root.deleteMode ? qsTr("%1 marked · %2").arg(root.markedCount).arg(shown) : shown;
                        }

                        input.Keys.onPressed: event => {
                            const ctrl = event.modifiers & Qt.ControlModifier;
                            const shift = event.modifiers & Qt.ShiftModifier;
                            const key = event.key;
                            const enter = key === Qt.Key_Return || key === Qt.Key_Enter;

                            if (key === Qt.Key_Down || ctrl && (key === Qt.Key_J || key === Qt.Key_N))
                                list.incrementCurrentIndex();
                            else if (key === Qt.Key_Up || ctrl && (key === Qt.Key_K || key === Qt.Key_P))
                                list.decrementCurrentIndex();
                            else if (key === Qt.Key_PageDown)
                                list.currentIndex = Math.min(list.count - 1, list.currentIndex + Theme.maxShown);
                            else if (key === Qt.Key_PageUp)
                                list.currentIndex = Math.max(0, list.currentIndex - Theme.maxShown);
                            else if (key === Qt.Key_Escape && search.text)
                                search.input.clear(); // Esc: the search first, then delete mode, then the picker
                            else if (key === Qt.Key_Escape && root.deleteMode)
                                root.setDeleteMode(false);
                            else if (key === Qt.Key_Escape)
                                root.close();
                            else if (ctrl && key === Qt.Key_H)
                                root.showHelp = !root.showHelp;
                            else if (ctrl && shift && key === Qt.Key_D)
                                root.setDeleteMode(!root.deleteMode);
                            else if (root.deleteMode && key === Qt.Key_Tab) {
                                root.toggleMark(root.current);
                                list.incrementCurrentIndex();
                            } else if (root.deleteMode && key === Qt.Key_Backtab) {
                                root.toggleMark(root.current);
                                list.decrementCurrentIndex();
                            } else if (root.deleteMode && ctrl && key === Qt.Key_A)
                                root.markAllShown();
                            else if (root.deleteMode && enter)
                                root.remove(root.markedCount ? root.entries.filter(e => root.marked[e.id]) : [root.current]);
                            else if (key === Qt.Key_Tab)
                                list.incrementCurrentIndex();
                            else if (key === Qt.Key_Backtab)
                                list.decrementCurrentIndex();
                            else if (enter)
                                root.copy(root.current);
                            else if (ctrl && key === Qt.Key_O)
                                root.open(root.current);
                            else if (ctrl && key === Qt.Key_D)
                                root.remove([root.current]);
                            else
                                return;
                            event.accepted = true;
                        }
                    }

                    Item {
                        id: help

                        width: search.width
                        height: root.showHelp ? helpBar.implicitHeight + Theme.padding.large : 0
                        opacity: root.showHelp ? 1 : 0
                        clip: true

                        Behavior on height {
                            NumberAnimation {
                                duration: Theme.effectsDuration * 1.5
                                easing.type: Easing.BezierSpline
                                easing.bezierCurve: Theme.emphasizedDecel
                            }
                        }

                        Behavior on opacity {
                            NumberAnimation { duration: Theme.effectsDuration }
                        }

                        HelpBar {
                            id: helpBar

                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            items: root.deleteMode ? [
                                { keys: ["Tab"], label: qsTr("mark") },
                                { keys: ["Ctrl", "A"], label: qsTr("mark all shown") },
                                { keys: ["Enter"], label: root.markedCount ? qsTr("delete %1 marked").arg(root.markedCount) : qsTr("delete highlighted") },
                                { keys: ["Esc"], label: qsTr("back") },
                                { keys: ["Ctrl", "H"], label: qsTr("hide help") }
                            ] : [
                                { keys: ["Enter"], label: qsTr("copy") },
                                { keys: ["Ctrl", "O"], label: qsTr("open link or path") },
                                { keys: ["Ctrl", "D"], label: qsTr("delete") },
                                { keys: ["Ctrl", "Shift", "D"], label: qsTr("delete several") },
                                { keys: ["Esc"], label: qsTr("close") },
                                { keys: ["Ctrl", "H"], label: qsTr("hide help") }
                            ]
                        }
                    }
                }
            }

            Component.onCompleted: showAnim.start()

            ParallelAnimation {
                id: showAnim

                NumberAnimation {
                    target: panel
                    property: "opacity"
                    to: 1
                    duration: Theme.effectsDuration
                }

                NumberAnimation {
                    target: panel
                    property: "scale"
                    to: 1
                    duration: Theme.spatialDuration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Theme.emphasizedDecel
                }
            }

            ParallelAnimation {
                id: hideAnim

                onFinished: Qt.quit()

                NumberAnimation {
                    target: panel
                    property: "opacity"
                    to: 0
                    duration: Theme.effectsDuration
                }

                NumberAnimation {
                    target: panel
                    property: "scale"
                    to: 0.8
                    duration: Theme.effectsDuration
                    easing.type: Easing.InCubic
                }
            }
        }
    }
}

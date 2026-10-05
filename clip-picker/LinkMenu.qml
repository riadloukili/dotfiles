// "Open which link?": shown over the picker when Ctrl+O finds several links
// in an entry. It behaves like the clipboard list -- same highlight, hover,
// scrolling and movement keys -- and handles its own keys (handleKey), fed by
// the picker's search field, or by its own once "/" has opened its search.
// Matching is fzf.js, as in the list, with matched characters picked out.
import QtQuick
import "fzf.js" as Fzf
import "markup.js" as Markup

Item {
    id: root

    property var links: []
    property Item returnFocusTo // the picker's search field, given focus back on leaving
    property bool showHelp // its own help footer, for its own keys; Ctrl+H toggles both
    readonly property bool shown: links.length > 0

    property bool searching
    readonly property string query: field.text.trim()
    readonly property var results: {
        if (!finder)
            return [];
        return finder.find(query).map(r => ({ url: r.item, positions: Array.from(r.positions) }));
    }
    property var finder: null
    property int current: 0

    signal chosen(url: string)
    signal helpToggled

    // Nine rows, one per number shortcut; also the screenful PgUp/PgDn move
    // by, as in the main list. Rows are a little shorter than the list's so
    // nine fit in the picker even with the search open.
    readonly property int shownRows: 9
    readonly property int rowHeight: 40

    function next(): void {
        current = Math.min(results.length - 1, current + 1);
    }

    function previous(): void {
        current = Math.max(0, current - 1);
    }

    function pageDown(): void {
        current = Math.min(results.length - 1, current + shownRows);
    }

    function pageUp(): void {
        current = Math.max(0, current - shownRows);
    }

    function accept(index: int): void {
        if (index >= 0 && index < results.length)
            chosen(results[index].url);
    }

    function openSearch(): void {
        searching = true;
        field.input.forceActiveFocus();
    }

    function closeSearch(): void {
        searching = false;
        field.input.clear();
        returnFocusTo?.forceActiveFocus();
    }

    function dismiss(): void {
        links = [];
    }

    // Every key while the menu is up. Returns false only for what the search
    // field should type itself. Esc steps back like the picker's: the search
    // text, then the search, then the menu.
    function handleKey(event): bool {
        const ctrl = event.modifiers & Qt.ControlModifier;
        const key = event.key;

        if (key === Qt.Key_Down || key === Qt.Key_Tab || ctrl && (key === Qt.Key_J || key === Qt.Key_N))
            next();
        else if (key === Qt.Key_Up || key === Qt.Key_Backtab || ctrl && (key === Qt.Key_K || key === Qt.Key_P))
            previous();
        else if (key === Qt.Key_PageDown)
            pageDown();
        else if (key === Qt.Key_PageUp)
            pageUp();
        else if (key === Qt.Key_Return || key === Qt.Key_Enter)
            accept(current);
        else if (ctrl && key === Qt.Key_H)
            helpToggled();
        else if (key === Qt.Key_Escape && field.text)
            field.input.clear();
        else if (key === Qt.Key_Escape && searching)
            closeSearch();
        else if (key === Qt.Key_Escape)
            dismiss();
        else if (searching)
            return false; // typed into the search
        else if (event.text === "/")
            openSearch();
        else if (key >= Qt.Key_1 && key <= Qt.Key_9)
            accept(key - Qt.Key_1);
        return true;
    }

    onLinksChanged: {
        finder = new Fzf.Finder(links, { selector: url => url, match: Fzf.extendedMatch, fuzzy: "v2", casing: "smart-case" });
        if (!links.length) {
            searching = false;
            field.input.clear();
            returnFocusTo?.forceActiveFocus();
        }
        current = 0;
    }
    onResultsChanged: current = 0

    visible: opacity > 0
    opacity: shown ? 1 : 0

    Behavior on opacity {
        NumberAnimation { duration: Theme.effectsDuration }
    }

    // Dim the picker behind; a click there goes back to it. It also takes the
    // hover and the wheel, so the list underneath neither lights up nor
    // scrolls while the menu is up.
    Rectangle {
        anchors.fill: parent
        radius: Theme.rounding.extraLarge
        color: Qt.alpha(Theme.m3surface, 0.6)

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onClicked: root.dismiss()
            onWheel: wheel => wheel.accepted = true
        }
    }

    Rectangle {
        id: card

        anchors.centerIn: parent
        width: Math.min(680, parent.width - Theme.padding.large * 4)
        height: column.implicitHeight + Theme.padding.large * 2
        radius: Theme.rounding.extraLarge
        color: Theme.m3surfaceContainer
        scale: root.shown ? 1 : 0.9

        Behavior on scale {
            NumberAnimation {
                duration: Theme.spatialDuration
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Theme.emphasizedDecel
            }
        }

        // Swallow clicks, hover and wheel so they reach neither the dismissing
        // scrim nor the list under it (the link list scrolls itself, on top).
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onWheel: wheel => wheel.accepted = true
        }

        Column {
            id: column

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: Theme.padding.large

            Row {
                spacing: Theme.spacing.small
                leftPadding: Theme.padding.small

                Icon {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "link"
                    color: Theme.m3primary
                }

                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("Open which link?")
                    pointSize: Theme.size.large
                    font.weight: Font.Medium
                }

                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("%1 found").arg(root.links.length)
                    color: Theme.m3outline
                    pointSize: Theme.size.small
                }
            }

            // The search, slid open by "/" the way the picker's help is.
            Item {
                width: parent.width
                height: root.searching ? field.implicitHeight + Theme.spacing.medium : 0
                opacity: root.searching ? 1 : 0
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

                SearchBar {
                    id: field

                    anchors.bottom: parent.bottom
                    width: parent.width
                    placeholder: qsTr("Search links")
                    counter: `${root.results.length}/${root.links.length}`
                    input.focus: false
                    input.Keys.onPressed: event => event.accepted = root.handleKey(event)
                }
            }

            Item {
                width: parent.width
                height: Theme.spacing.medium
            }

            ListView {
                id: list

                readonly property int rows: Math.max(1, Math.min(root.links.length, root.shownRows))

                width: parent.width
                // Sized for the links, not the matches, so searching does not
                // make the card jump.
                height: rows * root.rowHeight + (rows - 1) * spacing
                clip: true
                spacing: 4
                model: root.results
                currentIndex: root.current
                boundsBehavior: Flickable.StopAtBounds
                keyNavigationEnabled: false
                highlightFollowsCurrentItem: false
                highlightRangeMode: ListView.ApplyRange
                preferredHighlightBegin: 0
                preferredHighlightEnd: height

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

                delegate: Item {
                    required property var modelData
                    required property int index

                    width: list.width
                    height: root.rowHeight

                    // As in the main list: hover only lights the row up; the
                    // selection moves with the keys, and a click opens.
                    Rectangle {
                        anchors.fill: parent
                        radius: Theme.rounding.large
                        color: Theme.m3onSurface
                        opacity: hover.containsMouse ? 0.08 : 0

                        Behavior on opacity {
                            NumberAnimation { duration: Theme.effectsDuration }
                        }
                    }

                    MouseArea {
                        id: hover

                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.accept(index)
                    }

                    // Numbered while not searching, when 1-9 pick directly.
                    KeyCap {
                        id: number

                        anchors.left: parent.left
                        anchors.leftMargin: Theme.padding.medium
                        anchors.verticalCenter: parent.verticalCenter
                        opacity: !root.searching && index < 9 ? 1 : 0
                        text: String(index + 1)

                        Behavior on opacity {
                            NumberAnimation { duration: Theme.effectsDuration }
                        }
                    }

                    Label {
                        anchors.left: parent.left
                        anchors.leftMargin: Theme.padding.medium + number.implicitWidth + Theme.spacing.medium
                        anchors.right: parent.right
                        anchors.rightMargin: Theme.padding.medium
                        anchors.verticalCenter: parent.verticalCenter
                        text: Markup.highlighted(modelData.url, modelData.positions, Theme.m3primary)
                        textFormat: Text.StyledText
                        elide: Text.ElideMiddle
                    }
                }

                Label {
                    anchors.centerIn: parent
                    visible: list.count === 0
                    text: qsTr("No matching links")
                    color: Theme.m3outline
                }
            }

            // This menu's shortcuts, shown and hidden with the picker's (Ctrl+H)
            // and sliding the same way, while the picker's footer keeps its own.
            // Ctrl+H itself is listed only there, since it toggles both.
            Item {
                width: parent.width
                height: root.showHelp ? menuHelp.implicitHeight + Theme.padding.large : 0
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
                    id: menuHelp

                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    maxWidth: parent.width
                    items: root.searching ? [
                        { keys: ["Enter"], label: qsTr("open") },
                        { keys: ["Esc"], label: root.query ? qsTr("clear search") : qsTr("close search") }
                    ] : [
                        { keys: ["Enter"], label: qsTr("open") },
                        { keys: ["1–9"], label: qsTr("open by number") },
                        { keys: ["/"], label: qsTr("search") },
                        { keys: ["Esc"], label: qsTr("back") }
                    ]
                }
            }
        }
    }
}

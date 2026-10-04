pragma Singleton

// caelestia's look, outside caelestia: the current scheme's colours (re-read
// whenever the CLI rewrites scheme.json) and the shell's tokens -- rounding,
// spacing, sizes, fonts -- copied from its Caelestia.Config defaults.
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property var colours: ({})

    function c(name: string, fallback: string): color {
        const hex = colours[name];
        return hex ? `#${hex}` : fallback;
    }

    // Colours (Material 3 roles, as caelestia names them)
    readonly property color m3surface: c("surface", "#131317")
    readonly property color m3surfaceContainer: c("surfaceContainer", "#1f1f23")
    readonly property color m3surfaceContainerHigh: c("surfaceContainerHigh", "#2a2a2e")
    readonly property color m3onSurface: c("onSurface", "#e4e1e7")
    readonly property color m3onSurfaceVariant: c("onSurfaceVariant", "#c6c5d1")
    readonly property color m3outline: c("outline", "#90909a")
    readonly property color m3primary: c("primary", "#bac3ff")
    readonly property color m3onPrimary: c("onPrimary", "#232c60")
    readonly property color m3secondaryContainer: c("secondaryContainer", "#42455c")
    readonly property color m3onSecondaryContainer: c("onSecondaryContainer", "#b1b3ce")
    readonly property color m3error: c("error", "#ffb4ab")
    readonly property color m3errorContainer: c("errorContainer", "#93000a")
    readonly property color m3onErrorContainer: c("onErrorContainer", "#ffdad6")

    // appearance.transparency: enabled in shell.json, caelestia's base is 0.85
    readonly property real alpha: 0.85

    // Tokens
    readonly property var rounding: ({ small: 8, medium: 12, large: 16, extraLarge: 28 })
    readonly property var spacing: ({ small: 8, medium: 12, large: 16 })
    readonly property var padding: ({ small: 8, medium: 12, large: 16 })
    readonly property int itemHeight: 57
    readonly property int listWidth: 600
    readonly property int previewWidth: 520
    readonly property int maxShown: 7

    // Fonts: caelestia's body/label styles (point sizes; opsz follows the size,
    // ROND 25 is its default rounding for Google Sans Flex).
    readonly property string sans: "Google Sans Flex"
    readonly property string icons: "Material Symbols Rounded"
    readonly property var size: ({ small: 12, medium: 14, large: 16, icon: 18 })

    // Motion: expressive default spatial (500 ms) on M3's emphasized-decelerate
    // curve for the panel, standard (200 ms) for the small stuff.
    readonly property int spatialDuration: 500
    readonly property list<real> emphasizedDecel: [0.05, 0.7, 0.1, 1, 1, 1]
    readonly property int effectsDuration: 200

    FileView {
        path: `${Quickshell.env("XDG_STATE_HOME") || Quickshell.env("HOME") + "/.local/state"}/caelestia/scheme.json`
        watchChanges: true
        onFileChanged: reload()
        onLoaded: {
            try {
                root.colours = JSON.parse(text()).colours ?? {};
            } catch (e) {
                console.warn(`clip-picker: unreadable scheme.json: ${e}`);
            }
        }
    }
}

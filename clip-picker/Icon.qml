// A Material Symbols glyph, as caelestia's MaterialIcon draws them -- but
// sized and centred by the glyph's design square (one em, standing on the
// baseline) rather than the font's line box, which has more room below the
// baseline than above and leaves icons sitting high when centred.
import QtQuick

Item {
    id: root

    property alias text: glyph.text
    property alias color: glyph.color
    property real fill: 0
    property int pointSize: Theme.size.icon

    implicitWidth: glyph.implicitWidth
    implicitHeight: glyph.implicitWidth

    FontMetrics {
        id: metrics

        font: glyph.font
    }

    Text {
        id: glyph

        y: root.implicitHeight - metrics.ascent
        color: Theme.m3onSurfaceVariant
        font.family: Theme.icons
        font.pointSize: root.pointSize
        font.variableAxes: ({ FILL: root.fill, opsz: root.pointSize })
        renderType: Text.NativeRendering
    }
}

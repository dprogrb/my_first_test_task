# Generates main/game.gui — run: python tools/_gen_gui.py from project root
positions = [
    (368, 190),
    (480, 190),
    (592, 190),
    (368, 302),
    (480, 302),
    (592, 302),
    (368, 414),
    (480, 414),
    (592, 414),
]
text_block = """nodes {
  position {
    x: %.1f
    y: %.1f
    z: 0.0
    w: 0.0
  }
  rotation {
    x: 0.0
    y: 0.0
    z: 0.0
    w: 0.0
  }
  scale {
    x: 1.0
    y: 1.0
    z: 1.0
    w: 0.0
  }
  size {
    x: 100.0
    y: 100.0
    z: 0.0
    w: 0.0
  }
  color {
    x: 1.0
    y: 1.0
    z: 1.0
    w: 1.0
  }
  type: TYPE_TEXT
  blend_mode: BLEND_MODE_ALPHA
  text: "%s"
  texture: ""
  font: "system_font"
  id: "%s"
  xanchor: XANCHOR_NONE
  yanchor: YANCHOR_NONE
  pivot: PIVOT_CENTER
  outline {
    x: 0.0
    y: 0.0
    z: 0.0
    w: 1.0
  }
  shadow {
    x: 0.0
    y: 0.0
    z: 0.0
    w: 1.0
  }
}
"""
parts = []
parts.append(
    """script: "/main/game.gui_script"
fonts {
  name: "system_font"
  font: "/builtins/fonts/default.font"
}
textures: []
background_color {
  x: 0.15
  y: 0.15
  z: 0.18
  w: 1.0
}
"""
)
for i, (x, y) in enumerate(positions, start=1):
    parts.append(text_block % (x, y, " ", "cell%d" % i))
for name, tx, x, y in [
    ("hud_p1", "P1: 0", 120, 580),
    ("hud_p2", "P2: 0", 840, 580),
    ("hud_round", "Round 1", 480, 580),
]:
    parts.append(text_block % (x, y, tx, name))
parts.append(
    """nodes {
  position { x: 480.0 y: 320.0 z: 0.0 w: 0.0 }
  rotation { x: 0.0 y: 0.0 z: 0.0 w: 0.0 }
  scale { x: 1.0 y: 1.0 z: 1.0 w: 0.0 }
  size { x: 420.0 y: 220.0 z: 0.0 w: 0.0 }
  color { x: 0.1 y: 0.1 z: 0.12 w: 0.95 }
  type: TYPE_BOX
  blend_mode: BLEND_MODE_ALPHA
  texture: ""
  id: "popup_panel"
  xanchor: XANCHOR_NONE
  yanchor: YANCHOR_NONE
  pivot: PIVOT_CENTER
  adjust_mode: ADJUST_MODE_FIT
  layer: ""
  inherit_alpha: true
  slice9 { x: 0.0 y: 0.0 z: 0.0 w: 0.0 }
  clipping_mode: CLIPPING_MODE_NONE
  clipping_visible: true
  clipping_inverted: false
  alpha: 1.0
  template_node_child: false
  size_mode: SIZE_MODE_MANUAL
}
"""
)
parts.append(text_block % (480, 360, "Message", "popup_title"))
parts.append(text_block % (480, 300, "[ Priest ]", "popup_priest"))
parts.append(text_block % (480, 240, "Tap to continue", "popup_hint"))
parts.append(
    '\nmaterial: "/builtins/materials/gui.material"\nadjust_reference: ADJUST_REFERENCE_PARENT\nmax_nodes: 512\n'
)
open("main/game.gui", "w", encoding="utf-8").writelines(parts)
print("main/game.gui written")

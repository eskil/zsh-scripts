set_tab() {
  local name="$1"
  local color="$2"

  if [[ -z "$name" ]]; then
    echo "Usage: set_tab <name> [color]" >&2
    return 1
  fi

  # Set iTerm2 tab name
  printf "\033]1;%s\007" "$name"

  # Named color map (CSS color names)
  local -A named_colors=(
    red       "#ff0000"
    green     "#00ff00"
    blue      "#0000ff"
    yellow    "#ffff00"
    orange    "#ffa500"
    purple    "#800080"
    magenta   "#ff00ff"
    cyan      "#00ffff"
    teal      "#008080"
    pink      "#ffc0cb"
    violet    "#ee82ee"
    indigo    "#4b0082"
    brown     "#a52a2a"
    grey      "#808080"
    gray      "#808080"
    black     "#000000"
    white     "#ffffff"
    slateblue "#6a5acd"
    gold      "#ffd700"
    coral     "#ff7f50"
  )

  # If color is a name, convert to hex
  if [[ -n "$color" && -v named_colors[$color] ]]; then
    color="${named_colors[$color]}"
  fi

  # If color is not specified, hash the name for a consistent color
  if [[ -z "$color" ]]; then
    local hash=$(echo -n "$name" | md5 | tr -dc '0-9' | cut -c1-5)
    local hue=$((hash % 360))
    local s=0.6
    local v=0.9
    local h=$(echo "scale=2; $hue / 60" | bc)

    read r g b <<< $(awk -v h="$h" -v s="$s" -v v="$v" '
      function hsv2rgb(h, s, v,   c, x, m, r, g, b, i, f) {
        c = v * s
        i = int(h)
        f = h - i
        x = c * (1 - ((i % 2 == 0) ? 1 - f : f))
        if (i == 0) { r = c; g = x; b = 0 }
        else if (i == 1) { r = x; g = c; b = 0 }
        else if (i == 2) { r = 0; g = c; b = x }
        else if (i == 3) { r = 0; g = x; b = c }
        else if (i == 4) { r = x; g = 0; b = c }
        else { r = c; g = 0; b = x }
        m = v - c
        printf "%d %d %d", (r+m)*255, (g+m)*255, (b+m)*255
      }
      BEGIN { hsv2rgb(h, s, v) }
    ')
  else
    # Parse hex color
    if [[ "$color" =~ ^#?([a-fA-F0-9]{6})$ ]]; then
      local hex="${match[1]}"
      r=$((16#${hex[1,2]}))
      g=$((16#${hex[3,4]}))
      b=$((16#${hex[5,6]}))
    else
      echo "Invalid color format: '$color'" >&2
      return 1
    fi
  fi

  # Set iTerm2 tab color (background brightness)
  printf "\033]6;1;bg;red;brightness;%d\007" "$r"
  printf "\033]6;1;bg;green;brightness;%d\007" "$g"
  printf "\033]6;1;bg;blue;brightness;%d\007" "$b"
}

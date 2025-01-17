#!/bin/bash

HexToRgba() {
    hex_color="$1"
    alpha="${2:-1.0}" 

    hex_color="${hex_color#"#"}"

    r=$((16#${hex_color:0:2}))
    g=$((16#${hex_color:2:2}))
    b=$((16#${hex_color:4:2}))

    echo "rgba($r, $g, $b, $alpha)"
}


#!/bin/bash
# Barra de estado: carpeta (azul) | rama (verde) | modelo (amarillo) | contexto (verde/amarillo/rojo)
input=$(cat)
pct=$(printf '%s' "$input" | grep -oE '"used_percentage":[0-9.]+' | head -1 | grep -oE '[0-9.]+' | cut -d. -f1)
modelo=$(printf '%s' "$input" | grep -oE '"display_name":"[^"]*"' | head -1 | cut -d'"' -f4)
rama=$(git branch --show-current 2>/dev/null)
pct=${pct:-0}

azul=$'\033[94m'; verde=$'\033[92m'; amarillo=$'\033[93m'; rojo=$'\033[91m'; gris=$'\033[90m'; fin=$'\033[0m'

# Contexto usado: verde hasta 59 %, amarillo de 60 a 84 %, rojo desde 85 %.
if [ "$pct" -ge 85 ]; then color_ctx=$rojo
elif [ "$pct" -ge 60 ]; then color_ctx=$amarillo
else color_ctx=$verde; fi

sep="${gris} | ${fin}"
printf '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%% ctx%s\n' \
  "$azul" "$(basename "$PWD")" "$fin" "$sep" \
  "$verde" "${rama:-no git}" "$fin" "$sep" \
  "$amarillo" "${modelo:-?}" "$fin" "$sep" \
  "$color_ctx" "$pct" "$fin"

#!/bin/bash

HDMI_DISPLAY=$(xrandr -q | grep " connected" | grep -oP 'HDMI[^\s]*')
if [[ "$HDMI_DISPLAY" ]]; then
  xrandr --output $HDMI_DISPLAY --set "Broadcast RGB" "Full"
fi

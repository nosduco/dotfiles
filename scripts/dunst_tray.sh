#!/bin/bash

COUNT=$(dunstctl count waiting)
ENABLED="<span font=\"Material Design Icons\" size='large' font_weight='normal' rise='-1500'>󰂚</span>"
DISABLED="<span font=\"Material Design Icons\" size='large' font_weight='normal' rise='-1500'>󰂛</span>"
if [ $COUNT != 0 ]; then DISABLED="<span font=\"Materail Design Icons\" size='large' font_weight='normal' rise='-1500'>󰅸</span> $COUNT"; fi
if dunstctl is-paused | grep -q "false" ; then echo $ENABLED; else echo $DISABLED; fi

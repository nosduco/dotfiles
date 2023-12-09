#!/bin/bash

# Import secrets
set -a # automatically export all variables
source ~/.dotfiles/.env
set +a


# Check arguments
if [ -z "$1" ]; then
  echo "Expected argument to be one of: [default, chill, christmas]"
  exit 1
fi

# Change scene based on argument
if [ $1 = "relax" ]; then
  hass-cli service call hue.activate_scene --arguments entity_id=scene.tony_s_office_relax
elif [ $1 = "chill" ]; then
  hass-cli service call hue.activate_scene --arguments entity_id=scene.tony_s_office_chill
elif [ $1 = "christmas" ]; then
  hass-cli service call hue.activate_scene --arguments entity_id=scene.tony_s_office_christmas
fi


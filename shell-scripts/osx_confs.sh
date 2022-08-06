#! /bin/bash

# Add half-height spacer to dock
# defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="small-spacer-tile";}'

# Show hidden running apps in dock as transparent icons
# defaults write com.apple.Dock showhidden -bool TRUE && killAll Dock

# Adjust delay before dock opens when hidden
# defaults write com.apple.dock autohide-delay -float 0.1 && killAll Dock

# Adjust dock animation speed when hidden
# defaults write com.apple.dock autohide-time-modifier -float 0.35 && killAll Dock

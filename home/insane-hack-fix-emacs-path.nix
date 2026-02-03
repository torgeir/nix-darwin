{ config, lib, pkgs, ... }:

{
  # something is iffy with how this setup moves Emacs.app to /Application/.
  # this fixes path issues afterwards

  home.activation.emacsAppEnv = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    DOOMDIR_VALUE="${config.home.sessionVariables.DOOMDIR}"
    DOOMLOCALDIR_VALUE="${config.home.sessionVariables.DOOMLOCALDIR}"
    DOOMPROFILELOADFILE_VALUE="${config.home.sessionVariables.DOOMPROFILELOADFILE}"
    EMACS_APP="/Applications/Emacs.app"
    PLIST_FILE="$EMACS_APP/Contents/Info.plist"
    NEW_EMACS_PATH="/run/current-system/sw/bin:/etc/profiles/per-user/$(whoami)/bin:${config.xdg.configHome}/emacs/bin:${config.home.homeDirectory}/.doom.d/bin:/usr/bin:/bin:/usr/sbin:/sbin"

    if [ -d "$EMACS_APP" ]; then
      echo "Modified Emacs.app environment variables.."
      /usr/bin/sudo chmod -R u+w "$EMACS_APP"

      # Modify the existing Emacs.app Info.plist to include environment variables
      /usr/libexec/PlistBuddy -c "Add :LSEnvironment dict" $PLIST_FILE 2>/dev/null || true
      /usr/libexec/PlistBuddy -c "Add :LSEnvironment:DOOMDIR string $DOOMDIR_VALUE" $PLIST_FILE || true
      /usr/libexec/PlistBuddy -c "Add :LSEnvironment:DOOMLOCALDIR string $DOOMLOCALDIR_VALUE" $PLIST_FILE || true
      /usr/libexec/PlistBuddy -c "Add :LSEnvironment:DOOMPROFILELOADFILE string $DOOMPROFILELOADFILE_VALUE" $PLIST_FILE || true
      /usr/libexec/PlistBuddy -c "Add :LSEnvironment:PATH string $NEW_EMACS_PATH" $PLIST_FILE || true

      # Clear Launch Services cache so the changes take effect
      /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

      echo "Modified Emacs.app environment variables.. OK"
    fi
  '';

}

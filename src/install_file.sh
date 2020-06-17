#/bin/bash

# Install file based on extension

matches_exist () {
  [ $# -gt 1 ] || [ -e "$1" ]
}

file_path=$1
file_name=$(/usr/bin/basename $file_path)

if [[ $file_path == *.dmg ]]; then
  VOLUME=$(hdiutil attach -nobrowse "$file_path" | cut -f3 | tail -n1 ; exit ${PIPESTATUS[0]})

  if matches_exist "$VOLUME"/*.app  ; then
    app_name=`ls -dl -A1 "$VOLUME"/*.app | head -n1 | xargs /usr/bin/basename -s`

 	  (rsync -a "$VOLUME"/*.app /Applications/ 2>/dev/null; SYNCED=$?
  		hdiutil detach -quiet "$VOLUME"; exit $? || exit "$SYNCED")
  	echo "Installed $app_name"

  elif matches_exist "$VOLUME"/*.pkg ; then
    echo "Opening package found in DMG..."
    open "$VOLUME"/*.pkg
  fi

elif [[ $file_path == *.pkg ]]; then
  echo "Opening package $file_name..."
  open "$file_path"
fi
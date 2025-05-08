####
# run_file_link.sh FILE
#
# Search and replace numerous patterns and overwrite input file.
#
# Expected to run with find, for example
#
#    find [b-it]* -type f \( -name "*.htm" -o -name "*.txt" \) -exec bash resources/bin/run_file_link.sh {} \;
#
####

for FILE in "$@"; do
  if [[ ! -f "$FILE" ]]; then
    echo "File $FILE does not exist" >&2
    exit 0
  fi

  TMPFILE=$(mktemp)

  if sed -E \
    -e "s:[_~-]m:-m:g" \
    -e "s:[_~][nm]k:-nk:g" -e "s:[_~][nm]g:-ng:g" \
    -e "s:[_-][nm]c:~nc:g" -e "s:[_-][nm]j:~nj:g" \
    -e "s:[-~][nm]_d:_n_d:g" -e "s:[-~][nm]_t:_n_t:g" \
    -e "s:/by.nc/:/by-nc/:g" -e "s:/by.nc.nd/:/by-nc-nd/:g" -e "s:cc.by.nc.png:cc_by_nc.png:g" \
    "$FILE" >"$TMPFILE"; then
    mv "$TMPFILE" "$FILE"
  else
    echo "Error processing $FILE" >&2
    rm -f "$TMPFILE"
    exit 1
  fi
done

exit 0

####
# run_file_link_pali.sh FILE
#
# Search and replace numerous patterns and overwrite input file.
#
# Expected to run with find, for example
#
#    find [b-it]* -type f \( -name "*.htm" -o -name "*.txt" \)
#
#    -exec bash resources/bin/run_file_link_pali.sh {} \;
#    or
#    | xargs -n 100 bash "$RUN_PALI";
#
####

for FILE in "$@"; do
  if [[ ! -f "$FILE" ]]; then
    echo "File $FILE does not exist" >&2
    exit 0
  fi

  TMPFILE=$(mktemp)

  if sed -E \
    -e "s:([Ss])er.n[ti]*y:\1erenity:g" \
    "$FILE" >"$TMPFILE"; then
    mv "$TMPFILE" "$FILE"
  else
    echo "Error processing $FILE" >&2
    rm -f "$TMPFILE"
    exit 1
  fi
done

exit 0

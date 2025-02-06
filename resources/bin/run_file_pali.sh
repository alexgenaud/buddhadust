####
# run_file_link_pali.sh FILE
#
# Search and replace numerous patterns and overwrite input file.
#
# Expected to run with find, for example
#
#    find [b-it]* -type f \( -name "*.htm" -o -name "*.txt" \) -exec bash resources/bin/run_file_link_pali.sh {} \;
#
####

for FILE in "$@"; do
  if [[ ! -f "$FILE" ]]; then
    echo "File $FILE does not exist" >&2
    exit 0
  fi

  TMPFILE=$(mktemp)

  if sed -E \
    -e "s:[ṆÑ]K:ṄK:g" -e "s:[ṇñ]k:ṅk:g" -e "s:[ṆÑ]G:ṄG:g" -e "s:[ṇñ]g:ṅg:g" \
    -e "s:[ṆṄ]C:ÑC:g" -e "s:[ṇṅ]c:ñc:g" -e "s:[ṆṄ]J:ÑJ:g" -e "s:[ṇṅ]j:ñj:g" \
    -e "s:[ṄÑ]Ḍ:ṆḌ:g" -e "s:[ṅñ]ḍ:ṇḍ:g" -e "s:[ṄÑ]Ṭ:ṆṬ:g" -e "s:[ṅñ]ṭ:ṇṭ:g" \
    -e "s:[ṂṀ]K:ṄK:g" -e "s:[ṃṁ]k:ṅk:g" -e "s:[ṂṀ]G:ṄG:g" -e "s:[ṃṁ]g:ṅg:g" \
    -e "s:[ṂṀ]C:ÑC:g" -e "s:[ṃṁ]c:ñc:g" -e "s:[ṂṀ]J:ÑJ:g" -e "s:[ṃṁ]j:ñj:g" \
    -e "s:[ṂṀ]Ḍ:ṆḌ:g" -e "s:[ṃṁ]ḍ:ṇḍ:g" -e "s:[ṂṀ]Ṭ:ṆṬ:g" -e "s:[ṃṁ]ṭ:ṇṭ:g" \
    "$FILE" >"$TMPFILE"; then
    mv "$TMPFILE" "$FILE"
  else
    echo "Error processing $FILE" >&2
    rm -f "$TMPFILE"
    exit 1
  fi
done

exit 0

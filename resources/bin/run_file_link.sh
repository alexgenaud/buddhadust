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

if [ $# -eq 0 ]; then
  echo "No arguments supplied" >&2
  exit 0
fi
FILE=$1

# Ensure the file exists
if [[ ! -f "$FILE" ]]; then
  echo "File $FILE does not exist" >&2
  # Fail gracefully (just continue)
  exit 0
fi

# Create a temporary file for processing
TMPFILE=$(mktemp)

# Perform search and replace, then safely overwrite the original
# saṅkhār..
if sed -E \
  -e "s:[_~]nk:-nk:g" -e "s:[_~]ng:-ng:g" \
  -e "s:[_-]nc:~nc:g" -e "s:[_-]nj:~nj:g" \
  -e "s:[-~]n_d:_n_d:g" -e "s:[-~]n_t:_n_t:g" \
  -e "s:/by.nc/:/by-nc/:g" -e "s:/by.nc.nd/:/by-nc-nd/:g" -e "s:cc.by.nc.png:cc_by_nc.png:g" \
  -e "s:[_~-]mk:-nk:g" -e "s:[_~-]mg:-ng:g" \
  -e "s:[_~-]mc:~nc:g" -e "s:[_~-]mj:~nj:g" \
  -e "s:[_~-]m_d:_n_d:g" -e "s:[_~-]m_t:_n_t:g" \
  "$FILE" >"$TMPFILE"; then
  mv "$TMPFILE" "$FILE"
else
  echo "Error processing $FILE" >&2
  rm -f "$TMPFILE"
  # Fail fatally
  exit 1
fi

exit 0

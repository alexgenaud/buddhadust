# cd obo_buddhadust
# bash resources/bin/run_dirs_links_and_pali.sh &

echo Pāli corrections
ls -d backmatter dhammatalk dhamma-vinaya/bd dhamma-vinaya/pali
echo Specific English and links corrections
ls -d [dit]*.htm backmatter dhamma* frontmatter

RUN_PALI=resources/bin/run_file_pali.sh
find backmatter dhammatalk dhamma-vinaya/bd dhamma-vinaya/pali \
  -type f \( -name "*.htm" -o -name "*.txt" \) | xargs -n 1000 bash "$RUN_PALI"

RUN_ENGL=resources/bin/run_file_english.sh
find [dit]*.htm backmatter dhamma* frontmatter \
  -type f \( -name "*.htm" -o -name "*.txt" \) | xargs -n 1000 bash "$RUN_ENGL"

RUN_LINK=resources/bin/run_file_link.sh
find [dit]*.htm backmatter dhamma* frontmatter \
  -type f \( -name "*.htm" -o -name "*.txt" \) | xargs -n 1000 bash "$RUN_LINK"

# root: No changes
# frontmatter No changes
# backmatter Can changed
# dhammatalk Can change
# dhamma-vinaya No change except
# dhamma-vinaya/bd Can change
# dhamma-vinaya/pali Can change

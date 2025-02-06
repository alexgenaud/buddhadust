# cd obo_buddhadust
# bash resources/bin/run_dirs_links_and_pali.sh &

echo Pāli corrections
ls -d [dit]*.htm backmatter dhammatalk frontmatter
ls -d dhamma-vinaya/bd dhamma-vinaya/pali
echo Specific english and links corrections
ls -d [dit]*.htm backmatter dhamma* frontmatter

RUN_PALI=resources/bin/run_file_pali.sh
find [dit]*.htm backmatter dhammatalk frontmatter \
  -type f \( -name "*.htm" -o -name "*.txt" \) | xargs -n 100 bash "$RUN_PALI"
find dhamma-vinaya/bd dhamma-vinaya/pali \
  -type f \( -name "*.htm" -o -name "*.txt" \) | xargs -n 100 bash "$RUN_PALI"

RUN_ENGL=resources/bin/run_file_english.sh
find [dit]*.htm backmatter dhamma* frontmatter \
  -type f \( -name "*.htm" -o -name "*.txt" \) | xargs -n 100 bash "$RUN_ENGL"

RUN_LINK=resources/bin/run_file_link.sh
find [dit]*.htm backmatter dhamma* frontmatter \
  -type f \( -name "*.htm" -o -name "*.txt" \) | xargs -n 100 bash "$RUN_LINK"

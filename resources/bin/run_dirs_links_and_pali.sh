# cd obo_buddhadust
# bash resources/bin/run_dirs_links_and_pali.sh &

echo link and pali corrections
ls -d [dit]*.htm backmatter dhammatalk dhamma-vinaya/bd dhamma-vinaya/pali frontmatter
echo links only
ls -d dhamma-vinaya/[^bp]* dhamma-vinaya/b[i-z]* dhamma-vinaya/pt*
echo begin

find [dit]*.htm backmatter dhammatalk dhamma-vinaya/bd dhamma-vinaya/pali frontmatter \
  -type f \( -name "*.htm" -o -name "*.txt" \) -exec bash resources/bin/run_file_link_pali.sh {} \;

find dhamma-vinaya/[^bp]* dhamma-vinaya/b[i-z]* dhamma-vinaya/pt* \
  -type f \( -name "*.htm" -o -name "*.txt" \) -exec bash resources/bin/run_file_link.sh {} \;

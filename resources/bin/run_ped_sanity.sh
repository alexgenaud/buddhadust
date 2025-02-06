# Helpful tool on macosx that converts ped.htm to ped.txt
# textutil -convert txt ped.htm
PED_PATH="backmatter/glossology/ped/pts_ped/ped.htm"

RE_ZKEY='[a-y][0-4][a-z0-6-]*'
RE_IDPALI='x[a-y_~-][a-y_~-]*[z0-6-]*'
RE_IDLETTER='e_x*[a-y][aiuh]*'
# RE_PALIENTRY='[A-YĀĪŪḌṬḶṂṀṆṄÑ-][^<]*'
# RE_PALILETTER='[A-YĀĪŪḌṬḶṂṀṆṄÑ-][^ ]*'
RE_PALIENTRY='-*[A-YĀĪŪḌṬḶṂṀṆṄÑ][a-yāīūḍṭḷṃṁṇṅñ\(\)° -]*'
RE_PALILETTER='[A-YĀĪŪḌṬḶṂṀṆṄÑ-][a-yāīūḍṭḷṃṁṇṅñ]*'

RE_P_Z='^<p z="'$RE_ZKEY'">'
RE_A_PALI='<a id="'$RE_IDPALI'" href="#'$RE_IDPALI'" class="palientry">'
RE_A_LETTER='<a href="#'$RE_IDLETTER'" id="'$RE_IDLETTER'">'

WC_PRE_P_Z=$(grep "$RE_P_Z" $PED_PATH | wc -l)
echo $WC_PRE_P_Z 16439 $RE_P_Z

REGEX=${RE_P_Z}${RE_A_PALI}':: '$RE_PALIENTRY'<'
WC_Z_TO_ENTRY=$(grep "$REGEX" $PED_PATH | wc -l)
echo '::' $WC_Z_TO_ENTRY 16402 "$REGEX"

REGEX=$RE_P_Z'------*'$RE_A_LETTER'\[ '$RE_PALILETTER' \]<'
WC_Z_TO_LETTER=$(grep "$REGEX" $PED_PATH | wc -l)
echo ":: $WC_Z_TO_LETTER 37" "$REGEX"

WC_FULL_BOTH=$(echo "$WC_Z_TO_ENTRY $WC_Z_TO_LETTER + p" | dc)
echo $WC_FULL_BOTH 16439 both entries and first letters

WC_ID_X=$(grep "id=.x[a-y_~-]" $PED_PATH | wc -l)
WC_ID_E=$(grep "id=.e_[a-y]" $PED_PATH | wc -l)
WC_ID_BOTH=$(echo "$WC_ID_X $WC_ID_E + p" | dc)
echo $WC_ID_BOTH 16439 'id=.*[a-y_~-]' $WC_ID_X x=16301 $WC_ID_E e=37

echo Review unique ids and hrefs
sed 's:id=:\nid=:g' $PED_PATH | grep 'id="x[^"]*"' | sed -E 's/.*id="(x[^"]*)".*/\1/' | sort >tmp.ids
sed 's:href=:\nhref=:g' $PED_PATH | grep 'href="#x[^"]*"' | sed -E 's/.*href="#(x[^"]*)".*/\1/' | sort >tmp.hrefs
echo none-unique ids
sort tmp.ids | uniq -c | grep -v "  1 "
echo $(wc -l tmp.ids tmp.hrefs)

sort tmp.ids | uniq >x
mv x tmp.ids
sort tmp.hrefs | uniq >x
mv x tmp.hrefs
echo diff ids hrefs
diff tmp.ids tmp.hrefs

echo "list lines with odd entries"
grep '^<p z="[a-y][0-4][a-z0-6-]*"><a id="x[a-y_~-][a-y_~-]*[z0-6-]*" href="#x[a-y_~-][a-y_~-]*[z0-6-]*" class="palientry">:: [A-YĀĪŪḌṬḶṂṀṆṄÑ-]' backmatter/glossology/ped/pts_ped/ped.htm | grep -v 'class="palientry">:: -*[A-YĀĪŪḌṬḶṂṀṆṄÑ][a-yāīūḍṭḷṃṁṇṅñ\(\)° -]*<' | head

echo "Invalid p z keys, probably missing trailing number 1"
grep 'p z="[^"]*"' $PED_PATH | grep -v 'p z="[a-y][a-y0-4-]*[0-4]-*[0-9z]*"' | sed -E 's:.*p z="([^"]*)".*:\1:' | wc -l

echo "Print any weird characters in PED Entries"
grep "^<p.*>:: " $PED_PATH | sed -E 's_.*>:: ([^/]*)/.*_\1_' | sed 's:<sup>:/:g' | sed "s:[<,].*::" | tr '[:upper:]' '[:lower:]' | sed 's:[\(\)° -]::g' | grep "[^a-z/0-9āīūḍṭḷṇṃṅṁñ]"

echo "Unexpected PED Entry characters to z sort key"
grep "^<p.*>:: " $PED_PATH | tr '[:upper:]' '[:lower:]' | sed -E -e 's_.*>:: ([^/]*)/.*_\1_' -e 's:<sup>:/:g' -e "s:[<,].*::" -e 's:[\(\)° -]::g' -e 's:([a-y]):\11:g' -e 's:ā:a2:g' -e 's:ī:i2:g' -e 's:ū:u2:g' -e 's:ḍ:d2:g' -e 's:ṭ:t2:g' -e 's:ḷ:l2:g' -e 's:[ṁṃ]:m2:g' -e 's:ṇ:n2:g' -e 's:ṅ:n3:g' -e 's:ñ:n4:g' | grep "[^a-z/0-9]"

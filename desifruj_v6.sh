#!/usr/bin/bash
# Zip 3.0, UnZip 6.00

cesta_soubory_hesel="/home/pi/bash/verze_6_bash/keys/"

if [ -z "$1" ]; then
h=${0##*/}
echo $h" file_name_zip"
exit 0
fi

archiv_zip_nazev=$1

# odstrani pripadny main file comment ze souboru zip
# protoze by pak neodpovidaly hodnoty radku  head -n X a tail -n X
# main comment je pri prikazu unzip -l archiv.zip hned na zacatku vypisu
# file comment radky jsou teprve az za nim
rm -f main_comment_file.txt
sleep 0.2
touch main_comment_file.txt
sleep 0.2
zip -z < main_comment_file.txt $archiv_zip_nazev
sleep 0.2
rm -f main_comment_file.txt
sleep 0.2
#

read_zip_file_comment=$(unzip -l $archiv_zip_nazev | head -n 5 | tail -n 1)
echo "zip_file_comment = "
echo $read_zip_file_comment
d_zip_file_comment=${#read_zip_file_comment}
echo $d_zip_file_comment" znaku delka file comment"

test_1=$(( d_zip_file_comment  % 2 ))
if [ "$test_1" -ne "0" ]
then
echo "delka retezce file comment musi byt sude cislo"
exit 0
fi

test_2=$d_zip_file_comment
if [ "$test_2" -gt "252" ]; then
echo "delka retezce file comment musi byt mensi nebo rovna 252"
exit 0
fi

read_zip_file_comment_soubor_hesel=$(unzip -l $archiv_zip_nazev | head -n 7 | tail -n 1)
echo "nazev souboru klice = "$read_zip_file_comment_soubor_hesel
d_zip_file_comment_soubor_hesel=${#read_zip_file_comment_soubor_hesel}
echo $d_zip_file_comment_soubor_hesel" znaku file comment soubor hesel"

read_zip_file_comment_soubor_datum_vzniku=$(unzip -l $archiv_zip_nazev | head -n 9 | tail -n 1)
#echo "datum vytvoreni tohoto archivu je "$read_zip_file_comment_soubor_datum_vzniku
echo $read_zip_file_comment_soubor_datum_vzniku

sha1sum_zip_file_comment_soubor_hesel=$(unzip -l $archiv_zip_nazev | head -n 11 | tail -n 1)
echo "sha1sum souboru klice ulozeneho do file comment pri vytvareni archivu "$archiv_zip_nazev
echo $sha1sum_zip_file_comment_soubor_hesel

echo "sha1sum pouziteho souboru klice pro desifrovani ted"
sha=$(sha1sum $cesta_soubory_hesel$read_zip_file_comment_soubor_hesel)
sha2=${sha:0:40}
echo $sha2

#sha2="abcd" # test
if [ "$sha1sum_zip_file_comment_soubor_hesel" != "$sha2" ]; then
echo "soubor klice kterym byl zasifrovan archiv "$archiv_zip_nazev
echo "neodpovida obsahu souboru klice ktery je pouzit ted pri desifrovani"
exit 0
fi

# source

#soubor_hesel_2=${soubor_hesel##*/}
# vyhaze vsechny lomitka z cesty, kvuli nazvu archivu
soubor_hesel_2=$cesta_soubory_hesel$read_zip_file_comment_soubor_hesel
echo "nacteny soubor hesel ="
echo $soubor_hesel_2
source $soubor_hesel_2

heslo=""
pom_1=0
for (( aa = 0; aa <= $d_zip_file_comment - 2; aa=aa+2)); do
seg=${read_zip_file_comment:$aa:2}
#echo $pom_1" "$seg
cmd_1='heslo+=${n_'
cmd_1+=$pom_1
cmd_1+='[$seg]}'
#echo $cmd_1
eval $cmd_1
((pom_1++))
done

echo "heslo = "
echo $heslo
d_heslo=${#heslo}
echo "delka hesla = "$d_heslo" znaku"
sleep 5

# unzip

cmd_2="unzip -t -P "
cmd_2+="'$heslo' "
cmd_2+="$archiv_zip_nazev"
#echo $cmd_2
eval $cmd_2
sleep 1

cmd_3="unzip -x -P "
cmd_3+="'$heslo' "
cmd_3+="$archiv_zip_nazev"
#echo $cmd_3
eval $cmd_3


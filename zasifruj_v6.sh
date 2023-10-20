#!/usr/bin/bash
# Zip 3.0, UnZip 6.00

cesta_soubory_hesel="/home/pi/bash/verze_6_bash/keys/"

if [ -z "$2" ]; then
h=${0##*/}
echo $h" SouborHesel zip_folder/"
echo "seznam klicu v adresari "$cesta_soubory_hesel
ls $cesta_soubory_hesel
exit 0
fi

soubor_hesel=$1
soubor_hesel_2=$cesta_soubory_hesel$soubor_hesel
echo "nacteny soubor hesel ="
echo $soubor_hesel_2
source $soubor_hesel_2

soubor_hesel=${soubor_hesel##*/}
# vyhaze vsechny lomitka z cesty, kvuli nazvu archivu
zip_folder=$2

echo "nazev souboru hesel = "$1
echo "pocet poly v souboru "$1" = "$n_x", tzn. n_0 az n_"$(($n_x - 1))

heslo=""
zip_file_comment=""
for (( aa = 0; aa <= $n_x - 1; aa++ ));do

#echo $(( $RANDOM % 62 + 10 ))
rnd=$(( $RANDOM % 62 + 10 ))
#echo $aa" "$rnd
zip_file_comment+=${rnd}

# heslo+=${n_X[$rnd]}
cmd_1='heslo+=${n_'
cmd_1+=$aa
cmd_1+='[$rnd]}'
#echo $cmd_1
eval $cmd_1
done

echo "zip_file_comment = "
echo $zip_file_comment
d_zip_file_comment=${#zip_file_comment}
echo "delka zip_file_comment = "$d_zip_file_comment" znaku"

echo "heslo = "
echo $heslo
d_heslo=${#heslo}
echo "delka hesla = "$d_heslo" znaku"

archiv_zip_nazev=${zip_folder:0:${#zip_folder}-1}"_v6.zip"
echo "nazev archivu zip je"
echo $archiv_zip_nazev
datum_ted=$(date +'%d.%m.%Y %H:%M')
echo "datum vytvoreni tohoto archivu je "$datum_ted

#

rm -f zip_file_comment.txt
sleep 0.3
echo $zip_file_comment > zip_file_comment.txt
sleep 0.3
echo $soubor_hesel >>zip_file_comment.txt
sleep 0.3
echo "datum vytvoreni tohoto archivu je "$datum_ted >>zip_file_comment.txt
sha=$(sha1sum $cesta_soubory_hesel$soubor_hesel)
sha2=${sha:0:40}
echo "sha1sum souboru klicu je "
echo $sha2
echo $sha2 >>zip_file_comment.txt

sleep 5

#echo "cat zip_file_comment.txt = "
#cat zip_file_comment.txt

cmd_1="zip -r -9 -y -UN=UTF8 -P "
cmd_1+="'$heslo'"
cmd_1+=" -c < 'zip_file_comment.txt' "
cmd_1+=$archiv_zip_nazev
cmd_1+=" "$zip_folder
eval $cmd_1
sleep 1

cmd_2="unzip -t -P "
cmd_2+="'$heslo' "
cmd_2+=$archiv_zip_nazev
eval $cmd_2
sleep 1

cmd_3="unzip -l "
cmd_3+=$archiv_zip_nazev
eval $cmd_3
sleep 1

rm -f zip_file_comment.txt


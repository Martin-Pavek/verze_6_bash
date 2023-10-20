#!/usr/bin/bash

cesta_soubory_hesel="/home/pi/bash/verze_6_bash/keys/"

if [ -z "$1" ]; then
h=${0##*/}
echo $h" OutputKeyFile"
echo $h" osoba1-osoba2"
echo "seznam klicu v adresari "$cesta_soubory_hesel
ls $cesta_soubory_hesel
exit 0
fi

pole_znaky=( [10]="a" {b..z} {A..Z} {0..9} )
#declare -p pole_znaky
d_pole_znaky=${#pole_znaky[@]}

max_mix=300 # nechat jak je

max_pole=126 # 126 je maximalni delka hesla aby byl string v zip file comment jenom na jeden radek !!! (nedavat vic jak 125)
#max_pole=10 # testovaci

test_1=$(( max_pole  % 2 ))
if [ "$test_1" -ne "0" ]; then
echo "promenna max_pole musi byt sude cislo"
exit 0
fi

test_2=$max_pole
if [ "$test_2" -gt "126" ]; then
echo "delka promenne max_pole musi byt mensi nebo rovna 126"
exit 0
fi

prepsat_output=1 # tohle nechat ja je
for (( aa = 0; aa <= $max_pole - 1; aa++)); do
for (( bb = 1; bb <= $max_mix; bb++)); do
rnd_1=$(( $RANDOM % $d_pole_znaky + 10 ))
rnd_2=$(( $RANDOM % $d_pole_znaky + 10 ))
#echo $rnd_1
#echo $rnd_2

pom=${pole_znaky[$rnd_1]}
#echo $pom
pole_znaky[$rnd_1]=${pole_znaky[$rnd_2]}
pole_znaky[$rnd_2]=$pom
done

: '
cc=$(declare -p pole_znaky )
#echo $cc
out_1="declare -a n_"$aa
out_1+=${cc:21:${#cc}}
echo $out_1
# trochu prasarna ale funguje i takto
'

out_1="declare -a n_"$aa"=( "
for (( cc = 10; cc <= $d_pole_znaky + 9; cc++)); do
out_1+="["$cc"]="
out_1+='"'
out_1+=${pole_znaky[$cc]}
# tady se zase x krat vola subshell, tak co je nakonec lepsi ?
out_1+='" '
done

out_1+=")"

echo $out_1

if [ "$prepsat_output"  == "1" ]; then
echo $out_1 >$cesta_soubory_hesel$1
prepsat_output=0
else
echo $out_1 >>$cesta_soubory_hesel$1
fi
done

out_2="declare -a n_x="$max_pole
echo $out_2
echo $out_2 >>$cesta_soubory_hesel$1

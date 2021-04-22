#!/bin/bash
#/usr/bin/python
#echo -n "Válassz régiót! eune/euw/na: "
#read region

#echo -n "Adjon meg egy idéző nevet! "
#read summonerName


if [[ $# < 4 ]]
then
	echo "Invalid argumentum! Szükséges: -r regioNev -u idezoNev"
	sleep 2
	exit
fi


while getopts ":r:u:" opt; do
	case ${opt} in
	r )
	  region=$OPTARG ;;
	u ) 
	  summonerName=$OPTARG ;;
	\? )
	  echo "Invalid option: $OPTARG" 1>&2 ;;
	: )
	  echo "Invalid option: $OPTARG requires an agrument" 1>&2 ;;
	esac
done
shift $((OPTIND -1))

url="http://$region.op.gg/summoner/userName=$summonerName"
if curl --head --silent --fail -iL $url  > /dev/null
then 
	curl -iL $url > eredmeny.txt
else
        echo "Nem létezik ilyen URL! A program kilép 2 mp múlva."
	echo "$url"
	sleep 2
	exit
fi
if [ -d "Results" ] ; then
        echo ""
else
        mkdir Results
fi


grep -A 1 "<div class=\"ChampionName\">" eredmeny.txt > Results/ChampionNames.txt

grep -A 1 "<div class=\"CKRate tip\""  eredmeny.txt > Results/KillPart.txt

grep -A 1 "<div class=\"GameResult\">" eredmeny.txt > Results/WinLose.txt

grep "<div class=\"GameLength\">" eredmeny.txt > Results/Length.txt

grep "<span class=\"Kill\">" eredmeny.txt > Results/Kills.txt

grep "<span class=\"Death\">" eredmeny.txt > Results/Deaths.txt

grep "<span class=\"Assist\">" eredmeny.txt > Results/Assists.txt

grep "<span class=\"CS tip\"" eredmeny.txt > Results/CreepScore.txt


champFile=`cat Results/ChampionNames.txt | xargs`
kpFile=`cat Results/KillPart.txt | xargs`
wlFile=`cat Results/WinLose.txt | xargs`
assistFile=`cat Results/Assists.txt | xargs`
echo "$champFile" > Results/ChampionNames.txt
echo "$kpFile" > Results/KillPart.txt
echo "$wlFile" > Results/WinLose.txt




#MatchResult-ből kiszedem a HTML elemeket     "|" az elválasztó jel
winLoseInput=`cat Results/WinLose.txt`
winLoseOutput=${winLoseInput// -- /_}
winLoseOutput=${winLoseOutput//<\/div>_/|}
winLoseOutput=${winLoseOutput//<div class\=/k}
winLoseOutput=${winLoseOutput//kGameResult>/}
winLoseOutput=${winLoseOutput//k/}
winLoseOutput=${winLoseOutput//<\/div>/}
winLoseOutput=${winLoseOutput// /}
echo $winLoseOutput > Results/WinLose.txt


#Assist-ből kiszedem a HTML tageket   " " az elválasztó, 2. elemtől
assistInput=`cat Results/Assists.txt`

assistOutput=${assistInput//<span class/k}
assistOutput=${assistOutput//k\=\"Assist/k}
assistOutput=${assistOutput//k\">/}
assistOutput=${assistOutput//<\/span>/}
assistOutput=${assistOutput//k/}
assistOutput=${assistOutput//*./}

echo $assistOutput | sed 's/ /_/g' > Results/Assists.txt

#Kills-ből kiszedem a HTML tageket      "/" az elválasztó, 2. elemtől
killInput=`cat Results/Kills.txt`
killOutput=${killInput//<span class\=\"Kill\">/k}
killOutput=${killOutput//<\/span>/k}
killOutput=${killOutput//k/}
killOutput=${killOutput//Triple/}
killOutput=${killOutput//Double/}
killOutput=${killOutput//Quadra/}
killOutput=${killOutput//Penta/}
killOutput=${killOutput// /}
killOutput=${killOutput//Kill/}
killOutput=${killOutput//*./}
killOutput=${killOutput//\//}

echo $killOutput | sed 's/ /_/g' > Results/Kills.txt


#Deaths-ből kiszedem a HTML tageket     "/" az elávasztó,  2. elemtől
deathInput=`cat Results/Deaths.txt`
deathOutput=${deathInput//<span class\=\"Death\">/k}
deathOutput=${deathOutput//<\/span>/k}
deathOutput=${deathOutput//k/}
deathOutput=${deathOutput//*./}
deathOutput=${deathOutput//\//}
echo $deathOutput | sed 's/ /_/g'> Results/Deaths.txt


#Length-ből kiszedem a HTML tageket 	"|" az elválasztó, 1. elemtől

lengthInput=`cat Results/Length.txt`
lengthOutput=${lengthInput//<div class\=\"GameL/k}
lengthOutput=${lengthOutput//kength\">/k}
lengthOutput=${lengthOutput//<\/div>/|}
lengthOutput=${lengthOutput//k/}
lengthOutput=${lengthOutput//*./}
echo $lengthOutput | sed 's/ //g' > Results/Length.txt



#KillParticipation-ből kiszedem a HTML tageket     "_" az elválasztó, 1. elemtől
kpInput=`cat Results/KillPart.txt`
kpOutput=${kpInput// -- /_}
kpOutput=${kpOutput//<\/div>_/|}
kpOutput=${kpOutput//<div class\=/k}
kpOutput=${kpOutput//kCKRate tip /}
kpOutput=${kpOutput//title\=Kill/}
kpOutput=${kpOutput//Participation>/}
kpOutput=${kpOutput//P\/Kill/}
kpOutput=${kpOutput//<\/div>/}

echo $kpOutput | sed 's/ //g' > Results/KillPart.txt


#ChampionNames-ből kiszedem a HTML tageket	"|" az elválasztó, 1. elemtől, ezeket ">" jel választja el, 2. használható!
champInput=`cat Results/ChampionNames.txt`
champOutput=${champInput//<\/a>/|}
champOutput=${champOutput//\/champion\//}
champOutput=${champOutput//\/statistics/}
champOutput=${champOutput//<div class\=ChampionName>/}
champOutput=${champOutput//<a href\=/}
champOutput=${champOutput//target\=_blank/}
champOutput=${champOutput// \-\- /}

echo $champOutput | sed 's/ //g' > Results/ChampionNames.txt


#CreepScore-ból kiszedem a HTML tageket
csInput=`cat Results/CreepScore.txt`
csOutput=${csInput//<span class\=\"CS tip\"/}
csOutput=${csOutput// title\=\"minion /}
csOutput=${csOutput//CS/|}
csOutput=${csOutput// monster/}
csOutput=${csOutput//&lt/}
csOutput=${csOutput//br&gt;|/}
csOutput=${csOutput// /}
echo $csOutput | sed 's/ //g'> Results/CreepScore.txt


parKP=`cat Results/KillPart.txt`
parCS=`cat Results/CreepScore.txt`
parChampNames=`cat Results/ChampionNames.txt`
parWinLose=`cat Results/WinLose.txt`
parKills=`cat Results/Kills.txt`
parDeaths=`cat Results/Deaths.txt`
parAssists=`cat Results/Assists.txt`
parLength=`cat Results/Length.txt`

if [ -z "$parKP"  ]
then
	echo "Nem létezik ilyen idéző, vagy nincs megjeleníthető meccselőzménye!"
else
clear
./python.py $parWinLose $parAssists $parKills $parDeaths $parLength $parKP $parChampNames $parCS $summonerName
fi

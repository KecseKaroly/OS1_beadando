#! /usr/bin/python2

import sys

creepScore=sys.argv[8]
winLose=sys.argv[1]
assist=sys.argv[2]
kills=sys.argv[3]
death=sys.argv[4]
length=sys.argv[5]
kp=sys.argv[6]
champs=sys.argv[7]
summoner=sys.argv[9]


#print("CS: "+ creepScore)
#print("W/L: "+ winLose)
#print("Assists: "+ assist)
#print("Kills: "+ kills)
#print("Deaths: "+ death)
#print("Length: "+ length)
#print("KP: "+ kp)
#print("Champs: "+ champs)


kpArray=kp.split("_")
winLoseArray=winLose.split("|")
assistArray=assist.split("_")
killsArray=kills.split("_")
deathsArray=death.split("_")
lengthArray=length.split("|")
champsArray=champs.split("|")
csArray=creepScore.split("|")



print(summoner+"'S MATCH HISTORY")
print("")
print("Match result  Length  Champion  K/D/A  Kill participation  Creep Score")
print("")
for i in range(10):
	ujChampArray=champsArray[i].split(">")
	ujCsArray=csArray[i].split(";")
	ujCSArray=ujCsArray[0].split("+")
	print (winLoseArray[i] + "  -  " + lengthArray[i] + "  -  " +ujChampArray[1] +"  -  "+ killsArray[i+1]+"/"+deathsArray[i+1]+"/"+assistArray[i+1] + "  -  " + kpArray[i] + "  -   "+ str(int(ujCSArray[0]) + int(ujCSArray[1])) )

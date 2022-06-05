#!/bin/bash

openNotion () {
	echo "Abrindo notion..."
	sleep 1

	notion_local="../../../../c/Users/hugofolloni/AppData/Local/Programs/Notion"

	cd "$notion_local" && ./Notion.exe

	clear
	exit 
}

runWeather () {
	echo "Segundo meus cálculos, o tempo hoje..."

	my_ip=`curl -s https://ipinfo.io/ip`

	my_xml=`curl -s http://api.geoiplookup.net/?query="$my_ip"`
	latitude=$(sed -n -e 's/.*<latitude>\(.*\)<\/latitude>.*/\1/p' <<< $my_xml)
	longitude=$(sed -n -e 's/.*<longitude>\(.*\)<\/longitude>.*/\1/p' <<< $my_xml)
	city=$(sed -n -e 's/.*<city>\(.*\)<\/city>.*/\1/p' <<< $my_xml)

	api="http://api.weatherapi.com/v1/forecast.json?key=%2022370fad94b44b3c94300446211806&lang=pt&q=$city"

	avg_condition=`curl -s $api | jq '.forecast.forecastday[0].day.condition.text'`
	echo "	$avg_condition"

	temp_media=`curl -s $api | jq '.forecast.forecastday[0].day.avgtemp_c'`
	echo "	Temperatura média: $temp_mediaº"

	chance_rain=`curl -s $api | jq '.forecast.forecastday[0].day.daily_chance_of_rain'`
	echo "	Chance de chuva: $chance_rain%"
}

runInfos () {
	data=$(date +'%Y-%d-%m')
	hora=$(date +'%H:%M')
	weekday=$(date +'%a')

	case "$weekday" in
		("Sun") weekday="Domingo" ;;
		("Mon")	weekday="Segunda" ;;
		("Tue") weekday="Terça" ;;
		("Wed") weekday="Quarta" ;;
		("Thu") weekday="Quinta" ;;
		("Fri") weekday="Sexta";;
		("Sat") weekday="Sábado";;
		(*) weekday="$weekday" ;;
	esac


	echo "Hoje é dia $data"
	echo "São $hora de $weekday!"

	runWeather

	sleep 1

	echo "Você quer abrir o Notion para acompanhar suas tarefas diárias?"
	read open_notion

	if [ "$open_notion" == "y" ] ; then
		openNotion
	else 
		echo "Tenha um bom dia, $name!"
	fi
}

name=$(whoami)

clear
echo "Hello World!"
echo "Hello $name!"
sleep 1

echo "Você quer receber informações?"
read want_info

if [ "$want_info" == "y" ] ; then
	runInfos
else
	echo "Ok, tchau! Tenha um bom dia!"
	sleep 0.5
	echo "0 entrosas... :c"
	sleep 0.5
	clear
	exit 0
fi

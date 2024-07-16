#!/bin/bash

url="https://www.youtube.com/watch?v=wkc6QgjbYyI"

data=$(curl --silent $url | grep -Eo "var ytInitialData.+}}]}}}" | sed 's/var ytInitialData = //')
echo $data | jq

function getTotalViews() {
	viewsFilter=$(echo $data | /usr/local/bin/jq | grep -w -A 1 "viewCount" | grep "simpleText")
	numberViews=$(echo $viewsFilter | /usr/local/bin/ggrep -Pzo "((?<=\"simpleText\": \")(.*?)(?= vistas))")
	echo "$numberViews Vistas"
}

function getTotalLikes() {
	likesFilter=$(echo $data | /usr/local/bin/jq | grep -w -A 3 "factoidRenderer" | grep "simpleText" | head -n1)
	numberOfLikes=$(echo $likesFilter | sed 's/simpleText//g' | tr -d "\" :")
	echo "$numberOfLikes Me Gusta"
}

function getTotalSuscriptors() {
	suscriptorsFilter=$(echo $data | jq | ggrep -Pzo "(?<=\"simpleText\": \")(.*?)(?=M de suscriptores)")
	numberOfSuscriptors=$(echo $suscriptorsFilter)
	echo "$numberOfSuscriptors" "de Suscriptores"
}

function getNameChanel() {
	nameChanelFilter=$(echo $data | jq '.contents.twoColumnWatchNextResults.results.results.contents[1].videoSecondaryInfoRenderer.owner.videoOwnerRenderer.title.runs[0].text' | tr -d '"')
	echo "Channel: $nameChanelFilter"
}

# getTotalViews
# getTotalLikes
# getTotalSuscriptors
# getNameChanel

# data=$(curl --silent "https://www.youtube.com/watch?v=RfUMlkyn0qE" | grep -Eo "var ytInitialData.+}}]}}}" | sed 's/var ytInitialData = //g')
# viewsFilter=$(echo $data | /usr/local/bin/jq | grep -w -A 1 "viewCount" | grep "simpleText")
# numberViews=$(echo $viewsFilter | /usr/local/bin/ggrep -Pzo "((?<=\"simpleText\": \")(.*?)(?= vistas))")
# echo $numberViews

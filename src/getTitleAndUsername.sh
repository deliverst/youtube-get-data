function getData() {
	wget -q "$1"
}

function getUUIDYouTube() {
	echo "$1" | sed 's/https:\/\/youtube.com\/shorts\///'
}

function getUUIDInternal() {
	cat "$1" | ggrep -oP '(?<=nonce=")[^"]*' | head -n1
}

function getObjectJavascript() {
	text=$(cat "$1" | grep -Eo "<script nonce=\"$2\">var ytInitialData*.+</script>" | sed "s/<script nonce=\"$2\">var ytInitialData = //" | sed 's/<\/script>//g' | sed -E 's/<script.+//g' | jq .overlay.reelPlayerOverlayRenderer.reelPlayerHeaderSupportedRenderers.reelPlayerHeaderRenderer.accessibility.accessibilityData.label 2>/dev/null | sed -E 's/hace.+//' | tr -d "\"")
	username=$(echo $text | grep -Eo "@.+")
	title=$(echo "$text" | sed "s/ $username//")
	echo "$youtubeURL - $username - $title"
}

uids=("0zKet1czczo")

for UUIDshort in ${uids[@]}; do
	youtubeURL="https://youtube.com/shorts/$UUIDshort"
	getData "https://youtube.com/shorts/$UUIDshort"
	internalID=$(getUUIDInternal $(getUUIDYouTube "$youtubeURL"))
	externalID=$(getUUIDYouTube "$youtubeURL")
	getObjectJavascript "$externalID" "$internalID"
	rm "$UUIDshort"
done

# example get information: https://youtube.com/shorts/0zKet1czczo - @dereklipp_ - I hear your bourbon glass 😂

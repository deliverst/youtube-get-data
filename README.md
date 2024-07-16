# README

## Description

This script is designed to extract specific information from YouTube Shorts. It performs the following tasks:

1. Downloads the webpage content of a given YouTube Shorts URL.
2. Extracts unique identifiers (UUIDs) from the webpage.
3. Retrieves and formats data related to the video, such as the username and title.

## Prerequisites

Make sure you have the following tools installed on your system:
- `wget`: for downloading webpage content.
- `sed`: for text manipulation.
- `ggrep` (GNU grep): for searching text patterns.
- `jq`: for processing JSON data.

## Usage

1. **Define the UUIDs:**
   Update the `uids` array with the YouTube Shorts UUIDs you want to process.

2. **Run the Script:**
   Execute the script in a terminal.

## Script Explanation

### Functions

1. **`getData`**
   ```bash
   function getData() {
       wget -q "$1"
   }
   ```
   This function downloads the webpage content of the given URL using `wget`.

2. **`getUUIDYouTube`**
   ```bash
   function getUUIDYouTube() {
       echo "$1" | sed 's/https:\/\/youtube.com\/shorts\///'
   }
   ```
   This function extracts the UUID from a YouTube Shorts URL.

3. **`getUUIDInternal`**
   ```bash
   function getUUIDInternal() {
       cat "$1" | ggrep -oP '(?<=nonce=")[^"]*' | head -n1
   }
   ```
   This function extracts the internal UUID from the downloaded webpage content using `grep`.

4. **`getObjectJavascript`**
   ```bash
   function getObjectJavascript() {
       text=$(cat "$1" | grep -Eo "<script nonce=\"$2\">var ytInitialData*.+</script>" | sed "s/<script nonce=\"$2\">var ytInitialData = //" | sed 's/<\/script>//g' | sed -E 's/<script.+//g' | jq .overlay.reelPlayerOverlayRenderer.reelPlayerHeaderSupportedRenderers.reelPlayerHeaderRenderer.accessibility.accessibilityData.label 2>/dev/null | sed -E 's/hace.+//' | tr -d "\"")
       username=$(echo $text | grep -Eo "@.+")
       title=$(echo "$text" | sed "s/ $username//")
       echo "$youtubeURL - $username - $title"
   }
   ```
   This function processes the downloaded webpage content to extract the video's username and title using `grep`, `sed`, and `jq`.

### Main Script

```bash
uids=("0zKet1czczo")

for UUIDshort in ${uids[@]}; do
    youtubeURL="https://youtube.com/shorts/$UUIDshort"
    getData "https://youtube.com/shorts/$UUIDshort"
    internalID=$(getUUIDInternal $(getUUIDYouTube "$youtubeURL"))
    externalID=$(getUUIDYouTube "$youtubeURL")
    getObjectJavascript "$externalID" "$internalID"
    rm "$UUIDshort"
done
```

1. The script initializes an array `uids` containing YouTube Shorts UUIDs.
2. For each UUID, it constructs the YouTube Shorts URL and downloads the content.
3. It extracts both internal and external UUIDs.
4. It retrieves and prints the video information (URL, username, and title).
5. It deletes the downloaded webpage content file after processing.

## Example

To process a YouTube Shorts video with UUID `0zKet1czczo`, update the `uids` array and run the script:

```bash
uids=("0zKet1czczo")
```

Execute the script in your terminal:

```bash
bash script.sh
```

The output will display the YouTube URL, username, and title of the video.

## Notes

- Ensure that you have the required tools installed.
- Adjust the script as needed to fit your specific requirements.
- The script is designed to handle basic extraction; further modifications may be necessary for more complex scenarios.

---

This README provides an overview of the script's functionality, usage instructions, and a detailed explanation of its components.
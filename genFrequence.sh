#!/bin/bash

URL="https://raw.githubusercontent.com/hermitdave/FrequencyWords/refs/heads/master/content/2018/en/en_full.txt"
OUTPUT="en_frequency.json"

echo "📥 Downloading and converting to JSON..."

# curl fetches the text file silently
# awk reads each line (which looks like "the 23135851162") and formats it as {"word": count}
curl -s "$URL" | awk '
BEGIN {
    # Start the JSON object
    print "{"
    first = 1
}
NF >= 2 { 
    # NF >= 2 ensures we only process lines with both a word and a count
    
    # Escape any rogue double quotes in the word to prevent invalid JSON
    gsub(/"/, "\\\"", $1)

    # Handle the comma separation for JSON
    if (!first) {
        print ","
    }
    
    # Print the key-value pair
    printf "  \"%s\": %s", $1, $2
    first = 0
}
END {
    # Close the JSON object
    print "\n}"
}' > "$OUTPUT"

echo "✅ Done! Saved to $OUTPUT"

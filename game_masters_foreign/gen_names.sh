#!/bin/sh

for i in Game\ Master*; do
	echo "Processing ${i}"
	if ( grep -q timestamp_ms "${i}" ); then
		date=$(awk '($1 == "timestamp_ms:") { print $2 }' < "${i}") #'
	else
		date=$(stat -c %Y "${i}")
		date=$(( $date * 1000 ))
		timestamp=${date}
	fi
	echo $date
	date=$(echo "obase=16; ${date}" | bc)
	date=00000${date}
	sed -e 's/quick_moves: 281/quick_moves: HIDDEN_POWER_FAST/' < "${i}" > "${date}.txt"
	if ( ! grep -q timestamp_ms "${i}" ); then
		echo -e "\ntimestamp_ms: ${timestamp}" >> "${date}.txt"
	fi
done

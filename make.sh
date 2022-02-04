#!/bin/bash
set -e

srcDir="src"
outDir="dist"

while read theme; do
	xfwmDir="$outDir/$theme/xfwm4"

	# Prepare target directory
	rm --recursive --force "$xfwmDir"
	mkdir --parents "$xfwmDir"
	cp "$srcDir/$theme/themerc" "$xfwmDir"

	# Extract images
	while read name area states; do
		for state in $states; do
			src="$srcDir/$theme/$state.xpm"
			xpm="$xfwmDir/$name-$state.xpm"

			printf "$xpm\n"
			magick "$src" -crop "$area" "$xpm"
		done
	done < "$srcDir/$theme/atlas.txt"

	# Insert symbolic color names
	while read color sym; do
		sed -i "s|c $color|c $color s $sym|g" "$xfwmDir"/*.xpm
	done < "$srcDir/$theme/colors.txt"
done < <(basename --multiple "$srcDir"/*/)

#!/bin/bash

# Print line number before each line
echo "Example of '=' command (line numbering):"
sed '=' distros.txt
echo

# Append text "This is an appended line" after lines containing "Ubuntu"
echo "Example of 'a' command (appending text after a match):"
sed '/Ubuntu/a\This is an appended line' distros.txt
echo

# Delete all lines containing "Fedora"
echo "Example of 'd' command (deleting lines with a match):"
sed '/Fedora/d' distros.txt
echo

# Insert text "This is an inserted line" before lines containing "Fedora"
echo "Example of 'i' command (inserting text before a match):"
sed '/Fedora/i\This is an inserted line' distros.txt
echo

# Print only lines containing "Ubuntu" (suppresses default printing with -n)
echo "Example of 'p' command (printing lines with a match):"
sed -n '/Ubuntu/p' distros.txt
echo

# Quit after the third line
echo "Example of 'q' command (quitting after a certain line):"
sed '3q' distros.txt
echo

# Substitute "Fedora" with "RedHat" (only first occurrence per line)
echo "Example of 's' command (substituting text):"
sed 's/Fedora/RedHat/' distros.txt
echo

# Transliterate: change all "U" to "X" and "b" to "y"
echo "Example of 'y' command (transliteration):"
sed 'y/U/Xb/y' distros.txt
echo

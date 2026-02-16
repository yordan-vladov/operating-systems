cat names.txt | sed 's/\([A-Z][a-z]\+\) \([A-Z][a-z]\+\) \([A-Z][a-z]\+\)/\1_\3/'
cat names.txt | sed -E 's/([A-Z][a-z]+) ([A-Z][a-z]+) ([A-Z][a-z]+)/\1_\3/'

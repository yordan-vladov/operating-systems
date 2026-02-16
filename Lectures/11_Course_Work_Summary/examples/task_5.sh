cat /usr/share/dict/words | grep -E "^a.*e$" | wc -l
cat /usr/share/dict/words | grep -E "^[a-z]{4}$" | wc -l
cat /usr/share/dict/words | grep -E "^[a-z]{,6}$" | wc -l
cat /usr/share/dict/words | tr -cd "a-z\n" | grep -E "^[a-z]{,6}$" | wc -l
cat /usr/share/dict/words | grep -E "^[^aeouiAEOUI]*$" | wc -l
cat /usr/share/dict/words | grep -E ".*[0-9].*[A-Z]$"

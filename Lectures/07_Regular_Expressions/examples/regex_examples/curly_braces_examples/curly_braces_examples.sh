cat phonelist.txt | grep -Ev '^\(?[0-9]{3}\)? [0-9]{3}-[0-9]{4}$'
cat phonelist.txt | grep -E '^\(?[0-9]{3}\)? [0-9]{3}-[0-9]{4}$'

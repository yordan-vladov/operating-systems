cut -d: -f1 /etc/passwd
cut -d: -f1,3 /etc/passwd
cut -d: -f1-3 /etc/passwd
cat /etc/passwd | cut -d: -f7 | sort | uniq -c

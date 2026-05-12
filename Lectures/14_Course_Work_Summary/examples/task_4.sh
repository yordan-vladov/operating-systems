cat task_4.txt | sort -t: -k2,2
cat task_4.txt | sort -nr -t: -k3,3 | head -n 1 > high-balance-user.txt
cat task_4.txt | sort -nr -t: -k3,3 | head -n 3

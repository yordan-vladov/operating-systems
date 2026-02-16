#!/usr/bin/env bash

# 1. Стартиране на два ping процеса във фонов режим и запис в лог файлове
ping google.com > /tmp/google-log &
ping abv.bg > /tmp/abv-log &

# 2. Показване на всички процеси, стартирани от текущия потребител
ps -u "$USER"

# 3. Извеждане на PID на всички ping процеси в текущия терминал
ps -t "$(tty)" | grep ping
pgrep -t "$(tty)" ping

# 4. Превключване на един ping процес на foreground
jobs
fg %1

# 5. Връщане на процеса обратно във фонов режим
bg %1

# 6. Стартиране на mousepad с приоритет NI = 10
nice -n 10 mousepad &

# 7. Промяна на приоритета на mousepad на NI = 2
renice 2 -p "$(pgrep mousepad)"

# 8. Стартиране на xclock с по-висок приоритет (NI = -6) с root достъп
sudo nice -n -6 xclock &

# 9. Показване на всички процеси, сортирани по приоритет (NI)
ps -eo pid,ni,comm --sort=-ni

# 10. Създаване на нов потребител ivan
sudo useradd ivan
sudo passwd ivan

# 11. Влизане в системата като потребител ivan
su - ivan

# 12. Стартиране на два sleep процеса (180 секунди) от името на ivan
sleep 180 &
sleep 180 &

# (връщане към предишния потребител)
exit

# 13. Прекратяване на всички процеси на потребителя ivan (като root)
sudo pkill -u ivan

# 14. Извеждане на общия брой процеси на текущия потребител
ps -u "$USER" --no-headers | wc -l

# 15. PID и име на процеса, който използва най-много CPU време
ps -eo pid,comm,time --sort=-time | head -n 2

# 16. Стартиране на xfce4-calculator и показване на броя нишки
xfce4-calculator &
ps -o pid,comm,nlwp -p "$(pgrep xfce4-calculator)"

# 17. Изпращане на SIGTERM към процеси, чиито имена завършват на 'r'
pkill -TERM -f 'r$'

# 18. Изпращане на SIGKILL към процес по PID
kill -9 <PID>

# 19. Стартиране на процес във фонов режим и проверка на състоянието му
sleep 300 &
jobs

# 20. Показване на йерархията на процесите
pstree -p

# 21. Запис на процесите на текущия потребител във файл
ps -u "$USER" > /tmp/user_processes.txt

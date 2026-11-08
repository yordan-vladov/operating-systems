# Сигурност в Линукс

---

## Съдържание

1. Основни концепции за сигурност
2. Управление на потребители и права
3. `sudo` — привилегирован достъп
4. Firewall — `ufw` и `iptables`
5. Защита на SSH
6. `fail2ban` — защита от brute-force
7. Одит и логове
8. Криптиране на файлове
9. Практически задачи
10. Обобщение

---

## 1. Основни концепции за сигурност

---

### CIA триада

Трите основни принципа на информационната сигурност:

| Принцип            | Значение                                              |
| ------------------ | ----------------------------------------------------- |
| **C**onfidentiality (Поверителност) | Данните са достъпни само за оторизирани потребители |
| **I**ntegrity (Цялостност)          | Данните не са модифицирани неоторизирано            |
| **A**vailability (Наличност)        | Системата е достъпна, когато е нужна                |

---

### Модел на заплахите (Threat Model)

- **Атакуващ** — кой може да атакува системата?
- **Вектор на атака** — откъде идва заплахата? (мрежа, физически достъп, вътрешен потребител)
- **Актив** — какво трябва да защитим? (данни, услуги, репутация)
- **Мерки** — какво правим срещу заплахата?

---

### Принципи на сигурна система

- **Минимални привилегии** — всеки процес/потребител получава само необходимите права.
- **Defense in depth** — множество слоеве защита.
- **Fail closed** — при грешка системата отказва достъп, не го разрешава.
- **Одит** — всички действия се записват.

---

## 2. Управление на потребители и права

---

### Права на файлове

```bash
# Преглед на права
ls -l /etc/passwd
# -rw-r--r-- 1 root root 2847 Apr 20 10:00 /etc/passwd
#  │││ │││ │││
#  │││ │││ └── Останали (other): r--  = 4
#  │││ └──── Група (group):  r--  = 4
#  └──── Собственик (owner): rw-  = 6
```

---

### Промяна на права — `chmod`

```bash
# Символен запис
chmod u+x скрипт.sh          # Добавя изпълнение за собственика
chmod go-w важен_файл.txt    # Премахва запис за група и останали
chmod a=r само_четене.txt    # Само четене за всички

# Числов запис
chmod 600 ~/.ssh/id_ed25519  # rw------- (частен ключ)
chmod 644 ~/.bashrc          # rw-r--r-- (конфиг файл)
chmod 755 /usr/local/bin/tool # rwxr-xr-x (изпълним файл)
```

---

### Специални права

| Право  | Символ | Октал | Ефект                                            |
| ------ | ------ | ----- | ------------------------------------------------ |
| SUID   | `s`    | 4000  | Изпълнява се с правата на **собственика**        |
| SGID   | `s`    | 2000  | Изпълнява се с правата на **групата**            |
| Sticky | `t`    | 1000  | Само собственикът може да изтрие файла в папката |

```bash
# SUID — пример: passwd се изпълнява като root
ls -l /usr/bin/passwd
# -rwsr-xr-x 1 root root ... /usr/bin/passwd

# Sticky bit на /tmp — всеки може да пише, но не може да трие чужди файлове
ls -ld /tmp
# drwxrwxrwt 20 root root ... /tmp
```

```bash
# Задаване с chmod — символен начин
chmod u+s file      # задава SUID
chmod g+s dir       # задава SGID
chmod +t dir        # задава Sticky bit

# Задаване с chmod — октален начин (префикс пред стандартните права)
chmod 4755 file     # SUID  + rwxr-xr-x
chmod 2755 dir      # SGID  + rwxr-xr-x
chmod 1777 dir      # Sticky + rwxrwxrwx (като /tmp)
chmod 6755 file     # SUID + SGID + rwxr-xr-x
```

---

### Намиране на опасни права

```bash
# Намиране на файлове с SUID
find / -perm -4000 -type f 2>/dev/null

# Намиране на файлове с SGID
find / -perm -2000 -type f 2>/dev/null

# Файлове с права за запис за всички
find / -perm -o+w -type f -not -path "/proc/*" 2>/dev/null
```

---

## 3. `sudo` — привилегирован достъп

---

### Какво е `sudo`?

- **sudo** (Superuser Do) — изпълнява команда с правата на друг потребител (по подразбиране `root`).
- По-сигурна алтернатива на директния `root` достъп.
- Всяка употреба се **логва** в `/var/log/auth.log`.

---

### Основна употреба

```bash
# Изпълнява команда като root
sudo apt update

# Изпълнява команда като конкретен потребител
sudo -u www-data ls /var/www/

# Отваря root shell (избягвайте ако може)
sudo -i

# Изпълнява команда без парола (ако е разрешено)
sudo -n systemctl restart nginx
```

---

### Конфигурация — `/etc/sudoers`

```bash
# Редактиране (ЗАДЪЛЖИТЕЛНО чрез visudo — проверява за грешки)
sudo visudo
```

```
# Формат:
# потребител хост=(като_кого) команди

# Пълни права за потребителя yordan
yordan ALL=(ALL:ALL) ALL

# Само определени команди без парола
deploy ALL=(root) NOPASSWD: /usr/bin/systemctl restart nginx

# Групата devops може да рестартира услуги
%devops ALL=(root) /usr/bin/systemctl restart *, /usr/bin/systemctl stop *
```

---

### Добри практики с `sudo`

- **Не използвайте** `NOPASSWD: ALL` — дава пълен root достъп без парола.
- Ограничавайте командите до **точно необходимото**.
- Редовно преглеждайте `/etc/sudoers` и файловете в `/etc/sudoers.d/`.
- Проверявайте кой е в групата `sudo`: `getent group sudo`.

---

## 4. Firewall — `ufw` и `iptables`

---

### Какво е firewall?

- Система, която **филтрира мрежовия трафик** въз основа на правила.
- Контролира кои портове и адреси са достъпни.
- Линукс ядрото използва **netfilter**, управляван чрез `iptables` или по-новия `nftables`.

---

### `ufw` — Uncomplicated Firewall

`ufw` е удобен интерфейс над `iptables`, подходящ за сървъри.

```bash
# Проверка на статуса
sudo ufw status verbose

# Активиране (ВНИМАНИЕ: уверете се, че SSH е разрешен преди!)
sudo ufw enable

# Деактивиране
sudo ufw disable
```

---

### Управление на правила с `ufw`

```bash
# Разрешаване на SSH (порт 22)
sudo ufw allow ssh
sudo ufw allow 22/tcp

# Разрешаване на уеб трафик
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Разрешаване от конкретен IP
sudo ufw allow from 192.168.1.100 to any port 22

# Забрана на порт
sudo ufw deny 23/tcp

# Изтриване на правило
sudo ufw delete allow 80/tcp
```

---

### Изходна политика на `ufw`

```bash
# Задаване на политика по подразбиране
sudo ufw default deny incoming   # Забранява всички входящи
sudo ufw default allow outgoing  # Разрешава всички изходящи

# Преглед на правилата с номера
sudo ufw status numbered

# Изтриване на правило по номер
sudo ufw delete 3
```

---

### `iptables` — ниско ниво

```bash
# Преглед на правилата
sudo iptables -L -n -v

# Разрешаване на SSH
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Блокиране на IP адрес
sudo iptables -A INPUT -s 10.0.0.5 -j DROP

# Запазване на правилата (Debian/Ubuntu)
sudo iptables-save > /etc/iptables/rules.v4
```

> За повечето случаи `ufw` е достатъчен. `iptables` се използва за сложни конфигурации.

---

## 5. Защита на SSH

---

### Конфигурационен файл на SSH сървъра

```bash
sudo nano /etc/ssh/sshd_config
```

---

### Препоръчани настройки

```
# Забраняване на root login
PermitRootLogin no

# Само ключове, без пароли
PasswordAuthentication no
PubkeyAuthentication yes

# Ограничаване на потребителите с достъп
AllowUsers yordan deploy

# Промяна на порта (скрива от масови сканирания)
Port 2222

# Изключване на неизползвани функции
X11Forwarding no
AllowAgentForwarding no

# Времеви лимит за вход
LoginGraceTime 30
MaxAuthTries 3
```

```bash
# Прилагане на промените
sudo systemctl restart sshd
```

---

### Проверка на SSH конфигурацията

```bash
# Тест на конфигурацията (без рестартиране)
sudo sshd -t

# Преглед на активните SSH сесии
who
ss -tnp | grep :22

# Логове за SSH вход
sudo journalctl -u ssh -f
sudo grep "Failed password" /var/log/auth.log
```

---

## 6. `fail2ban` — защита от brute-force

---

### Какво е `fail2ban`?

- Следи лог файловете за **неуспешни опити за вход**.
- При определен брой неуспехи — **блокира IP адреса** чрез firewall.
- Поддържа SSH, Apache, Nginx, FTP и много други услуги.

---

### Инсталиране и стартиране

```bash
# Инсталиране
sudo apt install fail2ban

# Стартиране и автоматично стартиране при boot
sudo systemctl enable --now fail2ban

# Проверка на статуса
sudo systemctl status fail2ban
```

---

### Конфигурация

```bash
# НЕ редактирайте /etc/fail2ban/jail.conf — ще се презапише при обновяване
# Създайте собствена конфигурация:
sudo nano /etc/fail2ban/jail.local
```

```ini
[DEFAULT]
bantime  = 1h       # Времетраене на блокирането
findtime = 10m      # Прозорец за броене на неуспехи
maxretry = 5        # Максимален брой неуспешни опита

[sshd]
enabled = true
port    = 22
logpath = /var/log/auth.log
maxretry = 3
bantime  = 24h
```

---

### Управление на `fail2ban`

```bash
# Преглед на всички jails
sudo fail2ban-client status

# Преглед на блокираните IP за SSH
sudo fail2ban-client status sshd

# Ръчно блокиране на IP
sudo fail2ban-client set sshd banip 10.0.0.5

# Разблокиране на IP
sudo fail2ban-client set sshd unbanip 10.0.0.5
```

---

## 7. Одит и логове

---

### Важни лог файлове

| Файл                    | Съдържание                            |
| ----------------------- | ------------------------------------- |
| `/var/log/auth.log`     | Автентикация, sudo, SSH (Debian/Ubuntu) |
| `/var/log/secure`       | Автентикация (RHEL/CentOS)            |
| `/var/log/syslog`       | Общи системни съобщения               |
| `/var/log/kern.log`     | Съобщения от ядрото                   |
| `/var/log/fail2ban.log` | Действия на fail2ban                  |
| `/var/log/ufw.log`      | Firewall събитияr                     |

---

### Преглед на логове

```bash
# Последни неуспешни входове
sudo grep "Failed password" /var/log/auth.log | tail -20

# Успешни входове
sudo grep "Accepted" /var/log/auth.log

# Употреба на sudo
sudo grep "sudo" /var/log/auth.log

# Следене на логове в реално време
sudo tail -f /var/log/auth.log
sudo journalctl -f
```

---

### `auditd` — разширен одит

```bash
# Инсталиране
sudo apt install auditd

# Наблюдение на достъпа до файл
sudo auditctl -w /etc/passwd -p rwa -k passwd_changes

# Преглед на записите
sudo ausearch -k passwd_changes

# Генериране на отчет
sudo aureport --auth
```

---

### `last` и `lastb` — история на входовете

```bash
# История на успешните входове
last

# История на неуспешните входове (изисква root)
sudo lastb | head -20

# Кои потребители са влезли последно
lastlog
```

---

## 8. Криптиране на файлове

---

### `gpg` — GNU Privacy Guard

GPG прилага **асиметрична криптография** за криптиране и подписване на файлове.

```bash
# Генериране на ключова двойка
gpg --full-generate-key

# Преглед на ключовете
gpg --list-keys
gpg --list-secret-keys
```

---

### Криптиране и декриптиране с GPG

```bash
# Криптиране за конкретен получател (с публичния му ключ)
gpg --encrypt --recipient yordan@example.com тайно.txt
# Създава тайно.txt.gpg

# Симетрично криптиране (с парола)
gpg --symmetric тайно.txt

# Декриптиране
gpg --decrypt тайно.txt.gpg > тайно.txt

# Подписване на файл
gpg --sign документ.pdf

# Проверка на подпис
gpg --verify документ.pdf.gpg
```

---

### `openssl` — криптиране от командния ред

```bash
# Симетрично криптиране (AES-256)
openssl enc -aes-256-cbc -pbkdf2 -in тайно.txt -out тайно.enc

# Декриптиране
openssl enc -d -aes-256-cbc -pbkdf2 -in тайно.enc -out тайно.txt

# Генериране на случаен ключ (32 байта, hex)
openssl rand -hex 32

# Изчисляване на хеш (за проверка на цялостност)
openssl dgst -sha256 файл.iso
sha256sum файл.iso
```

---

### Криптиране на директории с `tar` и `openssl`

```bash
# Архивиране и криптиране
tar czf - ./важна_папка/ | openssl enc -aes-256-cbc -pbkdf2 -out архив.tar.gz.enc

# Декриптиране и разархивиране
openssl enc -d -aes-256-cbc -pbkdf2 -in архив.tar.gz.enc | tar xzf -
```

---

## 9. Практически задачи

---

### Задача 1 — Одит на права

```bash
# 1. Намерете всички файлове с SUID в /usr/bin
find /usr/bin -perm -4000 -type f

# 2. Намерете файлове с права за запис за всички в /etc
find /etc -perm -o+w -type f 2>/dev/null

# 3. Проверете правата на критичните файлове
ls -l /etc/passwd /etc/shadow /etc/sudoers
```

**Цел:** Разберете какво е инсталирано и потенциално рисково.

---

### Задача 2 — Конфигуриране на `ufw`

```bash
# 1. Задайте политика по подразбиране
sudo ufw default deny incoming
sudo ufw default allow outgoing

# 2. Разрешете SSH и HTTP
sudo ufw allow ssh
sudo ufw allow 80/tcp

# 3. Активирайте firewall-а
sudo ufw enable

# 4. Проверете правилата
sudo ufw status verbose
```

---

### Задача 3 — Защита на SSH сървъра

```bash
# 1. Редактирайте /etc/ssh/sshd_config:
#    - PermitRootLogin no
#    - MaxAuthTries 3
#    - LoginGraceTime 30

# 2. Проверете конфигурацията за грешки
sudo sshd -t

# 3. Рестартирайте SSH
sudo systemctl restart sshd

# 4. Проверете логовете за грешки
sudo journalctl -u ssh -n 20
```

---

### Задача 4 — Инсталиране и настройка на `fail2ban`

```bash
# 1. Инсталирайте fail2ban
sudo apt install fail2ban

# 2. Създайте /etc/fail2ban/jail.local с:
#    maxretry = 3
#    bantime = 1h за sshd

# 3. Стартирайте услугата
sudo systemctl enable --now fail2ban

# 4. Проверете статуса на SSH jail
sudo fail2ban-client status sshd
```

---

### Задача 5 — Криптиране на файл

```bash
# 1. Създайте тестов файл с чувствителна информация
echo "Тайна парола: SuperSecret123" > тайно.txt

# 2. Криптирайте с OpenSSL
openssl enc -aes-256-cbc -pbkdf2 -in тайно.txt -out тайно.enc

# 3. Изтрийте оригинала
rm тайно.txt

# 4. Декриптирайте и прочетете
openssl enc -d -aes-256-cbc -pbkdf2 -in тайно.enc
```

---

## 10. Обобщение

---

### Основни команди

| Команда                                   | Предназначение                          |
| ----------------------------------------- | --------------------------------------- |
| `chmod`, `chown`                          | Управление на права на файлове          |
| `find / -perm -4000`                      | Намиране на SUID файлове                |
| `sudo visudo`                             | Редактиране на sudoers (безопасно)      |
| `ufw enable / allow / deny`               | Управление на firewall                  |
| `fail2ban-client status sshd`             | Преглед на блокирани IP                 |
| `grep "Failed password" /var/log/auth.log` | Неуспешни SSH входове                  |
| `last` / `lastb`                          | История на входовете                    |
| `gpg --encrypt`                           | Криптиране с GPG                        |
| `openssl enc -aes-256-cbc`               | Симетрично криптиране                   |
| `auditctl -w /path`                       | Наблюдение на файл с auditd             |

---

### Ключови изводи

- Прилагайте **минимални привилегии** — никой процес не трябва да има повече права от необходимото.
- Използвайте **SSH ключове** и деактивирайте вход с парола.
- Firewall-ът (`ufw`) трябва да **забранява всичко по подразбиране** и да разрешава само необходимото.
- `fail2ban` е лесна и ефективна защита срещу brute-force атаки.
- Редовно преглеждайте **логовете** — ранното откритие предотвратява инциденти.
- Криптирайте чувствителни данни в покой с `gpg` или `openssl`.

---

### Допълнителни ресурси

- `man ufw`, `man iptables`, `man sshd_config`
- `man gpg`, `man openssl`
- CIS Benchmarks за Linux: https://www.cisecurity.org/cis-benchmarks
- OWASP Linux Security: https://owasp.org
- `lynis` — инструмент за одит на сигурността: `sudo apt install lynis && sudo lynis audit system`

---

# Daemon Програми

---
## Съдържание

- Какво е daemon?
- Съществени daemon програми.
- Работа с daemon програми.
---
## Какво е daemon?

- Програма, която се изпълнява на фонов режим и изпълнява определена системна услуга / задача.
- Различна от **demon** (зъл дух от някои религии).
---
- Принтер daemon отговаря за всичките услуги, свързани с принтера.
- Network daemon отговаря за мрежовите комуникации с другите устройства.
- ...
---
- Daemon-ите изпълняват определено действие в предварително зададени времена или в отговор на определени явления.
- Всеки daemon наблюдава специфична част от системата и е "невидим" за потребителя.
---
## Идентифициране на daemon

- Програми, които завършват с "d".
- Възможно е да засечем daemon-и чрез програми като `ps`,`top` или `htop`.
- Най-добре се виждат чрез командата `pstree.`
---
## Видове процеси

- Интерактивни - изпълняват се през терминала
- Batch - групи от процеси, които се изпълняват във фона
- Daemon - изпълняват се във фона, не изискват човешка намеса
---
## Пускане на daemon-и

- Когато се пусне компютъра, daemon-и започват да се създават от init системата.
- Създаването на процес се случва чрез метод, наречен **forking**.
---
## fork

- Команда, която позволява на един процес (**parent**) да създаде друг процес (**child**).
- След като **child** е създаден той ще започне да изпълнява инструкции, заложени след създаващият го `fork()`.
---
- Системните daemon-и се създават от init системата, като тя създава fork-ове на себе си.
- По този начин init системата е parent процесът на daemon-ите.
- Друг начин е един процес да създаде daemon и след това да умре.
---
- Когато е един parent процес умре, child  процесите стават "сираци".
- Всички сираци се поемат от **init** системата.
---
## Прост fork

```python
# Importing os module
import os

# Creating child processes using fork() method
os.fork()

# This will be executed by both parent & child processes
print("Hello from a process.")
```
---

![](/Attachments/OS_Daemons_Pic_1.png)

---
## Няколко fork-a

```python
# Importing os module
import os

# Creating child processes using fork() method
os.fork()
os.fork()

# This will be executed by both parent & child processes
print("Hello from a process.")
```
---
![](/Attachments/OS_Daemons_Pic_2.png)

---
## Контролиран fork

```python
import os


print("Starting the program...")

# Fork the current process
pid = os.fork()

if pid == 0:
    # This block runs in the child process
    print("Child process:")
    print(f"  PID: {os.getpid()}")  # Process ID of the child
    print(f"  Parent PID: {os.getppid()}")  # Parent's Process ID
else:
    # This block runs in the parent process
    print("Parent process:")
    print(f"  PID: {os.getpid()}")  # Process ID of the parent
    print(f"  Child PID: {pid}")  # Process ID of the created child

# Both processes execute this
print(f"Process {os.getpid()} says hello!")
```
---
![](/Attachments/OS_Daemons_Pic_3.png)

---
## daemon - Примери

- `systemd` - системна конфигурация
- `rsyslogd` - логване на системни съобщения
- `udisksd` - работа с дискови устройства
- `logind` - влизане на потребители
---
- `httpd` - изпълняване на http заявки
- `sshd` - свързване със сървъри
- `ftpd` - трансфериране на файлове
- `crond` - настройване на операции, които трябва да се изпълнят по определено време
---
## systemd

- Предлага набор от системни услуги, включително и напълно функционираща **init** система.
- Използва от повечето популярни дистрибуции.
- Потребителите могат да взаимодействат със **systemd** чрез командата **systemctl**.
---
## systemctl - Синтаксис

- Можем да променяме системните услуги, използвайки **systemctl**:
```bash
systemctl <command> <service_name>
```
---
## Примерна услуга/daemon

- **mysql** - Популярна СУБД
- Не се стартира ръчно от потребителя
- Работи на нашата система чрез daemon-ът **mysqld**
---
## systemctl start

- Използваме за стартиране на системна услуга.
```bash
sudo systemctl start mysql
```
---
## systemctl stop

- Използваме за спиране на системна услуга.
```bash
sudo systemctl stop mysql
```
---
## systemctl enable

- Позволява услугата да се пуска автоматично след стартиране на системата.
```bash
sudo systemctl enable mysql
Created symlink '/etc/systemd/system/mysql.service' → '/usr/lib/systemd/system/mariadb.service'.
Created symlink '/etc/systemd/system/mysqld.service' → '/usr/lib/systemd/system/mariadb.service'.
Created symlink '/etc/systemd/system/multi-user.target.wants/mariadb.service' → '/usr/lib/systemd/system/mariadb.service'.
```
---
## systemctl disable

- Услугата няма да се стартира автоматично след стартиране на системата
```bash
sudo systemctl disable mysql
Removed '/etc/systemd/system/multi-user.target.wants/mariadb.service'.
Removed '/etc/systemd/system/mysql.service'.
Removed '/etc/systemd/system/mysqld.service'.
```
---
## systemctl status

- Проверява статусът на дадена услуга
```bash
systemctl status mysql
```
---
## systemctl restart

- Рестартира дадена услуга
```bash
sudo systemctl restart mysql
```
---
## systemctl reload

- Прилагат се промени, направени към конфигурацията на услугата, без да се рестартира цялата услуга
```bash
sudo systemctl reload mysql
```
---
## systemctl mask

- Прави една услуга да не може да се стартира
```bash
sudo systemctl mask mysql
Created symlink '/etc/systemd/system/mysql.service' → '/dev/null'.
```
---
## systemctl unmask

- Прави една маскирана услуга отново да може да се стартира
```bash
sudo systemctl unmask mysql
Removed '/etc/systemd/system/mysql.service' → '/dev/null'.
```
---
# Създаване на daemon
---
##  Създаване на програма

```python
#!/usr/bin/env python3

import http.server
import socketserver
import os

PORT = 8080
DIRECTORY = "/tmp/http-server"

class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIRECTORY, **kwargs)

def main():
    os.makedirs(DIRECTORY, exist_ok=True)
    with socketserver.TCPServer(("", PORT), Handler) as httpd:
        httpd.serve_forever()

if __name__ == "__main__":
    main()
```
---
## Създаване на service файл

```ini
[Unit]
Description=Simple Python HTTP Server
After=network.target

[Service]
ExecStart=/usr/bin/python3 /path/to/simple-http-daemon.py
WorkingDirectory=/tmp
Restart=always

[Install]
WantedBy=multi-user.target
```
---
## Подкарване на daemon

```bash
sudo systemctl daemon-reload # презареждаме systemd
sudo systemctl start simple-http-daemon # започваме услугата
sudo systemctl status simple-http-daemon # проверяваме нейният статус
sudo systemctl stop simple-http-daemon # спираме услугата
```
---

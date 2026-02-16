# Linux – Логване и лог файлове

---

### Съдържание

* Какво е логване?
* Какво представляват лог файловете?
* Къде се съхраняват логовете?
* Основни инструменти за преглед
* Системи за логване (rsyslog, systemd-journald)

---

## Какво е логване?

* Процес на записване на събития, грешки и действия в системата.
* Използва се за:
  * Диагностика на проблеми
  * Наблюдение на сигурността
  * Анализ на работата на системата
  * Одит и проследяване на действия

---

## Какво представлява лог файл?

* Обикновен текстов файл
* Съдържа информация за:
    * Дата и час
    * Име на услуга или процес
    * Тип на съобщението (info, warning, error)
    * Описание на събитието

---

Примерен запис в лог файл:

```text
Feb 09 10:15:32 server sshd[1234]: Failed password for user admin
```

---

## Къде се съхраняват лог файловете?

В Linux повечето логове се намират в директорията:

```bash
/var/log
```

---

## Основни лог файлове

- Най-често използвани лог файлове:
    * **/var/log/syslog** – общи системни съобщения
    * **/var/log/auth.log** – информация за логване и автентикация
    * **/var/log/kern.log** – съобщения от ядрото
    * **/var/log/dmesg** – съобщения при стартиране
    * **/var/log/apache2/** – логове на уеб сървър

---
- Спрямо дистрибуцията, която използваме, log файловете могат да имат различни имена или изпълняват от различни команди.
- Например за **Fedora**:
    - **/var/log/syslog** (Ubuntu/Debian) → **/var/log/messages** (Fedora)
    - **/var/log/auth.log** → **/var/log/secure**
    - **/var/log/kern.log** → **journalctl -k**
    - **/var/log/dmesg** → **dmesg** или **journalctl -b**  
    - **/var/log/apache2/** → **/var/log/httpd/**

---
## Нива на лог съобщения (Log Levels)

* DEBUG – подробна информация за разработчици
* INFO – информационни съобщения
* WARNING – предупреждения
* ERROR – грешки
* CRITICAL – критични проблеми

---

## Преглед на лог файлове

---

### Преглед на съдържание

```bash
cat /var/log/syslog
```

---

### Преглед страница по страница

```bash
less /var/log/syslog
```

---

### Преглед в реално време

```bash
tail -f /var/log/syslog
```

---

## systemd-journald и journalctl

- В модерните Linux системи логовете се управляват от **systemd**:
- Инструментът за достъп до тях е:

```bash
journalctl
```

---

## journalctl

- **journalctl** е инструмент за преглед на логовете от systemd-journald.

---
### Основни команди:

```bash
journalctl            # всички логове
journalctl -b         # логове от текущото стартиране
journalctl -r         # показва логовете в обратен ред
journalctl -n 50      # последните 50 реда
```

---

## Преглед на грешки и проблеми

Полезно при диагностика на системата.

```bash
journalctl -xe            # последни грешки с обяснения
journalctl -p err         # само грешки
journalctl -p warning     # предупреждения
journalctl --since today  # от днес
```

---

- Нива на приоритет:
    * emerg
    * alert
    * crit
    * err
    * warning
    * notice
    * info
    * debug

---

## Логове на услуги (services)

- Преглед на конкретна systemd услуга:

```bash
journalctl -u sshd
journalctl -u httpd
journalctl -u NetworkManager
```

- Логове в реално време:

```bash
journalctl -u sshd -f
```

---

## Филтриране по време

- Много полезно при анализ на инциденти.

```bash
journalctl --since "2026-02-15 10:00"
journalctl --since "1 hour ago"
journalctl --since yesterday
journalctl --until "2026-02-15 12:00"
```

---

- **Комбиниране:**

```bash
journalctl --since yesterday --until today
```

---

## Kernel и Boot логове

- Системни проблеми и драйвери.

```bash
journalctl -k          # kernel съобщения
journalctl -b          # текущ boot
journalctl -b -1       # предишен boot
journalctl --list-boots
```

---

## Наблюдение в реално време

- Подобно на `tail -f`.

```bash
journalctl -f
journalctl -u sshd -f
journalctl -k -f
```

---

## Полезни практически примери

---

### Проверка защо услуга не стартира:

```bash
journalctl -u nginx -xe
```

---

### Проверка на SSH логвания:

```bash
journalctl -u sshd
```

---

### Последни системни грешки:

```bash
journalctl -p err -b
```

---

## rsyslog

Традиционната система за логване:

---

### rsyslog

* Събира логове от системата
* Записва ги във файлове в `/var/log`
* Конфигурационен файл:

```bash
/etc/rsyslog.conf
```

---

## Лог ротация (Log Rotation)

- С течение на времето лог файловете нарастват.
- Използва се инструментът **logrotate**:

---

### logrotate

* Архивира стари логове
* Компресира ги
* Изтрива много стари файлове
* Конфигурация в:

```bash
/etc/logrotate.conf
```

---

## Пример от практиката

### Сценарий:

Потребител не може да се логне в сървъра.

---

### Проверяваме:

```bash
tail -f /var/log/auth.log
```

---

- Възможни причини:
    * Грешна парола
    * Заключен акаунт
    * Няма права за достъп
    * Проблем със SSH услугата

---

## Ръчно логване от терминала

Потребителят може сам да записва съобщения в системните логове чрез командата **logger**.

---

- **Пример:**

```bash
logger "Тестово съобщение от потребителя"
```

---

- **Проверка:**

```bash
journalctl -n 20
```

---

## Задаване на приоритет (severity)

- Може да се зададе ниво на съобщението:

```bash
logger -p user.info "Информационно съобщение"
logger -p user.warning "Предупреждение"
logger -p user.err "Грешка"
```

---

- **Формат:**

```bash
logger -p facility.level "message"
```

---

- Примери за level:
    * info
    * warning
    * err
    * debug
    * crit

---

## Задаване на таг (име на приложение)

- Полезно при програми и скриптове.

```bash
logger -t MY_APP "Стартиране на приложението"
```

---

- **Филтриране:**

```bash
journalctl -t MY_APP
```

---

## Логване от Bash скрипт

- **Пример:**

```bash
#!/bin/bash

logger -t BACKUP "Backup started"

# някакви действия

logger -t BACKUP "Backup finished"
```

---

## Логване от Python програма

- Python има вградена библиотека **logging**.
- **Пример:**

```python
import logging

logging.basicConfig(level=logging.INFO)

logging.info("Програмата стартира")
logging.warning("Това е предупреждение")
logging.error("Възникна грешка")
```

---

## Логване към systemd journal от Python

- По-професионален вариант (Linux):
- Инсталиране:

```bash
pip install systemd-python
```

---

- **Пример:**

```python
from systemd import journal

journal.send("Python приложение стартира",
             PRIORITY=journal.LOG_INFO)

journal.send("Грешка в програмата",
             PRIORITY=journal.LOG_ERR)
```

---

- **Преглед:**

```bash
journalctl -t python
```

---

## Практически пример

- Сценарий:
- Програма записва събития:
    * старт
    * грешка
    * край
- Администраторът може да ги види чрез:

```bash
journalctl -t MY_APP
```

---

## Обобщение

* Логването е основен механизъм за диагностика
* Логовете се намират в `/var/log`
* `journalctl` работи със systemd
* `tail -f` е основна команда за наблюдение
* `logrotate` предпазва системата от препълване
* Потребителите могат сами да записват логове, като командата **logger** е най-лесният начин

# Работа с мрежови команди в Linux

---

## Съдържание

1. Основни концепции за мрежи в Linux
2. Команди за диагностика и информация
3. Команди за тестване на свързаност
4. Команди за мрежова конфигурация
5. Команди за анализ на трафик

---

### Какво ще научим днес?

- Как Linux управлява мрежовите интерфейси
- Кои са основните инструменти за работа с мрежата
- Как да диагностицираме мрежови проблеми от командния ред
- Как да четем и интерпретираме мрежова информация

---

## 2. Основни концепции

---

### Мрежови интерфейси в Linux

В Linux всеки мрежов адаптер се представя като **интерфейс**. Типични имена:

| Тип            | Старо наименование | Ново наименование |
| -------------- | ------------------ | ----------------- |
| Ethernet       | `eth0`, `eth1`     | `enp3s0`, `ens33` |
| Безжична мрежа | `wlan0`            | `wlp2s0`          |
| Loopback       | `lo`               | `lo`              |

---

### Loopback интерфейс

- IP адрес: `127.0.0.1` (IPv4) / `::1` (IPv6)
- Използва се за вътрешна комуникация на хоста
- Винаги е активен, дори без физическа мрежа

---

## 3. Команди за информация

---

### `ip` - Основен инструмент за мрежова конфигурация

Командата `ip` е съвременният заместител на остарялото `ifconfig`.

---

```bash
# Показва всички мрежови интерфейси и IP адреси
ip addr show

# Съкратена версия
ip a

# Показва информация само за конкретен интерфейс
ip addr show eth0
```

---
### Примерен изход:

```
2: enp3s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP
    inet 192.168.1.105/24 brd 192.168.1.255 scope global dynamic enp3s0
    inet6 fe80::a00:27ff:fe4e:66a1/64 scope link
```

---

### `ip` - Маршрути и линкове

```bash
# Показва таблицата с маршрути (routing table)
ip route show

# Съкратена версия
ip r

# Показва само статуса на линковете (без IP адреси)
ip link show

# Включва/изключва интерфейс
sudo ip link set eth0 up
sudo ip link set eth0 down
```

---

### Таблица с маршрути - какво означава?

```
default via 192.168.1.1 dev enp3s0 proto dhcp
192.168.1.0/24 dev enp3s0 proto kernel scope link
```

- `default via 192.168.1.1` - default gateway (рутерът)
- `192.168.1.0/24` - локалната мрежа, достъпна директно

---

### `ss` - Информация за мрежови сокети

`ss` е заместник на остарялото `netstat`.

---


```bash
# Показва всички активни TCP връзки
ss -t

# Показва всички слушащи портове
ss -l

# Показва всички TCP слушащи портове с имена на процесите
ss -tlnp

# Показва всички UDP слушащи портове
ss -ulnp
```

---

### Декодиране на флаговете:

| Флаг | Значение                                   |
| ---- | ------------------------------------------ |
| `-t` | TCP сокети                                 |
| `-u` | UDP сокети                                 |
| `-l` | Само слушащи портове                       |
| `-n` | Числови адреси/портове (без DNS резолюция) |
| `-p` | Показва процеса, собственик на сокета      |

---

### `hostname` и DNS информация

```bash
# Показва хостнейма на машината
hostname

# Показва всички IP адреси на машината
hostname -I

# Показва пълното квалифицирано домейн име (FQDN)
hostname -f
```

---

```bash
# Резолюция на домейн до IP адрес
nslookup google.com

# По-детайлен инструмент за DNS заявки
dig google.com

# Показва само A записа
dig google.com A +short

# Обратна резолюция (IP -> домейн)
dig -x 8.8.8.8
```

---

## 4. Тестване на свързаност

---

### `ping` - Проверка на достъпност

```bash
# Изпраща ICMP echo заявки към хост
ping google.com

# Ограничава броя пакети до 4
ping -c 4 google.com

# Задава интервал между пакетите (в секунди)
ping -i 0.5 -c 10 192.168.1.1

# Задава размера на пакета (в байтове)
ping -s 1024 google.com
```

---
### Интерпретация на резултата:

```
PING google.com (142.250.186.46): 56 data bytes
64 bytes from 142.250.186.46: icmp_seq=0 ttl=117 time=12.4 ms

--- google.com ping statistics ---
4 packets transmitted, 4 received, 0% packet loss
rtt min/avg/max/mdev = 11.2/12.4/13.8/1.0 ms
```

- `time` - закъснение в милисекунди (latency)
- `packet loss` - загуба на пакети (0% = добра свързаност)
- `ttl` - Time To Live (брой хопове, останали до изтичане)

---

### `traceroute` / `tracepath` - Проследяване на маршрута

```bash
# Показва всеки хоп по пътя до дестинацията
traceroute google.com

# Алтернатива без нужда от root права
tracepath google.com

# Използва TCP вместо ICMP (полезно при firewall)
traceroute -T google.com
```

---

### Пример за изход:

```
traceroute to google.com (142.250.186.46), 30 hops max
 1  192.168.1.1 (192.168.1.1)    1.2 ms   1.1 ms   1.0 ms
 2  10.0.0.1    (10.0.0.1)       8.3 ms   8.1 ms   8.4 ms
 3  * * *
 4  72.14.215.1 (72.14.215.1)   11.2 ms  11.0 ms  11.5 ms
```

- Всеки ред = един рутер (хоп) по пътя
- `* * *` = хопът не отговаря на ICMP (firewall)

---

### `curl` и `wget` - HTTP тестове

```bash
# Изтегля съдържание от URL
curl https://example.com

# Показва само HTTP header-ите
curl -I https://example.com

# Показва детайлна информация за заявката и отговора
curl -v https://example.com

# Изтегля файл и го запазва
wget https://example.com/file.txt

# Проверява HTTP статус кода
curl -o /dev/null -s -w "%{http_code}" https://example.com
```

---

## 5. Мрежова конфигурация

---

### Временна конфигурация с `ip`

> Важно: Тези промени се губят след рестарт на системата!

```bash
# Добавя IP адрес към интерфейс
sudo ip addr add 192.168.1.200/24 dev eth0

# Премахва IP адрес от интерфейс
sudo ip addr del 192.168.1.200/24 dev eth0

# Добавя default gateway
sudo ip route add default via 192.168.1.1

# Изтрива маршрут
sudo ip route del default via 192.168.1.1
```

---

### Постоянна конфигурация

Постоянната мрежова конфигурация зависи от дистрибуцията:

---

#### Debian / Ubuntu - Netplan (съвременен подход)

```yaml
# /etc/netplan/01-network.yaml
network:
  version: 2
  ethernets:
    enp3s0:
      addresses:
        - 192.168.1.100/24
      routes:
        - to: default
          via: 192.168.1.1
      nameservers:
        addresses: [8.8.8.8, 1.1.1.1]
```

---

```bash
# Прилага конфигурацията
sudo netplan apply
```

---

#### Red Hat / CentOS - nmcli

```bash
# Показва всички мрежови връзки
nmcli connection show

# Добавя статичен IP
nmcli con mod enp3s0 ipv4.addresses 192.168.1.100/24
nmcli con mod enp3s0 ipv4.gateway 192.168.1.1
nmcli con up enp3s0
```

---

### `/etc/hosts` и `/etc/resolv.conf`

```bash
# Файл с локални DNS записи
cat /etc/hosts
```

---

```
127.0.0.1   localhost
127.0.1.1   mycomputer
192.168.1.50  fileserver.local fileserver
```

---

```bash
# Конфигурация на DNS reshttps://github.com/yordan-vladov/operating-systems/blob/main/Lectures/18_Devices/devices.mdolver
cat /etc/resolv.conf
```

---

```
nameserver 8.8.8.8
nameserver 1.1.1.1
search home.local
```

---

## 6. Анализ на мрежов трафик

---

### `tcpdump` - Прихващане на мрежови пакети

```bash
# Прихваща всички пакети на интерфейс
sudo tcpdump -i eth0

# Прихваща само HTTP трафик (порт 80)
sudo tcpdump -i eth0 port 80

# Прихваща трафик от/до конкретен IP
sudo tcpdump -i eth0 host 192.168.1.1

# Записва в pcap файл за по-късен анализ
sudo tcpdump -i eth0 -w capture.pcap

# Четене на записан файл
tcpdump -r capture.pcap
```

---

### `netstat` (остарял) vs `ss` (съвременен)

```bash
# Еквивалентни команди:

# Стари (netstat)          | Нови (ss)
netstat -tuln              | ss -tuln
netstat -an                | ss -an
netstat -r                 | ip route show
netstat -i                 | ip -s link
```

---

### `arp` и `ip neigh` - ARP таблица

```bash
# Показва ARP кеша (остаряла команда)
arp -a

# Съвременен вариант
ip neigh show

# Изчиства ARP записа за конкретен IP
sudo ip neigh del 192.168.1.50 dev eth0
```

---

### `iptables` - Основи на firewall

```bash
# Показва текущите правила
sudo iptables -L -v -n

# Показва NAT правилата
sudo iptables -t nat -L -v -n

# Позволява входящ трафик на порт 22 (SSH)
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Блокира входящ трафик от конкретен IP
sudo iptables -A INPUT -s 10.0.0.5 -j DROP
```

> За постоянни правила в Ubuntu се използва `ufw`, а в RedHat - `firewalld`.

---

## 7. Практически задачи

---

### Задача 1 - Мрежова диагностика

Изпълнете следните команди и отговорете на въпросите:

```bash
ip addr show
ip route show
ping -c 4 8.8.8.8
traceroute google.com
ss -tlnp
```

---

**Въпроси:**
- Кой е вашият IP адрес и каква е маската на подмрежата?
- Кой е default gateway?
- Колко хопа има до `google.com`?
- Кои портове слушат на вашата машина?

---

### Задача 2 - DNS и свързаност

```bash
nslookup github.com
dig github.com +short
curl -I https://github.com
```

---

**Въпроси:**
- До кой IP адрес се резолюцира `github.com`?
- Какъв HTTP статус код връща `github.com`?
- Колко дълго отнема DNS резолюцията?

---

### Задача 3 - Анализ на мрежов трафик (изисква sudo)

```bash
# В един терминал стартирайте прихващане
sudo tcpdump -i lo -n port 80

# В друг терминал генерирайте трафик
curl http://localhost
```

**Цел:** Наблюдавайте пакетите и идентифицирайте TCP handshake (SYN, SYN-ACK, ACK).

---

## 8. Обобщение

---

### Основни команди

| Команда           | Предназначение                        |
|-------------------|---------------------------------------|
| `ip addr`         | Показва IP адреси и интерфейси        |
| `ip route`        | Показва таблицата с маршрути          |
| `ip link`         | Управлява мрежови интерфейси          |
| `ss -tlnp`        | Показва слушащи портове               |
| `ping`            | Тества достъпност до хост             |
| `traceroute`      | Проследява маршрута до хост           |
| `dig` / `nslookup`| DNS заявки                            |
| `curl` / `wget`   | HTTP заявки и изтегляне               |
| `tcpdump`         | Прихваща мрежови пакети               |
| `nmcli`           | Управлява мрежови връзки (NetworkManager) |

---

## Ключови изводи

- `ip` замества `ifconfig`, `ss` замества `netstat`
- Всяка промяна с `ip` е временна до рестарт
- За постоянна конфигурация се използва Netplan (Ubuntu) или nmcli (RedHat)
- `tcpdump` е мощен инструмент за анализ, но изисква root права
- DNS конфигурацията се управлява чрез `/etc/resolv.conf`

---

## Допълнителни ресурси

- `man ip` - пълна документация за командата `ip`
- `man ss` - пълна документация за `ss`
- `man tcpdump` - пълна документация за `tcpdump`
- Linux Foundation - Networking Fundamentals
- `tldr ip`, `tldr ss` - опростени примери (изисква пакета `tldr`)

---


# Docker Compose

---
## Съдържание

- Какво е Docker Compose?
- Какво е YAML?
- Използване на Docker Compose.
---
### Какво е Docker Compose?

- Инструмент за дефиниране и стартиране на **мултиконтейнерни Docker приложения**.
- Използва файл `compose.yml`, за да опише **услуги**, **мрежи**, **томове** и **конфигурации**.
---
- Позволява стартиране на цялото приложение с една команда:
```bash
docker compose up
```
---
### Кога се използва?

- При разработка на приложения, използващи повече от един контейнер:
  - Приложение + база данни
  - Reverse proxy + API
  - Кеш сървър (Redis) + бекенд
---
- При нужда от лесно **разгръщане** и **споделяне** на конфигурации.
- Подходящ за **локално разработване**, **тестове**, **CI/CD** и др.
---
### Какво е YAML?

- **YAML** = YAML Ain’t Markup Language
- Формат за сериализация на данни – четим от човека.
- Използва се за конфигурационни файлове (вкл. `docker-compose.yml`).
---
### YAML синтаксис

```yaml
ключ: стойност

списък:
  - елемент1
  - елемент2

обект:
  вложен_ключ: вложена_стойност
```
---
### `compose.yml`: Основни компоненти

```yaml
version: '3.9'

services:
  web:
    image: nginx
    ports:
      - "8080:80"
  db:
    image: postgres
    environment:
      POSTGRES_PASSWORD: secret
```
---
### Основни ключове в `compose.yml`

- `version` – версия на синтаксиса
- `services` – описва контейнерите (услуги)
- `build` или `image` – как се създава контейнера
---
- `ports` – пренасочване на портове
- `volumes` – споделяне на файлове между хост и контейнер
- `environment` – задаване на променливи на средата
- `depends_on` – зависимост между услугите
---
### Пример: PHP + MySQL приложение

![](/Attachments/OS-Compose-1.png)

---
### PHP - Dockerfile

```Dockerfile
# Dockerfile
FROM php:8.1-apache

# Install PHP extensions
RUN docker-php-ext-install mysqli

# Copy project files to the Apache root directory
COPY . /var/www/html/

# Enable Apache mod_rewrite
RUN a2enmod rewrite
```
---
### `compose.yml` пример

```yaml
services:
  db:
    image: mysql:latest
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: gallery
    volumes:
      - db_data:/var/lib/mysql
      - ./gallery.sql:/docker-entrypoint-initdb.d/gallery.sql
  web:
    build: .
    ports:
      - "8080:80"
    volumes:
      - ./:/var/www/html
    depends_on:
      - db

volumes:
  db_data:
```
---
### Стартиране на проекта

```bash
docker compose up --build
```

- `--build` – създава образа на приложението
---
### Изтриване на проекта

```bash
docker compose down -v
```
- `-v` - премахва томове
---
### Заключение

- Docker Compose е мощен инструмент за работа с няколко контейнера.
- YAML файловете са лесни за четене и писане.
- С `compose.yml` можеш бързо да създаваш и стартираш цялостни среди.
---
### Материали

- [Docker Compose Документация](https://docs.docker.com/compose/)
- [Docker Compose Примери](https://github.com/docker/awesome-compose)
- [Използвано приложение](https://github.com/yordan-vladov/gallery#)

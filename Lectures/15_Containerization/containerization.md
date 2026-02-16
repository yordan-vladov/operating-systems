## Контейнеризация
---
## Съдържание

- Какво е контейнеризация?
- Предимства на контейнеризация?
- Docker.
---
### Какво е контейнеризация?

- Лека версия на виртуализация.
- Пакетираме приложение и всичките негови зависимости в изолирана, преносима единица, наречена **контейнер**.
- Можем да пренасяме тези  контейнери из различни компютърни среди.
---
- За разлика от виртуалните машини, контейнерите споделят едно и също ядро, правейки ги значително по-леки.
- Това също така ги прави по-несигурни, понеже самата ОС може да има уязвимости.
---
![](/Attachments/OS-Containerization-1.png)

---
## Docker
![](/Attachments/OS-Containerization-2.png)

---
### Какво е Docker?

- Платформа за разработване, разпространяване и пускане на контейнеризирани приложение?
- Чрез **Docker** ние можем да пакетираме приложение, заедно със всичките му **зависимости**.
- Един контейнер е по-лек от **VM** и може да работи на всяка система.
---
### Защо Docker?

- Синдром **"Работи при мен".**
- Различно поведение при различни среди.
- Комплексни зависимости.
---
- Чрез **Docker** ние можем да изолираме средата, което води до постоянно поведение при всички системи и прави приложенията по-лесни споделяне, пускане и мащабиране.
---
## Docker - Компоненти

- Engine
- Image
- Container
- Dockerfile
- Docker Hub
---
### Docker Engine

- Приложението, което изпълнява и управлява контейнерите
- Използва клиент-сървър архитектура:
    - Приложението работи във фона като **Docker Daemon** (`dockerd`).
    - Чрез **Docker CLI** (`docker`) можем да взаимодействаме с приложението.
---
```bash
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo docker run hello-world
```
---
```bash
# Добавяне на текущият потребител към docker групата
sudo usermod -aG docker $(whoami)
```
---
### Docker Image

- **Шаблон**, съдържащ инструкциите за създаване на контейнер.
- Съдържа кода на приложението, библиотеки, environment променливи, конфигурационни файлове и др.
---
### Docker Container

- Работеща инстанция на един **Docker Image**.
- Изолиран от ОС, ползва само ядрото.
- Може лесно да се стартира, спира, трие и рестартира.
---
### Dockerfile

- Текстови скрипт, съдържащ инструкциите за създаване на даден **Docker Image**.
- **Dockerfile -> Docker Image -> Docker Container**.
---
![](/Attachments/OS-Containerization-3.png)

---
### Dockerfile - Инструкции

- `FROM`: Базов **Docker Image**
- `COPY` / `ADD`: Добавяне на файлове
- `RUN`: Изпълняване на команди
- `CMD` / `ENTRYPOINT`: Команда, която да се изпълнява при стартиране на контейнера
- `EXPOSE`: Деклариране на порт
---
## Използване на Docker

- За да видим как можем да използваме **Docker** първо ще разработим просто уеб приложение с **Node.js**.
- **Node.js** е популярен фреймуърк за разработване на приложения, който ни позволява да използваме JavaScript като сървърен/приложен език.
- Поради развитата система от разширения/инструменти **Node.js** приложенията могат да се възползват от контейнеризация.
---
![](/Attachments/OS-Containerization-4.png)

---
### Разработка на приложението

1. [Инсталиране на Node.js](https://nodejs.org/en/download).
2. Създаване на проект:
```bash
mkdir profile-links-page
cd profile-links-page
npm init -y
```
---
3. Инсталиране на зависимости:
```bash
npm install express
```
---
4. Създаване на `index.js`:
```js
// index.js
const express = require("express");
const path = require("path");
const app = express();
const PORT = process.env.PORT || 3000;

// Serve static files from "public" folder
app.use(express.static(path.join(__dirname, "public")));

app.listen(PORT, () => {
  console.log(`Server is running at http://localhost:${PORT}`);
});
```
---
5. Имплементиране на страницата
6. Пускане на приложението
```bash
node index.js
```
---
### Споделяне на приложение

- Много рядко само един човек работи върху дадено приложение. Повечето пъти много хора (с различни среди) ще работят заедно върху дадено приложение.
- Най-често приложението ще седи в централно хранилище (например в GitHub) с инструкции за подкарване (най-често в README файл).
---
- За подкарване на съществуващо **Node.js** приложение най-малко трябва да изпълним:
```bash
npm install
node index.js # или `npm run`
```
---
- Най-често развитите приложения имат сложни зависимости, които трябва да се поддържат от всички разработчици.
- За направим приложението по-лесно за разработка ние можем да пакетираме в Docker контейнер, премахвайки нуждата от инсталиране/подкарване на допълнителен софтуер.
---
### Контейнеризиране на приложението

1. Създаване на `dockerignore` файл. В него поясняваме файлове/директории, които няма нужда да се копират в Docker контейнера:
```txt
node_modules
npm-debug.log
```
---
2. Създаване на `Dockerfile`:
```dockerfile
# Use an official Node.js runtime as base image
FROM node:18

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the app
COPY . .

# Expose port
EXPOSE 3000

# Start the app
CMD ["node", "index.js"]
```

---
3. Създаване на **Docker Image**:
```bash
docker build -t profile_page .
```
4. Създаване на **Docker Container**:
```bash
docker run -p 3000:3000 profile_page
```
---
- Ако искаме да спрем даден контейнер:
```bash
docker ps -a # виждаме информация за работещи контейнери
docker stop <CONTAINER_ID_OR_NAME> # спираме даден контейнер
docker rm <CONTAINER_ID_OR_NAME> # премахваме даден контейнер
docker system prune           # Изчисти неизползвани контейнери, мрежи, кеш и обеми
```
---
- Ако искаме да премахнем даден **Image**:
```bash
docker image ls # показва инсталирани изображения
docker rmi <IMAGE_NAME> # премахва дадено изображение
```
---
### Публикуване на приложението

- Освен за разработка, трябва да имаме предвид ѝ форматът за публикуване на приложението, когато искаме то да се използва на готово.
- Тук Docker също върши страхотна работа!
---
### Docker Hub

- Онлайн платформи за запазване и споделяне на **Docker** изображения.
- Чрез нея или нейни алтернативи като **GitHub Containers** ние можем да теглим официални изображения (`docker pull`) или да качваме наши (`docker push`).
---
### Публикуване - Стъпки

 1. Влизане в **Docker Hub**:
```bash
docker login
```
2. Тагване на изображението чрез `docker tag` (формат `<local-image> <dockerhub-username>/<repo-name>`):
```bash
docker tag profile_page yourusername/profile_page
```
---
3. Публикуване на изображението:
```bash
docker push yourusername/profile_page
```
4. Теглене и пускане на изображението:
```bash
docker pull yourusername/profile_page
docker run -p 3000:3000 yourusername/profile_page
```
---
## Взаимодействане с контейнер

- Можем да използваме командата `docker exec`, за да изпълним команда вътре в работещ Docker контейнер.
```bash
docker exec [OPTIONS] CONTAINER COMMAND [ARG...]
```
---
- **Пример:** искаме да отворим нова shell сесия в контейнер `web_app`, за да видим какво се случва в него:
```bash
docker exec -it web_app /bin/bash
```
---
- **Пример:** ако сме пуснали база данни като MongoDB да работи в контейнер и искаме да направим връзка с нея чрез `mongosh`:
```bash
docker exec -it mongodb mongosh -u admin -p secret
```
---
- чрез `docker exec` ние по-лесно можем да:
    - **дебъгваме** контейнеризирани приложения
    - **конфигурираме** пуснати контейнери
    - извършваме **мониторинг** върху съществуващи контейнери чрез програми като `top`, `htop`
---
## Docker volume

- По принцип един контейнер губи своите данни, след като е изтрит.
- Чрез **Docker volume (том)** ние можем да пазим данните, генерирани от контейнери.
```bash
docker volume create pgdata # създаване на том
```
---
- **Пример:** Пуснали сме база данни да работи в контейнери и искаме нейните данни да се запазят дори след като контейнера е изтрит.
- За тази можем да пазим данните в том.
---
```bash
docker run -d \
  --name postgres-db \
  -e POSTGRES_PASSWORD=mysecretpassword \
  -v pgdata:/var/lib/postgresql/data \
  postgres
```
---
- Допълнителни команди за работа с томове:
```bash
docker volume ls # показване на съществуващи томове
docker volume inspect pgdata # проверяване на конкретен том
docker volume rm pgdata
```
---
## Docker network

- По подразбиране всеки контейнер работи със своя собствена виртуална мрежа.
- **Docker network (мрежа)** позволява различни контейнери да комуникират по между си на обща мрежа.
---
```bash
docker network create mynetwork # създаване на мрежа
docker run -d --name db --network mynetwork -e MYSQL_ROOT_PASSWORD=root mysql # пускане на база данни
docker run -d --name webapp --network mynetwork my-web-app-image # пускане на уеб приложение, което комуникира с базата данни
```

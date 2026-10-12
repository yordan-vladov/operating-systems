# Стандартни потоци

---
## Съдържание

- Какво е поток?
- Стандартни потоци и файлови дескриптори
- Пренасочване на stdout
- Пренасочване на stdin
- Пренасочване на stderr
- Комбиниране на потоци

---
## Какво е поток?

- Връзка, която позволява данни да пътуват между програма и околната ѝ среда (операционната система, терминалът, ...)
- Всеки поток има посока — **към** програмата или **от** програмата
- Абстрахират програмните комуникации — програмата не се интересува дали пише в терминал, файл или друга програма

---
## Стандартни потоци

- Всяка програма в Linux се стартира с три отворени потока:

| Поток    | Име                | Дескриптор | По подразбиране |
|----------|--------------------|------------|-----------------|
| `stdin`  | Стандартен вход    | `0`        | Клавиатурата    |
| `stdout` | Стандартен изход   | `1`        | Терминалът      |
| `stderr` | Стандартна грешка  | `2`        | Терминалът      |

---
## Файлов дескриптор

- Уникален идентификатор за отворен файл или I/O ресурс
- Изразява се като неотрицателно цяло число
- Стандартните потоци винаги имат дескрипторите `0`, `1` и `2`
- Всеки следващ файл, който програмата отвори, получава следващия свободен номер (`3`, `4`, ...)

---
### stdin

- **Цел**: Вход на програмите. Обикновено идва от клавиатурата
- **Дескриптор**: `0`
- **Пример**: `cat` без аргументи чете от stdin и повтаря всеки въведен ред
- `Ctrl + D` сигнализира край на входа (EOF)

```bash
$ cat
Hello
Hello
Linux
Linux
^D
```

---
### stdout

- **Цел**: Нормален изход на програмите. Обикновено се извежда в терминала
- **Дескриптор**: `1`
- **Пример**: Резултатът на `pwd`, `whoami`, `ls`, `echo`

```bash
$ whoami
user
$ echo "Hello, World!"
Hello, World!
```

---
### stderr

- **Цел**: Съобщения за грешки и диагностика
- **Дескриптор**: `2`
- **Пример**: Опит за достъп до несъществуващ файл

```bash
$ ls missing.txt
ls: cannot access 'missing.txt': No such file or directory
$ cd missing_dir
bash: cd: missing_dir: No such file or directory
```

---
### Защо stdout и stderr са отделни?

- И двата потока по подразбиране отиват в терминала — изглеждат еднакво
- Разделението позволява да обработваме **резултатите** и **грешките** по различен начин
- Пример: запазваме резултата във файл, а грешките продължават да се виждат на екрана

```bash
$ ls file.txt missing.txt
ls: cannot access 'missing.txt': No such file or directory
file.txt
```

---
## Пренасочване

- По подразбиране:
    1. **stdin** — идва от клавиатурата
    2. **stdout** — отива към терминала
    3. **stderr** — отива към терминала
- Пренасочването ни позволява да променим крайната точка на даден поток — към файл, друга програма или устройство
- Пренасочването се извършва от **shell-а**, преди командата да бъде стартирана

| Оператор | Действие                                     |
|----------|----------------------------------------------|
| `>`      | stdout към файл (презаписва)                 |
| `>>`     | stdout към файл (добавя в края)              |
| `<`      | stdin от файл                                |
| `2>`     | stderr към файл (презаписва)                 |
| `2>>`    | stderr към файл (добавя в края)              |
| `2>&1`   | stderr към мястото, където сочи stdout       |
| `&>`     | stdout и stderr към файл                     |

---
## Пренасочване на stdout

---
### Оператор `>`

- Пренасочва изхода на команда към файл
- Ако файлът не съществува — създава се
- Ако файлът съществува — **съдържанието му се презаписва**

```bash
$ echo "Hello, World!" > output.txt
$ cat output.txt
Hello, World!

$ echo "Bye!" > output.txt
$ cat output.txt
Bye!
```

---
### Запазване на изхода на команди

- Всяка команда, която пише в stdout, може да бъде пренасочена

```bash
$ pwd > location.txt
$ whoami > user.txt
$ ls -la ~ > home_listing.txt

$ cat location.txt
/home/user/Documents
$ cat user.txt
user
```

---
### Оператор `>>`

- Ако вместо да презапишем файла искаме да добавим към него, използваме `>>`

```bash
$ echo "Hello, World!" > output.txt
$ echo "Hello, Again!" >> output.txt
$ cat output.txt
Hello, World!
Hello, Again!
```

---
### Пример: Създаване на файл със съдържание

- Комбинация от `mkdir`, `cd`, `echo`, `whoami`, `pwd` и пренасочване

```bash
$ mkdir -p projects/os
$ cd projects/os
$ echo "# Операционни системи" > README.md
$ whoami >> README.md
$ pwd >> README.md
$ cat README.md
# Операционни системи
user
/home/user/projects/os
```

---
### Пример: Дневник (log) файл

- `>>` е удобен за файлове, които растат с времето

```bash
$ echo "Започнах лабораторно упражнение" >> log.txt
$ echo "Създадох директория lab1" >> log.txt
$ echo "Приключих" >> log.txt
$ cat log.txt
Започнах лабораторно упражнение
Създадох директория lab1
Приключих
```

---
### Внимание при `>`

- Файлът се изпразва **преди** командата да се изпълни
- Затова не можем да пренасочим изхода на `cat` към същия файл, който четем

```bash
$ cat notes.txt
Важна бележка
$ cat notes.txt > notes.txt
$ cat notes.txt
$
```

- Файлът вече е празен

---
### `cat` и обединяване на файлове

- `cat` извежда съдържанието на един или повече файлове в stdout
- С пренасочване можем да обединим няколко файла в един

```bash
$ echo "Linux" > os1.txt
$ echo "Windows" > os2.txt
$ cat os1.txt os2.txt > all_os.txt
$ cat all_os.txt
Linux
Windows
```

---
## Пренасочване на stdin

---
### Оператор `<`

- Програмата получава входа си от файл, вместо от клавиатурата

```bash
$ command < file.txt
```

- `cat` без аргументи чете от stdin, затова двете команди дават еднакъв резултат:

```bash
$ cat < output.txt
Hello, World!
Hello, Again!
$ cat output.txt
Hello, World!
Hello, Again!
```

---
### Аргумент или stdin?

- `cat output.txt` — `cat` **сам отваря** файла по име
- `cat < output.txt` — **shell-ът отваря** файла и го подава като stdin; `cat` дори не знае името му
- Разликата се вижда при команди, които извеждат името на файла:

```bash
$ wc -l output.txt
2 output.txt
$ wc -l < output.txt
2
```

- `wc -l` — брои редовете във входа

---
### Писане във файл от клавиатурата

- Комбинация от stdin (клавиатурата) и пренасочен stdout
- Бърз начин да създадем файл без текстов редактор

```bash
$ cat > shopping.txt
мляко
хляб
яйца
^D
$ cat shopping.txt
мляко
хляб
яйца
```

- С `cat >> shopping.txt` добавяме към съществуващ файл

---
### Копиране чрез потоци

- `<` и `>` могат да се използват заедно
- Резултатът е подобен на `cp`

```bash
$ cat < shopping.txt > shopping_copy.txt
$ cat shopping_copy.txt
мляко
хляб
яйца
```

---
## Пренасочване на stderr

---
### Оператор `2>`

- Позволява ни да обработим грешките отделно от нормалния изход
- `2` е дескрипторът на stderr

```bash
$ ls missing.txt 2> errors.txt
$ cat errors.txt
ls: cannot access 'missing.txt': No such file or directory
```

- На екрана не се извежда нищо — грешката е във файла

---
### `>` не пренасочва грешките

- `>` е съкращение на `1>` — пренасочва **само** stdout
- Грешките продължават да се извеждат в терминала

```bash
$ ls file.txt missing.txt > result.txt
ls: cannot access 'missing.txt': No such file or directory
$ cat result.txt
file.txt
```

---
### Разделяне на изхода и грешките

- Можем да пренасочим двата потока към различни файлове

```bash
$ ls file.txt missing.txt > result.txt 2> errors.txt
$ cat result.txt
file.txt
$ cat errors.txt
ls: cannot access 'missing.txt': No such file or directory
```

---
### Натрупване на грешки с `2>>`

```bash
$ rm missing.txt 2>> errors.txt
$ mkdir projects 2>> errors.txt
$ cat errors.txt
ls: cannot access 'missing.txt': No such file or directory
rm: cannot remove 'missing.txt': No such file or directory
mkdir: cannot create directory 'projects': File exists
```

---
### `/dev/null`

- Специален файл, който служи като „черна дупка“
- Всичко записано в него се изхвърля
- Използваме го, когато искаме да скрием съобщенията за грешка

```bash
$ ls file.txt missing.txt 2> /dev/null
file.txt
```

- Или когато не ни интересува изходът, а само дали командата е успешна

```bash
$ ls file.txt > /dev/null
$
```

---
## Комбиниране на потоци

---
### Оператор `2>&1`

- Пренасочва stderr **натам, накъдето в момента сочи** stdout
- `&1` означава „файлов дескриптор 1“, а не файл с име `1`
- Използва се, когато искаме изходът и грешките да са на едно място

```bash
$ ls file.txt missing.txt > all.txt 2>&1
$ cat all.txt
ls: cannot access 'missing.txt': No such file or directory
file.txt
```

---
### Съкращение `&>`

- В `bash` има кратък запис за пренасочване и на двата потока

```bash
$ ls file.txt missing.txt &> all.txt
```

- Еквивалентно на:

```bash
$ ls file.txt missing.txt > all.txt 2>&1
```

- Скриване на целия изход на команда:

```bash
$ ls file.txt missing.txt &> /dev/null
```

---
## Каква е разликата между тези две команди?

```bash
$ command 2>&1 > test.txt
$ command > test.txt 2>&1
```

---
### Редът има значение

- Пренасочванията се изпълняват **отляво надясно**
- `2>&1` копира **текущата** стойност на stdout, а не създава постоянна връзка

```bash
$ ls file.txt missing.txt 2>&1 > test.txt
ls: cannot access 'missing.txt': No such file or directory
$ cat test.txt
file.txt
```

1. `2>&1` — stderr сочи към терминала (там, където е stdout в момента)
2. `> test.txt` — stdout сочи към файла
3. Грешките отиват в терминала, само изходът е във файла

---

```bash
$ ls file.txt missing.txt > test.txt 2>&1
$ cat test.txt
ls: cannot access 'missing.txt': No such file or directory
file.txt
```

1. `> test.txt` — stdout сочи към файла
2. `2>&1` — stderr сочи натам, накъдето сочи stdout — към файла
3. И изходът, и грешките са във файла

---
## Поглед напред: Pipes

- Освен към файл, stdout на една команда може да бъде подаден като stdin на друга
- Това става с оператора `|` (pipe)

```bash
$ ls ~ | wc -l
3
```

- Ще разгледаме pipes подробно в темата „Работа с данни“

---
## Обобщение

| Запис                 | Описание                                   |
|-----------------------|--------------------------------------------|
| `cmd > file`          | stdout към файл (презаписва)               |
| `cmd >> file`         | stdout към файл (добавя)                   |
| `cmd < file`          | stdin от файл                              |
| `cmd 2> file`         | stderr към файл                            |
| `cmd 2>> file`        | stderr към файл (добавя)                   |
| `cmd 2> /dev/null`    | скриване на грешките                       |
| `cmd > file 2>&1`     | stdout и stderr към един файл              |
| `cmd &> file`         | stdout и stderr към един файл (bash)       |
| `cat > file`          | запис от клавиатурата във файл             |
| `cat f1 f2 > file`    | обединяване на файлове                     |

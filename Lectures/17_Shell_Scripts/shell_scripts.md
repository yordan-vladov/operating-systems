# Shell Скриптове

---
## Съдържание

- Какво е shell?
- Какво е shell скрипт?
- Работа със shell скриптове.
---
## Какво е Shell?

- Команден интерпретатор.
- Позволява ни да пишем команди, които да се изпълняват от операционната система.
---
### Bash

- **Bourne Again Shell**.
- Подразбиращият се шел за повечето **Linux** дистрибуции.
- Конфигурира се чрез `.bashrc` и `.bash_profile.`
---
- **Функционалности:** история на командите, auto completion.
- **Предимства:** добре поддържан, документиран.
- **Недостатъци:** по-бавен от съвременни шелове.
---
## Zsh

- По-развита версия на Bash с повече функционалности.
- Конфигурира се чрез `.zshrc`,  `zsh_profile`, както и чрез фреймуърци като [oh my zsh](https://ohmyz.sh/).
---
- **Функционалности:** мощен auto complete, globbing
- **Предимства:** лесно персонализираме, повече функционалности
- **Недостатъци:** по-труден за научаване
---
## Shell Script

- Серия от команди, записани във файл.
- Командите се изпълняват ред по ред, подобно на програмни езици като Python.
- Shell скриптовете се  обозначават с `.sh`.
---
### Shell Script - Структура

```bash
#! shebang

commands
```
---
### Shebang

-  "#!", последвано от интерпретаторът/шелът, който ще изпълнява командите.
- Примери: #! /bin/bash, #! /bin/zsh, #! /bin/python
---
### Bash скрипт

- Скрипт, който се изпълнява от Bash шелът.
- Първият ред винаги ще бъде "#! /bin/bash".
---
## Изпълнение на скрипт

- Shell скриптовете са изпълними файлове, след. ги изпълняваме като въведем техният адрес.
- За тези цел трябва да имаме "execute" привилегии върху тях.
---
## Скрипт - Пример

- Скрипт, който принтира "Hello, World", когато е извикван.
```bash
echo "#! /bin/bash" > hello.sh
echo "echo 'Hello, World'" >> hello.sh
chmod +x hello.sh
./hello.sh
```
---
## Променливи

- Скриптовете могат да пазят информация в различни променливи.
```bash
foo="Operating Systems"
echo "I love $foo!"
```
---
- Те могат да съдържат прости данни:
```bash
message="Hello World"
short_message=hi
number=1
pi=3.142
other_pi="3.142"
mixed=123abc
```
---
- Или резултат от команда:
```bash
name=$(cat name.txt)
echo "My name is $name."
```
---
## Променливи - Пример

- Прост скрипт, който приветства потребителя и му казва текущата дата и време:
```txt
Hello, stamat!
Welcome to linux.
Today's date is 1999-01-01 and the current time is 21:17:04.
```
---
```sh
#!/bin/bash

# Variables
DATE=$(date +"%Y-%m-%d")
TIME=$(date +"%H:%M:%S")

# Greet the user
echo "Hello, $USER!"
echo "Welcome to $HOST."
echo "Today's date is $DATE and the current time is $TIME."
```
---
- Скрипт, който принтира името на потребителя, home директорията му, и предпочитаният му шел.
---
## Аритметика

```bash
#!/bin/bash

echo $((1 + 3)) # 4
```

---
## Какво ще се върне тук?

```bash
#!/bin/bash

a=3
b=a
echo $b
```
---
## Константи

```bash
#!/bin/bash

readonly A=5
A=6 # error

echo $A
```

---
## Сравнения

```bash
if [ condition ]; then
# Commands to run if condition is true
fi
```
---
## Аритметични оператори за сравнение

| Оператор | Значение  |
| -------- | --------- |
| `-eq`    | Равно     |
| `-ne`    | Неравно   |
| `-gt`    | По-голямо |
| `-lt`    | По-малко  |

---

| Оператор | Значение            |
| -------- | ------------------- |
| `-ge`    | По-голямо или равно |
| `-le`    | По-малко или равно  |

---
```bash
#!/bin/bash
if [ 5 -gt 3 ]; then
    echo "5 is greater than 3"
fi
```

---
```bash
if [ condition ]; then
    # Commands if condition is true
else
    # Commands if condition is false
fi
```
---
```bash
#!/bin/bash
num=15
if [ "$num" -gt 10 ]; then
    echo "Number is greater than 10"
else
    echo "Number is 10 or less"
fi
```
---
```bash
if [ condition1 ]; then
    # Commands for condition1
elif [ condition2 ]; then
    # Commands for condition2
else
    # Commands if none are true
fi
```
---
```bash
#!/bin/bash

num=10
if [ "$num" -gt 10 ]; then
    echo "Greater than 10"
elif [ "$num" -eq 10 ]; then
    echo "Equal to 10"
else
    echo "Less than 10"
fi
```
---
### (( )) - Работа с числа

```bash
a=-5
if ((a < 0)); then
	echo "$a is negative."
elif ((a > 0)); then
	echo "$a is positive."
else
	echo "$a is zero."
fi
```
---
- Напишете **bash** скрипт, който сравнява две числа и принтира кое от тях е по-голямо или са равни.
---
```bash
#! /bin/bash
a=5

if ((a % 2 == 0)); then
    echo "$a is even"
else
    echo "$a is odd"
fi
```
---
### Логически оператори

| Оператор    | Значение      |
| ----------- | ------------- |
| `&&` , `-a` | Логическо И   |
| \|\|, `-o`  | Логическо ИЛИ |
| `!`         | Логическо НЕ  |

---

```bash
if [ "$num" -gt 5 ] && [ "$num" -lt 20 ]; then
    echo "Number is between 5 and 20"
fi
```

---
- Напишете **bash** скрипт, който взима число и принтира **Fizz** ако числото се дели на 3, **Buzz** ако се дели на 5, и **FizzBuzz** ако се дели и на двете. Иначе принтира само числото.
---
## Текстови оператори за сравнение

| Оператор | Значение     |
| -------- | ------------ |
| `=`      | Равно        |
| `!=`     | Неравно      |
| `<`      | По-малко     |
| `>`      | По-голямо    |
| `-z`     | Празен       |
| `-n`     | Непразен низ |

---
```bash
#!/bin/bash
str1="hello"
str2="world"

if [ "$str1" = "$str2" ]; then
    echo "Strings are equal"
else
    echo "Strings are different"
fi
```
---
```bash
#!/bin/bash
str1="hello"

if [ -z "$str1" ]; then
    echo "String is empty"
else
    echo "String is not empty"
fi
```
---
```bash
if [[ "$str1" < "$str2" ]]; then
    echo "$str1 comes before $str2 in sorting"
fi
```

---
### Файлови оператор

| Оператор | Описание              |
| -------- | --------------------- |
| `-f`     | Файл съществува       |
| `-d`     | Директория съществува |
| `-e`     | Ресурс съществува     |
| `-r`     | Ресурс е четим        |
| `-w`     | Ресурс е редактируем  |
| `-x`     | Ресурс е изпълним     |

---

```bash
if [ -f "myfile.txt" ]; then
    echo "File exists"
else
    echo "File does not exist"
fi
```

---
- Напишете **bash** скрипт, който добавя съобщение към файл. Ако файлът не съществува, да се принтира "File does not exist".
---
## Четене на данни

- shell скриптовете могат да приемат потребителски данни по различни начини.
---
### read

- Позволява ни да въвеждаме данни по време на изпълнението на самият скрипт.
```bash
read var
echo $var
```
---
```bash
read var1 var2
echo "First: $var1, Second: $var2"
```
---
```bash
#! /bin/bash

# read a variable with a prompt
read -p "Enter your name: " name
echo $name
```
---
- Shell скрипт, който чете възрастта на потребителя и проверява дали той може да гласува.
---
```bash
read -s password
echo "Password $password entered"
```
---
-  Shell скрипт, който чете парола от потребителя и я сравнява с истинската парола от файл `password.txt`. Скриптът след това принтира дали паролите съвпадат.
---
### Командни аргументи

- При shell скриптовете лесно можем да задаваме аргументи от командната линия.
```bash
./script.sh arg1 arg2
```
---
- Те могат да се четат в самият чрез позицията им при задаването на командата:
```bash
#!/bin/bash
echo "First argument: $1"
echo "Second argument: $2"
```
---

| Променлива      | Значение                     |
| --------------- | ---------------------------- |
| $0              | Името на скрипта             |
| $1, $2, ..., $9 | Позиционни аргументи         |
| $#              | Брой аргументи               |
| $*              | Всички аргументи             |
| "$@"            | Всички аргументи (разделени) |

---
```bash
#!/bin/bash
# Usage: ./greet.sh name

if [ $# -ne 1 ]; then
    echo "Usage: $0 name"
    exit 1
fi

echo "Hello, $1! Welcome!"
```
---
- Скрипт, който получава като аргумент две числа и принтира техният сбор.
---
## Цикли

- В shell скриптовете може да създаваме `for` и `while` цикли.
---
### for цикъл

```bash
for variable in list
do
    # Commands to execute
done
```
---
```bash
#!/bin/bash
for name in Alice Bob Charlie
do
    echo "Hello, $name"
done
```
---
```bash
for i in {1..5}
do
    echo "Number: $i"
done
```
---
```bash
#! /bin/bash

for (( i = 0; i < 5; i++));
do
    echo $i
done
```
---
```bash
for arg in "$@"; do
  echo "Arg: $arg"
done
```
---
- Скрипт който приема две цели числа n и m и принтира всички числа (n..m).
---
### while цикъл

```bash
while [ condition ]
do
    # Commands to execute
done
```
---
```bash
#!/bin/bash
count=1
while [ $count -le 5 ]
do
    echo "Count: $count"
    ((count++))
done
```
---
### until цикъл

```bash
until [ condition ]
do
    # Commands to execute
done
```
---
```bash
#!/bin/bash
count=1
until [ $count -gt 5 ]
do
    echo "Count: $count"
    ((count++))
done
```
---
- Напишете **bash** скрипт, който иска потребителят да въвежда числа, докато не въведе **stop**. Да се принтира най-голямото от въведените числа.
---
### break, continue

- Можем да ползваме тези ключови думи в нашите цикли:
    - `break` - излиза от цикъла
    - `continue` - отива на следващата итерация на цикъла
---
```bash
for i in {1..10}
do
    if [ $i -eq 5 ]
    then
        break
    fi
    echo "Number: $i"
done
```
---
```bash
for i in {1..5}
do
    if [ $i -eq 3 ]
    then
        continue
    fi
    echo "Number: $i"
done
```
---
### Безкрайни цикли

```bash
while true
do
    echo "Running..."
    sleep 1  # Pause for 1 second
done
```
---
```bash
for (( ; ; ))
do
    echo "Infinite Loop"
    sleep 1
done
```
---
### Четене от файлове ред по ред

```bash
while IFS= read -r line; do
    echo "Text read from file: $line"
done < my_filename.txt
```
---
### Четене от резултат от команда

```bash
while IFS= read -r line; do
    echo $line
done < <(sort /etc/passwd)
```

---
- Напишете **bash** скрипт, който чете файл и принтира съдържанието, като в началото на всеки ред трябва да добави номера на реда.
---

```txt
This is the first line.      1: This is the first line.
This is the second line. =>  2: This is the second line.
This is the third line.      3: This is the third line.
```
---
## Масиви

- В **bash** скриптовете една променлива  може да пази множество стойности.
- Полезни при пазене на списъци от стойности, файлови имена, аргументи, т.н.
---
### Видове масиви

- **Индексирани масиви** - елементите се пазят чрез числени позиции (започващи от индекс 0).
- **Асоциативни масиви** - елементите се пазят като двойки **ключ - стойност** (подобно на речници или hashmap-ове).
---
### Индексирани масиви

```bash
# Method 1: Declare and initialize in one line
array1=("apple" "banana" "cherry")

echo ${array1[0]}  # Output: apple
echo ${array1[2]}  # Output: cherry
```
---
```bash
# Method 2: Declare an empty array and add elements later
declare -a array2
array2[0]="apple"
array2[1]="banana"
array2[2]="cherry"
```
---
```bash
# Method 3: Initialize with values directly
array3=([0]="apple" [1]="banana" [2]="cherry")
```
---
- Можем да достъпваме обща информация за масив:
```bash
# All elements of an array
echo ${array1[@]}  # Output: apple banana cherry

# Number of elements of an array
echo ${#array1[@]}  # Output: 3
```
---
- Можем да променяме съдържанието на масив:
```bash
# Appending an element to an array
array1+=("date")
echo ${array1[@]}  # Output: apple banana cherry date

# Removing an element from an array
unset array1[1]  # Removes "banana"
echo ${array1[@]}  # Output: apple cherry date
```
---
- Можем да итерираме през един масив:
```bash
for fruit in "${array1[@]}";
do
    echo $fruit
done
```
---
- Напишете **bash** скрипт, който иска потребителят да въведе списък от файлове. Скриптът принтира броят редове на всеки въведен файл.
---
```txt
Enter filenames: file1.txt file2.txt file3.txt
file1.txt: 10 lines
file2.txt: 25 lines
file3.txt: 15 lines
```
---
### Асоциативни масиви

```bash
# Declare an associative array
declare -A assoc_array

# Initialize with key-value pairs
assoc_array=([fruit]="apple" [color]="red" [size]="small")
```
---
```bash
# Accessing elements in assoc. array
echo ${assoc_array[fruit]}  # Output: apple
echo ${assoc_array[color]}  # Output: red
```
---
- Можем да достъпваме всички ключове/стойности на един масив:
```bash
# All keys
echo ${!assoc_array[@]}  # Output: fruit color size

# All values
echo ${assoc_array[@]}  # Output: apple red small
```
---
- Можем да итерираме през един асоциативен масив:
```bash
for key in "${!assoc_array[@]}"; do
    echo "$key: ${assoc_array[$key]}"
done
```
---
- Напишете **bash**, който иска потребителят да въведе изречение. Скриптът след това принтира всяка дума колко пъти се среща.

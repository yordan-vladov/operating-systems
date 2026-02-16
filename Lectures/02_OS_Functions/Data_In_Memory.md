
# Представяне на данни в паметта

---

## Съдържание

- Как се представят данни в паметта
- Подреждане на паметта

---

## Представяне на int

- Всеки int съдържа 4 байта
- Да разгледаме как ще се изглeжда примерно число 1234

---

![Number_Into_Binary.png](/Attachments/Number_Into_Binary.png)

---

![Binary_Number_Into_Bytes.png](/Attachments/Binary_Number_Into_Bytes.png)

---

## Endianness

- Редът в който байтовете се подреждат в дума в паметта
- **Big-Endian** - байтовете се подреждат от най-големият до най-малкият байт
- **Little-Endian** - байтовете се подреждат от най-малкият до най-големият байт

---

![Int_In_Big_Endian.png](/Attachments/Int_In_Big_Endian.png)

---

![Int_In_Little_Endian.png](/Attachments/Int_In_Little_Endian.png)

---

## Представяне на текстов низ

- Всеки текстов низ се е представен като низ от символи.
- Ако използваме ASCII, тогава всеки символ има размер 1 байт
- Ще видим как се представи текстът '1234'

---

![String_To_Symbols.png](/Attachments/String_To_Symbols.png)

---

![ASCII_Table.png](/Attachments/ASCII_Table.png)

---

![Symbol_To_ASCII_Values.png](/Attachments/Symbol_To_ASCII_Values.png)

---

![ASCII_Values_To_Bytes.png](/Attachments/ASCII_Values_To_Bytes.png)

---

## Подреждане

- ASCII не е повлиян от endianness-а на компютъра, понеже те просто представляват масив от символи с размер 1 байт
- Ако използваме кодирания като UTF-16, тогава endianess-а вече има значение

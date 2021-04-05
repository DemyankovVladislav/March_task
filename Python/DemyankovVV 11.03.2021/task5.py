stroka = str(input("Введите строку из латинских букв, цифр, знаков препинания и пробельных символов: "))
a = "a"
a1 = "A"
b = "o"
b1 = "O"
c = "e"
c1 = "E"
d = "i"
d1 = "I"
e = "u"
e1 = "U"
f = "y"
f1 = "Y"
count = 0
for i in stroka:
    if i == a or i == a1 or i == b or i == b1 or i == c or i == c1 or i==d or i==d1 or i==e or i==e1 or i==f or i==f1:
        count+=1
    else:
        continue
print("Количество согласных в строке "+ str(stroka)+ " = " +str(count))


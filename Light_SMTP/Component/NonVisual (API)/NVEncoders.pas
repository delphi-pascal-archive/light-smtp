unit NVEncoders;

interface

const
    Base64Out: array [0..64] of Char = (
        'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
        'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
        'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
        'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
        '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/', '='
    );
    Base64In: array[0..127] of Byte = (
        255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
        255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
        255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
        255, 255, 255, 255,  62, 255, 255, 255,  63,  52,  53,  54,  55,
         56,  57,  58,  59,  60,  61, 255, 255, 255,  64, 255, 255, 255,
          0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11,  12,
         13,  14,  15,  16,  17,  18,  19,  20,  21,  22,  23,  24,  25,
        255, 255, 255, 255, 255, 255,  26,  27,  28,  29,  30,  31,  32,
         33,  34,  35,  36,  37,  38,  39,  40,  41,  42,  43,  44,  45,
         46,  47,  48,  49,  50,  51, 255, 255, 255, 255, 255
    );

Const
base64str='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

Type
TBase64 = Record //структура для работы с base64
ByteArr  : Array [0..2] Of Byte;//массив из трех байтов
ByteCount:Byte;                 //количество считанных байт
End;

Function CodeBase64(Base64:TBase64):String;
function Base64Encode(const Input : String) : String;

implementation

// Функция преобразования строки в Base64 строку
function Base64Encode(const Input : String) : String;
var
    Count : Integer;
    Len   : Integer;
begin
    Result := '';
    Count  := 1;
    Len    := Length(Input);
    while Count <= Len do begin
        Result := Result + Base64Out[(Byte(Input[Count]) and $FC) shr 2];
        if (Count + 1) <= Len then begin
            Result := Result + Base64Out[((Byte(Input[Count]) and $03) shl 4) +
                                         ((Byte(Input[Count + 1]) and $F0) shr 4)];
            if (Count + 2) <= Len then begin
                Result := Result + Base64Out[((Byte(Input[Count + 1]) and $0F) shl 2) +
                                             ((Byte(Input[Count + 2]) and $C0) shr 6)];
                Result := Result + Base64Out[(Byte(Input[Count + 2]) and $3F)];
            end
            else begin
                Result := Result + Base64Out[(Byte(Input[Count + 1]) and $0F) shl 2];
                Result := Result + '=';
            end
        end
        else begin
            Result := Result + Base64Out[(Byte(Input[Count]) and $03) shl 4];
            Result := Result + '==';
        end;
        Count := Count + 3;
    end;
end;

// Оригинальный код принадлежит Терехов А.В.
Function CodeBase64(Base64:TBase64):String;
Var
N,M:Byte;
Dest,        //результат - 6-ти битное число с base64-кодом
Sour:Byte;   //исходное 8-ми битное число
NextNum:Byte;// флаг-счетчик для начала работы со следующим 6-ти битным числом
Temp:Byte;   //вспомогательная переменная используется для проверки старшего байта
             //8-ми битного исходного числа
Begin {CodeBase64}
//обнуляем результат
Result:='';
//инициализируем флаг - "следущее 6-ти битное число"
NextNum:=1;
//обнуляем 6-ти битный результат
Dest:=0;
//будем работать с массивом из трех байтов
For N:=0 To 2 Do
Begin {For N}
//берем очередной байт-источник
Sour:=Base64.ByteArr[N];
//пройдемся по всем 8-ми битам байта источника
For M:=0 To 7 Do
Begin {For M}
//будем работать не с самим байтом источником, а с его копией
Temp:=Sour;
//делаем побитный сдвиг влево для байта-источника и байта-приемника
Temp:=Temp SHL M;
Dest:=Dest SHL 1;
//если старший бит байта-источника равен 1
If (Temp And 128) = 128 Then
//в байте приемнике устанавливаем младший бит в 1
Dest:=Dest Or 1;
//увеличиваем счетчик перехода к следующему байту-приемнику
Inc(NextNum);
//если обработаны все 6 битов числа-приемника
If NextNum > 6 Then
Begin {If NextNum}
//заполняем результат функции, добавляя к нему символ из строки base64-алфавита
//с кодом на 1 больше, чем Dest (base64 коды начинаются с 0, а код первого
//символа строки base64-алфавита 1).
Result:=Result+base64str[Dest+1];
//обнуляем счетчик обработанных бит 6-ти битного числа-премника
NextNum:=1;
//обнуляем число-приемник
Dest:=0;
End; {If NextNum}
End; {For M}
End;{For N}
//добавим конечный знак = (равно)
//один знак, если обрабатываются два байта и два знака, если обрабатывается 1 байт
//не забываем, что кодированный стринг состоит из 4 символов
If Base64.ByteCount < 3 Then
For N:=0 To (2 - Base64.ByteCount) Do
Result[4-N]:='=';

End;

end.

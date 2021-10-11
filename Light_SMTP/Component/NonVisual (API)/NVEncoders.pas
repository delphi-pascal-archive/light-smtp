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
TBase64 = Record //��������� ��� ������ � base64
ByteArr  : Array [0..2] Of Byte;//������ �� ���� ������
ByteCount:Byte;                 //���������� ��������� ����
End;

Function CodeBase64(Base64:TBase64):String;
function Base64Encode(const Input : String) : String;

implementation

// ������� �������������� ������ � Base64 ������
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

// ������������ ��� ����������� ������� �.�.
Function CodeBase64(Base64:TBase64):String;
Var
N,M:Byte;
Dest,        //��������� - 6-�� ������ ����� � base64-�����
Sour:Byte;   //�������� 8-�� ������ �����
NextNum:Byte;// ����-������� ��� ������ ������ �� ��������� 6-�� ������ ������
Temp:Byte;   //��������������� ���������� ������������ ��� �������� �������� �����
             //8-�� ������� ��������� �����
Begin {CodeBase64}
//�������� ���������
Result:='';
//�������������� ���� - "�������� 6-�� ������ �����"
NextNum:=1;
//�������� 6-�� ������ ���������
Dest:=0;
//����� �������� � �������� �� ���� ������
For N:=0 To 2 Do
Begin {For N}
//����� ��������� ����-��������
Sour:=Base64.ByteArr[N];
//��������� �� ���� 8-�� ����� ����� ���������
For M:=0 To 7 Do
Begin {For M}
//����� �������� �� � ����� ������ ����������, � � ��� ������
Temp:=Sour;
//������ �������� ����� ����� ��� �����-��������� � �����-���������
Temp:=Temp SHL M;
Dest:=Dest SHL 1;
//���� ������� ��� �����-��������� ����� 1
If (Temp And 128) = 128 Then
//� ����� ��������� ������������� ������� ��� � 1
Dest:=Dest Or 1;
//����������� ������� �������� � ���������� �����-���������
Inc(NextNum);
//���� ���������� ��� 6 ����� �����-���������
If NextNum > 6 Then
Begin {If NextNum}
//��������� ��������� �������, �������� � ���� ������ �� ������ base64-��������
//� ����� �� 1 ������, ��� Dest (base64 ���� ���������� � 0, � ��� �������
//������� ������ base64-�������� 1).
Result:=Result+base64str[Dest+1];
//�������� ������� ������������ ��� 6-�� ������� �����-��������
NextNum:=1;
//�������� �����-��������
Dest:=0;
End; {If NextNum}
End; {For M}
End;{For N}
//������� �������� ���� = (�����)
//���� ����, ���� �������������� ��� ����� � ��� �����, ���� �������������� 1 ����
//�� ��������, ��� ������������ ������ ������� �� 4 ��������
If Base64.ByteCount < 3 Then
For N:=0 To (2 - Base64.ByteCount) Do
Result[4-N]:='=';

End;

end.

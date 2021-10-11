unit Main;

interface

//////////////////////////////////////////////
//////////////////////////////////////////////
///                                        ///
///                                        ///
///  Пример программы, работающей с SMTP   ///
///  протоколом через сокеты на основе     ///
///  компонента Light SMTP.                ///
///                                        ///
///  Copyright 2010 Булай Никита.          ///
///                                        ///
//////////////////////////////////////////////
//////////////////////////////////////////////

uses
  Windows, Messages, SysUtils, Classes, Forms,
  Dialogs, StdCtrls, LightSMTP10, Buttons, XPMan, ComCtrls, Controls;

type
  TForm1 = class(TForm)
    SendToBox: TEdit;
    Label1: TLabel;
    SubjectBox: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    SendBtn: TButton;
    ExitBtn: TButton;
    Label8: TLabel;
    OpenDialog: TOpenDialog;
    SpeedButton1: TSpeedButton;
    XPManifest1: TXPManifest;
    ProgressBar: TProgressBar;
    LogList: TMemo;
    Label4: TLabel;
    Label5: TLabel;
    GroupBox1: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    SmtpServer: TEdit;
    SmtpPort: TEdit;
    LoginBox: TEdit;
    PassBox: TEdit;
    SMTP: TLightSMTP;
    CopyTo: TMemo;
    Label11: TLabel;
    Label12: TLabel;
    Auth: TComboBox;
    Files: TListBox;
    SpeedButton2: TSpeedButton;
    Label13: TLabel;
    Label14: TLabel;
    MsgBox: TMemo;
    AsHtml: TCheckBox;
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SMTPSendProgress(Total, Current: Integer);
    procedure SMTPServerReceive(Answer: string);
    procedure SendBtnClick(Sender: TObject);
    procedure ExitBtnClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.SendBtnClick(Sender: TObject);
begin
MsgBox.Enabled:=False;
LogList.Lines.Clear;
ProgressBar.Position:=0;
// Если программа не настроена
if (SmtpServer.Text='') or (SmtpPort.Text='')
    or (LoginBox.Text='') or (PassBox.Text='') then
begin
  // то выдать сообщение
  MessageBox(handle,'Вы не произвели настройку!','Ошибка',0+$000010);
end
else
begin
SendBtn.Enabled:=false;
LogList.Lines.Add('>> Отправка данных на сервер...');
try
// иначе послать сообщение
SMTP.Host:=Smtpserver.Text;
SMTP.Port:=StrToInt(Smtpport.Text);
SMTP.UserName:=LoginBox.Text;
case Auth.ItemIndex of
 0: SMTP.Authorization:= atAuthNone;
 1: SMTP.Authorization:= atAuthPlain;
 2: SMTP.Authorization:= atAuthLogin;
end;
if not AsHtml.Checked then SMTP.ContentType:= ctTextPlain
else SMTP.ContentType:= ctTextHTML;

SMTP.Password:=PassBox.Text;
SMTP.Subject:=SubjectBox.Text;
SMTP.SendTo:=SendToBox.Text;
SMTP.CopyTo.Assign(CopyTo.Lines);
SMTP.MessageBody.Assign(MsgBox.Lines);
SMTP.FilesToSend.Assign(Files.Items);
SMTP.SendMail;
finally
SendBtn.Enabled:=true;
MsgBox.Enabled:=True;
end;
end;
end;

procedure TForm1.ExitBtnClick(Sender: TObject);
begin
// Выход
Close;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
SendBtn.SetFocus;
end;

procedure TForm1.SMTPSendProgress(Total, Current: Integer);
begin
Application.ProcessMessages;
ProgressBar.Max:=Total;
ProgressBar.Position:=Current;
end;

procedure TForm1.SMTPServerReceive(Answer: string);
begin
LogList.Lines.Add('>> '+Answer)
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
if OpenDialog.Execute then
begin
   Files.Items.Add(OpenDialog.FileName);
end;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
if Files.Items.Count>0 then
 Files.Items.Delete(Files.ItemIndex);
end;

end.

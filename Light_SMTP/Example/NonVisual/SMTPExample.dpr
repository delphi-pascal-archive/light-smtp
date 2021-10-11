program SMTPExample;

uses
  Windows,
  Classes,
  NVLightSMTP10;

{$R *.res}

var API_SMTP: TNVLightSMTP;

begin
API_SMTP:= TNVLightSMTP.Create;

API_SMTP.Host:='smtp.mail.ru';
API_SMTP.Port:=2525;
API_SMTP.Username:='username@mail.ru';
API_SMTP.Password:='password';
API_SMTP.Subject:= 'Тема письма';
API_SMTP.Charset:='Windows-1251';
API_SMTP.Authorization:= atAuthLogin;
API_SMTP.XMailer:='API Example';
API_SMTP.SendTo:='myfriend@mail.ru';
API_SMTP.ContentType:= ctTextPlain;
API_SMTP.MessageBody.Add('Привет');
API_SMTP.MessageBody.Add('Проверяю работу компонента');

// Отправим письмо
API_SMTP.SendMail(true);
API_SMTP.Free;
end.

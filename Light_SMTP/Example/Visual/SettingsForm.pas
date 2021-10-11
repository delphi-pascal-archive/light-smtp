unit SettingsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,IniFiles;

type
  TSettings = class(TForm)
    GroupBox1: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    _smtpserver: TEdit;
    _smtpport: TEdit;
    _login: TEdit;
    _pass: TEdit;
    Button1: TButton;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Settings: TSettings;

implementation

{$R *.dfm}

procedure TSettings.Button1Click(Sender: TObject);
begin
Close;
end;

procedure TSettings.FormCreate(Sender: TObject);
var Ini: TIniFile;
begin
Ini:=TIniFile.Create(ExtractFilePath(paramStr(0))+'Settings.ini');
_smtpserver.Text:=Ini.ReadString('Settings','SMTP Server','');
_smtpport.Text:=Ini.ReadString('Settings','SMTP Port','');
_login.Text:=Ini.ReadString('Settings','Login','');
_pass.Text:=Ini.ReadString('Settings','Password','');
Ini.Free;
end;

procedure TSettings.FormDestroy(Sender: TObject);
var Ini: TIniFile;
begin
Ini:=TIniFile.Create(ExtractFilePath(paramStr(0))+'Settings.ini');
Ini.WriteString('Settings','SMTP Server',Settings._smtpserver.Text);
Ini.WriteString('Settings','SMTP Port',Settings._smtpport.Text);
Ini.WriteString('Settings','Login',Settings._login.Text);
Ini.WriteString('Settings','Password',Settings._pass.Text);
Ini.Free;
end;

end.

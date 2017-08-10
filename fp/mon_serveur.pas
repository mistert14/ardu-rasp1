unit mon_serveur;

{$mode objfpc}{$H+}

interface

uses
  cthreads,
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  synaser,fphttpapp, fpwebfile, fphttpserver;

type

  { TForm1 }

  THTTPServerThread = Class(TThread)
  Private
    FServer : TFPHTTPServer;
  Public
    Constructor Create(APort : Word;
    Const OnRequest : THTTPServerRequestHandler);
    Procedure Execute; override;
    Procedure DoTerminate; override;
    Property Server : TFPHTTPServer Read FServer;
end;

  TForm1 = class(TForm)
    BStart: TButton;
    BStop: TButton;
    MLog: TMemo;

    procedure BStartClick(Sender: TObject);
    procedure BStopClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
     FRep:char;
     FValue:string;
     FUrl:string;
     FHandler:TFPCustomFileModule;
     procedure Split(Delimiter: Char; Str: string) ;
     procedure patch_template;

  public
    FListOfStrings:TstringList;
    Fser:TBlockSerial;
    FServer:THTTPServerThread;
    procedure DoHandleRequest(Sender: TObject;var ARequest: TFPHTTPConnectionRequest;var AResponse: TFPHTTPConnectionResponse);
     procedure ShowURL;
  end;
const MX=1000;
var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure Tform1.Split(Delimiter: Char; Str: string) ;
  begin
   FListOfStrings.Clear;
   FListOfStrings.Delimiter       := Delimiter;
   FListOfStrings.StrictDelimiter := True; // Requires D2006 or newer.
   FListOfStrings.DelimitedText   := Str;
end;
procedure THTTPServerThread.DoTerminate;
begin
inherited DoTerminate;
FServer.Active:=False;
end;

constructor THTTPServerThread.Create(APort: Word;
const OnRequest: THTTPServerRequestHandler);
begin
FServer:=TFPHTTPServer.Create(Nil);
FServer.Port:=APort;
FServer.OnRequest:=OnRequest;
Inherited Create(False);
end;

procedure THTTPServerThread.Execute;
begin
try
FServer.Active:=True;
Finally
FreeAndNil(FServer);
end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  RegisterFileLocation('files','/home/mistert/public_html');
  MimeTypesFile:='/etc/mime.types';
  FHandler:=TFPCustomFileModule.CreateNew(Self);
  FHandler.BaseURL:='files/';
  FListOfStrings:=TstringList.create;
  Fser:=Tblockserial.create;
  Fser.LinuxLock:=false;
  if not Fser.InstanceActive then Fser.connect('/dev/ttyACM0');
  Fser.config(115200,8,'N',SB1,False,False);
  Fser.purge();
  sleep(300);


end;

procedure TForm1.ShowURL;
begin
MLog.Lines.Add('Requete : '+FURL);
MLog.Lines.Add('Reponse : '+FRep);
end;
procedure Tform1.patch_template;
var f,f2:Textfile;
    s:string;
begin
  AssignFile(f,'/home/mistert/public_html/files/result.html.template');
  AssignFile(f2,'/var/www/html/result.html');
  reset(f);
  rewrite(f2);
  while not eof(f) do
  begin
    readln(f,s);
    if pos('%1',s)>0 then begin
       s  := StringReplace(s, '%1', FRep, [rfReplaceAll, rfIgnoreCase]);
    end;
    if pos('%2',s)>0 then begin
       s  := StringReplace(s, '%2', FValue, [rfReplaceAll, rfIgnoreCase]);
    end;
    writeln(f2,s);
    end;

  closefile(f);
  closefile(f2);
end;

procedure TForm1.DoHandleRequest(Sender: TObject;
var ARequest: TFPHTTPConnectionRequest;
var AResponse: TFPHTTPConnectionResponse);

var s:string;
begin
FURL:=Arequest.URL;
if pos('?',FURL) >0 then begin
   Split('?',FURL);
   FRep:=FListOfStrings[1][1];
   Fser.SendByte(ord(FRep));
   If Fser.CanRead(MX) then begin
     s:=Fser.RecvString(MX);
     Fvalue:=s;

     //remplacer %1 %2 dans fichier template
     patch_template;
     MLog.lines.add(s);
  end;

end;

FServer.Synchronize(@ShowURL);
FHandler.HandleRequest(ARequest,AResponse);
end;

procedure TForm1.BStartClick(Sender: TObject);
var s:string;
begin
If Fser.CanRead(MX) then begin
     s:=Fser.RecvString(MX);
     MLog.lines.add(s);
  end;
MLog.Lines.Add('Starting server');
FServer:=THTTPServerThread.Create(8080,@DoHandleRequest);
end;

procedure TForm1.BStopClick(Sender: TObject);
begin
  MLog.Lines.Add('Stopping server');
  FServer.Terminate;
end;


end.


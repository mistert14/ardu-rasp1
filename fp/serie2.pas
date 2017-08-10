(*$r+*)

program serial;
uses dos,synaser,sysutils;


const MX=1000;
var 
  l:Text;
  ser:TBlockserial;
  s:AnsiString;
  i,TimeOuts:integer;

begin


TimeOuts:=0;
if ser=nil then 
begin
  ser:=TBlockserial.create;
  ser.LinuxLock:=false;



if not ser.InstanceActive then ser.connect('/dev/ttyACM0');
sleep(500);
ser.config(strtoint(paramstr(1)),8,'N',SB1,False,False);
ser.purge();
sleep(300);
//ser.flush();

for i:=1 to 5 do begin

if ser.canRead(MX) then begin 
   s:=ser.RecvString(MX);
   writeln(s);
end;


ser.sendString(#13#10+'RTSTA:0'+#13#10);
sleep(1);

if ser.canRead(MX) then begin 
  s:=ser.RecvString(MX);
  writeln(s);

 if ser.LastError=ErrTimeOut then begin
   Inc(TimeOuts);
   Writeln('Erreur time-out:', TimeOuts);
 end;



end;
end;


end;

end.

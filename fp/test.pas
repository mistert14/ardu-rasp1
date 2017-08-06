(*$r+*)

program test;
uses Classes,dos,synaser,sysutils,fptimer;


const MX=1000;
var 
  l:Text;
  ser:TBlockserial;
  s:AnsiString;
  i,TimeOuts:integer;

begin

Assign(l,'');
Rewrite(l);



TimeOuts:=0;
if ser=nil then 
begin
  ser:=TBlockserial.create;
  ser.LinuxLock:=false;



if not ser.InstanceActive then ser.connect('/dev/ttyACM0');
sleep(500);
ser.config(115200,8,'N',SB1,False,False);
ser.purge();
sleep(300);
//ser.flush();

for i:=0 to 4 do 
if ser.canRead(MX) then begin 
  s:=ser.RecvString(MX);
  if pos('nan',s) = 0 then writeln(l,s);

 if ser.LastError=ErrTimeOut then begin
   Inc(TimeOuts);
   Writeln(l,'Erreur time-out:', TimeOuts);
 end;


end;


end;

close(l);
end.

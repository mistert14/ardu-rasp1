(*$r+*)

program serial;
uses dos,synaser,sysutils;


const MX=1000;
var 
  l:Text;
  ser:TBlockserial;
  s:AnsiString;
  i,TimeOuts:integer;

function test(c:char;ser:Tblockserial):string;
var s:string;
begin
ser.sendByte(ord(c));
sleep(1);

if ser.canRead(MX) then begin 
  s:=ser.RecvString(MX);
  test:=s;
end else test:='Time out';


end;


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
ser.flush();

//msg accueil
if ser.canRead(MX) then begin 
   s:=ser.RecvString(MX);
   //writeln(l,s);
end;


//test CAR
s:= test(paramstr(1)[1],ser);

if pos('nan',s)=0 then 
   writeln(l,s) 
else
  begin
    repeat
      s:= test(paramstr(1)[1],ser);
    until(pos('nan',S)=0);
   writeln(l,s);

end;


 if ser.LastError=ErrTimeOut then begin
   Inc(TimeOuts);
   Writeln(l,'Erreur time-out:', TimeOuts);
 end;


end;


close(l);
end.

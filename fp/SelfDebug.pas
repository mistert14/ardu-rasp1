unit SelfDebug;
{$mode objfpc}{H+}
interface

  uses Classes, Sysutils, Process;

implementation

  Const
    DEBUGGER='gdb';
    DISPLAY=':0.0';
    MSWAIT=2000;

  Var
    AProcess: TProcess;

Initialization

  AProcess:=TProcess.create(nil);
  AProcess.CommandLine:=format('term -display %s -T "Debugging %s" -e "%s" "%s" %d', [DISPLAY,paramstr(0),DEBUGGER,paramstr(0),GetProcessID]);
  AProcess.execute;
  sleep(MSWAIT);

Finalization

  AProcess.free;

end.

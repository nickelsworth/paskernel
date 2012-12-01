Unit {$IFNDEF VER1_0}System{$ELSE}syslinux{$ENDIF};
Interface
{$DEFINE i386}
{$I systemh.inc}
{$I heaph.inc}
Var
  argc  : longint;
  argv  : ppchar;
  envp  : ppchar;

Procedure Disable;
Procedure Enable;
Function get_cs:Word;
Function get_ss:Word;
Function get_ds:Word;
Procedure outportb(port : word;data : byte);
Procedure outportw(port : word;data : word);
Procedure outportl(port : word;data : longint);
Function inportb(port : word) : byte;
Function inportw(port : word) : word;
Function inportl(port : word) : longint;

Implementation

Type
  THandle = Longint;
Const
  LineEnding = {#13}#10;
  LFNSupport = True;
  DirectorySeparator = '\';
  DriveSeparator = ':';
  PathSeparator = ';';

  UnusedHandle    = -1;
  StdInputHandle  = 0;
  StdOutputHandle = 1;
  StdErrorHandle  = 2;

  sLineBreak = LineEnding;

Var
  LameHeap : Array[0..256*1024-1] Of Byte;

{$I system.inc}

{$ASMMODE intel}
{$I sysfpcos.pp}
{$I vgaconsole.pp}
{$ASMMODE att}

Function ParamCount:LongInt;Begin ParamCount := 0;End;
Function ParamStr(l:LongInt):String;Begin ParamStr:='';End;
Procedure Randomize;Begin RandSeed:=$deadbeef;end;
Function Sbrk(size : LongInt) : Pointer;Begin Sbrk:=Nil;End;

Function GetHeapStart:Pointer;
Begin
  GetHeapStart := @LameHeap;
End;

Function GetHeapSize:LongInt;
Begin
  GetHeapSize := SizeOf(LameHeap);
End;

Procedure do_open(var f;p:pchar;flags:longint);

Begin
End;

Function do_read(h:thandle;addr:pointer;len : longint) : longint;

Begin
End;

Function do_write(h:thandle;addr:pointer;len : longint) : longint;

Var
  I : LongInt;

Begin
  If (h = StdOutputHandle) Or (h = StdErrorHandle) Then
  Begin
    For I := 1 To len Do
    Begin
      WriteTTY(PChar(addr)^);
      Inc(addr);
    End;
    Result := len;
  End
  Else
    Result := 0;
End;

Function do_filepos(handle : longint) : longint;

Begin
End;

Function do_filesize(handle : longint) : longint;

Begin
End;

Procedure do_seek(handle,pos : longint);

Begin
End;

Procedure do_truncate (handle,pos:longint);

Begin
End;

Procedure do_close(handle : longint);

Begin
End;

Procedure do_erase(p : pchar);

Begin
End;

Procedure do_rename(p1,p2 : pchar);

Begin
End;

Function do_isdevice(handle:longint):boolean;

Begin
End;

Procedure chdir(const s : string);[IOCheck];

Begin
End;

Procedure mkdir(const s : string);[IOCheck];

Begin
End;

Procedure rmdir(const s : string);[IOCheck];

Begin
End;

Procedure GetDir (DriveNr: byte; var Dir: ShortString);

Begin
End;

{$I heap.inc}
{$I file.inc}
{$I typefile.inc}
{$I text.inc}
{$IFDEF TEST_GENERIC}
{$I generic.inc}
{$ENDIF}

Procedure SysInitStdIO;

Begin
  OpenStdIO(Input,fmInput,StdInputHandle);
  OpenStdIO(Output,fmOutput,StdOutputHandle);
  OpenStdIO(StdOut,fmOutput,StdOutputHandle);
  OpenStdIO(StdErr,fmOutput,StdErrorHandle);
End;

Procedure system_exit; {magic}

Begin
  Disable;
  Writeln('core exit?');
  outportb($3C8, 0); {Paint the screen green on exit ;-) }
  outportb($3C9, 0);
  outportb($3C9, 63);
  outportb($3C9, 0);
  Repeat
  Until False;
End;

Begin
  VGAConsoleInit;
  argc := 0;
  argv := Nil;
  envp := Nil;

(*
  StackLength := InitialStkLen;
  StackBottom := Sptr - StackLength;
  { get some helpful informations }
  GetStartupInfo(@startupinfo);
  { some misc Win32 stuff }
  hprevinst:=0;
  if not IsLibrary then
    HInstance:=getmodulehandle(GetCommandFile);
  MainInstance:=HInstance;
  cmdshow:=startupinfo.wshowwindow;*)
  { Setup heap }
  InitHeap;
(*  SysInitExceptions;*)
  SysInitStdIO;
(*  { Arguments }
  setup_arguments;*)
  { Reset IO Error }
  InOutRes:=0;
(*  ProcessID := GetCurrentProcess;
  ThreadID := GetCurrentThread;
  { Reset internal error variable }
  errno:=0;*)
{$ifdef HASVARIANT}
  initvariantmanager;
{$endif HASVARIANT}
End.

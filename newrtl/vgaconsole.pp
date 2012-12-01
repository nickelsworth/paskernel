Var
  VideoBuf : PChar;
  ScreenWidth, ScreenHeight : LongInt;
  CursorPos : Word;
  CursorPosX, CursorPosY : Integer;

Procedure GetCursorPos;

Begin
  outportb($3D4, $F);
  CursorPos := inportb($3D5);
  outportb($3D4, $E);
  CursorPos := CursorPos Or (inportb($3D5) Shl 8);
  CursorPosX := CursorPos Mod ScreenWidth;
  CursorPosY := CursorPos Div ScreenWidth;
End;

Procedure SetCursorPos(X, Y : LongInt);

Begin
  CursorPosX := X;
  CursorPosY := Y;
  CursorPos := Y*ScreenWidth + X;
  outportb($3D4, $F);
  outportb($3D5, CursorPos And $FF);
  outportb($3D4, $E);
  outportb($3D5, (CursorPos Shr 8) And $FF);
End;

Procedure WriteTTY(c : Char);

Begin
  Case c Of
    #10 :
    Begin
      CursorPosX := 0;
      Inc(CursorPosY);
      If CursorPosY >= ScreenHeight Then
        CursorPosY := ScreenHeight - 1;
      SetCursorPos(CursorPosX, CursorPosY);
    End;
    Else
    Begin
      VideoBuf[CursorPos*2] := c;
      Inc(CursorPosX);
      If CursorPosX >= ScreenWidth Then
      Begin
        CursorPosX := 0;
        Inc(CursorPosY);
        If CursorPosY >= ScreenHeight Then
          CursorPosY := ScreenHeight - 1;
      End;
      SetCursorPos(CursorPosX, CursorPosY);
    End;
  End;
End;

{Procedure WriteString(Const s : String);

Var
  I : Integer;

Begin
  For I := 1 To Length(s) Do
    WriteTTY(s[I]);
End;}

Procedure VGAConsoleInit;

Begin
  Pointer(VideoBuf) := Pointer($B8000);
  ScreenWidth := 80;
  ScreenHeight := 25;
  GetCursorPos;
End;

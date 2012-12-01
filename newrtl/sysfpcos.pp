Procedure Disable;Assembler;Asm cli End;
Procedure Enable;Assembler;Asm sti End;
Function get_cs:Word;Assembler;Asm mov ax,cs End;
Function get_ss:Word;Assembler;Asm mov ax,ss End;
Function get_ds:Word;Assembler;Asm mov ax,ds End;
Procedure outportb(port : word;data : byte);
      begin
         asm
            mov dx,port
            mov al,data
            out dx,al
         end ['EAX','EDX'];
      end;
Procedure outportw(port : word;data : word);
      begin
         asm
            mov dx,port
            mov ax,data
            out dx,ax
         end ['EAX','EDX'];
      end;
Procedure outportl(port : word;data : longint);
      begin
         asm
            mov dx,port
            mov eax,data
            out dx,eax
         end ['EAX','EDX'];
      end;
Function inportb(port : word) : byte;
      begin
         asm
            mov dx,port
            in al,dx
            mov RESULT,al
         end ['EAX','EDX'];
      end;
Function inportw(port : word) : word;
      begin
         asm
            mov dx,port
            in ax,dx
            mov RESULT,ax
         end ['EAX','EDX'];
      end;
Function inportl(port : word) : longint;
      begin
         asm
            mov dx,port
            in eax,dx
            mov RESULT,eax
         end ['EAX','EDX'];
      end;

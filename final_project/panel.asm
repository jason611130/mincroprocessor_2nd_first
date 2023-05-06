PrintStr macro string
    mov ah,09h
    mov dx,offset string
    int 21h
    endm

GetChar macro char
    mov ah,07h
    int 21h
    mov char,al
    endm

GetChar06h macro char
    mov ah,06h
	mov dl,0ffh
    int 21h
    mov char,al
    endm

SetMode macro mode
    mov ah,0h
    mov al,mode
    int 10h
    endm

SetColor macro color
    mov ah,0bh
    mov bh,0h
    mov bl,color
    int 10h
    endm

WrPixel macro row,col,color
    mov ah,0ch
    mov bh,0h
    mov al,color
    mov cx,col
    mov dx,row
    int 10h
    endm

Read_Time macro 
mov ah,2ch
int 21h
endm

SET_CUR	macro row1,col1
	mov dh,row1
	mov dl,col1
	mov bx,0000h
	mov ah,02h
	int 10h
	endm

music   macro sound,during
Local L1,ispos
        mov al,0B6h
        out 43h,al
		mov bx,offset sounds
		mov si,sound
		shl si,1
		mov ax,[bx+si]
		;mov ax,4063
		out 42h,al      
		mov al,ah
		out 42h,al
		in  al,61h      
		or  al,3
		out 61h,al
		mov ah,0    
		
        mov ah,2ch			;readtime
		int 21h				;readtime
        mov BeforeTime,dl	;readtime
		endm

MusicEnd macro
	in 	al,61H 
	and al,0FCH 
	out 61H,al
	endm

delayTime macro num1
Local L1,ispos
Read_Time
mov BeforeTime,dl
L1:
	Read_Time
		mov al,dl			
		mov ah,BeforeTime	
		sub al,ah			
		cmp al,99
		jb ispos
		add al,100
		ispos:
		cmp	al,num1
        jbe L1; time dela
		endm

.8086											
.model large
.stack 1024
.data

Skill_Level	db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 07fh, 001h, 0fbh, 0e0h, 0fch, 001h, 0fch, 001h, 0fch, 000h, 000h, 001h, 0fch, 001h, 0ffh, 081h, 0f9h, 0f1h, 0ffh, 081h, 0fch, 000h
			db 077h, 000h, 071h, 080h, 070h, 000h, 070h, 000h, 070h, 000h, 000h, 000h, 070h, 000h, 071h, 080h, 070h, 0e0h, 071h, 080h, 070h, 000h
			db 0e3h, 000h, 073h, 000h, 070h, 000h, 070h, 000h, 070h, 000h, 000h, 000h, 070h, 000h, 070h, 000h, 070h, 0c0h, 070h, 000h, 070h, 000h
			db 0f0h, 000h, 076h, 000h, 070h, 000h, 070h, 000h, 070h, 000h, 000h, 000h, 070h, 000h, 073h, 000h, 038h, 0c0h, 073h, 000h, 070h, 000h
			db 078h, 000h, 07ch, 000h, 070h, 000h, 070h, 000h, 070h, 000h, 000h, 000h, 070h, 000h, 073h, 000h, 038h, 0c0h, 073h, 000h, 070h, 000h
			db 03eh, 000h, 07ch, 000h, 070h, 000h, 070h, 000h, 070h, 000h, 000h, 000h, 070h, 000h, 07fh, 000h, 01dh, 080h, 07fh, 000h, 070h, 000h
			db 00fh, 000h, 07eh, 000h, 070h, 000h, 070h, 000h, 070h, 000h, 000h, 000h, 070h, 000h, 073h, 000h, 01dh, 080h, 073h, 000h, 070h, 000h
			db 0c7h, 080h, 07fh, 000h, 070h, 000h, 070h, 000h, 070h, 000h, 000h, 000h, 070h, 000h, 073h, 000h, 01fh, 080h, 073h, 000h, 070h, 000h
			db 0e3h, 080h, 073h, 080h, 070h, 000h, 070h, 0c0h, 070h, 0c0h, 000h, 000h, 070h, 0c0h, 070h, 0c0h, 00fh, 000h, 070h, 0c0h, 070h, 0c0h
			db 0f7h, 000h, 071h, 0e0h, 070h, 000h, 071h, 080h, 071h, 080h, 000h, 000h, 071h, 080h, 071h, 0c0h, 00fh, 000h, 071h, 0c0h, 071h, 080h
			db 0feh, 001h, 0fbh, 0f0h, 0fch, 001h, 0ffh, 081h, 0ffh, 080h, 000h, 001h, 0ffh, 081h, 0ffh, 080h, 006h, 001h, 0ffh, 081h, 0ffh, 080h
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			
num1		db 000h, 000h
			db 03ch, 000h
			db 07ch, 000h
			db 01ch, 000h
			db 01ch, 000h
			db 01ch, 000h
			db 01ch, 000h
			db 01ch, 000h
			db 01ch, 000h
			db 01ch, 000h
			db 01ch, 000h
			db 07eh, 000h
			db 000h, 000h
			db 000h, 000h
			db 000h, 000h
			db 000h, 000h

num2		db 000h, 000h
			db 07ch, 000h
			db 0eeh, 000h
			db 0ceh, 000h
			db 006h, 000h
			db 00eh, 000h
			db 00eh, 000h
			db 00ch, 000h
			db 018h, 000h
			db 030h, 000h
			db 063h, 000h
			db 0ffh, 000h
			db 000h, 000h
			db 000h, 000h
			db 000h, 000h
			db 000h, 000h

num3		db 000h, 000h
			db 07ch, 000h
			db 0eeh, 000h
			db 0ceh, 000h
			db 00ch, 000h
			db 01ch, 000h
			db 03eh, 000h
			db 00eh, 000h
			db 00eh, 000h
			db 006h, 000h
			db 00eh, 000h
			db 0fch, 000h
			db 000h, 000h
			db 000h, 000h
			db 000h, 000h
			db 000h, 000h
			
ourname		db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 00eh, 070h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 00eh, 007h, 000h, 030h, 070h
			db 00eh, 070h, 03fh, 0fch, 03fh, 0fch, 000h, 000h, 07fh, 0ffh, 003h, 0c0h, 03bh, 0f0h
			db 07fh, 0feh, 000h, 038h, 039h, 08ch, 000h, 000h, 00eh, 070h, 001h, 080h, 00fh, 0f0h
			db 00eh, 070h, 000h, 070h, 03fh, 0fch, 000h, 000h, 01ch, 0ech, 0ffh, 0ffh, 003h, 0feh
			db 00fh, 0f0h, 001h, 0c0h, 039h, 08ch, 000h, 000h, 019h, 0deh, 000h, 030h, 0e7h, 070h
			db 000h, 000h, 001h, 080h, 03bh, 0ech, 000h, 000h, 01bh, 0f8h, 01ch, 070h, 07eh, 070h
			db 0ffh, 0ffh, 0ffh, 0ffh, 03fh, 07ch, 000h, 000h, 01eh, 07ch, 00ch, 060h, 01fh, 0ffh
			db 001h, 080h, 001h, 080h, 03ch, 03ch, 000h, 000h, 01ch, 0eeh, 00eh, 0e0h, 000h, 000h
			db 03fh, 0fch, 001h, 080h, 03fh, 0fch, 000h, 000h, 0fbh, 0ffh, 007h, 0c0h, 00fh, 0feh
			db 039h, 09ch, 001h, 080h, 00fh, 080h, 000h, 000h, 05bh, 077h, 003h, 0c0h, 01fh, 08eh
			db 03fh, 0fch, 001h, 080h, 03fh, 0dch, 000h, 000h, 019h, 0fch, 003h, 0c0h, 01bh, 08eh
			db 039h, 09ch, 001h, 080h, 07eh, 0feh, 000h, 000h, 01bh, 0feh, 007h, 0f0h, 03bh, 08eh
			db 03fh, 0fch, 001h, 080h, 06eh, 03fh, 000h, 000h, 01fh, 077h, 01ch, 03ch, 073h, 0feh
			db 078h, 00eh, 007h, 080h, 0efh, 0f2h, 000h, 000h, 078h, 0f0h, 0f0h, 00fh, 0e3h, 08eh
			db 060h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h

F1			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 001h, 0f0h, 000h, 000h, 000h, 000h, 000h
			db 0ffh, 0ffh, 0ffh, 0ffh, 080h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 007h, 0f0h, 000h, 000h, 000h, 000h, 000h
			db 0ffh, 0ffh, 0ffh, 0ffh, 080h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 01fh, 0f0h, 000h, 000h, 000h, 000h, 000h
			db 007h, 0ffh, 0ffh, 0ffh, 080h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 07fh, 0f0h, 000h, 000h, 000h, 000h, 000h
			db 003h, 0fch, 000h, 01fh, 080h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 001h, 0ffh, 0f0h, 000h, 000h, 000h, 000h, 000h
			db 003h, 0fch, 000h, 00fh, 0c0h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 001h, 0ffh, 0f0h, 000h, 000h, 000h, 000h, 000h
			db 003h, 0fch, 000h, 007h, 0c0h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 00fh, 0f0h, 000h, 000h, 000h, 000h, 000h
			db 003h, 0fch, 000h, 003h, 0c0h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 007h, 0f0h, 000h, 000h, 000h, 000h, 000h
			db 003h, 0fch, 000h, 003h, 0c0h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 007h, 0f0h, 000h, 000h, 000h, 000h, 000h
			db 003h, 0fch, 000h, 001h, 0c0h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 007h, 0f0h, 000h, 000h, 000h, 000h, 000h
			db 003h, 0fch, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 007h, 0f0h, 000h, 000h, 000h, 000h, 000h
			db 003h, 0fch, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 007h, 0f0h, 000h, 000h, 000h, 000h, 000h
			db 003h, 0fch, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 007h, 0f0h, 000h, 000h, 000h, 000h, 000h
			db 003h, 0fch, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 007h, 0f0h, 000h, 000h, 000h, 000h, 000h
			db 003h, 0fch, 000h, 070h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 007h, 0f0h, 000h, 000h, 000h, 000h, 000h
			db 003h, 0fch, 000h, 070h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 007h, 0f0h, 000h, 000h, 000h, 000h, 000h
			db 003h, 0fch, 000h, 070h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 007h, 0f0h, 000h, 000h, 000h, 000h, 000h
			db 003h, 0fch, 000h, 070h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 007h, 0f0h, 000h, 000h, 000h, 000h, 000h
			db 003h, 0fch, 000h, 0f0h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 007h, 0f0h, 000h, 000h, 000h, 000h, 000h
			db 003h, 0fch, 007h, 0f0h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 007h, 0f0h, 000h, 000h, 000h, 000h, 000h
			db 003h, 0ffh, 0ffh, 0f0h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 007h, 0f0h, 000h, 000h, 000h, 000h, 000h
			db 003h, 0ffh, 0ffh, 0f0h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 007h, 0f0h, 000h, 000h, 000h, 000h, 000h
			db 003h, 0ffh, 0ffh, 0f0h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 007h, 0f0h, 000h, 000h, 000h, 000h, 000h
			db 003h, 0fch, 001h, 0f0h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 007h, 0f0h, 000h, 000h, 000h, 000h, 000h
			db 003h, 0fch, 000h, 0f0h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 007h, 0f0h, 000h, 000h, 000h, 000h, 000h
			db 003h, 0fch, 000h, 070h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 007h, 0f0h, 000h, 000h, 000h, 000h, 000h
			db 003h, 0fch, 000h, 070h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 007h, 0f0h, 000h, 000h, 000h, 000h, 000h
			db 003h, 0fch, 000h, 070h, 000h, 000h, 000h, 000h, 03fh, 0ffh, 0f0h, 000h, 000h, 000h, 000h, 000h, 000h, 007h, 0f0h, 000h, 000h, 000h, 000h, 000h
			db 003h, 0fch, 000h, 030h, 000h, 000h, 000h, 000h, 03fh, 0ffh, 0f0h, 000h, 000h, 000h, 000h, 000h, 000h, 007h, 0f0h, 000h, 000h, 000h, 000h, 000h
			db 003h, 0fch, 000h, 000h, 000h, 000h, 000h, 000h, 03fh, 0ffh, 0f0h, 000h, 000h, 000h, 000h, 000h, 000h, 007h, 0f0h, 000h, 000h, 000h, 000h, 000h
			db 003h, 0fch, 000h, 000h, 000h, 000h, 000h, 000h, 03fh, 0ffh, 0f0h, 000h, 000h, 000h, 000h, 000h, 000h, 007h, 0f0h, 000h, 000h, 000h, 000h, 000h
			db 003h, 0fch, 000h, 000h, 000h, 000h, 000h, 000h, 03fh, 0ffh, 0f0h, 000h, 000h, 000h, 000h, 000h, 000h, 007h, 0f0h, 000h, 000h, 000h, 000h, 000h
			db 003h, 0fch, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 007h, 0f0h, 000h, 000h, 000h, 000h, 000h
			db 003h, 0fch, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 007h, 0f0h, 000h, 000h, 000h, 000h, 000h
			db 003h, 0fch, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 007h, 0f0h, 000h, 000h, 000h, 000h, 000h
			db 003h, 0fch, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 007h, 0f0h, 000h, 000h, 000h, 000h, 000h
			db 003h, 0fch, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 007h, 0f0h, 000h, 000h, 000h, 000h, 000h
			db 003h, 0fch, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 007h, 0f0h, 000h, 000h, 000h, 000h, 000h
			db 003h, 0fch, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 007h, 0f0h, 000h, 000h, 000h, 000h, 000h
			db 003h, 0fch, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 007h, 0f0h, 000h, 000h, 000h, 000h, 000h
			db 003h, 0fch, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 007h, 0f0h, 000h, 000h, 000h, 000h, 000h
			db 007h, 0feh, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 00fh, 0f8h, 000h, 000h, 000h, 000h, 000h
			db 0ffh, 0ffh, 0f0h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 001h, 0ffh, 0ffh, 080h, 000h, 000h, 000h, 000h
			db 0ffh, 0ffh, 0f0h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 001h, 0ffh, 0ffh, 080h, 000h, 000h, 000h, 000h
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			
rightback	db 0ffh, 0ffh, 0ffh, 0feh, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f0h, 000h, 000h, 000h, 00fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 07fh, 0ffh, 0ffh, 0ffh
			db 0ffh, 0ffh, 0ffh, 0feh, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 00fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 07fh, 0ffh, 0ffh, 0ffh
			db 0ffh, 0ffh, 0ffh, 0feh, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 00fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 07fh, 0ffh, 0ffh, 0ffh
			db 0ffh, 0ffh, 0ffh, 0feh, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 00fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 07fh, 0ffh, 0ffh, 0ffh
			db 0ffh, 0ffh, 0ffh, 0feh, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 00fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 07fh, 0ffh, 0ffh, 0ffh
			db 0ffh, 0ffh, 0ffh, 0feh, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 00fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 07fh, 0ffh, 0ffh, 0ffh
			db 0ffh, 0ffh, 0ffh, 0feh, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 00fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 07fh, 0ffh, 0ffh, 0ffh
			db 0ffh, 0ffh, 0ffh, 0feh, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 00fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 07fh, 0ffh, 0ffh, 0ffh
			db 0ffh, 0ffh, 0ffh, 0feh, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 00fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 07fh, 0ffh, 0ffh, 0ffh
			db 0ffh, 0ffh, 0ffh, 0feh, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 00fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 07fh, 0ffh, 0ffh, 0ffh
			db 0ffh, 0ffh, 0ffh, 0feh, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 00fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 07fh, 0ffh, 0ffh, 0ffh
			db 0ffh, 0ffh, 0ffh, 0feh, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 00fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 07fh, 0ffh, 0ffh, 0ffh
			db 0ffh, 0ffh, 0ffh, 0feh, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 00fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 07fh, 0ffh, 0ffh, 0ffh
			db 000h, 000h, 000h, 001h, 0ffh, 0ffh, 0ffh, 0fch, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0f0h, 000h, 000h, 000h, 03fh, 0ffh, 0ffh, 0ffh, 080h, 000h, 000h, 000h
			db 000h, 000h, 000h, 001h, 0ffh, 0ffh, 0ffh, 0fch, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0f0h, 000h, 000h, 000h, 03fh, 0ffh, 0ffh, 0ffh, 080h, 000h, 000h, 000h
			db 000h, 000h, 000h, 001h, 0ffh, 0ffh, 0ffh, 0fch, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0f0h, 000h, 000h, 000h, 03fh, 0ffh, 0ffh, 0ffh, 080h, 000h, 000h, 000h
			db 000h, 000h, 000h, 001h, 0ffh, 0ffh, 0ffh, 0fch, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0f0h, 000h, 000h, 000h, 03fh, 0ffh, 0ffh, 0ffh, 080h, 000h, 000h, 000h
			db 000h, 000h, 000h, 001h, 0ffh, 0ffh, 0ffh, 0fch, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0f0h, 000h, 000h, 000h, 03fh, 0ffh, 0ffh, 0ffh, 080h, 000h, 000h, 000h
			db 000h, 000h, 000h, 001h, 0ffh, 0ffh, 0ffh, 0fch, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0f0h, 000h, 000h, 000h, 03fh, 0ffh, 0ffh, 0ffh, 080h, 000h, 000h, 000h
			db 000h, 000h, 000h, 001h, 0ffh, 0ffh, 0ffh, 0fch, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0f0h, 000h, 000h, 000h, 03fh, 0ffh, 0ffh, 0ffh, 080h, 000h, 000h, 000h
			db 000h, 000h, 000h, 001h, 0ffh, 0ffh, 0ffh, 0fch, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0f0h, 000h, 000h, 000h, 03fh, 0ffh, 0ffh, 0ffh, 080h, 000h, 000h, 000h
			db 000h, 000h, 000h, 001h, 0ffh, 0ffh, 0ffh, 0fch, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0f0h, 000h, 000h, 000h, 03fh, 0ffh, 0ffh, 0ffh, 080h, 000h, 000h, 000h
			db 000h, 000h, 000h, 001h, 0ffh, 0ffh, 0ffh, 0fch, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0f0h, 000h, 000h, 000h, 03fh, 0ffh, 0ffh, 0ffh, 080h, 000h, 000h, 000h
			db 000h, 000h, 000h, 001h, 0ffh, 0ffh, 0ffh, 0fch, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0f0h, 000h, 000h, 000h, 03fh, 0ffh, 0ffh, 0ffh, 080h, 000h, 000h, 000h
			db 000h, 000h, 000h, 001h, 0ffh, 0ffh, 0ffh, 0fch, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0f0h, 000h, 000h, 000h, 03fh, 0ffh, 0ffh, 0ffh, 080h, 000h, 000h, 000h
			db 000h, 000h, 000h, 001h, 0ffh, 0ffh, 0ffh, 0fch, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0f0h, 000h, 000h, 000h, 03fh, 0ffh, 0ffh, 0ffh, 080h, 000h, 000h, 000h
			db 0ffh, 0ffh, 0ffh, 0feh, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 00fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 0ffh, 0ffh, 0ffh, 0feh, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 00fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 0ffh, 0ffh, 0ffh, 0feh, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 00fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 0ffh, 0ffh, 0ffh, 0feh, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 00fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 0ffh, 0ffh, 0ffh, 0feh, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 00fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 0ffh, 0ffh, 0ffh, 0feh, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 00fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 0ffh, 0ffh, 0ffh, 0feh, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 00fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 0ffh, 0ffh, 0ffh, 0feh, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 00fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 0ffh, 0ffh, 0ffh, 0feh, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 00fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 0ffh, 0ffh, 0ffh, 0feh, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 00fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 0ffh, 0ffh, 0ffh, 0feh, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 00fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 0ffh, 0ffh, 0ffh, 0feh, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 00fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 000h, 000h, 000h, 001h, 0ffh, 0ffh, 0ffh, 0fch, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0f0h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 000h, 000h, 000h, 001h, 0ffh, 0ffh, 0ffh, 0fch, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0f0h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 000h, 000h, 000h, 001h, 0ffh, 0ffh, 0ffh, 0fch, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0f0h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 000h, 000h, 000h, 001h, 0ffh, 0ffh, 0ffh, 0fch, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0f0h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 000h, 000h, 000h, 001h, 0ffh, 0ffh, 0ffh, 0fch, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0f0h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 000h, 000h, 000h, 001h, 0ffh, 0ffh, 0ffh, 0fch, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0f0h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 000h, 000h, 000h, 001h, 0ffh, 0ffh, 0ffh, 0fch, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0f0h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 000h, 000h, 000h, 001h, 0ffh, 0ffh, 0ffh, 0fch, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0f0h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 000h, 000h, 000h, 001h, 0ffh, 0ffh, 0ffh, 0fch, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0f0h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 000h, 000h, 000h, 001h, 0ffh, 0ffh, 0ffh, 0fch, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0f0h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 000h, 000h, 000h, 001h, 0ffh, 0ffh, 0ffh, 0fch, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0f0h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 000h, 000h, 000h, 001h, 0ffh, 0ffh, 0ffh, 0fch, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0f0h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 000h, 000h, 000h, 001h, 0ffh, 0ffh, 0ffh, 0fch, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0f0h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 07fh, 0ffh, 0ffh, 0feh, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 0ffh, 0ffh, 0ffh, 0feh, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 0ffh, 0ffh, 0ffh, 0feh, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 0ffh, 0ffh, 0ffh, 0feh, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 0ffh, 0ffh, 0ffh, 0feh, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 0ffh, 0ffh, 0ffh, 0feh, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 0ffh, 0ffh, 0ffh, 0feh, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 0ffh, 0ffh, 0ffh, 0feh, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 0ffh, 0ffh, 0ffh, 0feh, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 0ffh, 0ffh, 0ffh, 0feh, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 0ffh, 0ffh, 0ffh, 0feh, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 0ffh, 0ffh, 0ffh, 0feh, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 07fh, 0ffh, 0ffh, 0feh, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			
leftback    db 0ffh, 0ffh, 0ffh, 0feh, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 01fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 07fh, 0ffh, 0ffh, 0ffh
			db 0ffh, 0ffh, 0ffh, 0feh, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 01fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 07fh, 0ffh, 0ffh, 0ffh
			db 0ffh, 0ffh, 0ffh, 0feh, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 01fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 07fh, 0ffh, 0ffh, 0ffh
			db 0ffh, 0ffh, 0ffh, 0feh, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 01fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 07fh, 0ffh, 0ffh, 0ffh
			db 0ffh, 0ffh, 0ffh, 0feh, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 01fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 07fh, 0ffh, 0ffh, 0ffh
			db 0ffh, 0ffh, 0ffh, 0feh, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 01fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 07fh, 0ffh, 0ffh, 0ffh
			db 0ffh, 0ffh, 0ffh, 0feh, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 01fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 07fh, 0ffh, 0ffh, 0ffh
			db 0ffh, 0ffh, 0ffh, 0feh, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 01fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 07fh, 0ffh, 0ffh, 0ffh
			db 0ffh, 0ffh, 0ffh, 0feh, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 01fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 07fh, 0ffh, 0ffh, 0ffh
			db 0ffh, 0ffh, 0ffh, 0feh, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 01fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 07fh, 0ffh, 0ffh, 0ffh
			db 0ffh, 0ffh, 0ffh, 0feh, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 01fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 07fh, 0ffh, 0ffh, 0ffh
			db 0ffh, 0ffh, 0ffh, 0feh, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 01fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 07fh, 0ffh, 0ffh, 0ffh
			db 0ffh, 0ffh, 0ffh, 0feh, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 01fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 07fh, 0ffh, 0ffh, 0ffh
			db 000h, 000h, 000h, 001h, 0ffh, 0ffh, 0ffh, 0fch, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0e0h, 000h, 000h, 000h, 03fh, 0ffh, 0ffh, 0ffh, 080h, 000h, 000h, 000h
			db 000h, 000h, 000h, 001h, 0ffh, 0ffh, 0ffh, 0fch, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0e0h, 000h, 000h, 000h, 03fh, 0ffh, 0ffh, 0ffh, 080h, 000h, 000h, 000h
			db 000h, 000h, 000h, 001h, 0ffh, 0ffh, 0ffh, 0fch, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0e0h, 000h, 000h, 000h, 03fh, 0ffh, 0ffh, 0ffh, 080h, 000h, 000h, 000h
			db 000h, 000h, 000h, 001h, 0ffh, 0ffh, 0ffh, 0fch, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0e0h, 000h, 000h, 000h, 03fh, 0ffh, 0ffh, 0ffh, 080h, 000h, 000h, 000h
			db 000h, 000h, 000h, 001h, 0ffh, 0ffh, 0ffh, 0fch, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0e0h, 000h, 000h, 000h, 03fh, 0ffh, 0ffh, 0ffh, 080h, 000h, 000h, 000h
			db 000h, 000h, 000h, 001h, 0ffh, 0ffh, 0ffh, 0fch, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0e0h, 000h, 000h, 000h, 03fh, 0ffh, 0ffh, 0ffh, 080h, 000h, 000h, 000h
			db 000h, 000h, 000h, 001h, 0ffh, 0ffh, 0ffh, 0fch, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0e0h, 000h, 000h, 000h, 03fh, 0ffh, 0ffh, 0ffh, 080h, 000h, 000h, 000h
			db 000h, 000h, 000h, 001h, 0ffh, 0ffh, 0ffh, 0fch, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0e0h, 000h, 000h, 000h, 03fh, 0ffh, 0ffh, 0ffh, 080h, 000h, 000h, 000h
			db 000h, 000h, 000h, 001h, 0ffh, 0ffh, 0ffh, 0fch, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0e0h, 000h, 000h, 000h, 03fh, 0ffh, 0ffh, 0ffh, 080h, 000h, 000h, 000h
			db 000h, 000h, 000h, 001h, 0ffh, 0ffh, 0ffh, 0fch, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0e0h, 000h, 000h, 000h, 03fh, 0ffh, 0ffh, 0ffh, 080h, 000h, 000h, 000h
			db 000h, 000h, 000h, 001h, 0ffh, 0ffh, 0ffh, 0fch, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0e0h, 000h, 000h, 000h, 03fh, 0ffh, 0ffh, 0ffh, 080h, 000h, 000h, 000h
			db 000h, 000h, 000h, 001h, 0ffh, 0ffh, 0ffh, 0fch, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0e0h, 000h, 000h, 000h, 03fh, 0ffh, 0ffh, 0ffh, 080h, 000h, 000h, 000h
			db 000h, 000h, 000h, 001h, 0ffh, 0ffh, 0ffh, 0fch, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0e0h, 000h, 000h, 000h, 03fh, 0ffh, 0ffh, 0ffh, 080h, 000h, 000h, 000h
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 01fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 07fh, 0ffh, 0ffh, 0ffh
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 01fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 07fh, 0ffh, 0ffh, 0ffh
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 01fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 07fh, 0ffh, 0ffh, 0ffh
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 01fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 07fh, 0ffh, 0ffh, 0ffh
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 01fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 07fh, 0ffh, 0ffh, 0ffh
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 01fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 07fh, 0ffh, 0ffh, 0ffh
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 01fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 07fh, 0ffh, 0ffh, 0ffh
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 01fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 07fh, 0ffh, 0ffh, 0ffh
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 01fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 07fh, 0ffh, 0ffh, 0ffh
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 01fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 07fh, 0ffh, 0ffh, 0ffh
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 01fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 07fh, 0ffh, 0ffh, 0ffh
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 003h, 0ffh, 0ffh, 0ffh, 0f8h, 000h, 000h, 000h, 01fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 07fh, 0ffh, 0ffh, 0ffh
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0e0h, 000h, 000h, 000h, 03fh, 0ffh, 0ffh, 0ffh, 080h, 000h, 000h, 000h
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0e0h, 000h, 000h, 000h, 03fh, 0ffh, 0ffh, 0ffh, 080h, 000h, 000h, 000h
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0e0h, 000h, 000h, 000h, 03fh, 0ffh, 0ffh, 0ffh, 080h, 000h, 000h, 000h
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0e0h, 000h, 000h, 000h, 03fh, 0ffh, 0ffh, 0ffh, 080h, 000h, 000h, 000h
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0e0h, 000h, 000h, 000h, 03fh, 0ffh, 0ffh, 0ffh, 080h, 000h, 000h, 000h
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0e0h, 000h, 000h, 000h, 03fh, 0ffh, 0ffh, 0ffh, 080h, 000h, 000h, 000h
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0e0h, 000h, 000h, 000h, 03fh, 0ffh, 0ffh, 0ffh, 080h, 000h, 000h, 000h
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0e0h, 000h, 000h, 000h, 03fh, 0ffh, 0ffh, 0ffh, 080h, 000h, 000h, 000h
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0e0h, 000h, 000h, 000h, 03fh, 0ffh, 0ffh, 0ffh, 080h, 000h, 000h, 000h
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0e0h, 000h, 000h, 000h, 03fh, 0ffh, 0ffh, 0ffh, 080h, 000h, 000h, 000h
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0e0h, 000h, 000h, 000h, 03fh, 0ffh, 0ffh, 0ffh, 080h, 000h, 000h, 000h
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0e0h, 000h, 000h, 000h, 03fh, 0ffh, 0ffh, 0ffh, 080h, 000h, 000h, 000h
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 007h, 0ffh, 0ffh, 0ffh, 0e0h, 000h, 000h, 000h, 03fh, 0ffh, 0ffh, 0ffh, 080h, 000h, 000h, 000h
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 01fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 0ffh, 0ffh, 0ffh, 0ffh
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 01fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 0ffh, 0ffh, 0ffh, 0ffh
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 01fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 0ffh, 0ffh, 0ffh, 0ffh
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 01fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 0ffh, 0ffh, 0ffh, 0ffh
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 01fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 0ffh, 0ffh, 0ffh, 0ffh
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 01fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 0ffh, 0ffh, 0ffh, 0ffh
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 01fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 0ffh, 0ffh, 0ffh, 0ffh
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 01fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 0ffh, 0ffh, 0ffh, 0ffh
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 01fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 0ffh, 0ffh, 0ffh, 0ffh
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 01fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 0ffh, 0ffh, 0ffh, 0ffh
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 01fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 0ffh, 0ffh, 0ffh, 0ffh
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 01fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 0ffh, 0ffh, 0ffh, 0ffh
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 01fh, 0ffh, 0ffh, 0ffh, 0c0h, 000h, 000h, 000h, 0ffh, 0ffh, 0ffh, 0ffh

star 		db 000h, 000h
			db 001h, 080h
			db 001h, 0c0h
			db 003h, 0c0h
			db 07fh, 0feh
			db 03fh, 0feh
			db 03fh, 0fch
			db 01fh, 0fch
			db 01fh, 0f8h
			db 03fh, 0fch
			db 03fh, 0feh
			db 07fh, 0feh
			db 003h, 0e0h
			db 003h, 0c0h
			db 001h, 080h
			db 000h, 000h

clnstart 	db 0ffh, 0ffh
			db 0ffh, 0ffh
			db 0ffh, 0ffh
			db 0ffh, 0ffh
			db 0ffh, 0ffh
			db 0ffh, 0ffh
			db 0ffh, 0ffh
			db 0ffh, 0ffh
			db 0ffh, 0ffh
			db 0ffh, 0ffh
			db 0ffh, 0ffh
			db 0ffh, 0ffh
			db 0ffh, 0ffh
			db 0ffh, 0ffh
			db 0ffh, 0ffh
			db 0ffh, 000h

StrSCORE	db 03fh, 080h, 01fh, 080h, 01fh, 080h, 07fh, 0c0h, 07fh, 0c0h
			db 071h, 0c0h, 039h, 0e0h, 039h, 0e0h, 071h, 0c0h, 070h, 000h
			db 061h, 0c0h, 070h, 0e0h, 070h, 070h, 070h, 0e0h, 070h, 000h
			db 0e0h, 000h, 070h, 0c0h, 070h, 070h, 070h, 0e0h, 070h, 000h
			db 078h, 000h, 0e0h, 000h, 0e0h, 070h, 070h, 0e0h, 070h, 000h
			db 03fh, 000h, 0e0h, 000h, 0e0h, 070h, 071h, 0c0h, 07fh, 0c0h
			db 00fh, 0c0h, 0e0h, 000h, 0e0h, 070h, 07fh, 080h, 070h, 000h
			db 001h, 0c0h, 0e0h, 000h, 0e0h, 070h, 077h, 080h, 070h, 000h
			db 000h, 0e0h, 070h, 070h, 070h, 070h, 073h, 0c0h, 070h, 000h
			db 0e0h, 0c0h, 070h, 0e0h, 070h, 070h, 071h, 0c0h, 070h, 000h
			db 071h, 0c0h, 039h, 0e0h, 039h, 0e0h, 070h, 0e0h, 070h, 000h
			db 03fh, 080h, 01fh, 080h, 01fh, 080h, 070h, 0f0h, 07fh, 0e0h
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h

StrTIME		db 0ffh, 0c0h, 070h, 000h, 0f0h, 038h, 07fh, 0c0h
			db 01ch, 000h, 070h, 000h, 0f8h, 078h, 070h, 000h
			db 01ch, 000h, 070h, 000h, 0f8h, 0f8h, 070h, 000h
			db 01ch, 000h, 070h, 000h, 0f8h, 0f8h, 070h, 000h
			db 01ch, 000h, 070h, 000h, 0fch, 0f8h, 070h, 000h
			db 01ch, 000h, 070h, 000h, 0fdh, 0f8h, 07fh, 0c0h
			db 01ch, 000h, 070h, 000h, 0fdh, 0f8h, 070h, 000h
			db 01ch, 000h, 070h, 000h, 0efh, 0b8h, 070h, 000h
			db 01ch, 000h, 070h, 000h, 0efh, 0b8h, 070h, 000h
			db 01ch, 000h, 070h, 000h, 0efh, 0b8h, 070h, 000h
			db 01ch, 000h, 070h, 000h, 0e7h, 038h, 070h, 000h
			db 01ch, 000h, 070h, 000h, 0e7h, 038h, 07fh, 0e0h
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
			
WX				dw	0
WY				dw	0
index	 		dw 0
background_color db 00h
content 		db 0
bit 			db 0 
StartRow 		dw 0
StartCol 		dw 0
StartXW 		dw 216
StartYW 		dw 216
SizeXW 			dw 22
SizeYW 			dw 16
ColorB 			db 0Ah
Source			dw 0
nowstar			dw 240
ScorePoint  	db 4 dup(' '),'$' 
TIMES			db 4 dup(' '),'$' 
StartTime		db 0
Score			db 0
TIME 			db 0
Level 			dw 0
GameTimeIndex	db 45,40,30	
GameTime		db 0	
sounds			dw 0ffffh,4560,4063,3619,3416,3043,2711,2415,2280,2031,1809,1715,1521,1355,1207
BeforeTime      db 0

melody 			db 10,15,11,11,11,10,9,7,7,7,9,9,13,12,11,10,11
gameStartMin	db 0
gameStartSec	db 0
gameStarthSec	db 0
gameCurMin	db 0
gameCurSec	db 0
gameCurhSec	db 0
.code
.startup

Read_Time 
mov gameStartMin,cl
mov gameStartSec,dh
mov gameStarthSec,dl

SetMode 12h
SetColor background_color

;--------------------------------------------------------------------------------------------------------------
music 9,15

MusicEnd
MusicEnd

MusicEnd
mov StartXW,0
mov StartYW,0
mov SizeXW,27
mov SizeYW,64
mov ColorB,07h
lea bx,rightback
mov Source,bx
call Print_Pic 

mov StartXW,424
mov StartYW,0
mov SizeXW,27
mov SizeYW,64
mov ColorB,07h
lea bx,leftback
lea bx,leftback
mov Source,bx
call Print_Pic 

mov StartXW,240
mov StartYW,30
mov SizeXW,24
mov SizeYW,64
mov ColorB,01h
lea bx,F1
mov Source,bx
call Print_Pic 

mov StartXW,232
mov StartYW,240
mov SizeXW,22
mov SizeYW,16
mov ColorB,0eh
lea bx,Skill_Level
mov Source,bx
call Print_Pic 

mov StartYW,300
call Print_Pic 

mov StartYW,360
call Print_Pic 

mov StartXW,416
mov StartYW,240
mov SizeXW,2
mov SizeYW,16
mov ColorB,0eh
lea bx,num1
mov Source,bx
call Print_Pic 

mov StartYW,300
lea bx,num2
mov Source,bx
call Print_Pic

mov StartYW,360
lea bx,num3
mov Source,bx
call Print_Pic

mov StartXW,260
mov StartYW,400
mov SizeXW,14
mov SizeYW,16
mov ColorB,06h
lea bx,ourname
mov Source,bx
call Print_Pic 
music 4,50

; --------------------------------------------------------------------------------------------------------------	
L1:				;print star
mov StartXW,200
mov StartYW,240
mov SizeXW,2
mov SizeYW,16
mov ColorB,00h
lea bx,star
mov Source,bx
call Print_Pic

mov StartYW,300
call Print_Pic
mov StartYW,360
call Print_Pic

mov StartXW,200
mov cx,nowstar
mov StartYW,cx
mov SizeXW,2
mov SizeYW,16
mov ColorB,02h
lea bx,star
mov Source,bx
call Print_Pic

GetChar al

cmp al,'w'
je	func1
cmp al,'s'
je	func2
cmp al,20h
jne L1

jmp finish1page
func1:				;decide if star is at Y position 240 
cmp nowstar,240
je L1
mov cx,nowstar
sub cx,60
mov nowstar,cx
sub Level,1
jmp L1
func2:
cmp nowstar,360		;decide if star is at Y position 360
je L1
mov cx,nowstar
add cx,60
mov nowstar,cx
add Level,1
jmp L1
; -------------------------------------------------------------------------------------------------------------------

; -------------------------------------------------------------------------------------------------------------------
; 第二頁

finish1page:
musicend
music 5,50
MusicEnd
SetMode 12h
SetColor background_color
mov di,offset GameTimeIndex
mov bx,Level
mov al,[di+bx]
mov GameTime,al

mov StartXW,350
mov StartYW,30
mov SizeXW,8
mov SizeYW,16
mov ColorB,0fh
lea bx,StrTIME
mov Source,bx
call Print_Pic 

mov StartXW,334
mov StartYW,65
mov SizeXW,10
mov SizeYW,16
mov ColorB,0fh
lea bx,StrSCORE
mov Source,bx
call Print_Pic 

Read_Time
mov StartTime,dh
wait1:
Read_Time
mov ah,0
mov al,dh			;現在時間放al
mov ah,StartTime	;把之前時間放入ah
sub al,ah			;計數時間al
cmp al,59
jb ispos
add al,60
ispos:
mov ah,0
sub al,GameTime		;45開始倒數
neg al
mov TIME,al
mov di,offset TIMES
call tran
cmp TIME,10
jae Time_Dont_Shift_Word
mov di,offset TIMES
mov al,[di]
mov bl,' '
mov [di],bl
mov [di+1],al
Time_Dont_Shift_Word:
SET_CUR	3,49
PrintStr TIMES

Read_Time
mov ah,0
mov al,cl
mov di,offset ScorePoint
call tran
SET_CUR	5,49
PrintStr ScorePoint

GetChar06h al
cmp TIME,0
je Finish
cmp al,'q'
jne	wait1

Finish:

SetMode 03h
musicend
.exit
; -------------------------------------------------------------------------------------------------------------------
Print_Pic proc 
	mov si,0
	mov di,0

	nextbyte:
		mov bx,Source
		mov al,[bx+si]
		mov content,al
		mov bit,0
	H2B:
		
		mov ax,si
		mov bx,SizeXW
		mov dx,0
		div bx
		mov ax,dx
		mov dx,0
		mov cx,8
		mul cx
		mov bh,0
		mov bl,bit
		add bx,ax
		mov ax,StartYW
		mov cx,di
		add ax,cx
		mov StartRow,ax
		mov ax,StartXW
		mov cx,bx
		add ax,cx
		mov StartCol,ax
		mov al,content
		and al,10000000b
		cmp al,10000000b
		je	Print
		
		jmp FinishPrint
		Print:
		
			WrPixel	StartRow,StartCol,ColorB
		FinishPrint:
			mov cl,content
			shl cl,1
			mov content,cl
			inc bit
			mov al,bit
			mov ah,0
			mov bl,8
			div bl
			cmp ah,0
			jne H2B
			inc si
			mov ax,si
			mov dx,0
			mov cx,SizeXW
			div cx
			cmp dx,0
			jne nextbyte
			
		ChangelRow:
			inc di
			cmp di,SizeYW
			jne nextbyte
		ret
Print_Pic	 endp
; -------------------------------------------------------------------------------------------------------------------
tran proc near
	mov cx,0
Hex2Dec:
	inc cx
	mov bx,10
	mov dx,0
	div bx
	push dx
	cmp ax,0
	jne Hex2Dec
Dec2Ascii:
	pop ax
	add al,30h
	mov [di],al
	inc di
	loop Dec2Ascii
	ret 
tran endp

end

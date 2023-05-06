GetChar macro char
    mov ah,07h
    int 21h
    mov char,al
    endm
PrintStr macro string
    mov ah,09h
    mov dx,offset string
    int 21h
    endm
SetScreen macro
    mov ax,@data
    mov ds,ax
    mov es,ax
    mov ax,4f01h
    mov cx,103h    
    lea di,vesa_info
    int 10h

    mov ax,0A000h
    mov es,ax
    mov ax,4f02h
    mov bx,103h
    int 10h
endm
set_Background macro window,color                        
    Local       store_process
    cld                                           
    mov   ax, 0A000h
    mov   es, ax
    mov   dx, 0
    store_process:
    mov   cx, 0ffffh                          
    mov   ax, 4f05h
    mov   bh,0
    mov   bl,window
    int   10h
    mov   al, color
    mov   di, 0
    rep   stosb                               
    mov   es:[di],color
    inc   dx
    cmp   dx, 7
    jle   store_process
endm
get_Background macro window                        
mov   ax, 4f05h
mov   bh,1
mov   bl,window
int   10h
    
endm

Set_file_pointer macro f4b,b4b
mov ah,42h                  ;MOVE FILE READ/WRITE POINTER (LSEEK)
mov al,0                    ;AL = method value
                            ;0 = offset from beginning of file
                            ;1 = offset from present location
                            ;2 = offset from end of file
mov bx,file_handle          ;bx :file_handle
mov cx,f4b                  ;cx:dx offset in byte
mov dx,b4b                  
int 21h
endm


.model large
.386
.stack 1024
.data
file_in		        db 800 dup(?)
page1_1             db 3 dup(?)


pic_address         dw ?
file_handle         dw ?
vesa_info 	        db 256 dup(?)
fail_open           db "fail to open file",'$' 
file_f16b           dw 0
file_b16b           dw 0
screen_row          dw 0
futurefile_pointer  dd 0
byte_read_write     dw 800
recover_pic_x       dw 0
recover_pic_y       dw 0
buf                 db 10 dup('u'),'$'
.code
start:
;---------------------------------------------------
SetScreen
set_Background 1,0h
GetChar al
set_Background 0,0eh
GetChar al
set_Background 0,0h
GetChar al
set_Background 0,0eh
mov ax,4c00h		;exit dos
int 21h
;---------------------------------------------------
;---------------------------------------------------
;---------------------------------------------------
;---------------------------------------------------
;---------------------------------------------------
;---------------------------------------------------
;---------------------------------------------------

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

;---------------------------------------------------
;---------------------------------------------------

;---------------------------------------------------
end start
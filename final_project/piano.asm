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
set_Background macro color                        
    Local       store_process
    cld                                           
    mov   ax, 0A000h
    mov   es, ax
    mov   dx, 0
    store_process:
    mov   cx, 0ffffh                          
    mov   ax, 4f05h
    mov   bx, 0
    int   10h
    mov   al, color
    mov   di, 0
    rep   stosb                               
    mov   es:[di],color
    inc   dx
    cmp   dx, 7
    jle   store_process
endm

set_Background macro buf                        
    Local       store_process
    cld                                           
    mov ax,0A000h
    mov es,ax
    mov dx,0
    store_process:                         
    mov ax, 4f05h
    mov bx, 0
    int 10h
    mov cx,0ffffh 
    mov ax,@data
    mov ds,ax
    lea si,buffer
    mov al,color
    mov di,0
    rep stosb                               
    inc dx
    cmp dx, 7
    jle   store_process
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


; Wrpixel macro x,y,color
; Local LL
;     mov ax,y
;     mov cx,800
;     mul cx
;     mov bx,x
;     add ax,bx           ;dx是page的位置ax是offset位置

;     push  ax
;     mov ax, 0A000h
;     mov es, ax
;     mov ax, 4f05h
;     mov bx, 0
;     int 10h
;     pop di
;     mov cx,0
;     mov cl,color
;     mov es:[di],cx
; endm

.model large
.386
.stack 1024
.data
file_in		        db 800 dup(?)
page1_1             db 3 dup(?)

pic1                db "/nosignal.dnj",0
pic2                db "/wave.dnj",0
pic3                db "/spy.dnj",0
pic4                db "/first.dnj",0
pic5                db "/smile.dnj",0
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
buffer              db 65536 dup(?)
buf                 db 6 dup(?),'$'
.code
start:
;---------------------------------------------------
;---------------------------------------------------
;---------------------------------------------------
;---------------------------------------------------
;---------------------------------------------------
; init
; SetScreen
; set_Background 00h
;---------------------------------------------------
; lea dx,pic4
; mov pic_address,dx
; call Print_screen
; GetChar al
; ;---------------------------------------------------
; lea dx,pic5
; mov pic_address,dx
; call Print_screen
; GetChar al
;---------------------------------------------------
mov ax,0
mov gs,ax
mov si,0
mov gs:[si],1
mov ax,gs:[si]
call tran
mov ax,@data
mov ds,ax
lea di,buf
PrintStr buf
mov ax,4c00h		;exit dos
int 21h
;---------------------------------------------------
;---------------------------------------------------
;---------------------------------------------------
;---------------------------------------------------
;---------------------------------------------------
;---------------------------------------------------
;---------------------------------------------------
Print_screen proc
mov ax,@data
mov ds,ax
mov ah,3Dh					;Open file
mov al,0					;0,R 1,W 2,R/W
mov dx,pic_address
int 21h

pushf                       ;read flag val
pop bx
and bx,0001
.if bx==0001                ;verify CF is set(error)
PrintStr fail_open
.endif
mov file_handle,ax          ;ax return file_handle

;---------------------------------------------------
mov file_f16b,0
mov file_b16b,0

Read_file_write_monitor:
mov byte_read_write,800
mov screen_row,0

segment_print:

cld                                           
mov ax,0A000h
mov es,ax
mov dx,file_f16b     
mov ax,4f05h
mov bx,0
int 10h
mov cx,0ffffh
mov ax,@data 
mov ds,ax
mov ax,0A000h
mov es,ax
lea si,file_in
mov di,file_b16b        ;ds:si-->es:di
rep movsb
mov file_b16b,di

inc screen_row
.if screen_row==81
mov byte_read_write,736 ;最後一行
.endif
.if file_f16b==7
cmp screen_row,26
.elseif
cmp screen_row,81
.endif
jle segment_print

inc file_f16b
cmp file_f16b,7
jle Read_file_write_monitor

mov ah, 3Eh					;close file
mov bx, file_handle
int 21h
ret
Print_screen endp

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

;---------------------------------------------------
end start
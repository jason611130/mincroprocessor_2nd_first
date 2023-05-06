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

store_no_yellow macro
local Lop1,next
Lop1:
    mov al,ds:[si]
    cmp al,2ch
    je next
    cmp al,0eh
    je next
    cmp al,44h
    je next
    cmp al,2bh
    je next
    cmp al,5ch
    je next
    cmp al,43h
    je next
    mov byte ptr es:[di],al
    next:
    inc si
    inc di
    loop Lop1
endm
.model large
.386
.stack 1024
.data
file_in		        db 800 dup(?)
page1_1             db 3 dup(?)

pic2                db "/wave.dnj",0
pic3                db "/spy.dnj",0
pic4                db "/first.dnj",0
pic5                db "/spy1.dnj",0
pic6                db "/smile.dnj",0
pic7                db "/smile1.dnj",0 ;433,382
pic_star            db "/star.dnj",0 ;80,80
pic_black           db "/black.dnj",0 ;47,173
pic_dashboard       db "/Dash.dnj",0 ;778,93
pic_racebg0         db "/racebg0.dnj",0 ;1285,600
pic_racebg1         db "/racebg1.dnj",0 ;1285,600
pic_carm            db "/carm.dnj",0 ;75,50
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
recover_pic_startx  dw 0
recover_pic_starty  dw 0
pageOffset          dd 0
read_file_count     dd 0
PicPage             dw 0
PicOffset           dw 0
PicFirstcnt         dw 0
nowstar             dw 310
level               dw 0
GameTimeIndex	    db 45,40,30	
GameTime		    db 0
gameStartMin	    db 0
gameStartSec	    db 0
gameStarthSec	    db 0
gameCurMin	        db 0
gameCurSec	        db 0
gameCurhSec	        db 0
TIME 			    db 0
TIMES			    db 4 dup(' '),'$' 
StartTime		    db 0
str_buffer          db 10 dup(?),'$'
racebg_shift_x      dw 243
shift_cnt           dw 0
pre_racebg_shift    dw 0
racebg_shift_y      dw 100
arrowOffset         dd 0
.code
start:
;---------------------------------------------------
;---------------------------------------------------
;---------------------------------------------------
;---------------------------------------------------
;---------------------------------------------------
; init
SetScreen
set_Background 00h
LLL:
lea ax,pic_racebg1
mov pic_address,ax
mov recover_pic_x,800
mov recover_pic_y,200
mov recover_pic_startx,0
mov recover_pic_starty,200
call Print_racebackground


GetChar al
cmp al,'a'
je left
cmp al,'d'
je right
cmp al,'w'
je up
cmp al,'s'
je down
cmp al,'q'
je finish
left:
cmp racebg_shift_x,0
je LLL
mov bx,racebg_shift_x
sub bx,5
mov racebg_shift_x,bx
jmp LLL
right:
cmp racebg_shift_x,0
je LLL
mov bx,racebg_shift_x
add bx,5
mov racebg_shift_x,bx
jmp LLL
up:
cmp racebg_shift_y,0
je LLL
mov bx,racebg_shift_y
sub bx,5
mov racebg_shift_y,bx
jmp LLL
down:
cmp racebg_shift_y,0
je LLL
mov bx,racebg_shift_y
add bx,5
mov racebg_shift_y,bx
jmp LLL
finish:
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
Print_racebackground proc
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

    xor eax,eax
    xor edx,edx
    mov ax,recover_pic_starty
    mov bx,800
    mul bx
    xor ebx,ebx
    mov bx,dx
    shl ebx,16
    add ebx,eax
    xor eax,eax 
    mov ax,recover_pic_startx
    add ebx,eax
    mov PageOffset,ebx
    
    xor eax,eax
    xor edx,edx
    mov ax,racebg_shift_y
    mov bx,1285
    mul bx
    xor ebx,ebx
    mov bx,dx
    shl ebx,16
    add ebx,eax
    xor eax,eax 
    mov ax,racebg_shift_x
    add ebx,eax
    mov arrowOffset,ebx
    
    mov file_b16b,bx
    shr ebx,16
    mov file_f16b,bx
    
    
    mov screen_row,0
    line_print:
        Set_file_pointer file_f16b,file_b16b
        mov bx,file_handle
        mov cx,recover_pic_x				; 140 Bytes to read
        lea dx,file_in
        mov ah,3fh
        int 21h
    
        mov ebx,PageOffset
        mov PicOffset,bx
        shr ebx,16
        mov PicPage,bx

        mov ebx,PageOffset
        and ebx,0ffffh
        xor eax,eax
        mov ax,recover_pic_x
        add ebx,eax
        cmp ebx,0ffffh

        ja  dotwicebg
            mov ax,0A000h
            mov es,ax
            mov dx,PicPage                                         
            mov ax,4f05h
            mov bx,0
            int 10h
            cld
    
            mov cx,recover_pic_x
            mov ax,@data 
            mov ds,ax
            mov ax,0A000h
            mov es,ax
            lea si,file_in
            mov di,PicOffset        ;ds:si-->es:di
            rep movsb
            jmp finish_store
        dotwicebg:
            mov ax,0A000h
            mov es,ax
            mov dx,PicPage
            mov ax,4f05h
            mov bx,0
            int 10h

            cld
            mov cx,0ffffh
            mov dx,PicOffset
            sub cx,dx
            mov PicFirstcnt,cx
            mov ax,@data 
            mov ds,ax
            mov ax,0A000h
            mov es,ax
            lea si,file_in
            mov di,PicOffset        ;ds:si-->es:di
            rep movsb

            inc PicPage
            mov ax,0A000h
            mov es,ax
            mov dx,PicPage
            mov ax,4f05h
            mov bx,0
            int 10h
            cld

            mov cx,recover_pic_x
            mov dx,PicFirstcnt
            sub cx,dx
            mov ax,@data 
            mov ds,ax
            mov ax,0A000h
            mov es,ax
            lea bx,file_in
            add bx,PicFirstcnt
            mov si,bx
            mov di,0        ;ds:si-->es:di
            rep movsb
        finish_store:

        
        mov ebx,pageOffset
        xor edx,edx
        mov dx,800
        add ebx,edx
        mov pageOffset,ebx
        
        xor ebx,ebx
        mov bx,file_f16b
        shl ebx,16
        mov dx,file_b16b
        add ebx,edx
        mov dx,1285
        add ebx,edx
        mov file_b16b,bx
        shr ebx,16
        mov file_f16b,bx
        mov ax,screen_row
        mov dx,0
        mov bx,1
        div bx
        mov shift_cnt,dx
        .if screen_row > 285 && shift_cnt == 0
        ; mov ax,file_b16b
        ; mov bx,pre_racebg_shift
        ; sub ax,bx
        ; mov file_b16b,ax
        ; mov dx,screen_row
        ; mov cx,600
        ; sub cx,dx
        ; mov pre_racebg_shift,cx
        ; mov ax,file_b16b
        ; add ax,cx
        ; mov file_b16b,ax
        ; mov ax,file_b16b
        ; add ax,1
        ; mov file_b16b,ax
        .endif
        


        inc screen_row
        mov ax,recover_pic_y
        
        cmp screen_row,ax
    jle line_print
    mov ah, 3Eh					;close file
    mov bx, file_handle
    int 21h
    ret
Print_racebackground endp
;---------------------------------------------------
Print_No_Yellow proc 
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

    xor eax,eax
    xor edx,edx
    mov ax,recover_pic_starty
    mov bx,800
    mul bx
    xor ebx,ebx
    mov bx,dx
    shl ebx,16
    add ebx,eax
    xor eax,eax 
    mov ax,recover_pic_startx
    add ebx,eax
    mov PageOffset,ebx


    mov file_f16b,0
    mov file_b16b,0
    mov screen_row,0
    row1_print:
        Set_file_pointer file_f16b,file_b16b
        mov bx,file_handle
        mov cx,recover_pic_x				; 140 Bytes to read
        lea dx,file_in
        mov ah,3fh
        int 21h
    
        mov ebx,PageOffset
        mov PicOffset,bx
        shr ebx,16
        mov PicPage,bx

        mov ebx,PageOffset
        and ebx,0ffffh
        xor eax,eax
        mov ax,recover_pic_x
        add ebx,eax
        cmp ebx,0ffffh

        ja  dotwice1
            mov ax,0A000h
            mov es,ax
            mov dx,PicPage                                         
            mov ax,4f05h
            mov bx,0
            int 10h
            cld
    
            mov cx,recover_pic_x
            mov ax,@data 
            mov ds,ax
            mov ax,0A000h
            mov es,ax
            lea si,file_in
            mov di,PicOffset        ;ds:si-->es:di
            store_no_yellow
            jmp finish_store_datas
        dotwice1:
            mov ax,0A000h
            mov es,ax
            mov dx,PicPage
            mov ax,4f05h
            mov bx,0
            int 10h

            cld
            mov cx,0ffffh
            mov dx,PicOffset
            sub cx,dx
            mov PicFirstcnt,cx
            mov ax,@data 
            mov ds,ax
            mov ax,0A000h
            mov es,ax
            lea si,file_in
            mov di,PicOffset        ;ds:si-->es:di
            store_no_yellow
            

            inc PicPage
            mov ax,0A000h
            mov es,ax
            mov dx,PicPage
            mov ax,4f05h
            mov bx,0
            int 10h
            cld

            mov cx,recover_pic_x
            mov dx,PicFirstcnt
            sub cx,dx
            mov ax,@data 
            mov ds,ax
            mov ax,0A000h
            mov es,ax
            lea bx,file_in
            add bx,PicFirstcnt
            mov si,bx
            mov di,0        ;ds:si-->es:di
            store_no_yellow
        finish_store_datas:

        mov ebx,pageOffset
        xor edx,edx
        add ebx,800
        mov pageOffset,ebx
        
        xor ebx,ebx
        mov bx,file_f16b
        shl ebx,16
        mov dx,file_b16b
        add ebx,edx
        mov dx,recover_pic_x
        add ebx,edx
        mov file_b16b,bx
        shr ebx,16
        mov file_f16b,bx

        inc screen_row
        mov ax,recover_pic_y
        cmp screen_row,ax
    jle row1_print
    mov ah, 3Eh					;close file
    mov bx, file_handle
    int 21h
    ret
Print_No_Yellow endp



Print_clean proc

    xor eax,eax
    xor edx,edx
    mov ax,recover_pic_starty
    mov bx,800
    mul bx
    xor ebx,ebx
    mov bx,dx
    shl ebx,16
    add ebx,eax
    xor eax,eax 
    mov ax,recover_pic_startx
    add ebx,eax
    mov PageOffset,ebx


    ; mov file_f16b,0
    ; mov file_b16b,0
    mov screen_row,0
    row2_print:
    
        mov ebx,PageOffset
        mov PicOffset,bx
        shr ebx,16
        mov PicPage,bx

        mov ebx,PageOffset
        and ebx,0ffffh
        xor eax,eax
        mov ax,recover_pic_x
        add ebx,eax
        cmp ebx,0ffffh

        ja  dotwice2
            mov ax,0A000h
            mov es,ax
            mov dx,PicPage                                         
            mov ax,4f05h
            mov bx,0
            int 10h
            cld
    
            mov cx,recover_pic_x
            mov ax,@data 
            mov ax,0A000h
            mov es,ax
            mov al,0
            mov di,PicOffset        ;ds:si-->es:di
            rep stosb
            jmp finish_store_data2
        dotwice2:
            mov ax,0A000h
            mov es,ax
            mov dx,PicPage
            mov ax,4f05h
            mov bx,0
            int 10h

            cld
            mov cx,0ffffh
            mov dx,PicOffset
            sub cx,dx
            mov PicFirstcnt,cx
            mov ax,@data 
            mov ax,0A000h
            mov es,ax
            mov al,0
            mov di,PicOffset        ;ds:si-->es:di
            rep stosb

            inc PicPage
            mov ax,0A000h
            mov es,ax
            mov dx,PicPage
            mov ax,4f05h
            mov bx,0
            int 10h
            cld

            mov cx,recover_pic_x
            mov dx,PicFirstcnt
            sub cx,dx
            mov ax,@data 
            mov ds,ax
            mov ax,0A000h
            mov es,ax
            lea bx,file_in
            add bx,PicFirstcnt
            mov al,0
            mov di,0        ;ds:si-->es:di
            rep stosb
        finish_store_data2:

        mov ebx,pageOffset
        xor edx,edx
        add ebx,800
        mov pageOffset,ebx

        inc screen_row
        mov ax,recover_pic_y
        cmp screen_row,ax
    jle row2_print
    mov ah, 3Eh					;close file
    mov bx, file_handle
    int 21h
    ret
Print_clean endp



end start
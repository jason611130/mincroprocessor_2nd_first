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
store_no_yellow macro
local Lop1,next
Lop1:
    mov al,ds:[si]
    cmp al,2ch
    cmp al,0h
    je next
    mov byte ptr es:[di],al
    next:
    inc si
    inc di
    loop Lop1
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
    cmp al,0h
    je next
    mov byte ptr es:[di],al
    next:
    inc si
    inc di
    loop Lop1
endm
clear_all_sign macro
    Local clean
    mov cx ,sign_num
    clean:
        push cx
        mov ax,4
        mul cx
        mov si ,ax
        mov recover_pic_x,100 
        mov recover_pic_y,10
        
        mov bx ,block_pos[si][-2]
        mov recover_pic_startx,bx
        mov bx ,block_pos[si][-4]
        mov recover_pic_starty,bx

        call Print_clean
        pop cx
    loop clean

endm
draw_all_sign macro
Local draw,_continue

        mov cx ,sign_num
        lea ax,pic_sign
        mov pic_address,ax
        draw:
            push cx
            mov ax,4
            mul cx
            mov si ,ax
            
            mov recover_pic_x,100 
            mov recover_pic_y,100

            mov bx ,block_pos[si][-2]
            mov recover_pic_startx,bx
            mov bx ,block_pos[si][-4]
            mov recover_pic_starty,bx
            cmp recover_pic_starty,0
            je _continue
            call Print_No_Yellow
            _continue:
            pop cx
        loop draw

endm

update_sign_pos macro
Local update,continue

        mov cx ,sign_num
        update:
            push cx
            mov ax,4
            mul cx
            mov si ,ax

            mov ax,block_pos[si][-4]
            cmp ax,0
            je continue
            add ax,speed
            mov block_pos[si][-4],ax
            cmp ax,600
            jb continue
            mov block_pos[si][-4],0
            continue:
            pop cx
        loop update

endm


draw_panel macro
    lea ax,pic_panel
    mov pic_address,ax
    mov recover_pic_x,800 
    mov recover_pic_y,200
    mov recover_pic_startx,0
    mov recover_pic_starty,0
    call Print_No_Yellow
endm

print_frame_num macro
mov ax,cnt
mov di,offset fps_num
call tran
SET_CUR 0,0
PrintStr fps_num
endm

print_sec macro
    mov ax,sec_pic
    mov di,offset sec_num
    call tran
    SET_CUR 1,0
    PrintStr sec_num
endm
.model large
.386
.stack 1024
.data
file_in		        db 800 dup(?)
page1_1             db 3 dup(?)



pic_sign            db "/sign.dnj",0 ;100,100
pic_panel            db "/dashh.dnj",0 ;800,200
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
sign_num dw 7
block_pos dw  0,00  ,0,115,   0,230,    0,335,   0,450,   0,565,    0,680
; block_pos dw  0,0,600,0,600,0,600,0,600,0,600,0,600,0
speed dw 10
fps_num db "F_NUM=",10 dup(' '),'$'
sec_num db "S_NUM=",10 dup(' '),'$'
time1   dw      ?,?,?,0
time2   dw      65535,0,0,0
cnt dw 0
sec_pic dw 0
song_seq dw 0,1,2,3,4,5,6,0,1,2,3,4,5,6,255

note_index dw 0
note_index_frame dw 0
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
mov  ax, @data
mov  es, ax
mov  ds, ax
main:
    mov  ax, @data
    mov  ds, ax
    mov  es, ax
  

    print_frame_num
    print_sec

    draw_all_sign
    draw_panel

     t:
        mov  ax, @data
        mov  ds, ax
        mov  es, ax
        mov     di,offset time1 
        call    get_time
        mov ax ,time2[0]
        sub ax ,time1[0]
        cmp ax ,19886 ;19886,39772
        jae _NEXT_FRAME ;;>16ms
        jmp t ;;loop until 1/60s

    _NEXT_FRAME:
        clear_all_sign
        update_sign_pos
        mov bx,time1[0]
        mov time2[0],bx
        inc note_index_frame
        inc cnt
        cmp cnt ,60
        jbe _next_note
            mov cnt,0
            inc sec_pic
        _next_note: 
        mov ax,100
        mov dx,0
        mov bx,speed
        div bx
        cmp note_index_frame , ax
        jb _no
        
            
            mov  ax, @data
            mov  es, ax
            mov  ds, ax
            
            mov note_index_frame,0
            mov ax,note_index
            mov bx,2
            mul bx
            mov si,ax
            mov ax, song_seq[si]
            cmp ax,255
            je _music_end
            mov bx,4
            mul bx
            mov si,ax
            mov ax,block_pos[si]
            inc ax
            mov block_pos[si] ,ax
            inc note_index
            jmp _no
            _music_end:
                mov note_index,0
        _no:

         


jmp main
GetChar al

mov ax,4c00h		;exit dos
int 21h
;---------------------------------------------------
;---------------------------------------------------
;---------------------------------------------------
;---------------------------------------------------
;---------------------------------------------------
;---------------------------------------------------
;---------------------------------------------------
clear_all_sign proc
    mov ax,@data
    mov ds,ax
    mov recover_pic_x,100 
    mov recover_pic_y,100
    mov recover_pic_startx,0
    mov ax,block_pos
    mov recover_pic_starty,0
    call Print_clean
clear_all_sign endp
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

    mov file_f16b,0
    mov file_b16b,0

    Read_file_write_monitor:
    mov byte_read_write,800
    mov screen_row,0

    segment_print:
    Set_file_pointer file_f16b,file_b16b
    mov bx,file_handle
    mov cx,byte_read_write				; Bytes to read
    lea dx,file_in
    mov ah,3fh
    int 21h

    cld                                           
    mov ax,0A000h
    mov es,ax
    mov dx,file_f16b
    mov cx,byte_read_write                     
    mov ax,4f05h
    mov bx,0
    int 10h
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
Print_pic proc
recover_pic:

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
    row_print:
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

        ja  dotwice
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
            jmp finish_store_data
        dotwice:
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
        finish_store_data:

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
    jle row_print
    mov ah, 3Eh					;close file
    mov bx, file_handle
    int 21h
    ret
Print_pic endp


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
    mov [di+6],al
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

    mov file_f16b,0
    mov ax,racebg_shift_x
    mov file_b16b,ax
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

get_time        proc    near
        push    ds     
        push    si      
        sub     ax,ax   
        mov     si,46ch
        mov     ds,ax

        cli             

        mov     al,0   
        out     43h,al

        in      al,40h  
        mov     bl,al
        in      al,40h
        mov     bh,al
        ; not     bx    

        mov     ax,bx
ok:     stosw          
        movsw         
        movsw

        sti            
        pop     si
        pop     ds
        ret
get_time        endp
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
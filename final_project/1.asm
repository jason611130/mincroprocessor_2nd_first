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
Local buffer0,buffer1,_end
	mov dh,row1
	mov dl,col1
	mov bx,0000h
    ;for double buffer
    cmp now_buffer_index,1
    je buffer0
    cmp now_buffer_index,0
    je buffer1

    buffer0: ;from page 0
    ; mov bh,10
    jmp _end 

    buffer1:  ;from page 10     
    
    _end:
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
    Local clean,do_not
    mov cx ,sign_num
    clean:
        push cx
        mov ax,4
        mul cx
        mov si ,ax
        mov recover_pic_x,100 
        mov ax,speed
        mov recover_pic_y,20
        
        mov bx ,block_pos[si][-2]
        mov recover_pic_startx,bx
        mov bx ,block_pos[si][-4]
        cmp bx,100
        jbe do_not
        sub bx,speed
        sub bx,speed
        mov recover_pic_starty,bx

        call Print_clean

        do_not:
        pop cx
    loop clean

endm
clear_page macro
    mov recover_pic_x,800
    mov recover_pic_y,400

    mov recover_pic_startx,0
    mov recover_pic_starty,100
    
    lea ax,pic_clean
    mov pic_address,ax
    call Print_pic
endm
draw_all_sign macro
Local draw,_continue

        mov cx ,4
        lea ax,pic_sign
        mov pic_address,ax
        draw:
            push cx
            mov ax,2
            mul cx
            mov si,ax
            
            mov recover_pic_x,100 
            mov recover_pic_y,100

            mov bx,blockX[si][-2]
            mov recover_pic_startx,bx
            mov bx,blockY[si][-2]
            mov recover_pic_starty,bx
            cmp recover_pic_starty,0
            je _continue
            call Print_No_Yellow
            _continue:
            pop cx
        loop draw

endm

update_sign_pos macro
Local update,continue,set,hit

        mov cx,4
        update:
            push cx
            mov ax,@data
            mov ds,ax
            mov ax,2
            mul cx
            mov si,ax
            lea bx,blockY
            mov ax,[bx+si-2]
            cmp ax,0
            je continue

            add ax,speed
            mov word ptr blockY[si][-2],ax
            ; cmp ax,300
            ; jb continue
            ; cmp ax,400
            ; jbe hit
            cmp ax,400
            ja set
            hit:
                mov si,cx
                lea bx,can_hit_index
                mov byte ptr [bx+si-1],  1
                jmp continue
            set:
            mov ax,now_lower_index
            inc ax
            mov dx,0
            mov bx,4
            div bx
            mov now_lower_index,dx
            mov word ptr BlockY[si][-2],0
            ; mov di,cx
            ; lea bx,can_hit_index
            ; mov byte ptr [bx+di-1],0 ;設定沒打到方塊
            ; lea bx,hit_index
            ; mov byte ptr [bx+di-1],0
            continue:
            pop cx
        loop update

endm


draw_panel macro
    lea ax,pic_panel
    mov pic_address,ax
    mov recover_pic_x,800 
    mov recover_pic_y,100
    mov recover_pic_startx,0
    mov recover_pic_starty,0
    call Print_pic
endm

print_frame_num macro
mov ax,cnt
mov di,offset fps_num
call tran


SET_CUR 1,0
PrintStr fps_num
endm

print_sec macro
    mov ax,sec_pic
    mov di,offset sec_num
    call tran

    SET_CUR 0,0
    PrintStr sec_num
endm

draw_menu macro n
Local n_1,n_2,_draw,_draw
    cmp n,0
    je n_1
    cmp n,1
    je n_2
    n_1:
        lea ax,pic_menu_1
        jmp _draw
    n_2:
        lea ax,pic_menu_2
        jmp _draw
    _draw:
        mov pic_address,ax
        mov recover_pic_x,800 
        mov recover_pic_y,600
        mov recover_pic_startx,0
        mov recover_pic_starty,0
        call Print_pic

endm

hit_note_or_not macro
Local L1,continue
    mov cx,sign_num
    L1:
        push cx
        
        mov ax,@data
        mov ds,ax
        mov es,ax
        mov dx,0
        mov ax,4
        mul cx
        mov temp,cx
        mov si,ax
        lea bx,hit_index
        mov di,temp
        cmp byte ptr [bx+di-1],0
        je continue
        mov word ptr BlockY[si][-2],0
        mov ax,temp
        mov di,ax
        lea bx,can_hit_index
        mov byte ptr [bx+di-1],0 
        lea bx,hit_index
        mov byte ptr [bx+di-1],0
        continue:
        pop cx
    loop L1
endm
music   macro sound

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

    endm
MusicEnd macro
	in 	al,61H 
	and al,0FCH 
	out 61H,al
	endm


.model large
.386
.stack 1024
.data
file_in		        db 800 dup(?)
page1_1             db 3 dup(?)


pic_sign            db "sign.dnj",0 ;100,100
pic_panel           db "dash.dnj",0 ;800,200
pic_menu_1          db "1page.dnj",0 ;800,600
pic_menu_2          db "2page.dnj",0 ;800,600
pic_clean           db "clean.dnj",0 ;800,600
pic_sz              db "smallz.dnj",0 ;100,100
pic_sx              db "smallx.dnj",0 ;100,100
pic_sc              db "smallc.dnj",0 ;100,100
pic_sv              db "smallv.dnj",0 ;100,100
pic_sl              db "smalll.dnj",0 ;100,100
pic_sr              db "smallr.dnj",0 ;100,100
pic_sq              db "smallq.dnj",0 ;100,100
pic_bz              db "bigz.dnj",0 ;100,100
pic_bx              db "bigx.dnj",0 ;100,100
pic_bc              db "bigc.dnj",0 ;100,100
pic_bv              db "bigv.dnj",0 ;100,100
pic_bl              db "bigl.dnj",0 ;100,100
pic_br              db "bigr.dnj",0 ;100,100
pic_bq              db "bigq.dnj",0 ;100,100
pic_great           db "great.dnj",0 ;60,60

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
block_posx dw  0,115,230,345,460,575,690
blockX dw  4 dup(0)
blockY dw  4 dup(0)
sounds			dw 0ffffh,4560,4063,3619,3416,3043,2711,2415,2280,2031,1809,1715,1521,1355,1207
speed dw 5
fps_num db "F_NUM=",10 dup(' '),'$'
sec_num db "S_NUM=",10 dup(' '),'$'
time1   dw      ?,?,?,0
time2   dw      65535,0,0,0
cnt dw 0
sec_pic dw 0
song_seq dw 0,2,1,3,255;0,1,2,3,4,5,6,0,1,2,3,4,5,6,255
flow_flag dw 1
note_index dw 0
note_index_frame dw 0
menu_page_index dw 0
now_buffer_index dw 0
keyboard_show_cnt dw 0
can_hit_index db 7 dup(0)
hit_index db 7 dup(0)
key db 0
hit_a_sign db 0
temp dw 0
notecnt dw 0
xpos dw 0
now_lower_index dw 0
lowest_Xval dw 0
lowest_Yval dw 0
hit_area db 0
.code
start:
;---------------------------------------------------
;---------------------------------------------------
;---------------------------------------------------
;---------------------------------------------------
;---------------------------------------------------
; init

SetScreen

mov  ax, @data
mov  es, ax
mov  ds, ax
main:

    mov  ax, @data
    mov  ds, ax
    mov  es, ax
  
    mov  AH , 4Fh     
    mov  AL , 07h        
    mov  BH , 00h        
    mov  BL , 00h
    cmp now_buffer_index,0
    je buffer0
    cmp now_buffer_index,1
    je buffer1
    buffer0:
    mov  CX ,0
    mov  DX , 0
    jmp _b_set
    buffer1:       
    mov  CX ,160
    mov  DX , 819
    _b_set:
    int 10h

    cmp flow_flag,0
    je menu_page
    cmp flow_flag,1
    je game_page
menu_page:
    music 0
    mov  ax, @data
    mov  ds, ax
    mov  es, ax
    
    mov dx,0
    mov ax,menu_page_index
    mov bx,2
    div bx
    mov menu_page_index,dx
    t1:
        mov  ax, @data
        mov  ds, ax
        mov  es, ax
        mov     di,offset time1 
        call    get_time
        mov ax ,time2[0]
        sub ax ,time1[0]
        cmp ax ,19886 ;19886,39772
        jae _NEXT_FRAME_menu ;;>16ms
        jmp t1 ;;loop until 1/60s

    _NEXT_FRAME_menu:
        
        draw_menu menu_page_index
        
        inc now_buffer_index
        mov dx,0
        mov ax,now_buffer_index
        mov bx,2
        div bx
        mov now_buffer_index,dx

        inc cnt
        cmp cnt ,12
        jbe _mNO
            mov cnt,0
            inc sec_pic
            mov ax,menu_page_index
            inc ax
            mov menu_page_index,ax
        _mNO:
    jmp main
game_page:
    print_frame_num
    print_sec 
    clear_page
    cmp keyboard_show_cnt,1
    ja keyboard_already_exist
    inc keyboard_show_cnt
    keyboard_already_exist:
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
        ;clear_all_sign
        MusicEnd
        update_sign_pos
        GetChar06h al
        mov key,al
        call draw_keyborad
        hit_note_or_not

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
            mov note_index_frame,0
            mov ax, @data
            mov es,ax
            mov ds,ax
            mov ax,note_index
            shl ax,1
            mov di,ax
            lea bx,song_seq
            mov ax,[bx+di]
            cmp ax,255
            je _music_end
            mov di,ax
            shl di,1
            lea bx,block_posx
            mov ax,[bx+di]
            mov xpos,ax

            mov ax,note_index
            mov dx,0
            mov bx,4
            div bx
            mov si,dx
            shl si,1
            lea bx,blockX
            mov ax,xpos
            mov [bx+si],ax

            ; mov ax,now_lower_index
            ; mov dx,0
            ; mov bx,4
            ; div bx
            ; mov now_lower_index,dx

            lea bx,blockY
            mov ax,[bx+si]
            inc ax
            mov [bx+si],ax
            inc note_index
            jmp _no
            _music_end:
                mov note_index,0
        _no:
        inc now_buffer_index
        mov dx,0
        mov ax,now_buffer_index
        mov bx,2
        div bx
        mov now_buffer_index,dx


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

        ;for double buffer
        cmp now_buffer_index,1
        je _rpic_buffer0
        cmp now_buffer_index,0
        je _rpic_buffer1

        _rpic_buffer0: ;from page 0
        jmp _RB_end 
        _rpic_buffer1:  ;from page 10     
        mov ax,PicPage
        add ax,10
        mov PicPage,ax

        _RB_end:

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

        ;for double buffer
        cmp now_buffer_index,1
        je _pNYP_buffer0
        cmp now_buffer_index,0
        je _pNYP_buffer1

        _pNYP_buffer0: ;from page 0
        jmp _pn_end 
        _pNYP_buffer1:  ;from page 10     
        mov ax,PicPage
        add ax,10
        mov PicPage,ax

        _pn_end:

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
        xor     ax,ax   
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
        
        ;for double buffer
        cmp now_buffer_index,1
        je _pC_buffer0
        cmp now_buffer_index,0
        je _pC_buffer1

        _pC_buffer0: ;from page 0
        jmp _pc_end 
        _pC_buffer1:  ;from page 10     
        mov ax,PicPage
        add ax,10
        mov PicPage,ax

        _pc_end:

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

draw_keyborad proc
    mov ax,@data
    mov ds,ax
    mov es,ax
    mov di,now_lower_index
    shl di,1
    lea bx,blockX
    mov dx,[bx+di]
    mov lowest_Xval,dx
    lea bx,blockY
    mov ax,[bx+di]
    mov lowest_Yval,ax

    .if lowest_Yval>=300
    mov hit_area,1
    .else
    mov hit_area,0
    .endif
    mov recover_pic_x,100
    mov recover_pic_y,100
    mov recover_pic_starty,500
    mov recover_pic_startx,0
    

    
    .if lowest_Xval==0&&hit_area==1&&key=="z"
    lea ax,pic_sz
    mov pic_address,ax
    call Print_Pic
    .else
    mov recover_pic_startx,0
    lea ax,pic_sq
    mov pic_address,ax
    call Print_Pic
    .endif

    ; lea ax,pic_sz
    ; lea bx,can_hit_index
    ; mov dl,[bx]
    ; mov hit_a_sign,dl
    ; .if key=='z';&& hit_a_sign==1
    ; music 1
    ; lea ax,pic_bz
    ; ; lea bx,hit_index
    ; ; mov byte ptr [bx],1
    ; .endif
    ; mov pic_address,ax
    ; call Print_Pic

    ; mov recover_pic_startx,115
    ; lea ax,pic_sx
    ; lea bx,can_hit_index
    ; mov dl,[bx+1]
    ; mov hit_a_sign,dl
    ; .if key=='x';&&hit_a_sign==1
    ; music 2
    ; lea ax,pic_bx
    ; ; lea bx,hit_index
    ; ; mov byte ptr [bx+1],1   
    ; .endif
    ; mov pic_address,ax
    ; call Print_Pic

    ; mov recover_pic_startx,230
    ; lea ax,pic_sc
    ; lea bx,can_hit_index
    ; mov dl,[bx+2]
    ; mov hit_a_sign,dl
    ; .if key=='c';&&hit_a_sign==1
    ; music 3
    ; lea ax,pic_bc
    ; ; lea bx,hit_index
    ; ; mov byte ptr [bx+2],1  
    ; .endif
    ; mov pic_address,ax
    ; call Print_Pic

    ; mov recover_pic_startx,345
    ; lea ax,pic_sv
    ; lea bx,can_hit_index
    ; mov dl,[bx+3]
    ; mov hit_a_sign,dl
    ; .if key=='v';&&hit_a_sign==1
    ; music 4
    ; lea ax,pic_bv
    ; ; lea bx,hit_index
    ; ; mov byte ptr [bx+3],1
    ; .endif
    ; mov pic_address,ax
    ; call Print_Pic

    ; mov recover_pic_startx,460
    ; lea ax,pic_sl
    ; lea bx,can_hit_index
    ; mov dl,[bx+4]
    ; mov hit_a_sign,dl
    ; .if key==',';&&hit_a_sign==1
    ; music 5
    ; lea ax,pic_bl
    ; ; lea bx,hit_index
    ; ; mov byte ptr [bx+4],1
    ; .endif
    ; mov pic_address,ax
    ; call Print_Pic

    ; mov recover_pic_startx,575
    ; lea ax,pic_sr
    ; lea bx,can_hit_index
    ; mov dl,[bx+5]
    ; mov hit_a_sign,dl
    ; .if key=='.';&&hit_a_sign==1
    ; music 6
    ; lea ax,pic_br
    ; ; lea bx,hit_index
    ; ; mov byte ptr [bx+5],1
    ; .endif
    ; mov pic_address,ax
    ; call Print_Pic

    ; mov recover_pic_startx,690
    ; lea ax,pic_sq
    ; lea bx,can_hit_index
    ; mov dl,[bx+6]
    ; mov hit_a_sign,dl
    ; .if key=='/';&&hit_a_sign==1
    ; music 7
    ; lea ax,pic_bq
    ; ; lea bx,hit_index
    ; ; mov byte ptr [bx+6],1
    ; .endif
    ; mov pic_address,ax
    ; call Print_Pic
    ret
draw_keyborad endp
end start
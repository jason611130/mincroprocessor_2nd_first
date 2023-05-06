;把鍵盤模擬成鋼琴的程式：
;1：Do　2：Re　3：Mi　4：Fa　5：Sol　6：La　7：Si　8：Do

;***************************************

;---------------------------------------
.8086
.model large
.stack 1024
.data
message db      'PAINO v 1.0',0dh,0ah
        db      '以鍵盤模擬鋼琴的程式',0dh,0ah,0dh,0ah
        db      '鍵盤 1、2……8 表示 Do、Re……Do。',0dh,0ah
        db      '按 Esc 鍵退出程式。$'
freq    dw      262,294,330,347,392,440,494,524 ;14 頻率
.code
.startup
begin:  mov     ah,9
        mov     dx,offset message
        int     21h

gt_key: mov     ah,7
        int     21h     ;20 讀取按鍵
        cmp     al,1bh
        je      exit    ;22 若為 Esc 鍵，則退出程式
        sub     al,'1'
        cbw
        mov     bx,ax
        shl     bx,1
        mov     ax,34dch
        mov     cx,freq[bx]     ;28 取得按鍵所代表的頻率
        mov     dx,12h          ;29 DX:AX=1234DCH=1193180D
        div     cx
        mov     bx,ax           ;31 BX=(1193180/頻率)之商數

        mov     al,10110110b    ;33 準備把 BX 寫入埠 42H 當作計數暫存器
        out     43h,al
        mov     ax,bx
        out     42h,al          ;36 先傳出 BX 之低位元組
        mov     al,ah
        out     42h,al          ;38 再傳出 BX 之高位元組
        in      al,61h
        or      al,00000011b
        out     61h,al          ;41 打開喇叭發出聲音

        mov     cx,0ffffh       ;43
delay:  mov     dx,400h
dec_dx: dec     dx
        jnz     dec_dx
        loop    delay           ;47 使聲音延續一段時間

        in      al,61h
        and     al,11111100b    ;50 遮掉位元 0 及位元 1
        out     61h,al          ;51 關掉喇叭
        jmp     gt_key

exit:   int     20h
.exit

end
;***************************************

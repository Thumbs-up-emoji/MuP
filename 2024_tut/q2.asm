.model tiny
.486
.data

curr db ?
rstrt dw 00
rend dw 250
cstrt dw 00
cend dw 150
rectc dw 4
delay_time dw 50 ;

.code
.startup

mov ah,0fh
int 10h
mov curr,al

mov ah,0
mov al,12h
int 10h

x4:
mov dx,rstrt
x2:
mov cx,cstrt
x1:

mov bx,rectc
and bx,1
jz x41
mov al,010b
jmp x42

x41:
mov al,100b

x42:
mov bx,0
mov ah,0ch
int 10h
inc cx
cmp cx,cend
jnz x1

inc dx
cmp dx,rend
jnz x2

dec rectc
jz xe

mov ax,20
add rstrt,ax
add cstrt,ax
sub rend,ax
sub cend,ax
call  delay

jmp x4

xe:
mov ah,07h
xf:
int 21h
cmp al,'e'  
jnz xf

mov ah,0
mov al,curr
int 10h

delay:
        ; Delay for the specified time
        mov     ax, delay_time
        mov     cx, ax
        mov     dx, ax
        mov     ah, 86h
        int     15h
        ret

.exit
end
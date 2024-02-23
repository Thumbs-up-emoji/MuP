.model small
.stack 100h

.data
    hello_msg db 'Hello World',0

.code
main proc
    mov ax,@data
    mov ds,ax
    mov ah,09h
    lea dx,hello_msg
    int 21h
    mov ah,4ch
    int 21h
main endp

end main
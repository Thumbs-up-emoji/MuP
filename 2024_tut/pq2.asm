.model tiny
.data
inp db "Enter the number in decimal: $"
res db 0dh,0ah,"The result in hexadecimal is: $"
maxi db 5
acti db ?
num db 4 dup(?)
conv db 5 dup(?)
.code
.startup
	lea dx,inp
	mov ah,09h
	int 21h

	lea dx,maxi
	mov ah,0ah
	int 21h
	
	lea si, num
	mov cl, acti
	mov di, 0ah
	mov ax, 00h

convert:mul di
	mov bl,[si]
	and bl,0fh

	add ax,bx
	inc si
	dec cl
	jnz convert

	lea di,conv
	mov ch,4

store:	mov bx,ax
	and bx,000fh
	cmp bl,0ah
	jge l1
	add bl,30h
	jmp mem
l1:	sub bl,0ah
	add bl,'A'
	
mem:	mov [di],bl
	mov cl,4
	shr ax,cl
	inc di
	dec ch
	jnz store

	lea bx,conv
	dec bx
	dec di

	lea dx,res
	mov ah,09h
	int 21h

print:	mov dl,[di]
	mov ah,02h
	int 21h
	
	dec di
	cmp di,bx
	jnz print

.exit
end
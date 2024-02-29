.model tiny
.486
.data
str1 db "Enter a number: $"
nline db 0dh,0ah,'$'
max1 db 3
act1 db ?
num1 db 3 dup(?)
str2 db 0dh,0ah,"The current running average: $"
result db 2 dup(0)
.code
.startup
	mov cl,0h
	mov di,00h
	
l1:	lea si,result

	lea dx,str1
	mov ah,09h
	int 21h

	lea dx,max1
	mov ah,0ah
	int 21h

	lea si,num1

	mov dx,cx

	mov ch,act1
	mov cl,4
	mov bx,00h

mov1:	rol bl,cl
	mov al,[si]
	
	cmp al,'q'
	je finish	

	cmp al,'A'
	jge hex1
	and al,0fh
	jmp con1

hex1:	sub al,'A'
	add al,0ah

con1:	add bl,al
	inc si
	dec ch
	jnz mov1

sum:	mov bh,00h
	add di,bx
	inc dl
	mov ax,di
	div dl
	mov ah,00h
	lea si,result
	mov ch,2

store:	mov bx,ax
	and bx,000fh
	cmp bl,0ah
	jge l2
	add bl,30h
	jmp mem
l2:	sub bl,0ah
	add bl,'A'
	
mem:	mov [si],bl
	mov cl,4
	shr ax,cl
	inc si
	dec ch
	jnz store

	mov cx,dx

	lea bx,result
	dec bx
	dec si
	
	lea dx,str2
	mov ah,09h
	int 21h

print:	mov dl,[si]
	mov ah,02h
	int 21h
	
	dec si
	cmp si,bx
	jnz print

	lea dx,nline
	mov ah,09h
	int 21h
	
	jmp l1
finish:
.exit
end
	
	
	
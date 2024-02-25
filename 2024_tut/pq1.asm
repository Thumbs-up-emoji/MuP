.model tiny
.data
inp1 db "Input the first number: $"
inp2 db 0dh,0ah,"Input the second number: $"
max1 db 3
act1 db ?
num1 db 3 dup(?)
max2 db 3
act2 db ?
num2 db 3 dup(?)
eve1 db 0dh,0ah,"Result: The sum is even$"
odd1 db 0dh,0ah,"Result: The sum is odd$"
.code
.startup
	lea dx,inp1
	mov ah,09h
	int 21h

	lea dx,max1
	mov ah,0ah
	int 21h

	lea dx,inp2
	mov ah,09h
	int 21h

	lea dx,max2
	mov ah,0ah
	int 21h

	lea si,num1
	mov ch,act1
	mov cl,4

conv1:	rol bl,cl
	mov al,[si]
	
	cmp al,'A'
	jge alph1
	and al,0fh
	jmp cont1

alph1:	sub al,'A'
	add al,0ah

cont1:	add bl,al
	inc si
	dec ch
	jnz conv1

	lea si,num2
	mov ch,act2
	mov dx,00h

conv2:	rol dl,cl
	mov al,[si]
	
	cmp al,'A'
	jge alph2
	and al,0fh
	jmp cont2

alph2:	sub al,'A'
	add al,0ah

cont2:	add dl,al
	inc si
	dec ch
	jnz conv2

	mov bh,00h
	mov dh,00h

	add bx,dx

	and bx,1h
	jz eve

	lea dx,odd1
	mov ah,09h
	int 21h
	jmp finish

eve:	lea dx,eve1
	mov ah,09h
	int 21h

finish:
.exit
end
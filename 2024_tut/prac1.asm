.model tiny
.486
.data
filen db "test.txt", 0
filen2 db "output.txt", 0
handle dw ? 
buf db 100 dup('$')
.code
.startup	
	;open the file in filen
	mov ah, 3dh
	mov al, 2h
	lea dx, filen
	int 21h
	mov handle, ax

	;copy the first 10 characters into buffer
	mov ah, 3fh
	mov bx, handle
	mov cx, 10
	lea dx, buf
	int 21h
	
	lea dx, buf
	mov ah, 09h
	int 21h
	
	mov ah, 3ch
	lea dx, filen2
	mov cl, 20h
	int 21h
	mov handle, ax
	
	mov ah, 42h
	mov al, 0
	mov bx, handle
	mov cx, 0
	mov dx, 0
	int 21h
	
	mov ah, 40h
	mov bx, handle
	mov cx, 10
	lea dx, buf
	int 21h
.exit
end
.model tiny
.486
.data
filen db "test.txt", 0
handle dw ? 
loc db ?
buf db 255 dup('$')
cnt db ?
col db 1
row db 0
prev db ?
attr db 00001111b
.code
.startup	
	;The attribute byte is used to specify the foreground and background of the character displayed on the screen.
	;Bits 2-1-0 represent the foreground colour
	;Bit 3 represents the intensity of foreground colour (0-low , 1- high intensity)
	;Bits 6-5-4 represent the background colour
	;Bit 7 is used for blinking text if set to 1
	;000       -black (gray)
	;001       -blue (bright blue)
	;010       -green (bright green)
	;011       -cyan (bright cyan) 
	;100       -red   (bright red)
	;101       -magenta (bright magenta)
	;110       -brown (yellow)
	;111       -white (bright white)
	mov attr, 11000010b
	
	;open the file in filen
	mov ah, 3dh
	mov al, 2h
	lea dx, filen
	int 21h
	mov handle, ax

	;copy the first 10 characters into buffer
	mov ah, 3fh
	mov bx, handle
	mov cx, 200
	lea dx, buf
	int 21h
	
	mov ah, 0fh
	int 10h
	mov prev, al
	
	mov ah, 00h
	mov al, 03h ;put display mode in al
	int 10h
	
	;this will print all the text inside buf
	mov cnt, 200
	lea si, buf
x2:	mov al, [si]
	inc si
	mov ah, 09h
	mov bh, 0;page number
	mov bl, attr;attribute
	mov cx, 1;number of times to write the character, moving 13*80 (in disp mode 3) will fill upper 13 rows (0-12)
	int 10h
	mov ah, 02h
	mov dh, row ;row
	mov dl, col ;column
	mov bh, 0 ;this is page unmber, usually 0
	int 10h
	inc col
	cmp col, 79
	je x3
	dec cnt
	jnz x2
	jmp x4
x3: mov col, 0
	inc row
	cmp row, 24
	je x4
	dec cnt
	jnz x2
x4:

	mov ah, 07h
x1:	int 21h
	cmp al, '&'
	jnz x1
	mov ah, 00h
	mov al, prev ;put display mode in al
	int 10h
.exit
end
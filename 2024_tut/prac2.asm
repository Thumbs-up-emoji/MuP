.model tiny  ; Set the memory model to tiny
.486  ; Set the target processor to the 486

.data  ; Begin the data segment
filen db "test.txt", 0  ; Define a null-terminated string for the filename
handle dw ?  ; Define a word for the file handle
loc db ?  ; Define a byte for the location
buf db 255 dup('$')  ; Define a buffer of 255 bytes, initialized to '$'
cnt db ?  ; Define a byte for the count
col db 1  ; Define a byte for the column, initialized to 1
row db 0  ; Define a byte for the row, initialized to 0
prev db ?  ; Define a byte for the previous value
attr db 00001111b  ; Define a byte for the attribute, initialized to 00001111b

.code  ; Begin the code segment
.startup  ; Set the entry point of the program

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

; Set the attribute byte
mov attr, 11000010b

; Open the file in filen
mov ah, 3dh  ; Set the function number for "Open File"
mov al, 2h  ; Set the access mode to read/write
lea dx, filen  ; Load the address of the filename into dx
int 21h  ; Call DOS interrupt 21h
mov handle, ax  ; Store the file handle

; Copy the first 200 characters into buffer
mov ah, 3fh  ; Set the function number for "Read from File"
mov bx, handle  ; Load the file handle into bx
mov cx, 200  ; Set the number of bytes to read
lea dx, buf  ; Load the address of the buffer into dx
int 21h  ; Call DOS interrupt 21h

; Get the current video mode and store it in prev
mov ah, 0fh  ; Set the function number for "Get Video Mode"
int 10h  ; Call BIOS interrupt 10h
mov prev, al  ; Store the video mode

; Set the video mode to 80x25 text mode with 16 colors
mov ah, 00h  ; Set the function number for "Set Video Mode"
mov al, 03h  ; Set the video mode to 80x25 text mode with 16 colors
int 10h  ; Call BIOS interrupt 10h

; Print the characters from the buffer to the screen
mov cnt, 200  ; Set the count to 200
lea si, buf  ; Load the address of the buffer into si
x2:	mov al, [si]  ; Load the character at si into al
	inc si  ; Increment si
	mov ah, 09h  ; Set the function number for "Write Character and Attribute at Cursor Position"
	mov bh, 0  ; Set the page number to 0
	mov bl, attr  ; Load the attribute into bl
	mov cx, 1  ; Set the number of times to write the character
	int 10h  ; Call BIOS interrupt 10h
	mov ah, 02h  ; Set the function number for "Set Cursor Position"
	mov dh, row  ; Load the row into dh
	mov dl, col  ; Load the column into dl
	mov bh, 0  ; Set the page number to 0
	int 10h  ; Call BIOS interrupt 10h
	inc col  ; Increment the column
	cmp col, 79  ; Compare the column to 79
	je x3  ; If the column is 79, jump to x3
	dec cnt  ; Decrement the count
	jnz x2  ; If the count is not zero, jump to x2
	jmp x4  ; Jump to x4
x3: mov col, 0  ; Set the column to 0
	inc row  ; Increment the row
	cmp row, 24  ; Compare the row to 24
	je x4  ; If the row is 24, jump to x4
	dec cnt  ; Decrement the count
	jnz x2  ; If the count is not zero, jump to x2
x4:

; Wait for the user to press '&'
mov ah, 07h  ; Set the function number for "Input Character Without Echo"
x1:	int 21h  ; Call DOS interrupt 21h
	cmp al, '&'  ; Compare the character to '&'
	jnz x1  ; If the character is not '&', jump to x1

; Restore the original video mode
mov ah, 00h  ; Set the function number for "Set Video Mode"
mov al, prev  ; Load the previous video mode into al
int 10h  ; Call BIOS interrupt 10h

.exit  ; Exit the program
end  ; End the program
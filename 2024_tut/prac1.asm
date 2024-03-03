.model tiny  ; Set the memory model to tiny
.486  ; Set the target processor to the 486

.data  ; Begin the data segment
filen db "test.txt", 0  ; Define a null-terminated string for the input filename
filen2 db "output.txt", 0  ; Define a null-terminated string for the output filename
handle dw ?  ; Define a word for the file handle
buf db 100 dup('$')  ; Define a buffer of 100 bytes, initialized to '$'

.code  ; Begin the code segment
.startup  ; Set the entry point of the program

; Open the file in filen
mov ah, 3dh  ; Set the function number for "Open File"
mov al, 2h  ; Set the access mode to read/write
lea dx, filen  ; Load the address of the input filename into dx
int 21h  ; Call DOS interrupt 21h
mov handle, ax  ; Store the file handle

; Copy the first 10 characters into buffer
mov ah, 3fh  ; Set the function number for "Read from File"
mov bx, handle  ; Load the file handle into bx
mov cx, 10  ; Set the number of bytes to read
lea dx, buf  ; Load the address of the buffer into dx
int 21h  ; Call DOS interrupt 21h

; Display the buffer on the console
lea dx, buf  ; Load the address of the buffer into dx
mov ah, 09h  ; Set the function number for "Write String to Console"
int 21h  ; Call DOS interrupt 21h

; Create a new file named filen2
mov ah, 3ch  ; Set the function number for "Create File"
lea dx, filen2  ; Load the address of the output filename into dx
mov cl, 20h  ; Set the file attributes to archive
int 21h  ; Call DOS interrupt 21h
mov handle, ax  ; Store the file handle

; Move the file pointer to the start of the file
mov ah, 42h  ; Set the function number for "Move File Pointer"
mov al, 0  ; Set the origin to the start of the file
mov bx, handle  ; Load the file handle into bx
mov cx, 0  ; Set the high word of the new file pointer position to 0
mov dx, 0  ; Set the low word of the new file pointer position to 0
int 21h  ; Call DOS interrupt 21h

; Write the buffer to the file
mov ah, 40h  ; Set the function number for "Write to File"
mov bx, handle  ; Load the file handle into bx
mov cx, 10  ; Set the number of bytes to write
lea dx, buf  ; Load the address of the buffer into dx
int 21h  ; Call DOS interrupt 21h

.exit  ; Exit the program
end  ; End the program
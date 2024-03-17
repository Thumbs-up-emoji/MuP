.model tiny  ; Set the memory model to tiny. This is needed because it determines how the program can address memory.
.486  ; Use 486 instruction set. This is needed to specify the minimum CPU architecture required to run this program.
.data  ; Start of data segment. This is where you define all the variables that you will use in your program.

curr db ?  ; Declare a byte variable 'curr' without initializing it. This is needed to store the current video mode.
rstrt dw 00  ; Declare a word variable 'rstrt' and initialize it to 0. This is needed to store the start row of the rectangle.
rend dw 250  ; Declare a word variable 'rend' and initialize it to 250. This is needed to store the end row of the rectangle.
cstrt dw 00  ; Declare a word variable 'cstrt' and initialize it to 0. This is needed to store the start column of the rectangle.
cend dw 150  ; Declare a word variable 'cend' and initialize it to 150. This is needed to store the end column of the rectangle.
rectc dw 4  ; Declare a word variable 'rectc' and initialize it to 4. This is needed to store the number of rectangles to draw.
delay_time dw 50 ; Declare a word variable 'delay_time' and initialize it to 50. This is needed to store the delay time between drawing rectangles.

.code  ; Start of code segment. This is where the actual instructions of the program are written.
.startup  ; Start of startup code. This is where the program begins executing.

mov ah,0fh  ; Function number for getting the current video mode
int 10h  ; Call video interrupt. This is needed to get the current video mode.
mov curr,al  ; Store the current video mode in 'curr'. This is needed to restore the video mode at the end of the program.

mov ah,0  ; Function number for setting the video mode
mov al,12h  ; Video mode number for 640x480 16-color graphics
int 10h  ; Call video interrupt. This is needed to set the video mode.

x4:
mov dx,rstrt  ; Start row for rectangle
x2:
mov cx,cstrt  ; Start column for rectangle
x1:

mov bx,rectc  ; Number of rectangles to draw
and bx,1  ; Check if the number of rectangles is odd
jz x41  ; Jump to x41 if the number of rectangles is even
mov al,010b  ; Color for odd rectangles
jmp x42  ; Unconditional jump to x42

x41:
mov al,100b  ; Color for even rectangles

x42:
mov bx,0  ; Page number. This is needed because the video interrupt uses it to determine where to draw the rectangle.
mov ah,0ch  ; Function number for setting the pixel color
int 10h  ; Call video interrupt. This is needed to set the pixel color.
inc cx  ; Increment the column. This is needed to move to the next column of the rectangle.
cmp cx,cend  ; Compare the current column with the end column of the rectangle.
jnz x1  ; Jump back to x1 if the current column is not equal to the end column. This is needed to draw the entire row of the rectangle.

inc dx  ; Increment the row. This is needed to move to the next row of the rectangle.
cmp dx,rend  ; Compare the current row with the end row of the rectangle.
jnz x2  ; Jump back to x2 if the current row is not equal to the end row. This is needed to draw the entire rectangle.

dec rectc  ; Decrement the number of rectangles. This is needed to draw the correct number of rectangles.
jz xe  ; Jump to xe if there are no more rectangles to draw.

mov ax,20  ; Size of the border around the rectangle
add rstrt,ax  ; Increase the start row of the rectangle. This is needed to draw the next rectangle inside the current one.
add cstrt,ax  ; Increase the start column of the rectangle. This is needed to draw the next rectangle inside the current one.
sub rend,ax  ; Decrease the end row of the rectangle. This is needed to draw the next rectangle inside the current one.
sub cend,ax  ; Decrease the end column of the rectangle. This is needed to draw the next rectangle inside the current one.
call  delay  ; Call delay procedure. This is needed to delay between drawing rectangles.

jmp x4  ; Unconditional jump to x4. This is needed to start drawing the next rectangle.

xe:
mov ah,07h  ; Function number for reading a character without echo
xf:
int 21h  ; Call DOS interrupt. This is needed to read a character from the keyboard.
cmp al,'e'  ; Compare the read character with 'e'
jnz xf  ; Jump back to xf if the read character is not 'e'. This is needed to wait for the user to press 'e' before the program exits.

mov ah,0  ; Function number for setting the video mode
mov al,curr  ; Previous video mode. This is needed to restore the video mode before the program exits.
int 10h  ; Call video interrupt. This is needed to set the video mode.

delay:  ; Start of delay procedure
        ; Delay for the specified time
        mov     ax, delay_time  ; Delay time
        mov     cx, ax  ; High order word of delay time
        mov     dx, ax  ; Low order word of delay time
        mov     ah, 86h  ; Function number for delay
        int     15h  ; Call system interrupt. This is needed to delay for the specified time.
        ret  ; Return from procedure

.exit  ; Exit the program. This is needed to tell the assembler where the program ends.
end  ; End of the program. This is needed to tell the assembler that there are no more instructions.
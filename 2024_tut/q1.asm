.model tiny  ; Set the memory model to tiny. This is needed because it determines how the program can address memory.
.486  ; Use 486 instruction set. This is needed to specify the minimum CPU architecture required to run this program.
.data  ; Start of data segment. This is where you define all the variables that you will use in your program.

; Define the start and end rows and columns for four squares
strow1  db      00  ; Start row for square 1
stcol1  db      00  ; Start column for square 1
enrow1  db      12  ; End row for square 1
encol1  db      40  ; End column for square 1

strow2  db      00  ; Start row for square 2
stcol2  db      40  ; Start column for square 2
enrow2  db      12  ; End row for square 2
encol2  db      80  ; End column for square 2

strow3  db      12  ; Start row for square 3
stcol3  db      00  ; Start column for square 3
enrow3  db      24  ; End row for square 3
encol3  db      40  ; End column for square 3

strow4  db      12  ; Start row for square 4
stcol4  db      40  ; Start column for square 4
enrow4  db      24  ; End row for square 4
encol4  db      80  ; End column for square 4

prev    db      ?  ; Variable to store the previous video mode. This is needed to restore the video mode at the end of the program.
cnt     db      0  ; Counter variable. This is used to control the loops that draw the squares.

.code  ; Start of code segment. This is where the actual instructions of the program are written.
.startup  ; Start of startup code. This is where the program begins executing.

; Save the previous video mode
mov     ah,0fh  ; Function number for getting the current video mode
int     10h  ; Call video interrupt. This is needed to get the current video mode.
mov     prev,al  ; Store the current video mode in prev. This is needed to restore the video mode at the end of the program.

; Set the video mode to 03h (80x25 text)
mov     ah,0h  ; Function number for setting the video mode
mov     al,03  ; Video mode number for 80x25 text
int     10h  ; Call video interrupt. This is needed to set the video mode.

; Draw the first square
mov     bh,0  ; Page number. This is needed because the video interrupt uses it to determine where to draw the square.
mov     dh,strow1  ; Start row for square 1
x1:     mov     dl,stcol1  ; Start column for square 1
mov     ah,02h  ; Function number for setting the cursor position
int     10h  ; Call video interrupt. This is needed to set the cursor position.

; Print 40 spaces in red
mov     ah,09h  ; Function number for writing character and attribute
mov     al,20h  ; ASCII for space. This is needed because we want to draw the square with spaces.
mov     bl,47h  ; Attribute for red on white. This is needed because we want the square to be red on white.
mov     cx,40  ; Repeat count. This is needed because we want to draw 40 spaces.
int     10h  ; Call video interrupt. This is needed to draw the spaces.

; Increment the row and repeat if not at the end of the square
inc     dh  ; Increment the row. This is needed to move to the next row of the square.
cmp     dh,enrow1  ; Compare the current row with the end row of the square.
jnz     x1  ; Jump back to x1 if the current row is not equal to the end row. This is needed to draw the entire square.

; Repeat the above steps for the remaining squares
; The comments for these steps would be the same as for the first square.

mov     dh,strow2
x2:     mov     dl,stcol2
mov     ah,02h
int     10h

mov     al,20h
mov     ah,09h
mov     bl,17h
mov     cx,40
int     10h

inc     dh
cmp     dh,enrow2
jnz     x2

mov     dh,strow3
x3:     mov     dl,stcol3
mov     ah,02h
int     10h

mov     al,20h
mov     ah,09h
mov     bl,17h
mov     cx,40
int     10h

inc     dh
cmp     dh,enrow3
jnz     x3

mov     dh,strow4
x4:     mov     dl,stcol4
mov     ah,02h
int     10h

mov     ah,09h
mov     al,20h
mov     bl,47h
mov     cx,40
int     10h

inc     dh
cmp     dh,enrow4
jnz     x4

; Wait for a key press
mov     ah, 00h  ; Function number for reading a key press
int     16h  ; Call keyboard interrupt. This is needed to wait for a key press before the program exits.

; Restore the previous video mode and exit
mov     ah, 00h  ; Function number for setting the video mode
mov     al, prev  ; Previous video mode. This is needed to restore the video mode before the program exits.
int     10h  ; Call video interrupt. This is needed to set the video mode.
int     20h  ; Terminate the program. This is needed to end the program.

.exit  ; Exit the program. This is needed to tell the assembler where the program ends.
end  ; End of the program. This is needed to tell the assembler that there are no more instructions.
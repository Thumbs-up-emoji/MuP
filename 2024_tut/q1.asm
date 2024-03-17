.model tiny
.486
.data
strow1  db      00
stcol1  db      00
enrow1  db      12
encol1  db      40

strow2  db      00
stcol2  db      40
enrow2  db      12
encol2  db      80

strow3  db      12
stcol3  db      00
enrow3  db      24
encol3  db      40

strow4  db      12
stcol4  db      40
enrow4  db      24
encol4  db      80

prev    db      ?
cnt		db		0


.code
.startup
		;previous mode
        mov     ah,0fh
        int     10h
        mov     prev,al
		
		;mode
        mov     ah,0h
        mov     al,03
        int     10h
		
		;cursor position sq1
        mov     bh,0                    
        mov     dh,strow1
x1:     mov     dl,stcol1
        mov     ah,02h
        int     10h
		
		;print space of color red
        mov     ah,09h
        mov     al,20h  ;space
        mov     bl,47h
        mov     cx,40 	;printing 40 times
        int     10h
		
		;checking if we reached new square
        inc     dh
        cmp     dh,enrow1
        jnz     x1
		
		;sq2--same proc
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

		;sq3
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

		;sq4
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
        mov     ah, 00h
        int     16h

        ; Restore previous video mode and exit
        mov     ah, 00h
        mov     al, prev
        int     10h
        int     20h		
        

.exit
end
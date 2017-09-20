;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;	ECE 109 001
;	Samuel Messick EE/CPE
;	Due 3/27/2017
;
;	Program Assignment 1
;	Version 1.1 (Looping)
;
;_________________________________________
;
; This program recieves an ASCII character
; and outputs its respective binary 
; representation.
;_________________________________________
;
;	General Purpose Register Key :)
;       ----------------------------
;       R1 --> ASCII input
;	R2 --> Counter
;	R3 --> Bitmask
;	R4 --> Bitmask/input "AND" result
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	.orig x3000

; Initializes g.p.r's,
; counter and bitmask.
; Outputs prompt.

Init    AND R0, R0, 0		;
	AND R1, R1, 0		;
	AND R2, R2, 0		; Zero the g.p.r's
	AND R3, R3, 0		;
	AND R4, R4, 0		;
	LD R2, Count		; Load counter value to R2
	ADD R3, R3, 1		; Set bitmask to 1
	LD R5, ASCII		; Loads ASCII conversion factor
	LD R6, Binary		; Sets pointer for binary string to be stored
	LEA R0, Prompt		; Loads prompt addr to R0
	PUTS			; Outputs prompt

; Obtains ASCII character
; and determines individual
; bit value

MyChar  GETC
	NOT R0, R0
	ADD R0, R0, 1
	OUT
	ADD R1, R1, R0		; Loads input ASCII code to R1
	ST R0, Char		; Stores ASCII code for later use
	LD R0, LF		; 
	OUT			; Outputs linefeed following input
	AND R0, R0, 0		; Clears R0

; Translates from ASCII to
; binary.

Trans   AND R4, R1, R3		; Bitwise check for 1 using bitmask
	BRz ZeroBit
	AND R4, R4, 0
	ADD R4, R4, 1
ZeroBit	ADD R0, R4, R5		; Converts "AND" result to ASCII	
	ADD R3, R3, R3  	; Doubles R3 (shifts bitmask 1 place left)
	STR R4, R6, 0		; Stores Binary Bit
	ADD R6, R6, 1
	ADD R2, R2, -1 		; Decrements counter by 1
	BRp Trans		; Checks if counter has reached 0

 
; Reverses calculated bits


Output  LEA R0, Response1
	PUTS
	ADD R2, R2, 8
	LD R0, Char
	OUT
	LEA R0, Response2
	PUTS 
ReadBin	AND R0, R0, 0
	LDR R0, R6, 0
	ADD R0, R0, R5
	OUT
	ADD R6, R6, -1
	ADD R2, R2, -1
	BRp ReadBin

; Terminates program

EndSeq  LD R0, LF
	OUT			; Outputs linefeed
	BRnzp Init

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Count   .FILL x0007
Prompt  .STRINGZ "> "
SP      .FILL x0020
Binary	.FILL x4000
ASCII   .FILL x0030
Char	.FILL x0000
LF	.FILL x000A
Response1 .STRINGZ "The ASCII code for '"
Response2 .STRINGZ "' is "

	.END
	



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;	ECE 109 001
;	Samuel Messick EE/CPE
;	
;	Program Assignment 1
;
;	Version 1.0
;	Due 3/27/2017
;	Last Edit 3/16/2017
;_________________________________________
;
; This program recieves an ASCII character
; and outputs its respective binary 
; representation.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	.orig x3000

; Initializes g.p.r's,
; loop counter and bitmask.
; Outputs prompt.

Init    AND R0, R0, 0		;\
	AND R1, R1, 0		; \
	AND R2, R2, 0		;  Zero the g.p.r's
	AND R3, R3, 0		; /
	AND R4, R4, 0		;/
	LD R2, Count		; Load counter value to R2
	ADD R3, R3, 1		; Set bitmask to 1
	LD R5, ASCII		; Loads ASCII addend
	LD R6, Binary		; Sets pointer for binary stack
	LEA R0, Prompt		; Loads prompt address to R0
	PUTS			; Outputs prompt

; Obtains ASCII character
; and determines individual
; bit value

MyChar  GETC
	OUT			; Prints input character
	ADD R1, R1, R0		; Loads input ASCII code to R1
	ST R0, Char		; Stores input ASCII code for output
	LD R0, LF		
	OUT			; Outputs line feed following input
	AND R0, R0, 0		; Clears R0

; Parses input's ASCII
; for 1's and 0's. Pushes
; bits into stack at x4000

Parse   AND R4, R1, R3		; Bitwise check for 1 using bitmask
	BRz ZeroBit		; Checks if "AND" result is 0
	AND R4, R4, 0		
	ADD R4, R4, 1		; Sets R4 to x0001 if "AND" result contains 1
ZeroBit	ADD R4, R4, R5		; Converts "AND" result to ASCII	
	ADD R3, R3, R3  	; Doubles R3 (shifts bitmask 1 place left)
PUSH	STR R4, R6, 0		; Stores Binary Bit
	ADD R2, R2, -1 		; Decrements counter by 1
	BRz Output		; Checks if counter has reached 0
	ADD R6, R6, 1		; Increments pointer for binary string
	BRnzp Parse		; Repeats loop

 
; Outputs parsed bits

Output  ADD R2, R2, 8		; Sets counter to 8
	LEA R0, Response1	 
	PUTS			; Displays first part of output string
	LD R0, Char		
	OUT			; Outputs input character
	LEA R0, Response2		
	PUTS			; Outputs second part of output string	

ReadBin	AND R0, R0, 0		; Clears R0
	LDR R0, R6, 0		; Loads binary 1 or 0 with pointer				
POP	OUT			; Outputs bit
	ADD R6, R6, -1		; Decrements binary string pointer
	ADD R2, R2, -1		; Decrements counter
	BRp ReadBin		; Checks if counter has reached 0

; Terminates program

EndSeq  LD R0, LF
	OUT			; Outputs line feed
	HALT			; program is terminated

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Count   .FILL x0008				; Count value for parsing loop
Prompt  .STRINGZ "> "				; Input prompt
Binary	.FILL x4000				; Pointer for end bit of ASCII translation
ASCII   .FILL x0030				; ASCII addend
Char	.FILL x0000				; Input character pointer
LF	.FILL x000A				; ASCII code for Line feed
Response1 .STRINGZ "The ASCII code for '"	; First half of output string
Response2 .STRINGZ "' is "			; Second half of output string

	.END
	



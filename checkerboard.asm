;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This program creates a 4px by 4px 
; box size checkerboard on the PennSim 
; video output.
;
; Author: Sam Messick
; Version 1.0
; Last Edited: 3/21/2017
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		.ORIG x3000

; Clear g.p.r's and save R7

SetM	AND R0, R0, 0 ;\
	AND R1, R1, 0 ; \
	AND R2, R2, 0 ;  \
	AND R3, R3, 0 ;    Set g.p.r's to zero
	AND R4, R4, 0 ;  /
	AND R5, R5, 0 ; /
	AND R6, R6, 0 ;/
	STI R7, R7, R7Save

; Color the screen black

InitBlk	LD R0, Black	; Loads the 
	LD R1, VideoB
	LD R2, RowCt
RowBlak	LD R3, RowInc
ColBlak STR R0, R1, 0	; Colors video pointer's DR black
	ADD R1, R1, 1	; Increments video pointer
	ADD R3, R3, -1	; Pixels in row to be colored is decremented
	BRp ColBlak	; Checks if pixels are left to be colored
	ADD R2, R2, -1	; Rows to be colored are decremented
	BRp RowBlak	; Checks if rows are left to be colored

InitRed LD R0, Red	; Loads the value for red
	LD R1, VideoB	; Loads the beginning of video memory
RowLoop	ADD R2, R2, 4	; Set 
	LDI R0, 



EndSeq  LEA R0, EndPrpt
	PUTS			; Reads end prompt
	GETC			; Waits for character input
	LD R0, LF
	OUT
	OUT			; Two linefeeds are printed
	LDI R7, R7Save		; R7 is restored	
	BRnzp ClrM		; Restarts program


VideoB 	.FILL xC000		; Video memory beginning
FirstPx .FILL x0000		; Location of the first column pointer
Black	.FILL x0000
Red 	.FILL x7C00		; Value for the color red
R7Save	.FILL x0000		; Location for preserving R7 during execution
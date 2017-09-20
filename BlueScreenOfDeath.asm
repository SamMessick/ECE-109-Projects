.orig x3000

InitM	AND R0, R0, 0	;\
	AND R1, R1, 0	; \
	AND R2, R2, 0	;  \
	AND R3, R3, 0	;   Zero the g.p.r's
	AND R4, R4, 0	;  /
	AND R5, R5, 0	; /
	AND R6, R6, 0	;/

InitBlu	LD R1, Blue
	LD R2, VideoB
	LD R4, RowCt
RowBlue	LD R3, RowInc
ColBlue STR R1, R2, 0
	ADD R2, R2, 1
	ADD R3, R3, -1
	BRp ColBlue
	ADD R4, R4, -1
	Brp RowBlue 
	HALT

Blue	.FILL x001F		; Code for blue fill
RowInc  .FILL x0080		; Number of pixels per row on video output
RowCt	.FILL x007C		; Number of rows of pixels on video output
VideoB  .FILL xC000		; Video memory beginning location

	.END
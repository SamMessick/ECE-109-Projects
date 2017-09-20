;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This program flashes random colors
; on the LC-3 video output. 
;
;
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.orig x3000

	LD R1, Black
InitBlk	LD R2, VideoB
	LD R4, RowCt
	ST R5, Full
RowFl1	LD R3, RowInc
ColmFl1 STR R1, R2, 0	; Colors video pointer's DR black
	ADD R2, R2, 1	; Increments video pointer
	ADD R3, R3, -1	; Pixels in row to be colored is decremented
	BRp ColmFl1	; Checks if pixels are left to be colored
	ADD R4, R4, -1	; Rows to be colored are decremented
	BRp RowFl1	; Checks if rows are left to be colored
	ADD R1, R1, 8	; Increments Color Value
	ADD, R5, R5, -8;	
	BRp InitBlk	; Checks if Color Value exceeds xFFFF

	LD R1, Full
InitWhi LD R2, VideoB
	LD R4, RowCt
RowFl2	LD R3, RowInc
ColmFl2 STR R1, R2, 0	; Colors video pointer's DR black
	ADD R2, R2, 1	; Increments video pointer
	ADD R3, R3, -1	; Pixels in row to be colored is decremented
	BRp ColmFl2	; Checks if pixels are left to be colored
	ADD R4, R4, -1	; Rows to be colored are decremented
	BRp RowFl2	; Checks if rows are left to be colored
	ADD R1, R1, -8	; Decrements Color Value	
	BRp InitWhi	; Checks if Color Value exceeds xFFFF
	BRnzp InitBlk


Black 	.FILL x0000
VideoB  .FILL xC000
RowInc  .FILL x0080		; New row addend
RowCt	.FILL x007C		; ColFill Counter
Full	.FILL xFFFF

.END


	


	.orig x3000

;InitBlk	LD R0, BLACK	; Load the value for black
;	LD R1, VideoB	; Load the center pixel's memory location
;	ST R1, BoxPtr	; Save the upper left box pixel's location
;	LD R3, RowCt	; Load the number of rows (loop counter)
;RowBlak	LD R2, RowInc	; Load the number of pixels per row
;ColBlak STR R0, R1, 0	; Color video pointer's DR black
;	ADD R1, R1, 1	; Increment video pointer
;	ADD R2, R2, -1	; Pixels in row to be colored is decremented
;	BRp ColBlak	; Check if pixels are left to be colored
;	ADD R3, R3, -1	; Row to be colored are decremented
;	BRp RowBlak	; Check if rows are left to be colored
;PaintSt	LD R0, VideoB	; Load starting video output address to R0
;	HALT

InitBlk	LD R0, BLACK
	LD R1, VideoB
	LD R2, Cancel
ColBlak	STR R0, R1, 0
	ADD R1, R1, 1
	ADD R3, R2, R1
	BRn ColBlak
	LD R1, WHITE	; Load white color value into R1
	JSR Paint

Paint	AND R5, R5, 0	
	ADD R5, R5, 8	; Set "rows to color" loop counter to 8
	LD  R2, VideoM	; Loads upper leftmost box pixel pointer
	LD  R4, RowInc
	AND R3, R3, 0	
Paint1	ADD R3, R3, 8	; Set "pixels to color" loop counter to 8
	ST  R2, TempPt	; Pointer to current leftmost pixel is stored
RowCol  STR R1, R2, 0 	; Pixel is colored red
	ADD R2, R2, 1	; The video memory pointer is incremented
	ADD R3, R3, -1	; Amount of pixels to color is decremented
	BRp RowCol	; Checks if pixels are left to be colored		
	LD  R2, TempPt	; Loads the leftmost pixel pointer
	ADD R2, R2, R4	; Moves the pixel pointer one pixel down
	ADD R5, R5, -1	; Amount of rows to color is decremented
	BRp Paint1 	; Checks if rows are left to be colored		
	HALT

BLACK  	.FILL x0000
VideoB	.FILL xC000
VideoM 	.FILL xDE44
RowCt  	.FILL 124
RowInc 	.FILL x80
UpprCs 	.FILL xFFDF
WHITE	.FILL x7FFF
TempPt	.BLKW 1
BoxPtr	.BLKW 1
Cancel	.FILL x0201
	.END
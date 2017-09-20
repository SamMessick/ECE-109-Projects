;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;	ECE 109 001
;	Samuel Messick EE/CPE
;
;	Program Assignment 2
;
;	Version 1.0
;	Due 4/10/2017
;	Last Edit 3/27/2017
;_________________________________________
;
; Draws a single-colored 8px by 8px block 
; User can recolor and move box based on
; keyboard input
;_________________________________________
;
;	Key Input Options (case insensitive)
;	------------------------------------
;	
;	W/w: move block one pixel row up
; 	A/a: move black one pixel column left
; 	S/s: move block one pixel row down
;	D/d: move block one pixel row right
; 	R/r: color block red
; 	G/g: color block green
; 	B/b: color block blue
; 	Y/y: color block yellow
;	space: color block white
;	return: clear the screen/return box
;	Q/q: halt program execution
;	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	.orig x3000

; Initialization
; ==============

;----------------------
; Init:
; -----
; Initializes g.p.r's,
; paints screen black
; paints white block at 
; (64, 62)
;----------------------

Init	AND R0, R0, 0	;\
	AND R1, R1, 0	; \
	AND R2, R2, 0	;  \
	AND R3, R3, 0	;   -Zero the g.p.r's
	AND R4, R4, 0	;  /
	AND R5, R5, 0	; /
	AND R6, R6, 0	;/

; Clears screen

InitBlk	LD R0, BLACK	; Loads value for black into R0
	LD R1, VideoB	; Loads 1st pixel video pointer
	LD R2, EndPx	; Loads addend test for last pixel on screen
ColBlak	STR R0, R1, 0	; Colors current pixel black
	ADD R1, R1, 1	; Increments video pointer
	ADD R3, R2, R1	
	BRn ColBlak	; Tests if current pixel is beyond screen bounds

	LD R1, WHITE	; Load value for white into R1
	ST R1, CurCol	; Saves current color value
	LD R0, BoxInit	
	ST R0, BoxPtr	; Load and store block pointer
	JSR Paint	; Add box to screen


; Main Program
;==============

Input	GETC		; Recieve user key input

;----------------------------
; WASD Movement
; -------------
; Verify if key pressed
; Undergo collision detection
; Move block if appropriate
;----------------------------


; move the block up

Up	LD R1, W	; Load 'W' ASCII subtrahend
	LD R2, UpprCs
	AND R3, R0, R2  
	ADD R3, R3, R1	; Convert input to uppercase ASCII and 
	BRnp Left	; check for a character match

	;\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
	; Up Collision Detection
	; -------------------------
	; Compares current video pointer to test
	; point along top edge within screen
	;\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\

	UPCol 	LD R0, TTst
		LD R1, BoxPtr
	UTest	ADD R2, R0, R1	; Check if the box is at or below
		BRnz Input	; the top video edge

UMove	LD R1, BLACK	; Load value for black into R1
	JSR Paint	; Clear block
	LD R0, MovUp	
	LD R1, BoxPtr	; Load current block location
	ADD R1, R1, R0	; and offset 8 rows up
	ST R1, BoxPtr	; Update block pointer
	LD R1, CurCol	; Load preexisting block color
	JSR Paint	; and restore block color
	BRnzp Input


; move the block left

Left	LD R1, A	; Load 'A' ASCII subtrahend
	AND R3, R0, R2
	ADD R3, R3, R1	; Convert input to uppercase ASCII and 
	BRnp Down	; check for a characer match

	;\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
	; Left Collision Detection
	; -------------------------
	; Increments current video pointer
	; by row to compare projected position
	; along bottom edge to test point
	;\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\

	LftCol 	LD R0, BTst
		LD R1, BoxPtr
		LD R2, RowDTst
	LTest	ADD R3, R1, R0 	; Check if video pointer is at or right of left edge
		BRz Input	; Video pointer is at left edge
		BRp LMove 	; Video pointer is right of left edge
		ADD R1, R2, R1	; Increase projected video pointer by one row
		BRnzp LTest	; Repeat Collision Detection Test

LMove	LD R1, BLACK	; Load value for black into R1
	JSR Paint	; Clear block
	LD R1, BoxPtr	; Load current block location
	ADD R1, R1, -8	; and offset 8 pixels left
	ST R1, BoxPtr	; Update block pointer
	LD R1, CurCol	; Load preexisting block color
	JSR Paint	; and restore block color
	BRnzp Input


; move the block down

Down	LD R1, S	; Load 'S' ASCII subtrahend
	AND R3, R0, R2
	ADD R3, R3, R1	; Convert character to uppercase ASCII and
	BRnp Right	; check for a character match

	;\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
	; Down Collision Detection
	; -------------------------
	; Compares current video pointer to test
	; point along bottom edge within screen
	;\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\

	DwnCol  LD R0, BTst
		LD R1, BoxPtr
	DTest	ADD R2, R0, R1	; Check if the box is at or higher
		BRzp Input	; than the bottom video edge

DMove	LD R1, BLACK	; Load value for black into R1
	JSR Paint	; Clear block
	LD R0, MovDwn
	LD R1, BoxPtr	; Load current block location
	ADD R1, R1, R0	; and offset 8 rows down
	ST R1, BoxPtr	; Update block pointer
	LD R1, CurCol	; Load preexisting block color
	JSR Paint	; and restore block color
	BRnzp Input


; move the block right

Right	LD R1, D	; Load 'D' ASCII subtrahend
	AND R3, R0, R2
	ADD R3, R3, R1	; Convert character to uppercase ASCII and
	BRnp Rd		; check for a character match

	;\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
	; Right Collision Detection
	; -------------------------
	; Decrements current video pointer
	; by row to compare projected position
	; along top edge to test point
	;\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
	
		RgtCol  LD R0, TTst
		LD R1, BoxPtr
		LD R2, RowUTst
	RTest	ADD R3, R1, R0	; Check if video pointer is at or left of right edge
		BRz Input	; Video pointer is at right edge
		BRn RMove	; Video pointer is left of right edge
		ADD R1, R1, R2	; Decrease projected video pointer by one row
		BRnzp RTest	; Repeat Collision Detection Test

RMove	LD R1, BLACK	; Load value for black into R1
	JSR Paint	; Clear block
	LD R1, BoxPtr	; Load current block location 
	ADD R1, R1, 8	; and offset 8 pixels right
	ST R1, BoxPtr	; Update block pointer
	LD R1, CurCol	; Load preexisting block color
	JSR Paint	; and restore block color
	BRnzp Input


;--------------------------
; Coloring methods
; ----------------
; Verify if key pressed
; Recolor box appropriately
;--------------------------

; color block red

Rd	LD R1, R	; Load 'R' ASCII subtrahend
	AND R3, R0, R2
	ADD R3, R3, R1	; Convert character to uppercase ASCII and
	BRnp Grn	; check for a character match
	LD R1, RED	; Load value for red into R1
	ST R1, CurCol	; Update current color value as red
	JSR Paint	; Paint block red
	BRnzp Input

; color block green

Grn	LD R1, G	;Load 'G' ASCII subtrahend
	AND R3, R0, R2
	ADD R3, R3, R1	; Convert character to uppercase ASCII and
	BRnp Blu	; check for a character match
	LD R1, GREEN	; Load value for green into R1
	ST R1, CurCol	; Update current color value as green
	JSR Paint	; Paint block green
	BRnzp Input	

; color block blue

Blu	LD R1, B	; Load 'B' ASCII subtrahend
	AND R3, R0, R2
	ADD R3, R3, R1	; Convert character to uppercase ASCII and
	BRnp Yel	; check for a character match
	LD R1, BLUE	; Load value for blue into R1
	ST R1, CurCol	; Update current color value as blue
	JSR Paint	; Paint block blue
	BRnzp Input

; color block yellow

Yel	LD R1, Y	; Load 'Y' ASCII subtrahend
	AND R3, R0, R2
	ADD R3, R3, R1	; Convert character to uppercase ASCII and
	BRnp Wht	; check for a character match
	LD R1, YELLOW	; Load value for yellow into R1
	ST R1, CurCol	; Update current color value as yellow
	JSR Paint	; Paint block yellow
	BRnzp Input

; color block white

Wht	LD R1, SP	; Load SPACE ASCII subtrahend
	ADD R3, R0, R1
	BRnp Return	; Check for an ASCII character match
	LD R1, WHITE	; Load value for white into R1
	ST R1, CurCol	; Update current color value as white
	JSR Paint	; Paint block white
	BRnzp Input


;----------------------------
; Escape methods
; ----------------
; Verify if key pressed
; Perform escape method if so
;----------------------------

; clear screen and reposition box to center

Return	LD R1, ENTER	; Load RETURN ASCII subtrahend
	ADD R3, R0, R1
	BRnp Quit	; Check for an ASCII character match
	JSR InitBlk	; Paint screen black and restore original block

; halt program execution

Quit	LD R1, Q	; Load 'Q' ASCII subtrahend
	AND R3, R0, R2
	ADD R3, R3, R1	; Convert charaacter to uppercase ASCII and
	BRnp Input	; check for a character match
	HALT		; Halt program execution




; SUBROUTINES
;=============

;------------------------------------
; Paint:
; ------
; Subroutine to paint box onto screen
; Color should be listed in R1
;------------------------------------

Paint	AND R4, R4, 0	
	ADD R4, R4, 8	; Set "rows to color" loop counter to 8
	LD  R0, BoxPtr	; Loads upper leftmost box pixel pointer
	LD  R3, RowDTst	; Loads row length
	AND R2, R2, 0	
Paint1	ADD R2, R2, 8	; Set "pixels to color" loop counter to 8
	ST  R0, TempPt	; Pointer to current leftmost pixel is stored
RowCol  STR R1, R0, 0 	; Pixel is colored
	ADD R0, R0, 1	; The video memory pointer is incremented
	ADD R2, R2, -1	; Amount of pixels to color is decremented
	BRp RowCol	; Checks if pixels are left to be colored		
	LD  R0, TempPt	; Loads the leftmost pixel pointer
	ADD R0, R0, R3	; Moves the pixel pointer one pixel down
	ADD R4, R4, -1	; Amount of rows to color is decremented
	BRp Paint1 	; Checks if rows are left to be colored		
	RET


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BTst 	.FILL x0900	; Bottom edge collision test addend
TTst	.FILL x3C88	; Top edge collision test addend
BLACK  	.FILL x0000	; RGB value for Black
VideoB 	.FILL xC000	; First video pixel memory pointer
BoxInit .FILL xDF40	; Starting upper left corner of block
EndPx	.FILL x0201	; Last video pixel test addend
BoxPtr 	.FILL xDE40	; Current location of upper left block pixel
MovUp	.FILL xFC00	; Pixel offset (up 8 rows)
MovDwn 	.FILL x0400	; Pixel offset (down 8 rows)
RowUTst	.FILL xFF80	; Pixel offset (up 1 row)
RowDTst	.FILL x0080	; Pixel offset (down 1 row)
UpprCs 	.FILL xFFDF	; Uppercase "AND" bitmask
RED	.FILL x7C00	; RGB value for Red
GREEN	.FILL x03E0	; RGB value for Green
BLUE	.FILL x001F	; RGB value for Blue
YELLOW	.FILL x7FE0	; RGB value for Yellow
WHITE	.FILL x7FFF	; RGB value for White
CurCol	.FILL x0000	; Current block color storage
W	.FILL xFFA9	; 'W' ASCII 2's comp negation
A	.FILL xFFBF	; 'A' ASCII 2's comp negation
S	.FILL xFFAD	; 'S' ASCII 2's comp negation
D	.FILL xFFBC	; 'D' ASCII 2's comp negation
R	.FILL xFFAE 	; 'R' ASCII 2's comp negation
G	.FILL xFFB9	; 'G' ASCII 2's comp negation
B	.FILL xFFBE	; 'B' ASCII 2's comp negation
Y	.FILL xFFA7	; 'Y' ASCII 2's comp negation
SP	.FILL xFFE0	; 'SP' ASCII 2's comp negation
ENTER	.FILL xFFF6	; 'RETURN' ASCII 2's comp negation
Q	.FILL xFFAF	; 'Q' ASCII 2's comp negation
TempPt	.FILL x0000	; BoxPtr temp storage for Paint subroutine
	.END
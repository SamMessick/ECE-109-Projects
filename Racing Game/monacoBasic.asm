;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;	ECE 109 001
;	Samuel Messick EE/CPE
;
;	Program Assignment 3
;
;	Version 1.0
;	Due 4/27/2017
;	Last Edit 4/11/2017
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
;	W/w: move block 8 pixel rows up
; 	A/a: move black 8 pixel columns left
; 	S/s: move block 8 pixel rows down
;	D/d: move block 8 pixel rows right
; 	R/r: color block red
; 	G/g: color block green
; 	B/b: color block blue
; 	Y/y: color block yellow
;	space: color block white
;	return: clear the screen/return box
;		to starting line
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

	JSR InitBlk
	LD R1, WHITE	; Load value for white into R1
	ST R1, CurCol	; Saves current color value
	LD R0, CarInit	
	ST R0, CarPtr	; Load and store block pointer
	JSR Paint	; Add box to screen
	JSR AddFns	; Add environment to screen


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
		LD R1, CarPtr
	UTest	ADD R2, R0, R1	; Check if the box is at or below
		BRnz Input	; the top video edge

UMove	LD R1, BLACK	; Load value for black into R1
	JSR Paint	; Clear block
	LD R0, MovUp	
	LD R1, CarPtr	; Load current block location
	ADD R1, R1, R0	; and offset 8 rows up
	ST R1, CarPtr	; Update block pointer
	LD R1, CurCol	; Load preexisting block color
	JSR Paint	; and restore block color
	JSR ColDet	; Check for pylon collision
	JSR AddFns	; Update Environment
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
		LD R1, CarPtr
		LD R2, LineDwn
	LTest	ADD R3, R1, R0 	; Check if video pointer is at or right of left edge
		BRz Input	; Video pointer is at left edge
		BRp LMove 	; Video pointer is right of left edge
		ADD R1, R2, R1	; Increase projected video pointer by one row
		BRnzp LTest	; Repeat Collision Detection Test

LMove	LD R1, BLACK	; Load value for black into R1
	JSR Paint	; Clear block
	LD R1, CarPtr	; Load current block location
	ADD R1, R1, -8	; and offset 8 pixels left
	ST R1, CarPtr	; Update block pointer
	LD R1, CurCol	; Load preexisting block color
	JSR Paint	; and restore block color
	JSR ColDet	; Check for pylon collision
	JSR LapChk	; Check if car has passed finish line
	JSR AddFns	; Update Environment
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
		LD R1, CarPtr
	DTest	ADD R2, R0, R1	; Check if the box is at or higher
		BRzp Input	; than the bottom video edge

DMove	LD R1, BLACK	; Load value for black into R1
	JSR Paint	; Clear block
	LD R0, MovDwn
	LD R1, CarPtr	; Load current block location
	ADD R1, R1, R0	; and offset 8 rows down
	ST R1, CarPtr	; Update block pointer
	LD R1, CurCol	; Load preexisting block color
	JSR Paint	; and restore block color
	JSR ColDet	; Check for pylon collision
	JSR AddFns	; Update Environment
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
		LD R1, CarPtr
		LD R2, LineUp
	RTest	ADD R3, R1, R0	; Check if video pointer is at or left of right edge
		BRz Input	; Video pointer is at right edge
		BRn RMove	; Video pointer is left of right edge
		ADD R1, R1, R2	; Decrease projected video pointer by one row
		BRnzp RTest	; Repeat Collision Detection Test

RMove	LD R1, BLACK	; Load value for black into R1
	JSR Paint	; Clear block
	LD R1, CarPtr	; Load current block location 
	ADD R1, R1, 8	; and offset 8 pixels right
	ST R1, CarPtr	; Update block pointer
	LD R1, CurCol	; Load preexisting block color
	JSR Paint	; and restore block color
	JSR ColDet	; Check for pylon collision
	JSR AddFns	; Update Environment
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
; InitBlk
; -------
; Subroutine to clear screen
;------------------------------------

InitBlk	LD R0, BLACK	; Loads value for black into R0
	LD R1, VideoB	; Loads 1st pixel video pointer
	LD R2, EndPx	; Loads addend test for last pixel on screen
ColBlak	STR R0, R1, 0	; Colors current pixel black
	ADD R1, R1, 1	; Increments video pointer
	ADD R3, R2, R1	
	BRn ColBlak	; Tests if current pixel is beyond screen bounds
	RET

;------------------------------------
; Paint:
; ------
; Subroutine to paint box onto screen
; Color should be listed in R1
;------------------------------------

Paint	AND R4, R4, 0	
	ADD R4, R4, 8	; Set "rows to color" loop counter to 8
	LD  R0, CarPtr	; Loads upper leftmost car pixel pointer
	LD  R3, LineDwn	; Loads row length
	AND R2, R2, 0	
Paint1	ADD R2, R2, 8	; Set "pixels to color" loop counter to 8
	ST  R0, TempPt	; Pointer to current leftmost pixel is stored
RowCol  STR R1, R0, 0 	; Pixel is colored
	ADD R0, R0, 1	; Increment video memory pointer
	ADD R2, R2, -1	; Amount of pixels to color is decremented
	BRp RowCol	; Checks if pixels are left to be colored		
	LD  R0, TempPt	; Loads the leftmost pixel pointer
	ADD R0, R0, R3	; Moves the pixel pointer one pixel down
	ADD R4, R4, -1	; Amount of rows to color is decremented
	BRp Paint1 	; Checks if rows are left to be colored		
	RET

;----------------------
; Environment Update
; ------------------
; Adds 16 orage pylons,
; from pylon array, and 
; finish line to screen
;----------------------

; Adds finish line

AddFns	AND R0, R0, 0	
	ADD R0, R0, 8	
	ADD R0, R0, R0	; Load 16 into R0 counter
	LD R1, Pyl9	; Load starting pixel pointer
	LD R2, WHITE	; Load color value for white
	LD R4, LineDwn	; Load row offset
PtFns	STR R2, R1, 0	; Color starting pixel pointer
	ADD R1, R1, R3	; Offset pixel pointer one row
	ADD R0, R0, -1	; Decrement R0 counter
	BRp PtFns	; Check if counter is zero

; Add pylons to screen

AddPyl	ADD R0, R0, 8	
	ADD R0, R0, R0	; Load 16 into R0 counter
	LEA R1, Pyl1	; Load pointer to 1st pylon address
PtPyl	LDR R2, R1, 0	; Load 1st pylon address into R2

	LD  R3, ORANGE	; Load color value for orange
	STR R3, R2, 0	; Color pylon center orange
	STR R3, R2, -1	; Color left pylon pixel orange
	STR R3, R2, 1	; Color right pylon pixel orange
	LD  R4, LineUp	
	ADD R5, R2, R4	; Create pointer to one pixel row above pylon
	STR R3, R5, 0	; Color upper pylon pixel orange
	LD  R4, LineDwn
	ADD R5, R2, R4	; Create pointer to one pixel row below pylon
	STR R3, R5, 0	; Color lower pylon pixel orange

	ADD R1, R1, 1	; Increment pylon address pointer
	ADD R0, R0, -1	; Decrement R0 counter
	BRp PtPyl	; Check if counter is zero
	RET

;--------------------------
; Pylon Collision Detection
; -------------------------
; Checks if car has collided
; with nearby pylon
;--------------------------

ColDet	LEA R1, Pyl1	; Load pointer to pylon array
	AND R5, R5, 0	
	ADD R5, R5, 8	
	ADD R5, R5, R5	; Load 16 into pylon counter
	AND R4, R4, 0	
PylChk	ADD R4, R4, 8	; Set "rows to check" loop counter to 8
	LD  R0, CarPtr	; Loads upper leftmost car pixel pointer
	LD  R3, LineDwn	; Loads row length
	LDR R2, R1, 0	; Load pylon address into R2
	NOT R2, R2
	ADD R2, R2, 1
	AND R6, R6, 0	
Check1	ADD R6, R6, 8	; Set "pixels to check" loop counter to 8
	ST  R0, TempPt	; Pointer to current leftmost pixel is stored
RowChk	ST  R0, TempPt1	; Store video memory testing value
	ADD R0, R2, R0	
	BRz Lose	; Check if testing value and pylon pointer match
	LD R0, TempPt1	; Load tested video memory value  
	ADD R0, R0, 1	; Increment video memory pointer
	ADD R6, R6, -1	; Amount of pixels to color is decremented
	BRp RowCHK	; Checks if pixels are left to be colored		
	LD  R0, TempPt	; Loads the leftmost pixel pointer
	ADD R0, R0, R3	; Moves the pixel pointer one pixel down
	ADD R4, R4, -1	; Amount of rows to color is decremented
	BRp Check1 	; Checks if rows are left to be colored	
	ADD R1, R1, 1	; Increment pylon address pointer
	ADD R5, R5, -1	; Decrement pylon counter
	BRp PylChk
	RET
Lose	LEA R0, LoseSeq
	PUTS		; Print losing sequence
	LD R0, LF
	OUT
	OUT
	OUT		; Print 3 linefeeds
	HALT

;--------------------------
; Lap Finish Detection
; --------------------
; Checks if car has passed
; finish line after start
;--------------------------

LapChk  LD R0, CarInit	; Load initial car position
	LD R1, CarPtr	; Load current car position
	NOT R1, R1
	ADD R1, R1, 0	; Negate current car position
	ADD R0, R0, R1	; Add negated position to initial
	BRnp Input	; and check if zero
	HALT

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

WHITE	.FILL	x7FFF	; RGB value for White
CarInit	.FILL	xF738	; Starting upper left corner of car
CarPtr	.FILL	x0000	; Current location of upper left corner of car
BLACK	.FILL	x0000	; RGB value for black
VideoB	.FILL	xC000	; First video pixel memory pointer
EndPx	.FILL	x0201	; Last video pixel test addend
BTst	.FILL	x0900	; Bottom edge collision test addend
TTst	.FILL	x3C88	; Top edge collision test addend
UpprCs	.FILL	xFFDF	; Uppercase "AND" bitmask
W	.FILL 	xFFA9	; 'W' ASCII 2's comp negation
MovUp	.FILL 	xFC00	; Pixel offset (up 8 rows)
A	.FILL   xFFBF	; 'A' ASCII 2's comp negation
S	.FILL   xFFAD	; 'S' ASCII 2's comp negation
D	.FILL   xFFBC	; 'D' ASCII 2's comp negation
MovDwn	.FILL	x0400	; Pixel offset (down 8 rows)
R	.FILL   xFFAE 	; 'R' ASCII 2's comp negation
RED	.FILL	x7C00	; RGB value for Red
CurCol	.FILL	x0000	; Current car color storage
G	.FILL	xFFB9	; 'G' ASCII 2's comp negation
GREEN	.FILL	x03E0	; RGB value for Green
B	.FILL	xFFBE	; 'B' ASCII 2's comp negation
BLUE	.FILL	x001F	; RGB value for Blue
Y	.FILL	xFFA7	; 'Y' ASCII 2's comp negation
YELLOW	.FILL	x7FE0	; RGB value for Yellow
SP	.FILL	xFFE0	; 'SP' ASCII 2's comp negation
ENTER	.FILL	xFFF6	; 'RETURN' ASCII 2's comp negation
Q	.FILL	xFFAF	; 'Q' ASCII 2's comp negation
TempPt	.FILL	x0000	; CarPtr temp storage for Paint and ColDet subroutines
TempPt1	.FILL	x0000	; CarPtr test value temp storage
ORANGE	.FILL	x7DE0	; RGB value for Orange
LineUp	.FILL	xFF80	; Pixel offset (up 1 row)
LineDwn	.FILL	x0080	; Pixel offset (down 1 row)
LoseSeq	.STRINGZ "CRASH!! GAME OVER!!!"	; Losing sequence message
LF	.FILL	x000A	; Linefeed character
Pyl1	.FILL	xC081	; Location of 1st pylon
Pyl2	.FILL	xDF01	; Location of 2nd pylon
Pyl3	.FILL	xFD01	; Location of 3rd pylon
Pyl4	.FILL	xC892	; Location of 4th pylon
Pyl5	.FILL	xDF12	; Location of 5th pylon
Pyl6	.FILL	xF512	; Location of 6th pylon
Pyl7	.FILL	xC0C0	; Location of 7th pylon
Pyl8	.FILL	xC8C0	; Location of 8th pylon
Pyl9	.FILL	xF540	; Top of finish line/9th pylon
Pyl10	.FILL	xFD40	; Location of 10th pylon
Pyl11	.FILL	xC8E9	; Location of 11th pylon
Pyl12	.FILL	xDF69	; Location of 12th pylon
Pyl13	.FILL	xF569	; Location of 13th pylon
Pyl14	.FILL	xC0FE	; Location of 14th pylon
Pyl15	.FILL	xDF7E	; Location of 15th pylon
Pyl16	.FILL	xFD7E	; Location of 16th pylon

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	.END
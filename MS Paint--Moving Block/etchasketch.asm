;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	Samuel Messick EE/CPE
;
;	Program Assignment 2
;
;	Version 1.1
;	Last Edit 3/27/2017
;_________________________________________
;
; Draws a single-colored 8px by 8px box 
; User can recolor and move box based on
; keyboard input. 
; This version does not erase the box as 
; is moves about the screen, and the user
; is able to change the size of the box freely;
; 100+ colors available via the "fun" button
; and standard RGB options
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
;	F/f: color block next "fun" color
;	backspace: color block white
;	space: color block black
;	return: clear the screen
;	Q/q: quit program
;	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	.orig x3000

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Init:
; -----
; Initializes g.p.r's,
; paints screen black
; paints white block at 
; (64, 62)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Init	AND R0, R0, 0	;\
	AND R1, R1, 0	; \
	AND R2, R2, 0	;  \
	AND R3, R3, 0	;   -Zero the g.p.r's
	AND R4, R4, 0	;  /
	AND R5, R5, 0	; /
	AND R6, R6, 0	;/

StScrn	JSR InitWht
	LD R1, BLACK	; Load white color value into R1
	ST R1, CurCol	; Saves current color value
	LD R0, BoxInit
	ST R0, BoxPtr	; Reset box pointer to middle pixel
	JSR Paint	; Add box to screen

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Input:
; ------
; Awaits user input,
; recolors or moves block
; based on key pressed
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Input	GETC		; Recieve user key input

; WASD Movement methods.
; Include collision detectors

Up	LD R1, W
	LD R2, UpprCs
	AND R3, R0, R2  
	ADD R3, R3, R1
	BRnp Left
UPCol 	LD R0, TTst
	LD R1, BoxSize
	ADD R0, R0, R1
	LD R1, BoxPtr
UTest	ADD R2, R0, R1	; Checks if the box is at or below
	BRnz Input	; the top video edge
UMove	LD R0, RowUp
	LD R1, BoxPtr
	ADD R1, R1, R0
	ST R1, BoxPtr
	LD R1, CurCol
	JSR Paint
	BRnzp Input

Left	LD R1, A
	AND R3, R0, R2
	ADD R3, R3, R1
	BRnp Down
LftCol  LD R0, BTst
	LD R1, BoxSize
	LD R2, RowDwn
MultD	ADD R3, R2, R2
	ADD R1, R1, -1
	BRpMultD
	NOT R3, R3
	ADD R3, R3, 1
	ADD R0, R0, R3
	LD R1, BoxPtr
	LD R2, RowDwn
LTest	ADD R3, R1, R0
	BRz Input
	BRp LMove 
	ADD R1, R2, R1
	BRnzp LTest
LMove	LD R1, BoxPtr
	ADD R1, R1, -1
	ST R1, BoxPtr
	LD R1, CurCol
	JSR Paint
	BRnzp Input

Down	LD R1, S
	AND R3, R0, R2
	ADD R3, R3, R1
	BRnp Right
DwnCol  LD R0, BTst
	LD R1, BoxSize
	LD R2, RowDwn
MultD	ADD R3, R2, R2
	ADD R1, R1, -1
	BRp  MultD
	ADD R0, R0, R3
	LD R1, BoxPtr
DTest	ADD R2, R0, R1	; Checks if the box is at or higher
	BRzp Input	; than the bottom video edge
DMove	LD R0, RowDwn
	LD R1, BoxPtr
	ADD R1, R1, R0
	ST R1, BoxPtr
	LD R1, CurCol
	JSR Paint
	BRnzp Input

Right	LD R1, D
	AND R3, R0, R2
	ADD R3, R3, R1
	BRnp Rd
RgtCol  LD R0, TTst
	LD R1, BoxSize
	ADD R0, R0, R1
	LD R1, BoxPtr
	LD R2, RowUp
RTest	ADD R3, R1, R0
	BRz Input
	BRn RMove
	ADD R1, R1, R2
	BRnzp RTest
RMove	LD R1, BoxPtr
	ADD R1, R1, 1
	ST R1, BoxPtr
	LD R1, CurCol
	JSR Paint
	BRnzp Input

; Coloring methods


Rd	LD R1, R
	AND R3, R0, R2
	ADD R3, R3, R1
	BRnp Grn
	LD R1, RED
	ST R1, CurCol
	JSR Paint
	BRnzp Input

Grn	LD R1, G
	AND R3, R0, R2
	ADD R3, R3, R1
	BRnp Blu
	LD R1, GREEN
	ST R1, CurCol
	JSR Paint
	BRnzp Input

Blu	LD R1, B
	AND R3, R0, R2
	ADD R3, R3, R1
	BRnp Yel
	LD R1, BLUE
	ST R1, CurCol
	JSR Paint
	BRnzp Input

Yel	LD R1, Y
	AND R3, R0, R2
	ADD R3, R3, R1
	BRnp Blk
	LD R1, YELLOW
	ST R1, CurCol
	JSR Paint
	BRnzp Input

Blk	LD R1, SP
	ADD R3, R0, R1
	BRnp Clr
	LD R1, BLACK
	ST R1, CurCol
	JSR Paint
	BRnzp Input

Clr	LD R1, BKSP
	ADD R3, R0, R1
	BRnp Return
	LD R1, BLACK
	JSR Paint
	LD R1, WHITE
	ST R1, CurCol
	JSR Paint
	BRnzp Input

Return	LD R1, ENTER
	ADD R3, R0, R1
	BRnp RandomF
	JSR InitWht
	LD R1, CurCol
	JSR Paint

RandomF	LD R1, F
	AND R3, R0, R2
	ADD R3, R3, R1
	BRnp RandomB
	LD R1, FuNCol
	LD R2, ForwCol
	ADD R1, R1, R2
	ST R1, FuNCol
	ST R1, CurCol
	JSR Paint
	BRnzp Input

RandomB	LD R1, V
	AND R3, R0, R2
	ADD R3, R3, R1
	BRnp Quit
	LD R1, FuNCol
	LD R2, BackCol
	ADD R1, R1, R2
	ST R1, FuNCol
	ST R1, CurCol
	JSR Paint
	BRnzp Input

Quit	LD R1, Q
	AND R3, R0, R2
	ADD R3, R3, R1
	BRnp ChgSize
	HALT

ChgSize LD R1, NINE
	LD R2, ZERO
	ADD R3, R0, R1
	BRp Input
	ADD R3, R0, R2
	BRn Input
	ST R3, BoxSize
	LD R1, CurCol
	JSR Paint
	BRnzp Input

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Paint:
; ------
; Subroutine to paint box onto screen
; Color should be listed in R1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Paint	LD  R5, BoxSize	; Set "rows to color" loop counter to 8
	LD  R2, BoxPtr	; Loads upper leftmost box pixel pointer
	LD  R4, RowDwn
Paint1	LD  R3, BoxSize	; Set "pixels to color" loop counter to 8
	ST  R2, TempPt	; Pointer to current leftmost pixel is stored
RowCol  STR R1, R2, 0 	; Pixel is colored
	ADD R2, R2, 1	; The video memory pointer is incremented
	ADD R3, R3, -1	; Amount of pixels to color is decremented
	BRp RowCol	; Checks if pixels are left to be colored		
	LD  R2, TempPt	; Loads the leftmost pixel pointer
	ADD R2, R2, R4	; Moves the pixel pointer one pixel down
	ADD R5, R5, -1	; Amount of rows to color is decremented
	BRp Paint1 	; Checks if rows are left to be colored		
	RET

; Clears screen

InitWht	LD R0, WHITE
	LD R1, VideoB
	LD R2, EndPx
ColWhit	STR R0, R1, 0
	ADD R1, R1, 1
	ADD R3, R2, R1
	BRn ColWhit
	RET

BTst 	.FILL x900    ;600	
TTst	.FILL x3F80   ;3F90
BLACK  	.FILL x0000
VideoB 	.FILL xC000
BoxInit .FILL xDF40
BoxSize .FILL x0008
EndPx	.FILL x0201
BoxPtr 	.FILL xDE40
RowCt  	.FILL #124
RowUp	.FILL xFF80
RowDwn 	.FILL x0080
UpprCs 	.FILL xFFDF
RED	.FILL x7C00
GREEN	.FILL x03E0
BLUE	.FILL x001F
YELLOW	.FILL x7FE0
WHITE	.FILL x7FFF
CurCol	.FILL x0000
W	.FILL xFFA9
A	.FILL xFFBF
S	.FILL xFFAD
D	.FILL xFFBC
R	.FILL xFFAE 
G	.FILL xFFB9
B	.FILL xFFBE
Y	.FILL xFFA7
SP	.FILL xFFE0
BKSP	.FILL xFFF8
F	.FILL xFFBA
V	.FILL xFFAA
FuNCol	.FILL x51F9
ForwCol	.FILL x028F
BackCol	.FILL xFD71
ENTER	.FILL xFFF6
Q	.FILL xFFAF
NINE	.FILL xFFC7
ZERO	.FILL xFFD0
TempPt	.FILL x0000
	.END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;    pikachu.asm   Sam Messick  4/13/17
;
;   Icon colors per pixel for an 8x8 pikachu icon
;
;

		.orig x4000
		.FILL x2D6B
		.FILL x0000
		.FILL x0000
		.FILL x0000
		.FILL x0000
		.FILL x2D6B
		.FILL x2D6B
		.FILL x0000

		.FILL x7DED
		.FILL x0000
		.FILL x0000
		.FILL x0000
		.FILL x7DE0
		.FILL x7FED
		.FILL x0000
		.FILL x0000

		.FILL x7DE0
		.FILL x7FED
		.FILL x7FED
		.FILL x7FED
		.FILL x7FED
		.FILL x0000
		.FILL x0000
		.FILL x0000

		.FILL x0000
		.FILL x7FED
		.FILL x7FED
		.FILL x0000
		.FILL x7FED
		.FILL x0000
		.FILL x7DE0
		.FILL x7DE0

		.FILL x7DE0
		.FILL x7FED
		.FILL x7FED
		.FILL x7FED
		.FILL x7C00
		.FILL x0000
		.FILL x7DE0
		.FILL x7DE0

		.FILL x0000
		.FILL x7DE0
		.FILL x7DE0
		.FILL x7DE0
		.FILL x7FED
		.FILL x0000
		.FILL x50A5
		.FILL x0000

		.FILL x0000
		.FILL x7FED
		.FILL x7DE0		
		.FILL x7FED
		.FILL x7DE0
		.FILL x7FED
		.FILL x50A5
		.FILL x0000

		.FILL x0000
		.FILL x7DE0
		.FILL x50A5
		.FILL x50A5
		.FILL x7DE0
		.FILL x7FED
		.FILL x0000
		.FILL x0000

		.END	




;RED	.FILL	x7C05	; RGB value for Red
;GREEN	.FILL	x03E5	; RGB value for Green
;BLUE	.FILL	x001D	; RGB value for Blue
;YELLOW	.FILL	x7FED	; RGB value for Yellow
;ORANGE	.FILL	x7DE0	; RGB value for Orange
;GRAY	.FILL	x2D6B	; RGB value for Gray
;PURPLE	.FILL	x7C1F	; RGB value for purple
;BROWN	.FILL 	x50A5	; RGB value for brown
;APRICOT.FILL 	x7F33	; RGB value for apricot
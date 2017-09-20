;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This program prints "Hello World"
;
; Author: Sam Messick
; Version 1.0
; Last Edited: 3/20/2017
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		.ORIG x3000

LEA R0, String
PUTS
HALT

String .STRINGZ "Hello World!"

		.END
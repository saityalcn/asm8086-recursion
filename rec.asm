mycode SEGMENT PARA 'code'
    ASSUME CS: mycode

   DNUM PROC FAR
		PUSH BP
		PUSH AX
		PUSH BX
		MOV BP, SP
		
		CMP WORD PTR [BP+10], 0
		JE RZERO
		
		CMP WORD PTR [BP+10], 1
		JE RONE 
		
		CMP WORD PTR [BP+10], 2
		JE RONE	
		
		
		XOR AX,AX
		PUSH AX		
		MOV AX, [BP+10]
		DEC AX
		PUSH AX	
		
		CALL DNUM
		
		POP AX
		POP AX		
		
		XOR BX, BX
		PUSH BX		; push 0 for return
		PUSH AX		; D(n-1) 
		
		CALL DNUM
		
		POP AX	; parameter
		POP BX 	; D(D(n-1))
		
		MOV BP, SP
		ADD WORD PTR[BP+12], BX		; 0+D(D(n-1))
		MOV AX, [BP+10]
		
		XOR BX, BX
		PUSH BX		; push 0 for return
		SUB AX, 2	; calc n-2 for D(n-2)
		PUSH AX		; param
		
		CALL DNUM
		
		POP AX
		POP BX		; D(n-2) return
		
		MOV BP, SP		
		MOV AX, [BP+10]	
		DEC AX
		SUB AX,BX
		
		XOR BX,BX
		PUSH BX		; 0 for return 
		PUSH AX 	; passing param
		
		CALL DNUM
		
		POP AX
		POP AX		; D(n-1-D(n-2)) 

		ADD WORD PTR[BP+12], AX 	; stack D(D(n-1)) + AX D(n-1-D(n-2))
		JMP SON
		
	RZERO:
		MOV WORD PTR [BP+12], 0		; return 0	
		JMP SON
	
	RONE:
		MOV WORD PTR [BP+12], 1		; return 1
	
	SON:
		POP BX
		POP AX
		POP BP
		RETF
		
    DNUM ENDP
	
mycode ENDS
	
stacksg SEGMENT PARA STACK 'stack'
		DW 80 DUP(?)
stacksg ENDS
datasg SEGMENT PARA 'data'
	sayi DW 10
datasg ENDS

codesg SEGMENT PARA 'code'
	ASSUME CS: codesg, SS: stacksg, DS: datasg

	PRINTINT PROC NEAR 
		PUSH AX
		PUSH DX
		PUSH BX
		
		XOR DX, DX
		MOV BX, 100
		DIV BX
		MOV BX, DX
		
		ADD AX, 30H	; 0 ASCII: 30H
		MOV DX, AX
		
		CMP DX, 0
		MOV AH, 2
		INT 21H	
		
		XOR DX, DX
		MOV AX, BX
		MOV BX, 10
		DIV BX
		MOV BX, DX
		
		ADD AX, 30H	; 0 ASCII: 30H
		MOV DX, AX

		MOV AH, 2
		INT 21H	
		
		MOV AX, BX
		ADD AX, 30H	; 0 ASCII: 30H
		MOV DX, AX	

		MOV AH, 2
		INT 21H	
		
		POP BX
		POP DX
		POP AX
		RET
	PRINTINT ENDP
	
	
	MAIN PROC FAR
		PUSH DS
		XOR AX, AX
		PUSH AX
		MOV AX, datasg
		MOV DS, AX
		
		XOR AX,AX
		PUSH AX		; return 
		MOV AX, sayi
		PUSH AX
		CALL FAR PTR DNUM
		POP AX
		POP AX
		CALL PRINTINT
	
		RETF
	MAIN ENDP
	
codesg ENDS

    END MAIN
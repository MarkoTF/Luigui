STACK SEGMENT STACK
    DB 64 DUP(?) ;Tama?o de la pila
STACK ENDS

DATOS SEGMENT
	CADENAGRACIAS DB 10,13,"GRACIAS, VUELVA PRONTO!!!", 01H, 10,13,"$"
    CADENA DB "Buenas, usted sabe que dia es? [s/n] --> ", "$"
    CADENAMALA DB 10,13,10,13,"Usted a sido afectado severamente por la cuarentena", 10,13,"$"
    CADENABUENA DB 10,13,"Felicidades, usted ha aguantado bien la cuarentena", 10,13,"$"
    ARRAY DB 53H, 53H, 40H, 53H, 40H
DATOS ENDS


CODIGO SEGMENT
    ASSUME CS:CODIGO,DS:DATOS,SS:STACK

    COLORES MACRO COLOR ;MACRO QUE RECIBE UN PARAMETRO
		PUSH AX ;PUSH SALVA EL CONTEXTO
		PUSH BX ;METIENDO LOS VALORES DE LOS
		PUSH CX
		PUSH DX

		;CABIAR cOLOR
       	MOV AX,0600H
       	;MOV BH,53H ;fondo morado(5), letra azul(0)
       	MOV BH,COLOR ;fondo morado(5), letra azul(0)
       	MOV CX,0000H ;de pOSISCIÓN IZQUIERDA SUPERIOR
       	MOV DX,184FH ;a posición derecha inferior
       	INT 10H

       	;FIJAR CURSOR EN POSISCION 00:00
       	MOV AH,02h ;SOLICITOD DE CAMBIO DE POSISCION
       	MOV BX,00 ;PAGINA NUMERO 0
       	MOV DX,0000 ;HILERA 0, COLUMNA 0
       	INT 10H

		POP DX ;ANTES DE SALIR DEL PROCEDIMIENTO
		POP CX ;DEBERAS REGRESAR LOS VALORES
		POP BX ;REGISTRO AL ORDEN INVERSO AL
		POP AX ;QUE ENTRARON A LA PILA CON POP
	ENDM ;FINALIZA LA MACRO



MIPROC PROC FAR
    PUSH DS 
    SUB AX,AX ;PARA RESTA
    PUSH AX
    MOV AX,DATOS
    MOV DS,AX
    
    LEA DX, CADENA ;aQU? COMIENZA MI VERDADERO PROGRAMA
    MOV AH, 09H
    INT 21H

    ;LEE LA RESPUESTA
    MOV AH, 07H
    INT 21H

    ;iMPRIME LA RESPUESTA
    MOV AH, 02h
    MOV DL, AL
    INT 21H

    
    ;sALTA SI ES "n"
    CMP RES, "s"
    JE L1

    CMP RES, "r"
    JE L2

    CMP RES, "m"
    JE L3

    CMP RES, "d"
    JE L4

    
    MOV SI, 00H

    ;SALTO SUMA
    L1:	
        ADD BL, VAR1
        MOV AH, 09H

        LEA DX, RADD
        INT 21H
        MOV DL, BL
        ADD DL, 30H
        MOV AH, 02h
        INT 21H

        JA SALIR;SALIR

    ;SALTO RESTA
    L2:
    	MOV AH,2CH
    	INT 21H

    	CMP AL, DH
    	JB L1 ;salta si dh es mayor que al

    	LOOP L3

    ;SALTO MULTIPLICACIÓN
    L3:
    	CALL BIENECHO

    	CMP SI, 04H
    	JA SALIR;SALIR

    ;sALTA DIVICIÓN
    L4:

    	COLORES 0FH ;Color de fondo negro, el color de letra blanco
    	CALL MALECHO

    ;SALTO SALIR
    SALIR:
    	;CADENA DE GRACIAS
    	MOV AH, 09H
		LEA DX, CADENAGRACIAS
		INT 21H
    
    	RET ;PARA RETORNAR EL CONTROL
    
MIPROC ENDP ;CIERRA MIPRC FAR


MALECHO PROC NEAR 
		PUSH AX 
		PUSH BX 
		PUSH CS 
		PUSH DX

		MOV AH, 09H
		LEA DX, CADENAMALA
		INT 21H

		POP DX 
		POP CX 
		POP BX 
		POP AX 
		RET 
MALECHO ENDP 

BIENECHO PROC NEAR 
		PUSH AX 
		PUSH BX 
		PUSH CS 
		PUSH DX

		MOV AH, 09H
		LEA DX, CADENABUENA
		INT 21H

		POP DX 
		POP CX 
		POP BX 
		POP AX 
		RET 
BIENECHO ENDP 


CODIGO ENDS ;CIERRA EL SEGMENTO DE COTIGO
END MIPROC
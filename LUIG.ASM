STACK SEGMENT STACK
    DB 64 DUP(?) ;Tama?o de la pila
STACK ENDS

DATOS SEGMENT
    MSG db 10, 13, "BIENVENIDAD", 01H, 10,13,"$"
    NUM1 db 10, 13, 10, 13 "VALOR NUMERO 1: ", 10,13,"$"
    NUM2 db 10, 13, 10, 13"VALOR NUMERO 2: ",  10,13,"$"
    RES db 10, 13,10,"ELIGE TU OPERADOR: ",  10,13,"$"
    RADD db "SUMA: ",10,"$"
    RSUB db "RESTA: ",10,"$"
    RMUL db "MULTIPLICACION:",10,"$"
    RADD db "DIVICION: ",10,"$"
    RTOTAL db "RESULTADO: ",10,"$"
    VAR1 DB 0
    VAR2 DB 0
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
        MOV CX,0000H ;de pOSISCI?N IZQUIERDA SUPERIOR
        MOV DX,184FH ;a posici?n derecha inferior
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
    CMP AL, "n"
    JE L2

    CMP AL, "s"
    JE L1



    
    MOV SI, 00H
    L1: 
        ;RECUPERAR LA HORA DEL SISTEMA
        MOV AH,2CH
        INT 21H

        ;RECUPERO LOS SEGUNDOS EN "AL"
        INC DH
        MOV AL, DH

        ;INCREMENTO 1 APUNTADOR DEL ARRAY
        INC SI

        CMP SI, 04H
        JA L4;IMPRIMIR CADENA Y SALIR

        ;cAMBIO DE COLOR
        COLORES ARRAY[SI]

    ;CICLO PARA EL TIEMPO
    L3:
        MOV AH,2CH
        INT 21H

        CMP AL, DH
        JB L1 ;salta si dh es mayor que al

        LOOP L3

    L4:
        CALL BIENECHO

        CMP SI, 04H
        JA SALIR;SALIR

    L2:

        COLORES 0FH ;Color de fondo negro, el color de letra blanco
        CALL MALECHO

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
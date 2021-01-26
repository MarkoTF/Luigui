STACK SEGMENT STACK
    DB 64 DUP(?) ;Tama?o de la pila
STACK ENDS

DATOS SEGMENT
    MSJDESPEDIDA DB 10, 10, 13, "HASTA LUEGO","$"
    MSJBIEN DB "BIENVENIDO",10, 13, "$"
    NUM1 DB 10, 13, "VALOR NUMERO 1: ","$"
    NUM2 DB  10, 13, "VALOR NUMERO 2: ","$"
    RES DB 10, 13,10,"ELIGE TU OPERADOR (s = suma,r = resta,m = multiplicacion,d = division, p = potencia): ","$"
    RADD DB 10,10, 13,"SUMA: ","$"
    RSUB DB 10,10, 13,"RESTA: ","$"
    RMUL DB 10,10,10, 13,"MULTIPLICACION: ","$"
    RDIV DB 10,10, 13,"DIVICION: ","$"
    RPOT DB 10,10, 13,"POTENCIA: ","$"
    MJSINVALIDO DB 10,10, 13,"OPCION INCORRECTA ","$"
    OP DB 0
    VAR1 DB 0
    VAR2 DB 0
DATOS ENDS


CODIGO SEGMENT
    ASSUME CS:CODIGO,DS:DATOS,SS:STACK

POTENCIAM MACRO NUMERO, POTENCIA ;MACRO QUE RECIBE UN PARAMETRO
    ;PUSH AX ;PUSH SALVA EL CONTEXTO
    ;PUSH BX ;METIENDO LOS VALORES DE LOS
    ;PUSH CX
    ;PUSH DX

    MOV AL, NUMERO
    MOV OP, AL

    CICLO:
        DEC POTENCIA
        CMP POTENCIA, 0
        JLE FIN

        MOV AL, OP
        MOV BL, NUMERO
        MUL BL
        MOV OP, AL

        LOOP CICLO
    FIN:
        ;RET

    ;POP DX ;ANTES DE SALIR DEL PROCEDIMIENTO
    ;POP CX ;DEBERAS REGRESAR LOS VALORES
    ;POP BX ;REGISTRO AL ORDEN INVERSO AL
    ;POP AX ;QUE ENTRARON A LA PILA CON POP
ENDM ;FINALIZA LA MACRO

MIPROC PROC FAR

    PUSH DS 
    SUB AX,AX ;PARA RESTA
    PUSH AX
    MOV AX,DATOS
    MOV DS,AX

    mov ah,00h
    mov al,03h
    int 10h

    ;*******************MENSAJE DE BIENVENIDA
    mov ah,09h
    lea dx, MSJBIEN
    int 21h
    
    ;**********************
    mov ah,09h
    lea dx, NUM1
    int 21h
    mov ah,01h
    int 21h
    sub al,30h ;restar 30h para obtener el numero
    mov VAR1,al
    
    
    
    ;int 21h
    ;**********************
    mov ah,09h
    lea dx, NUM2
    int 21h
    mov ah,01h
    int 21h
    sub al,30h ;restar 30h para obtener el numero
    mov VAR2,al

    ;mov ah,01h
    
    
    ;**********************
    mov ah,09h
    lea dx, RES
    int 21h
    mov ah,01h
    int 21h
    
    
    
    ;LEE LA RESPUESTA
    MOV AH, 07H
    mov OP,al

    mov bl,VAR2 ;mover a bl

    ;sALTA dependiedo de la respuesta
    CMP OP, "s"
    JE SUMA

    CMP OP, "r"
    JE RESTA

    CMP OP, "m"
    JE MULTIPLICACION

    CMP OP, "d"
    JE DIVICION

    CMP OP, "p"
    JE POTENCIA

    JMP INVALIDO

    
    ;MOV SI, 00H

    ;SALTO SUMA
    SUMA: 
        ADD BL, VAR1
        MOV AH, 09H

        LEA DX, RADD
        INT 21H
        MOV DL, BL
        ADD DL, 30H
        MOV AH, 02h
        INT 21H

        JMP SALIR;SALIR

    ;SALTO RESTA
    RESTA:
        SUB BL, VAR1
        MOV AH, 09H

        LEA DX, RSUB
        INT 21H
        MOV DL, BL
        ADD DL, 30H
        MOV AH, 02h
        INT 21H

        JMP SALIR;SALIR

    ;SALTO MULTIPLICACI?N
    MULTIPLICACION:
        MOV AH, 09H
        LEA DX, RMUL
        INT 21H

        MOV AL, VAR1
        MOV BL, VAR2
        MUL BL
        MOV DL,AL
        ADD DL, 30H
        MOV AH, 02h
        INT 21H

        JMP SALIR;SALIR

    ;sALTO DIVIDIR
    DIVICION:
        
        MOV AH,09h
        LEA DX,RDIV ;desplegar div
        INT 21h
        XOR AX,AX ;limpiamos el registro ax. 
        MOV AL,VAR2
        MOV BL,AL
        MOV AL,VAR1
        DIV BL ; divide AX/BX el resultado lo almacena en AX, el residuo queda en DX
        MOV BL,AL
        MOV DL,BL
        ADD DL,30h
        MOV AH,02h
        INT 21h
        
        
        JMP SALIR;SALIR

    ;POTENCIA
    POTENCIA:
        MOV AH, 09H
        LEA DX, RPOT
        INT 21H

        POTENCIAM VAR1, VAR2

        MOV DL,OP
        ADD DL, 30H
        MOV AH, 02h
        INT 21H

        JMP SALIR;SALIR

    INVALIDO:
        MOV AH, 09H
        LEA DX, MJSINVALIDO
        INT 21H

        JMP SALIR


    ;sALTO SALIR
    SALIR:
        ;CADENA DE GRACIAS
        MOV AH, 09H
        LEA DX, MSJDESPEDIDA
        INT 21H
    
        RET ;PARA RETORNAR EL CONTROL
    
MIPROC ENDP ;CIERRA MIPRC FAR

CODIGO ENDS ;CIERRA EL SEGMENTO DE COTIGO
END MIPROC

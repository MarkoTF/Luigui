STACK SEGMENT STACK
    DB 64 DUP(?) ;Tama?o de la pila
STACK ENDS

DATOS SEGMENT
    MSJDESPEDIDA DB 10, 13, "HASTA LUEGO", 01H, 10,13,"$"
    MSJBIEN DB "BIENVENIDO",10,13,"$"
    NUM1 DB 10, 13, "VALOR NUMERO 1: ", 10,13,"$"
    NUM2 DB  10, 13, "VALOR NUMERO 2: ",  10,13,"$"
    RES DB 10, 13,10,"ELIGE TU OPERADOR (s = suma,r = resta,m = multiplicacion,d = division): ",  10,13,"$"
    RADD DB "SUMA: ",10, 13,"$"
    RSUB DB "RESTA: ",10, 13,"$"
    RMUL DB "MULTIPLICACION:",10,13,"$"
    RDIV DB "DIVICION: ",10,13,"$"
    RTOTAL DB "RESULTADO: ",10,13,"$"
    OP DB 0
    VAR1 DB 0
    VAR2 DB 0
DATOS ENDS


CODIGO SEGMENT
    ASSUME CS:CODIGO,DS:DATOS,SS:STACK

MIPROC PROC FAR

    PUSH DS 
    SUB AX,AX ;PARA RESTA
    PUSH AX
    MOV AX,DATOS
    MOV DS,AX
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
    INT 21H

    ;iMPRIME LA RESPUESTA
    MOV AH, 02h
    MOV DL, AL
    INT 21H

    mov bl,VAR2 ;mover a bl
    int 21h

    ;sALTA SI ES "n"
    CMP OP, "s"
    JE L1

    CMP OP, "r"
    JE L2

    CMP OP, "m"
    JE L3

    CMP OP, "d"
    JE L4

    
    ;MOV SI, 00H

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
        SUB BL, VAR1
        MOV AH, 09H

        LEA DX, RSUB
        INT 21H
        MOV DL, BL
        ADD DL, 30H
        MOV AH, 02h
        INT 21H

        JA SALIR;SALIR

    ;SALTO MULTIPLICACI?N
    L3:
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

        JA SALIR;SALIR

    ;sALTO DIVIDIR
    L4:
        
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
        
        
        JA SALIR;SALIR

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

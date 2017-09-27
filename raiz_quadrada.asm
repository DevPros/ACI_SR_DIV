name "raiz_quadrada"   
             
       
org  100h	


jmp start            

msg             DB  "Introduza o valor que deseja calcular a raiz quadrada: ",'$' 
msgOverFlow     DB  0dh, 0ah, "Overflow $"
msgResultado    DB  0dh, 0ah, "Resultado: $"
resultado       DW  0
resto           DW  0
vDividendo      DB  0, 0, 0, 0, 0
vAuxiliar       DB  0, 0, 0, 0, 0     
ten             DW  10 
twenty          DW  20
hundred         DW  100


start:
        MOV DX, offset msg
        MOV AH, 09h
        INT 21h
       CALL SCAN
        LEA DX, msgResultado
        MOV AH, 09h
        INT 21h 
        MOV cx, 3
pilha_in:
       PUSH cx 
       CALL DIVISAO
        POP cx
        MOV DX, resto
       PUSH DX
       PUSH cx
       CALL COPIA_ARRAYS
        POP cx 
       LOOP pilha_in
        MOV resto, 0
        MOV AX, 0
        MOV CX, 0
        POP BX
primeiro_valor:
        INC CX
        MOV AX, CX
        MUL AX
       CALL verificaDX
        CMP AX, BX
        JNA primeiro_valor
        DEC CX 
        MOV AX, CX
       CALL PRINT_NUM
        MOV resultado, CX
        MOV AX, CX
        MUL AX 
        SUB BX, AX
        MOV resto, BX
        MOV CX, 2  
proximo_valor:
        MOV AX, resto
        MUL hundred
       CALL verificaDX
        POP BX  
        ADD AX, BX
       PUSH CX
        MOV CX, 0
       XCHG AX, BX
procura_valor:
        INC CX
        MOV AX, resultado
        MUL twenty
        ADD AX, CX
        MUL CX
       CALL verificaDX
        CMP AX, BX
        JNA procura_valor
        DEC CX
        MOV AX, CX
       CALL PRINT_NUM
        MOV AX, resultado
        MUL twenty
        ADD AX, CX
        MUL CX
       CALL verificaDX
        SUB BX, AX
        MOV resto, BX
        MOV AX, resultado
        MUL ten
       CALL verificaDX
        ADD AX, CX
        MOV resultado, AX
        POP CX
       LOOP proximo_valor
        MOV AL, '.'
        MOV AH, 0Eh
        INT 10h
        MOV cx, 3
proximo_valor_dec:
        MOV AX, resto
        MUL hundred
       CALL verificaDX
       PUSH CX
        MOV CX, 0
        MOV BX, AX
procura_valor_dec:
        INC CX
        MOV AX, resultado
        MUL twenty
        ADD AX, CX
        MUL CX
       CALL verificaDX
        CMP AX, BX
        JNA procura_valor_dec
        DEC CX
        MOV AX, CX
       CALL PRINT_NUM
        MOV AX, resultado
        MUL twenty
        ADD AX, CX
        MUL CX
       CALL verificaDX
        SUB BX, AX
        MOV resto, BX
        MOV AX, resultado
        MUL ten
       CALL verificaDX
        ADD AX, CX
        MOV resultado, AX
        POP CX
       LOOP proximo_valor_dec       
        RET   
 
verificaDX:
        CMP dx,0
        JNZ Overflow
        RET
overflow:
        MOV DX, offset msgOverFlow
        MOV AH, 9
        INT 21h
        MOV AL, 0Ah
        MOV AH, 0Eh
        INT 10h 
        MOV AL, 0Dh
        MOV AH, 0Eh
        INT 10h
        MOV resto, 0
        MOV resultado, 0
        LEA si, vDividendo
        LEA di, vAuxiliar  
        MOV cx, 5 
reinicia_vetores:
        MOV [si], 0
        MOV [di], 0
        INC di
        INC si
       LOOP reinicia_vetores 
        JMP start 


DIVISAO PROC NEAR
    
        LEA si, vDividendo
        MOV cx, 5
ciclo:
        MOV ax, resto
        MUL ten
       CALL verificaDX
       XCHG dx, ax
        MOV al , [si]
        ADD dx, ax
       PUSH cx
        MOV cx, 0
       XCHG dx, bx
procura_quociente:
        INC cx
        MOV ax, cx
        MUL hundred
       CALL verificaDX
        CMP ax, bx
        JNA procura_quociente
        DEC cx
       PUSH cx
        MOV ax, cx
        MOV cx, 4
        LEA di, vAuxiliar
percorre_array_auxiliar: 
        INC di
       LOOP percorre_array_auxiliar 
        MOV cx, 5
atribui_valores_auxiliar:  
        MOV dl, [di]
        MOV [di], al
        MOV al, dl
        DEC di
       LOOP atribui_valores_auxiliar
        POP ax
        MUL hundred
       CALL verificaDX
        SUB bx, ax
        MOV resto, bx
        POP cx
        INC si
       LOOP ciclo
        RET       

DIVISAO ENDP


SCAN   PROC NEAR
    
le_digito:
        MOV ah, 00h
        INT 16h 
        CMP al, 0Dh
         JE stop
        CMP al, '0'
         JB le_digito
        CMP al, '9'
         JA le_digito
        MOV ah, 0Eh
        INT 10h
        SUB al, 30h
        MOV ah, 0 
        MOV cx, 4
        LEA si, vDividendo
percorre_array_dividendo: 
        INC si
       LOOP percorre_array_dividendo 
        MOV cx, 5
atribui_valores_dividendo:  
        MOV dl, [si]
        MOV [si], al
        MOV al, dl
        DEC si
       LOOP atribui_valores_dividendo
        JMP le_digito 
stop:
        RET
         
SCAN   ENDP
 
 
PRINT_NUM   PROC    NEAR
    
        ADD al, 30h
        MOV ah, 0Eh
        INT 10h       
        RET
        
PRINT_NUM   ENDP 
                
                         
COPIA_ARRAYS    PROC    NEAR
    
        LEA si, vDividendo
        LEA di, vAuxiliar
        MOV cx, 5
percorre:       
        MOV al, [di]
        MOV [si], al
        MOV [di], 0
        INC si
        INC di
       LOOP percorre
        RET
        
COPIA_ARRAYS    ENDP
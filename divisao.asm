name "divisao"            
            
org  100h
jmp start
      
msgDividendo   DB  "Introduza o dividendo: ",'$'
msgDivisor     DB  0dh, 0ah,"Introduza o divisor: ",'$'     
msgResultado   DB  0dh, 0ah, "Resultado: $"
msgOverF       DB  0dh, 0ah, "Overflow $"
divisor        DW  0
resto          DW  0
vDividendo     DB  0, 0, 0, 0, 0     
ten            DW  10 
            
            
start:      
     MOV DX, offset msgDividendo
     MOV AH, 09h
     INT 21h
    CALL SCAN_DIVIDENDO 
     MOV DX, offset msgDivisor
     MOV AH, 09h
     INT 21h
    CALL SCAN_DIVISOR
     LEA DX, msgResultado
     MOV AH, 09h
     INT 21h
     MOV ax, divisor
     LEA si, vDividendo
     MOV cx, 5
ciclo_inteiro:
     MOV ax, resto
     MUL ten
    CALL verificaDX
    XCHG dx, ax
     MOV al , [si]
     ADD dx, ax
    PUSH cx
     MOV cx, 0
    XCHG dx, bx     
procura_quociente_inteiro:
     INC cx
     MOV ax, divisor
     MUL cx
    CALL verificaDX
     CMP ax, bx
     JNA procura_quociente_inteiro
     DEC cx
     MOV ax, cx
    CALL PRINT_NUM
    XCHG ax, cx
     MUL divisor
    CALL verificaDX
     SUB bx, ax
     MOV resto, bx
     POP cx
     INC si
    LOOP ciclo_inteiro
     MOV AL, '.'
     MOV AH, 0Eh
     INT 10h
     MOV cx, 3
ciclo_decimal:
     MOV ax, resto
     MUL ten
    CALL verificaDX
    PUSH cx
     MOV cx, 0
     MOV bx, ax
procura_quociente_decimal:
     INC cx
     MOV ax, divisor
     MUL cx
    CALL verificaDX
     CMP ax, bx
     JNA procura_quociente_decimal
     DEC cx
     MOV ax, cx
    CALL PRINT_NUM
    XCHG ax, cx
     MUL divisor
    CALL verificaDX
     SUB bx, ax
     MOV resto, bx
     POP cx
    LOOP ciclo_decimal
     JMP fim  
fim:        
     RET 
verificaDX:
     CMP dx,0
     JNZ overflow
     RET
overflow:
     MOV DX, offset msgOverF
     MOV AH, 9
     INT 21h
     MOV AL, 0Ah
     MOV AH, 0Eh
     INT 10h 
     MOV AL, 0Dh
     MOV AH, 0Eh
     INT 10h 
     MOV divisor, 0
     MOV resto, 0
     LEA si, vDividendo  
     MOV cx, 5
reinicia:
     MOV [si], 0
     INC si
    LOOP reinicia  
     JMP start         
     

SCAN_DIVIDENDO   PROC    NEAR
    
nextDigit1:
     MOV ah, 00h
     INT 16h 
     CMP al, 0Dh
      JE stop1
     CMP al, '0'
      JB nextDigit1 
     CMP al, '9'
      JA nextDigit1
     MOV ah, 0Eh
     INT 10h
     SUB al, 30h
     MOV ah, 0 
     LEA si, vDividendo
     MOV cx, 4
percorreArray: 
     INC si
    LOOP percorreArray 
     MOV cx, 5
atribuiValores:  
     MOV dl, [si]
     MOV [si], al
     MOV al, dl
     DEC si
    LOOP atribuiValores
     JMP nextDigit1 
stop1:
     RET
    
SCAN_DIVIDENDO   ENDP 
    
     
     
SCAN_DIVISOR    PROC    NEAR

nextDigit2:
     MOV ah, 00h
     INT 16h 
     CMP al, 0Dh
      JE  stop2
     CMP al, '0'
      JB nextDigit2 
     CMP al, '9'
      JA nextDigit2
     MOV ah, 0Eh
     INT 10h 
     SUB al, 30h
     MOV ah, 0
     MOV bx, ax  
     MOV ax, divisor
     MUL ten
    CALL verificaDX
     ADD ax, bx
     MOV divisor, ax
     JMP nextDigit2
stop2: 
     RET
    
SCAN_DIVISOR ENDP 
   
   
   
PRINT_NUM   PROC    NEAR

     ADD al, 30h
     MOV ah, 0Eh
     INT 10h       
     RET
    
PRINT_NUM   ENDP
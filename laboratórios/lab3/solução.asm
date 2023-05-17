; *********************************************************************
; * IST-UL
; * Modulo:    lab_pepe_tec.asm
; * Descrição: Exemplifica o acesso a um teclado.
; *            Lê uma linha do teclado, verificando se há alguma tecla
; *            premida nessa linha.
; *
; * Nota: Observe a forma como se acede aos periféricos de 8 bits
; *       através da instrução MOVB
; *********************************************************************

; **********************************************************************
; * Constantes
; **********************************************************************
; ATENÇÃO: constantes hexadecimais que comecem por uma letra devem ter 0 antes.
;          Isto não altera o valor de 16 bits e permite distinguir números de identificadores
DISPLAYS   EQU 0A000H  ; endereço dos displays de 7 segmentos (periférico POUT-1)
POUT       EQU 0C000H  ; endereço das linhas do teclado (periférico POUT-2)
PIN        EQU 0E000H  ; endereço das colunas do teclado (periférico PIN)
MASCARA    EQU 0FH     ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
LINE_R     EQU 16      ; linha a testar
OPERADOR   EQU 4       ; Quociente para multiplicação

; **********************************************************************
; * Código
; **********************************************************************
PLACE      0
inicio:		
; inicializações
    
    MOV R0, 0          ; bits da coluna da tecla pressionada
    MOV R1, 0          ; bits da linha atual
    MOV R2, 0          ; valor a passar aos displays
    MOV R3, DISPLAYS   ; endereço dos displays
    MOV R4, POUT       ; endereço do periférico de saída
    MOV R5, PIN        ; endereço do periférico de entrada
    MOV R6, MASCARA    ; máscara para bits de menor peso
    MOV R7, 0          ;
    MOV R8, 0          ;
    MOV R9, 0          ;
    MOV R10, OPERADOR  ;

; corpo principal do programa

reset:
    MOV R1, LINE_R     ; reset das linhas a verificar
    MOVB [R3], R2      ; escreve o valor nos displays

espera_tecla:
    SHR R1, 1          ; linha seguinte
    CMP R1, 0          ; já verificou todas as linhas?
    JZ reset           ; reset das linhas a verificar
    MOVB [R4], R1      ; ativa a linha R1 no teclado
    MOVB R0, [R5]      ; recebe o bit da coluna da tecla pressionada
    AND R0, R6         ; elimina bits para além dos bits 0-3
    CMP R0, 0          ; há tecla premida?
    JZ espera_tecla    ; se não repete

conversor:
    CMP R7, 1
    JZ segunda

    CMP R7, 2
    JZ final
        
    primeira:
        MOV R8, R1
        MOV R9, 0
        INC R7
        JMP bitdec

    segunda:
        MOV R1, R9
        MOV R8, R0
        MOV R9, 0
        INC R7
        JMP bitdec

    bitdec:
        SHR R8,1
        CMP R8, 0
        JNZ repetir
        JMP conversor
        repetir:
            INC R9
            JMP bitdec

    final:
        MOV R0, R9
        MOV R7, 0
        MOV R9, 0   

operacao:
    MUL R1, R10
    ADD R1, R0
    JMP controlo

controlo:
    CMP R1, 0
    JZ adicionar
    MOV R11, 0FH
    CMP R1, R11
    JZ subtrair
    JMP reset

JMP reset

adicionar:
    INC R2
    JMP reset

subtrair:
    DEC R2
    JMP reset

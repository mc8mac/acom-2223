; *********************************************************************
; * IST-UL
; * Modulo:    LAB2Solution.asm
; * Descrição: Solução do laboratorio 2.
; *********************************************************************

; **********************************************************************
; * Constantes
; **********************************************************************
; ATENÇÃO: constantes hexadecimais que comecem por uma letra devem ter 0 antes.
;          Isto não altera o valor de 16 bits e permite distinguir números de identificadores
DISPLAYS   EQU 0A000H  ; endereço dos displays de 7 segmentos (periférico POUT-1)

; **********************************************************************
; * Código
; **********************************************************************
PLACE      0
; inicializações
inicio:		
    MOV  R4, DISPLAYS  ; endereço do periférico dos displays
    MOV R1, 0; inicializa o contador a zero
    MOV R2, 00FFH; inicializa o máximo do contador
; corpo principal do programa
ciclo:
    ADD  R1, 1	 ; proximo numero no contador
    MOVB [R4], R1      ; escreve o numero atual
    SUB  R2, 1     ; retira um ciclo
    JZ Fim     ; acaba o ciclo caso r2 seja zero
    JMP ciclo     ; caso contrario volta a repetir
Fim:JMP Fim



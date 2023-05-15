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
TEC_LIN    EQU 0C000H  ; endereço das linhas do teclado (periférico POUT-2)
TEC_COL    EQU 0E000H  ; endereço das colunas do teclado (periférico PIN)
LINHA      EQU 16      ; linha a testar
MASCARA    EQU 0FH     ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado

; **********************************************************************
; * Código
; **********************************************************************
PLACE      0
inicio:		
; inicializações
    MOV R2, TEC_LIN   ; endereço do periférico das linhas
    MOV R3, TEC_COL   ; endereço do periférico das colunas
    MOV R4, DISPLAYS  ; endereço do periférico dos displays
    MOV R5, MASCARA   ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
    MOV R6, 0         ; contador de bits
    MOV R9, 4         ; quociente de multiplicação

; corpo principal do programa

reset_linha:
    MOV R1, LINHA      ; reset do nº de linhas a verificar

espera_tecla:          ; neste ciclo espera-se até uma tecla ser premida
    SHR R1,1           ; reduz o nº de bits de r1 para verificação
    CMP R1,0           ; verifica se já leu todas as linhas
    JZ reset_linha     ; reset do nº de linhas a verificar
    MOVB [R2], R1      ; escrever no periférico de saída (linhas)
    MOVB R0, [R3]      ; ler do periférico de entrada (colunas)
    AND R0, R5         ; elimina bits para além dos bits 0-3
    CMP R0, 0          ; há tecla premida?
    JZ espera_tecla    ; se nenhuma tecla premida, repete
    MOV R6, 0          ; caso contrário inicia o contador de iterações a zero
    
display:
    .primeirait:       ; primeira iteração para converter de binário para decimal
        CMP R6,0       ; já ocorreu alguma iteração?
        JNZ .segundait ; salta para a iteração seguinte
        MOV R7, R1     ; preparar para fazer a conversão para decimal
        MOV R8, 0
        JMP conta_bits ; realiza a conversão
    .segundait:        ; última iteração para converter de binário para decimal
        CMP R6,1       ; já ocorreu a mais que uma iteração?
        JNZ final      ; salta para obter o resultado final
        MOV R1, R8     ; R1 assume o seu número em binário para a conta final
        MOV R7, R0     ; preparar para fazer a conversão de binário para decimal
        MOV R8, 0      ; reset do contador
        JMP conta_bits ; realiza a conversão
    .final:            ; etiqueta local para realizar as últimas operações para conversão para decimal 
    ;********************************************************************************
        MUL R1, R9     ; Fórmula dada para mudança para decimal
        ADD R1, R8     ;
    ;********************************************************************************
        MOVB [R4], R1  ; escreve linha e coluna nos displays
        JMP espera_tecla   ; verifica se alguma tecla está a ser pressionada de momento

conta_bits:            ; conta o nº de bits
    SHR R7,1           ; retira um bit a R7
    CMP R7,0           ; R7 é zero?
    JNZ .repeat        ; Se não continua a retirar bits
    INC R6             ; incrementa o contador de iterações
    JMP display        ; fim da iteração
    .repeat:           ;
    INC R8             ; incremento do contador de bits
    JMP conta_bits     ; repete o ciclo

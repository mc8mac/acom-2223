
; *********************************************************************************
; Constantes
; *********************************************************************************

DISPLAYS            EQU 0A000H      ; endereço para escrita nos displays
POUT                EQU 0C000H      ; endereço do periférico de saída
PIN                 EQU 0E000H      ; endereço do periférico de entrada
MASK                EQU 0FH         ; máscara para bits de menor peso
MASK2               EQU 0FFF0H
LINHAS              EQU 16          ; constante para reset das linhas a verificar no teclado
OP                  EQU 4           ; operador para multiplicação

DEFINE_LINHA    	EQU 600AH       ; endereço do comando para definir a linha
DEFINE_COLUNA  		EQU 600CH       ; endereço do comando para definir a coluna
DEFINE_PIXEL    	EQU 6012H       ; endereço do comando para escrever um pixel
LIMPA_AVISO     	EQU 6040H       ; endereço do comando para apagar o aviso de nenhum cenário selecionado
LIMPA_ECRA 		    EQU 6002H       ; endereço do comando para apagar todos os pixels já desenhados
SEL_FUNDO           EQU 6042H       ; endereço do comando para selecionar uma imagem de fundo
TOCA_SOM			EQU 605AH       ; endereço do comando para tocar um som
SEL_PIXEL_ECRA      EQU 6004H


LINHA_METEORO       EQU 0           ; posição y inicial do meteoro
COLUNA_METEORO		EQU 0           ; posição x inicial do meteoro
HEIGHT_METEORO      EQU 6           ; altura do sprite
LENGTH_METEORO      EQU 6           ; largura do sprite
M_MOVES             EQU 32          ; LIMITE DO ECRA

HEIGHT_MINERAVEL    EQU 6           ; altura do sprite
LENGHT_MINERAVEL    EQU 6           ; largura do sprite

HEIGHT_EXPLOSAO     EQU 6           ; altura do sprite
LENGHT_EXPLOSAO     EQU 6           ; largura do sprite

LINHA_NAVE        	EQU 27          ; posição y inicial da nave
COLUNA_NAVE			EQU 25          ; posição x inicial da nave
HEIGHT_NAVE         EQU 5           ; altura do sprite
LENGTH_NAVE         EQU 15          ; largura do sprite

LINHA_SONDA_CEN     EQU 27          ; posição y inicial da nave
COLUNA_SONDA_CEN    EQU 32          ; posição x inicial da nave
LINHA_SONDA_ESQ     EQU 27          ; posição y inicial da nave
COLUNA_SONDA_ESQ    EQU 26          ; posição x inicial da nave
LINHA_SONDA_DIR     EQU 27          ; posição y inicial da nave
COLUNA_SONDA_DIR    EQU 38          ; posição x inicial da nave
HEIGHT_SONDA        EQU 1           ; altura do sprite
LENGHT_SONDA        EQU 1           ; largura do sprite
DISTANCIA_SONDA     EQU 12         ; distancia maxima da sonda
ENERGIA_INICIAL     EQU 100

RED                 EQU 0FF00H      ; vermelho
GRE                 EQU 0F0A0H      ; verde
WEI                 EQU 07CAFH      ; cor estranha
YEL                 EQU 0FFF0H      ; amarelo

; *********************************************************************************
; Dados 
; *********************************************************************************

PLACE       1000H
pilha:
	STACK 100H			
SP_inicial:		


estado_jogo:
    WORD        0


tab:
	WORD rot_int_0			; rotina de atendimento da interrupção 0
    WORD rot_int_1          ; rotina de atendimento da interrupção 1
    WORD rot_int_2          ; rotina de atendimento da interrupção 2


estado_int:
	WORD        0				; se int0, indica que a interrupção 0 ocorreu
    WORD        0			    ; se int1, indica que a interrupção 0 ocorreu
    WORD        0               ; se int2, indica que a interrupção 0 ocorreu

sonda_posicao:
    WORD        0,LINHA_SONDA_ESQ,COLUNA_SONDA_ESQ
    WORD        0,LINHA_SONDA_CEN,COLUNA_SONDA_CEN
    WORD        0,LINHA_SONDA_DIR,COLUNA_SONDA_DIR

tecla_dispara_sonda:
    WORD        0           ; estado da tecla esquerda
    WORD        0           ; estado da tecla central
    WORD        0           ; estado da tecla direita

meteoro_posicao:            ;x,y x=num de movimentos feitos, y=refrencia para origem_direcao_meteoro
    WORD        0,1
    WORD        0,1
    WORD        0,1
    WORD        0,1

meteoro_type:       ;espaco para guardar referencia ao tipo de meteoro
    WORD        0
    WORD        0
    WORD        0
    WORD        0

origem_direcao_meteoro:         ; x,y x=origem (-1-esquerda,0-centro,1-direita) y=direcao(-1-diagonal esquerda,0-baixo,1-diagonal direita)
        WORD    -1,1
        WORD    0,-1
        WORD    0,0
        WORD    0,1
        WORD    1,-1

DEF_METEORO:					    ; tabela que define o meteoro (Largura - Altura - Desenho)
	WORD		LENGTH_METEORO
	WORD		HEIGHT_METEORO
	WORD		000,RED,RED,RED,RED,000,
                RED,RED,000,000,RED,RED,
                RED,000,000,000,000,RED,
                RED,000,000,000,000,RED,
                RED,RED,000,000,RED,RED,
                000,RED,RED,RED,RED,000

DEF_MINERAVEL_1:                      ; tabela que define o meteoro mineravel (Largura - Altura - Desenho)
    WORD        LENGHT_MINERAVEL
    WORD        HEIGHT_MINERAVEL
    WORD        000,000,GRE,GRE,000,000,
                000,GRE,GRE,GRE,GRE,000,
                GRE,GRE,GRE,GRE,GRE,GRE,
                GRE,GRE,GRE,GRE,GRE,GRE,
                000,GRE,GRE,GRE,GRE,000,
                000,000,GRE,GRE,000,000

DEF_MINERAVEL_2:                      ; tabela que define o meteoro mineravel (Largura - Altura - Desenho)
    WORD        LENGHT_MINERAVEL
    WORD        HEIGHT_MINERAVEL
    WORD        000,000,000,000,000,000,
                000,000,GRE,GRE,000,000,
                000,GRE,GRE,GRE,GRE,000,
                000,GRE,GRE,GRE,GRE,000,
                000,000,GRE,GRE,000,000,
                000,000,000,000,000,000

DEF_MINERAVEL_3:                      ; tabela que define o meteoro mineravel (Largura - Altura - Desenho)
    WORD        LENGHT_MINERAVEL
    WORD        HEIGHT_MINERAVEL
    WORD        000,000,000,000,000,000,
                000,000,000,000,000,000,
                000,000,GRE,GRE,000,000,
                000,000,GRE,GRE,000,000,
                000,000,000,000,000,000,
                000,000,000,000,000,000                

DEF_EXPLOSAO:                       ; tabela que define a explosao (Largura - Altura - Desenho)
    WORD        LENGHT_EXPLOSAO
    WORD        HEIGHT_EXPLOSAO
    WORD        YEL,000,YEL,YEL,000,YEL,
                000,YEL,000,000,YEL,000,
                YEL,000,YEL,YEL,000,YEL,
                YEL,000,YEL,YEL,000,YEL,
                000,YEL,000,000,YEL,000,
                YEL,000,YEL,YEL,000,YEL

DEF_NAVE:                           ; tabela que define a nave (Largura - Altura - Desenho)
	WORD		LENGTH_NAVE
	WORD		HEIGHT_NAVE
	WORD		000,000,RED,RED,RED,RED,RED,RED,RED,RED,RED,RED,RED,000,000,
				000,RED,GRE,GRE,GRE,GRE,GRE,GRE,GRE,GRE,GRE,GRE,GRE,RED,000,
				RED,GRE,GRE,GRE,000,000,000,000,000,000,000,GRE,GRE,GRE,RED,
				RED,GRE,GRE,GRE,000,000,000,000,000,000,000,GRE,GRE,GRE,RED,
				RED,GRE,GRE,GRE,GRE,GRE,GRE,GRE,GRE,GRE,GRE,GRE,GRE,GRE,RED


DEF_SONDA:                          ; tabela que define a sonda (Largura - Altura - Desenho)
    WORD        LENGHT_SONDA
    WORD        HEIGHT_SONDA
    WORD        YEL


; *********************************************************************************
; * Código
; *********************************************************************************


PLACE   0				
inicio:          
    MOV  BTE, tab			        ; inicializa BTE (registo de Base da Tabela de Exce��es)                                                    
	MOV  SP, SP_inicial             ; inicializa o stack pointer
    MOV  [LIMPA_AVISO], R1	        ; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
    MOV  [LIMPA_ECRA], R1	        ; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
	MOV	 R1, 0			            ; cenário de fundo número 0
    MOV  [SEL_FUNDO], R1	        ; seleciona o cenário de fundo
    MOV  R0, DISPLAYS               ; para aceder aos displays
    MOVB [R0], R1                   ; define os displays a 000
ecra_inicial:
    CALL teclado_handler           ; salta para a função que trata de receber o input

    MOV R1, estado_jogo
    MOV R0, [R1]
    CMP R0,0
    JZ ecra_inicial

ecra_de_jogo:
    MOV	 R1, 1			            ; cenário de fundo número 0
    MOV  [SEL_FUNDO], R1	        ; seleciona o cenário de fundo

posiciona_nave:                     ; define as coordenadas para desenhar a nave
    MOV  R1, LINHA_NAVE             ; define a coordenada y
    MOV  R2, COLUNA_NAVE            ; define a coordenada x
    MOV  R4, DEF_NAVE			    ; define o que desenhar (nave)
    MOV  R7, 0	                    ;
    MOV  [SEL_PIXEL_ECRA], R7	    ; seleciona o ecra da nave
    MOV R10, ENERGIA_INICIAL
    CALL converte_display

desenha_nave:                       ; 
    CALL desenha_main               ; desenha o que foi definido em R4, na posição x = R2, y = R1 


   EI0					; permite interrupções 0
   EI1
   EI2
	EI					; permite interrupções (geral)

ciclo:

    CALL teclado_handler           ; salta para a função que trata de receber o input

    interrupcao0:
        MOV  R5, estado_int
        MOV  R2, [R5]		; valor da variável que diz se houve uma interrupção com o mesmo número da coluna
        CMP  R2, 0
        JZ   interrupcao1	; se não houve interrupção, salta o processo
        DI          ; desliga as interrupcoes para mover todos os asteroides
        MOV  R2, 0
        MOV  [R5], R2		; coloca a zero o valor da variável que diz se houve uma interrupção (consome evento)

        MOV  R7, 1                      ;
        MOV  [SEL_PIXEL_ECRA], R7       ; seleciona o ecrã do meteoro
        MOV  R3, 0                      ; NUMERO DO ASTEROIDE
        CALL gera_num_aleatorio
        MOV  R7, 2                      ;
        MOV  [SEL_PIXEL_ECRA], R7       ; seleciona o ecrã do meteoro
        MOV  R3, 4                      ; NUMERO DO ASTEROIDE
        CALL gera_num_aleatorio
        MOV  R7, 3                      ;
        MOV  [SEL_PIXEL_ECRA], R7       ; seleciona o ecrã do meteoro
        MOV  R3, 8                      ; NUMERO DO ASTEROIDE
        CALL gera_num_aleatorio
        MOV  R7, 4                      ;
        MOV  [SEL_PIXEL_ECRA], R7       ; seleciona o ecrã do meteoro
        MOV  R3, 12                      ; NUMERO DO ASTEROIDE
        CALL gera_num_aleatorio
        EI          ; reativa as interrupcoes

    interrupcao1:
    
        MOV R6, tecla_dispara_sonda
        MOV R5,[R6]
        CMP R5,1              ; verifica se tecla esquerda foi pressionada
        JZ dispara_esq
        proximo_tiro1:
        ADD R6,2
        MOV R5,[R6]
        CMP R5,1              ; verifica a tecla central
        JZ dispara_cen
        proximo_tiro2:
        ADD R6,2
        MOV R5,[R6]
        CMP R5,1               ; verifica a tecla direita
        JZ dispara_dir
        MOV  R5, estado_int
        ADD R5,2            ; a int 1 esta uma word depois da int 0
        MOV R3,0
        MOV [R5],R3             ; reinicia a interrupcao 1 a zero
    
        JMP interrupcao2

        dispara_esq:
        CALL tiro_esq
        JMP proximo_tiro1

        dispara_cen:
        CALL tiro_cen
        JMP proximo_tiro2
        
        dispara_dir:
        CALL tiro_dir
        MOV  R5, estado_int
        ADD R5,2            ; a int 1 esta uma word depois da int 0
        MOV R3,0
        MOV [R5],R3             ; reinicia a interrupcao 1 a zero

        interrupcao2:
        MOV  R5, estado_int
        ADD R5,4            ;   o estado da interrupcao 2 esta a duas wordsde distancia
        MOV  R2, [R5]		; valor da variável que diz se houve uma interrupção com o mesmo número da coluna
        CMP  R2, 0
        JZ sem_energia
        MOV  R2, 0
        MOV  [R5], R2		; coloca a zero o valor da variável que diz se houve uma interrupção (consome evento)

        CALL consumir_energia

        sem_energia:
        CMP R10,0
        JLE acabou_energia
        JMP pausa
        
        acabou_energia:
        CALL morte_por_energia
        DI
        MOV R1, estado_jogo
        MOV R0,3
        MOV [R1],R0          ; estado game over(3)
        JMP perdeu_o_jogo

        pausa:
        CALL teclado_handler

        MOV R1, estado_jogo
        MOV R0, [R1]
        CMP R0,4
        JZ pausa

        next:
JMP ciclo

perdeu_o_jogo:
    CALL teclado_handler           ; salta para a função que trata de receber o input

    MOV R1, estado_jogo
    MOV R0, [R1]
    CMP R0,2
    JNZ perdeu_o_jogo
    JMP ecra_de_jogo


; **********************************************************************
; morte_por energia-
; **********************************************************************
morte_por_energia:
PUSH R1
MOV	 R1, 2			            ; cenário de fundo número 3
    MOV  [SEL_FUNDO], R1	        ; seleciona o cenário de fundo
    MOV  [LIMPA_ECRA], R1	        ; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
    MOV R1,0
    MOV  R0, DISPLAYS               ; para aceder aos displays
    MOVB [R0], R1                   ; define os displays a 000
POP R1
RET


; **********************************************************************
; play_sound-
; **********************************************************************

play_sound:                         ;
    PUSH R9                         ;
    MOV  R9, 0                      ; define qual o som a tocar
    MOV  [TOCA_SOM], R9             ; toca o som selecionado
    POP  R9                         ;
    RET                             ;

; **********************************************************************
; desenha_main - Desenha na linha e coluna indicadas
;			    com a forma e cor definidas na tabela indicada.
;
; Argumentos:   R1 - linha
;               R2 - coluna
;               R4 - tabela que define o boneco
;
; **********************************************************************


desenha_main:                       ;
    PUSH R1                         ;
    PUSH R2                         ;
    PUSH R3                         ;
    PUSH R4                         ;
    PUSH R5
    PUSH R6                         ;
    PUSH R8

    MOV  R8, R2		                ; guarda a primeira coluna
    MOV  R5, [R4]	                ; obtém a largura do boneco
    MOV  R6, [R4+2]	                ; obtem a altura do boneco
    ADD  R4, 4		                ; endereço da cor do 1º pixel (4 porque a largura e altura são duas words)
    
reset_largura:                      ;
    PUSH R5			                ; guarda a largura na pilha
    
draw:				                ; desenha os pixels a partir da tabela
    MOV  R3, [R4]		            ; obtém a cor do próximo pixel
    CALL escreve_pixel		        ; escreve cada pixel
    ADD  R4, 2		            	; endereço da cor do próximo pixel (2 porque cada cor de pixel é uma word)
    ADD  R2, 1		            	; próxima coluna
    SUB  R5, 1			            ; menos uma coluna para tratar
    JNZ  draw			            ; continua até percorrer toda a largura do objeto
    SUB  R6, 1			            ; menos uma linha para tratar
    JZ   fim_desenha_main		    ; termina depois de percorrer todas as linhas
    POP  R5		                	; vai buscar a largura do objeto a desenhar
    ADD  R1,1		            	; proxima linha
    MOV  R2, R8			            ; volta para a primeira coluna
    JMP  reset_largura              ;

fim_desenha_main:                   ;
    POP R5                          ;
    POP R8
    POP R6                          ;
    POP R5  
    POP R4                          ;
    POP R3                          ;
    POP R2                          ;
    POP R1                          ;
    RET                             ;

; **********************************************************************
; apaga_object - Apaga na linha e coluna indicadas
;			  com a forma definida na tabela indicada.
;
; Argumentos:   R1 - linha
;               R2 - coluna
;               R4 - tabela que define o boneco
;
; **********************************************************************

apaga_object:                       ;
    PUSH R1                         ;
    PUSH R2                         ;
    PUSH R3                         ;
    PUSH R4                         ;
    PUSH R5
    PUSH R6                         ;

    MOV R8, R2                      ;
    MOV R5, [R4]		            ; obtém a largura do boneco
    MOV R6, [R4+2]		            ; obtem a altura do boneco
    ADD R4, 4			            ; endereço da cor do 1º pixel (4 porque a largura e altura são DUAS wordS)


reset_largura_apaga:                ;
    PUSH R5			                ; guarda a largura na pilha

apaga_pixels:       		        ; desenha os pixels do boneco a partir da tabela
	MOV  R3, 0		                ; cor para apagar o proximo pixel 
    CALL escreve_pixel	        	; escreve cada pixel do boneco
    ADD  R2, 1			            ; próxima coluna
    SUB  R5, 1			            ; menos uma coluna para tratar
    JNZ  apaga_pixels		        ; continua até percorrer toda a largura do objeto
    SUB  R6, 1			            ; menos uma linha para tratar
    JZ   fim_apaga		            ; termina depois de percorrer todas as linhas
    POP  R5			                ; vai buscar a largura do objeto a desenhar
    ADD  R1,1			            ; proxima linha
    MOV  R2, R8			            ; volta para a primeira coluna
    JMP  reset_largura_apaga        ;

fim_apaga:                          ;
	POP	R5                          ;
    POP R6                          ;
    POP R5
	POP	R4                          ;
	POP	R3                          ;
	POP	R2                          ;
	POP R1                          ;
	RET                             ;

; **********************************************************************
; ESCREVE_PIXEL - Escreve um pixel na linha e coluna indicadas.
; Argumentos:   R1 - linha
;               R2 - coluna
;               R3 - cor do pixel (em formato ARGB de 16 bits)
;
; **********************************************************************

escreve_pixel:                      ;
    MOV [DEFINE_LINHA], R1		    ; seleciona a linha
    MOV [DEFINE_COLUNA], R2	        ; seleciona a coluna
    MOV [DEFINE_PIXEL], R3		    ; altera a cor do pixel na linha e coluna já selecionadas
    RET                             ;

; **********************************************************************
; teclado_handler
;
; **********************************************************************

teclado_handler:                    ;
    PUSH R1                         ;
    PUSH R2                         ;
    PUSH R3                         ;
    PUSH R4                         ;
    MOV  R2, POUT                   ; para aceder ao periférico de saída
    MOV  R3, PIN                    ; para aceder ao periférico de entrada
    MOV  R4, MASK                   ; para isolar os 4 bits de menor peso
    MOV  R1, LINHAS                 ; reset das linhas a serem verificadas

JMP espera_tecla

reset_linhas:    
    POP R4
    POP R3
    POP R2
    POP R1
    RET                             ; volta para o ciclo principal se nenhuma tecla foi pressionada
                       ;
espera_tecla:                       ; verifica se há alguma tecla a ser pressionada
    SHR  R1,1                       ; linha seguinte
    CMP  R1,0                       ; a linha é zero?
    JZ   reset_linhas               ; reset para a linha inicial
    MOVB [R2], R1                   ; acesso ao teclado
    MOVB R0, [R3]                   ; retorno da coluna da tecla pressionada
    AND  R0, R4                     ; máscara para obter apenas os 4 bits de menor peso
    CMP  R0, 0                      ; tecla pressionada?
    JZ   espera_tecla               ; se não repete
    PUSH R0                         ; se sim, guarda a coluna pressionada

ha_tecla:                           ; verifica se a tecla ainda está a ser pressioanda
    MOVB [R2], R1                   ; acesso ao teclado
    MOVB R0, [R3]                   ; retorno da coluna da tecla pressionada
    AND  R0, R4                     ; máscara para obter apenas os 4 bits de menor peso
    CMP  R0, 0                      ; tecla pressionada?
    JNZ  ha_tecla                   ; se sim repete
    POP R0                          ; devolve o valor anterior de R0

convert_input:                      ; converte o input do teclado em hexadecimal
    MOV  R2, 0                      ; define o contador a zero
    CALL counter                    ; transforma o R1 em decimal (0-3)
    MOV  R3, R2                     ; guarda o valor decimal de R1
    MOV  R2, 0                      ; define o contador a zero
    MOV  R1, R0                     ; prepara para transformar o R0 em decimal (0-3)
    CALL counter                    ; transforma o R0 em decimal (0-3)
    MOV  R4, OP                     ; prepara para realizar uma multiplicação
    MUL  R3, R4                     ; 4 * Linhas
    ADD  R3, R2                     ; + Colunas
    MOV  R0, R3                     ; guarda o valor final em hexadecimal (0-F)
    JMP  controller                 ;

counter:                            ;
    SHR  R1,1                       ; reduz o número de bits a contar
    CMP  R1,0                       ; já chegou a zero?
    JZ   fim_counter                ; se sim acaba de contar
    INC  R2                         ; se não, +1
    JMP  counter                    ; e repete
fim_counter:                        ; fim do contador
    RET                             ; retorna um valor entre 0 e 3

; **********************************************************************
; CONTROLLER - Define qual o comando a realizar dependendo 
;              da tecla pressionada.
;
; Argumentos:   R0 - tecla pressionada
;
; **********************************************************************


controller:                         ; hub de comandos
    POP  R4                         ;
    POP  R3                         ;
    POP  R2                         ;
    POP  R1                         ;
    PUSH R1
    PUSH R2
    CMP  R0, 0                      ; tecla premida foi 0?
    JZ   dispara_sonda_esq1          ; dispara sonda direita
    JMP proxima_tecla1

    dispara_sonda_esq1:
    CALL dispara_sonda_esq
    JMP fim_teclas
    proxima_tecla1:
    CMP  R0, 1                      ; tecla premida foi 1?
    JZ   dispara_sonda_centro1       ; dispara sonda para o centro
    JMP proxima_tecla2

    dispara_sonda_centro1:
    CALL dispara_sonda_centro
    JMP fim_teclas

    proxima_tecla2:
    CMP  R0, 2                      ; tecla premida foi 2?
    JZ   dispara_sonda_direito1      ; dispara sonda para o centro
    JMP proxima_tecla3

    dispara_sonda_direito1:
    CALL dispara_sonda_direito
    JMP fim_teclas

    proxima_tecla3:
    MOV R1, estado_jogo             ; obtem a refrencia do estado do jogo
    MOV R2, [R1]                    ; opbtem o estado do jogo
    CMP R2,0                        ; apenas se estiver no estado inical- verifica a tecla
    JNZ proxima_tecla4
    MOV R1, 12                      ; tecla C
    CMP  R0, R1                      ; tecla premida foi C?
    JZ   inicia_o_jogo1
    JMP proxima_tecla4

    inicia_o_jogo1:
    CALL inicia_o_jogo
    JMP fim_teclas

    proxima_tecla4:
    MOV R1, estado_jogo             ; obtem a refrencia do estado do jogo
    MOV R2, [R1]                    ; opbtem o estado do jogo
    CMP R2,3                        ; apenas se estiver no estado game over- verifica a tecla
    JNZ proxima_tecla5
    MOV R1, 13                      ; tecla D
    CMP  R0, R1                      ; tecla premida foi D?
    JZ   reinicia_o_jogo1
    JMP proxima_tecla5

    reinicia_o_jogo1:
    CALL reinicia_o_jogo
    JMP fim_teclas

    proxima_tecla5:
    MOV R1, 14                      ; tecla D
    CMP  R0, R1                      ; tecla premida foi D?
    JZ para_jogo1
    JMP proxima_tecla6

    para_jogo1:
    CALL para_jogo
    JMP fim_teclas
    proxima_tecla6:
    MOV R1, 15                      ; tecla F
    CMP  R0, R1                      ; tecla premida foi F?
    JZ retoma_jogo1
    JMP fim_teclas

    retoma_jogo1:
    CALL retoma_jogo


    fim_teclas:
    POP R2
    POP R1
    RET   


; **********************************************************************
; retoma_jogo-
; **********************************************************************
 retoma_jogo:
    PUSH R1
    PUSH R2
    MOV R1, estado_jogo
    MOV R2, 1
    MOV [R1],R2
    MOV	 R1, 1			            ; cenário de fundo número 1
    MOV  [SEL_FUNDO], R1	        ; seleciona o cenário de fundo
    POP R2
    POP R1
    RET

; **********************************************************************
; para_jogo-
; **********************************************************************
 para_jogo:
    PUSH R1
    PUSH R2
    MOV R1, estado_jogo
    MOV R2, 4
    MOV [R1],R2
    MOV	 R1, 3			            ; cenário de fundo número 3
    MOV  [SEL_FUNDO], R1	        ; seleciona o cenário de fundo
    POP R2
    POP R1
    RET

; **********************************************************************
; reinicia_o_jogo-
; **********************************************************************
    reinicia_o_jogo:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R3
        MOV R1, estado_jogo
        MOV R0,2            ; indica que e para reiniciar o jogo
        MOV [R1], R0
        MOV R0,0            ; valor para reiniciar a posicao dos meteoros
        MOV R2, 0           ; valor para aceder a posicao dos meteoros
        MOV R3, 12          ; valor para aceder a posicao do ultimo meteoro
        reinicia_meteoros:
        MOV R6,meteoro_posicao
        MOV [R6+R2],R0              ; reinicia posicao a zero
        CMP R2,R3                   ; verifica se chegou ao ultimo meteoro
        JZ reinicia_sondas
        ADD R2,4                    ; vai para o proximo meteoro a duas word de distancia
        JMP reinicia_meteoros
        reinicia_sondas:
        MOV R2,0
        MOV R6, sonda_posicao
        r_s:
        MOV [R6+R2],R0
        CMP R2,R3
        JZ reinicia_tecla_tiro
        ADD R2,6
        JMP r_s
        reinicia_tecla_tiro:
        MOV R2,0
        MOV R6, tecla_dispara_sonda
        MOV R0,6
        t_d:
        MOV [R6+R2],R0
        CMP R2,R3
        JZ fim_reinicia
        ADD R2,2
        JMP t_d

    fim_reinicia:
    POP R3
    POP R2
    POP R1
    POP R0
    RET

; **********************************************************************
; inicia_o_jogo-
; **********************************************************************
    inicia_o_jogo:
    PUSH R0
    PUSH R1
        MOV R1, estado_jogo
        MOV R0,1
        MOV [R1], R0
    POP R1
    POP R0
    RET

consumir_energia:                   ; A cada N segundos retira 3 de energia
    SUB R10, 3
    CALL converte_display
    RET

consumir_energia_disparo:
    SUB R10, 5
    CALL converte_display
    RET
; **********************************************************************
; converte display - Hexadecimal para decimal e vice versa para os display
;
; Argumentos:   R0 - tecla pressionada
;
; **********************************************************************

converte_display:
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R10

    MOV R1, 10                      ;operador de divisão
    MOV R2, 1                       ;operador de multiplicação, (Somatorio de cada digito vezes 16^ordem do digito)
    MOV R3, 0                       ;contador de digitos
    MOV R4, R10                     ;guarda o valor de R10 para não destrui-lo
    MOV R5, 0                       ;valor convertido de hexadecimal para decimal
    MOV R6, 16
    JMP operacoes

    handle_expoentes:
        MOV R2, 16
        PUSH R3
        loop_expoentes:
            SUB R3,1
            JZ fim_loop_expoentes
            MUL R2, R6
            JMP loop_expoentes

    fim_loop_expoentes:
        POP R3

    operacoes:
        MOD R4, R1
        MUL R4, R2
        ADD R5, R4
        DIV R10, R1
        JZ fim_converte_display
        MOV R4, R10
        INC R3
        JMP handle_expoentes

    fim_converte_display:
        MOV R10, R5
        CALL update_displays
        POP R10
        POP R6
        POP R5
        POP R4
        POP R3
        POP R2
        POP R1

    RET
        


; **********************************************************************
; DISPARA_SONDA_esq-
; **********************************************************************
dispara_sonda_esq:
    CALL consumir_energia_disparo
    PUSH R1
    PUSH R2
    MOV R1,tecla_dispara_sonda
    MOV R2,1
    MOV [R1],R2
    POP R2
    POP R1
    RET

; **********************************************************************
; DISPARA_SONDA_cen-
; **********************************************************************
dispara_sonda_centro:
    CALL consumir_energia_disparo
    PUSH R1
    PUSH R2
    MOV R1,tecla_dispara_sonda
    ADD R1, 2                   ; adiciona uma word para aceder ao segundo valor da tabela
    MOV R2,1
    MOV [R1],R2
    POP R2
    POP R1
    RET
; **********************************************************************
; DISPARA_SONDA_cen-
; **********************************************************************
dispara_sonda_direito:
    CALL consumir_energia_disparo
    PUSH R1
    PUSH R2
    MOV R1,tecla_dispara_sonda
    ADD R1, 4                   ; adiciona duas words para aceder ao segundo valor da tabela
    MOV R2,1
    MOV [R1],R2
    POP R2
    POP R1
    RET
; **********************************************************************
; update_displays-
; **********************************************************************

update_displays:                    ;
    PUSH R1                         ;
    MOV  R1, DISPLAYS               ; para endereçar os displays
    MOV  [R1], R10                  ; escreve o valor de r10 nos displays
    POP  R1                         ;
    RET                             ;

; **********************************************************************
; move_sonda
; **********************************************************************

move_sonda:                         ;                         ;
    PUSH R3                         ;
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R8
    PUSH R4
    PUSH R1                         ;
    PUSH R2
    MOV  R3, DEF_SONDA              ; define a sonda como sprite a desenhar
    MOV  R5, sonda_posicao
    ADD R5,R4                  ; numero de vezes que a sonda x se moveu
    MOV R8,[R5]                  ; numero de vezes que a sonda x se moveu
    MOV R4, 2
    MOV R6,  [R5+R4]                 ; linha da sonda
    ADD R4, 2
    MOV  R7, [R5+R4]            ; COLUNA DA SONDA
    MUL R1, R8                  ; NUMERO DE VEZES QUE A SONDA JA SE MOVEU
    MUL R2, R8                     ; numero de vezes quye a sonda ja se moveu
    MOV R4, R3                      ; a rotina apaga e desenha recebe R4 como argumento
    ADD  R1, R6                     ; linha atual da sonda
    ADD  R2, R7                     ; coluna atual da sonda
    CALL apaga_object               ; apaga a sonda
    POP R2                          ; informacao sobre como se deve mover a sonda
    POP R1                          ; informacao sobre como se deve mover a sonda
    POP R4                          ; numnero do asteroide
    MOV R8,[R5]                  ; numero de vezes que a sonda x se moveu
    ADD  R8, 1                      ; adiciona ao nº de vezes que já se moveu a sonda
    MUL R1, R8                  ; NUMERO DE VEZES QUE A SONDA JA SE MOVEU
    MUL R2, R8                     ; numero de vezes quye a sonda ja se moveu
    ADD  R1, R6                     ; linha NOVA da sonda
    ADD  R2, R7                     ; coluna NOVA da sonda
    MOV [R5],R8                      ; GUARDA numero de vezes que a sonda ja se moveu
    MOV R6,R4                             ; guarda o numero da sonda
    MOV R4,R3                           ; DEF_SONDA
    CALL desenha_main               ; desenha a sonda na nova posição
    MOV R7, DISTANCIA_SONDA
    CMP R8, R7                      ; verifica se chegou ao limite
    JNZ fim_sonda

    CALL apaga_object               ; apaga a sonda
     

    MOV R3,0
    MOV [R5],R3                  ; reinicia o numero de vezes que a sonda foi movida
    MOV R5, tecla_dispara_sonda
    MOV R3,3
    DIV R6,R3                    ; para obter o numero da sonda em saltos de uma words
    MOV R3, 0
    MOV [R5+R6],R3                  ; desativa a tecla correspondente a sonda
    
    fim_sonda:
    POP R7
    POP R6
    POP R5
    POP R4
    POP R3                         ;
                             ;
    RET            ; verifica qual a próxima tecla

; **********************************************************************
; move_meteor
;ARGUMENTO R10- POSICAO E DIRECAO DO ASTEROIDE
;argumento R3-NUMERO DO ASTEROIDE
;argumento- R4 DEF DO METEORO(MINERAVEL OU NAO)
; **********************************************************************

move_meteor:                        ;
    CALL play_sound                 ;
    PUSH R1                         ;
    PUSH R2                         ;
    PUSH R4                         ;
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R9

    origem:
    MOV R6, meteoro_posicao
    MOV R7, origem_direcao_meteoro  ; tabela de possiveis direcoes e origens
    ADD R3, 2
    MOV  R9, [R6+R3]   ;vai buscar a REFERENCIA origem_direcao do meteoro x
    CMP R9, 1
    JNZ continua
    MOV R1, 4
    MUL R10,R1                       ; multiplicacao por 4 para aceder A PROXIMA LINHA DA TABELA word
    MOV  R2, [R7+R10]               ; origem do meteoro
    MOV [R6+R3], R10                  ;guarda a REFERENCIA origem_destino do meteoro x
    JMP posicao

    continua:
    MOV R2, [R7+R9]                 ; origem do meteoro 
    MOV R10, R9                     ; o salto necessario para chegar a origem do meteoro

    posicao:
        CMP R2, -1                      ; verificar origem do asteroide na esquerda
        JNZ c_ou_d
        MOV R2, 0                       ; origem no canto esquerdo superior (COORDENADA X E Y)
        MOV R1, R2
        MOV R5,1                        ; origem
        JMP movimento
        c_ou_d:
            CMP R2,0                        ; verificar origem no centro 
            JZ centro
            MOV R2, 57                      ; origem no canto direito (coordenada x)
            MOV R1, 0                       ; origem no canto direito (coordenada Y)
            MOV R5, -1                      ; origem
            JMP movimento
        centro:
            MOV R2, 29                      ; origem no canto direito (coordenada x)
            MOV R1, 0                       ; origem no canto direito (coordenada Y)
            MOV R5,0                        ; origem
    movimento:
        SUB R3,2
        MOV  R9, [R6+R3]                ;vai buscar o num de vezes que x foi movimentado
    tipo_de_asteroide:
        CALL define_type
       direcao2: 
        CMP R5,-1
        JZ direcao_da_direita2
        CMP R5, 0
        JZ direcao_do_centro2 
        direcao_da_esquerda2:
            ADD  R2, R9                      ; move o meteoro 1 para a direita
            ADD  R1, R9                     ; move o meteoro 1 para baixo
            JMP saida2
        direcao_do_centro2:
            ADD R10, 2
            MOV  R10, [R7+R10]   ;vai buscar a  direcao do meteoro x
            CMP R10,-1
            JZ direcao_da_direita2
            CMP R10, 1
            JZ direcao_da_esquerda2
            ADD  R1, R9                     ; move o meteoro 1 para baixo
            JMP saida2
        direcao_da_direita2:
            SUB  R2, R9                      ; move o meteoro 1 para a esquerda
            ADD  R1, R9                     ; move o meteoro 1 para baixo
        saida2:
                              ; POSICAO ATUAL
        CALL apaga_object               ; apaga o meteoro
        ADD  R9, 1                      ; adiciona ao nº de vezes que já se moveu o mteoro
    CALL direcao
    next_2:
    CALL desenha_main               ; desenha o meteoro na nova posição
    MOV R6,meteoro_posicao
    MOV [R6+R3],R9        ;atualiza a posicao do meteoro x
    MOV R4,M_MOVES
    CMP R9, R4                      ; verifica se chegou a ultima linha
    JNZ fim_move_meteor
    MOV R9, 0
    MOV [R6+R3],R9        ;atualiza a posicao do meteoro x
    ADD R3, 2
    MOV R9,1
    MOV [R6+R3],R9        ;REINICIA a REFRENCIA ORIGEM_DESTINO do meteoro x
fim_move_meteor:

    POP  R9
    POP  R7
    POP  R6
    POP  R5
    POP  R4                         ;
    POP  R2                         ;
    POP  R1                         ;
    RET            

; **********************************************************************
; ROT_INT_0 - 	Rotina de atendimento da interrupção 0
;			Assinala o evento na componente 0 da variável evento_int
; **********************************************************************
rot_int_0:
	PUSH R0
	PUSH R1
	MOV  R0, estado_int
	MOV  R1, 1			; assinala que houve uma interrupção 0
	MOV  [R0], R1			; na componente 0 da variável estado_int
	POP  R1
	POP  R0
	RFE
   ; **********************************************************************
; ROT_INT_1 - 	Rotina de atendimento da interrupção 1
;			Assinala o evento na componente 0 da variável evento_int
; **********************************************************************
rot_int_1:
	PUSH R0
	PUSH R1
	MOV  R0, estado_int
    ADD R0,2
	MOV  R1, 1			; assinala que houve uma interrupção 0
	MOV  [R0], R1			; na componente 0 da variável estado_int
	POP  R1
	POP  R0
	RFE

; **********************************************************************
; ROT_INT_2 - 	Rotina de atendimento da interrupção 2
;			Assinala o evento na componente 0 da variável evento_int
; **********************************************************************
rot_int_2:
	PUSH R0
	PUSH R1
	MOV  R0, estado_int
    ADD R0,4                ; estado da rotina esta a duas words de distancia 
	MOV  R1, 1			; assinala que houve uma interrupção 0
	MOV  [R0], R1			; na componente 0 da variável estado_int
	POP  R1
	POP  R0
	RFE


gera_num_aleatorio:
    PUSH R1
    PUSH R10
    PUSH R4
    MOV R1, PIN
    MOVB R10, [R1]
    SHR R10, 5            ;  coloca os bits 7 a 4 (aleatórios) do periférico nos bits 3 a 0 do registo, ficando-se assim com um valor aleatório entre 0 e 3
    CMP R10, 3              ; 
    JNZ m_meteor
    m_mineravel:
    MOVB R10, [R1]
    SHR R10, 4            ;  coloca os bits 7 a 4 (aleatórios) do periférico nos bits 3 a 0 do registo, ficando-se assim com um valor aleatório entre 0 e 15
    MOV R4, 5
    MOD R10, R4             ; posicao e direcao do meteoro aleatoria
    MOV R4, DEF_MINERAVEL_1
    CALL move_meteor
    JMP fim_m

    m_meteor: 
    MOVB R10, [R1]
    SHR R10, 4            ;  coloca os bits 7 a 4 (aleatórios) do periférico nos bits 3 a 0 do registo, ficando-se assim com um valor aleatório entre 0 e 15
    MOV R4, 5
    MOD R10, R4             ; posicao e direcao do meteoro aleatoria
    MOV R4, DEF_METEORO
    CALL move_meteor

    fim_m:    
        POP R4
        POP R10
        POP R1
        RET
;argumentos R5, R2, R1, R10
;DEVOLVE OS MESMOS
direcao:
    PUSH R3
        CMP R5,-1
        JZ direcao_da_direita
        CMP R5, 0
        JZ direcao_do_centro 
        direcao_da_esquerda:
            ADD  R2, 1                      ; move o meteoro 1 para a direita
            ADD  R1, 1                     ; move o meteoro 1 para baixo
            JMP saida
        direcao_do_centro:
            ADD R3, 2
            MOV R10,[R6+R3]         ; vai buscar o valor de R10 inicial
            ADD R10,2                   ;poara ir buscar a direcao
            MOV  R10, [R7+R10]   ;vai buscar a  direcao do meteoro x
            CMP R10,-1
            JZ direcao_da_direita
            CMP R10, 1
            JZ direcao_da_esquerda
            ADD  R1, 1                     ; move o meteoro 1 para baixo
            JMP saida
        direcao_da_direita:
            ADD  R2, -1                      ; move o meteoro 1 para a esquerda
            ADD  R1, 1                     ; move o meteoro 1 para baixo
        saida:
        POP R3
        RET
;argumentos- R3 numero do asteroide
; argumento R9 numero de vezes que o meteoro foi movido
;argumento-R4 tipo de meteoro(definido no gera numero aleatorio)
    define_type:
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R5
    MOV R1,meteoro_type
    MOV R5,2
    DIV R3,R5
    CMP R9,0
    JNZ fim_type
    MOV [R1+R3],R4
    fim_type:
    MOV R4,[R1+R3]      ; LE A INFORMACAO SOBRE O TIPO DE METEORO
    POP R5
    POP R3
    POP R2
    POP R1
    RET



verifica_int1:
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R5
    PUSH R7
    MOV  R5, estado_int
    ADD R5,2            ; a int 1 esta uma word depois da int 0
    MOV  R3, [R5]		; valor da variável que diz se houve uma interrupção com o mesmo número da coluna
    CMP R3,0
    JZ fim_verificacao
    MOV  R7, 5                      ;
    MOV  [SEL_PIXEL_ECRA], R7       ; seleciona o ecrã do meteoro
    CALL move_sonda
    fim_verificacao:
    POP R7
    POP R5
    POP R3
    POP R2
    POP R1
    RET

tiro_esq:
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R5         ;necessario para verificacao dos proximos tiros
    PUSH R6         ;necessario para verificacao dos proximos tiros
    MOV R1, -1
    MOV R2, -1
    MOV R4,0
    CALL verifica_int1
    POP R6
    POP R5
    POP R3
    POP R2
    POP R1
    RET

tiro_cen:
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R5         ;necessario para verificacao dos proximos tiros
    PUSH R6         ;necessario para verificacao dos proximos tiros
    MOV R1, -1
    MOV R2, 0
    MOV R4, 6
    CALL verifica_int1
    POP R6
    POP R5
    POP R3
    POP R2
    POP R1
    RET

tiro_dir:
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R5         ;necessario para verificacao dos proximos tiros
    PUSH R6         ;necessario para verificacao dos proximos tiros
    MOV R1, -1
    MOV R2, 1
    MOV R4,12
    CALL verifica_int1
    POP R6
    POP R5
    POP R3
    POP R2
    POP R1
    RET



; *********************************************************************************
; Constantes
; *********************************************************************************

DISPLAYS   EQU 0A000H               ; endereço para escrita nos displays
POUT       EQU 0C000H               ; endereço do periférico de saída
PIN        EQU 0E000H               ; endereço do periférico de entrada
MASK       EQU 0FH                  ; máscara para bits de menor peso
LINHAS     EQU 16                   ; constante para reset das linhas a verificar no teclado
OP         EQU 4                    ; operador para multiplicação

DEFINE_LINHA    	EQU 600AH       ; endereço do comando para definir a linha
DEFINE_COLUNA  		EQU 600CH       ; endereço do comando para definir a coluna
DEFINE_PIXEL    	EQU 6012H       ; endereço do comando para escrever um pixel
LIMPA_AVISO     	EQU 6040H       ; endereço do comando para apagar o aviso de nenhum cenário selecionado
LIMPA_ECRA 		    EQU 6002H       ; endereço do comando para apagar todos os pixels já desenhados
SEL_FUNDO           EQU 6042H       ; endereço do comando para selecionar uma imagem de fundo
TOCA_SOM			EQU 605AH       ; endereço do comando para tocar um som
SEL_PIXEL_ECRA      EQU 6004H

LINHA_METEORO       EQU 1           ; posição y inicial do meteoro
COLUNA_METEORO		EQU 1           ; posição x inicial do meteoro
HEIGHT_METEORO      EQU 6           ; altura do sprite
LENGTH_METEORO      EQU 6           ; largura do sprite

LINHA_NAVE        	EQU 27          ; posição y inicial da nave
COLUNA_NAVE			EQU 25          ; posição x inicial da nave
HEIGHT_NAVE         EQU 5           ; altura do sprite
LENGTH_NAVE         EQU 15          ; largura do sprite

LINHA_SONDA         EQU 27          ; posição y inicial da nave
COLUNA_SONDA        EQU 32          ; posição x inicial da nave
HEIGHT_SONDA        EQU 1           ; altura do sprite
LENGHT_SONDA        EQU 1           ; largura do sprite

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

DEF_METEORO:					    ; tabela que define o meteoro (Largura - Altura - Desenho)
	WORD		LENGTH_METEORO
	WORD		HEIGHT_METEORO
	WORD		000,RED,RED,RED,RED,000,
                RED,RED,000,000,RED,RED,
                RED,000,000,000,000,RED,
                RED,000,000,000,000,RED,
                RED,RED,000,000,RED,RED,
                000,RED,RED,RED,RED,000

DEF_NAVE:                           ; tabela que define a nave (Largura - Altura - Desenho)
	WORD		LENGTH_NAVE
	WORD		HEIGHT_NAVE
	WORD		000,000,RED,RED,RED,RED,RED,RED,RED,RED,RED,RED,RED,000,000,
				000,RED,GRE,GRE,GRE,GRE,GRE,GRE,GRE,GRE,GRE,GRE,GRE,RED,000,
				RED,GRE,GRE,GRE,WEI,YEL,WEI,WEI,WEI,YEL,WEI,GRE,GRE,GRE,RED,
				RED,GRE,GRE,GRE,WEI,YEL,YEL,WEI,YEL,YEL,WEI,GRE,GRE,GRE,RED,
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
	MOV  SP, SP_inicial             ; inicializa o stack pointer
    MOV  [LIMPA_AVISO], R1	        ; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
    MOV  [LIMPA_ECRA], R1	        ; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
	MOV	 R1, 0			            ; cenário de fundo número 0
    MOV  [SEL_FUNDO], R1	        ; seleciona o cenário de fundo
    MOV  R0, DISPLAYS               ; para aceder aos displays
    MOVB [R0], R1                   ; define os displays a 000
    MOV  R9,0                       ; inicializa o contador da posição do meteoro
    MOV  R6,0                       ; inicializa o contador da posição da sonda


posiciona_nave:                     ; define as coordenadas para desenhar a nave
    MOV  R1, LINHA_NAVE             ; define a coordenada y
    MOV  R2, COLUNA_NAVE            ; define a coordenada x
    MOV  R4, DEF_NAVE			    ; define o que desenhar (nave)
    MOV  R7, 0	                    ;
    MOV  [SEL_PIXEL_ECRA], R7	    ; seleciona o ecra da nave

desenha_nave:                       ; 
    CALL desenha_main               ; desenha o que foi definido em R4, na posição x = R2, y = R1 

posiciona_sonda:                    ; define as coordenadas para desenhar a sonda
    MOV  R1, LINHA_SONDA            ; define a coordenada y
    MOV  R2, COLUNA_SONDA           ; define a coordenada x
    MOV  R4, DEF_SONDA              ; define o que desenhar (sonda)
    MOV  R7, 1                      ; 
    MOV  [SEL_PIXEL_ECRA], R7       ; seleciona o ecrã da sonda

desenha_sonda:                      ;
    CALL desenha_main               ; desenha o que foi definido em R4, na posição x = R2, y = R1 

posiciona_meteoro:                  ; define as coordenadas a desenhar o meteoro
    MOV  R1, LINHA_METEORO          ; define a coordenada y
    MOV  R2, COLUNA_METEORO         ; define a coordenada x
    MOV  R4, DEF_METEORO            ; define o que desenhar (meteoro)
    MOV  R7, 2                      ;
    MOV  [SEL_PIXEL_ECRA], R7       ; seleciona o ecrã do meteoro

desenha_meteoro:                    ;
    CALL desenha_main               ; desenha o que foi definido em R4, na posição x = R2, y = R1 
    JMP  teclado_handler            ; salta para a função que trata de receber o input

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
    PUSH R6                         ;

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
    POP R6                          ;  
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

teclado_handler:                    ;
    PUSH R1                         ;
    PUSH R2                         ;
    PUSH R3                         ;
    PUSH R4                         ;
    MOV  R2, POUT                   ; para aceder ao periférico de saída
    MOV  R3, PIN                    ; para aceder ao periférico de entrada
    MOV  R4, MASK                   ; para isolar os 4 bits de menor peso

reset_linhas:                       ;
    MOV  R1, LINHAS                 ; reset das linhas a serem verificadas

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
    CMP  R0, 0                      ; tecla premida foi 0?
    JZ   move_sonda                 ; move a sonda para cima
    CMP  R0, 4                      ; tecla premida foi 4? 
    JZ   move_meteor                ; move o meteoro para baixo-direita
    MOV  R11, 8                     ; 
    CMP  R0,R11                     ; tecla premida foi 8? 
    JZ   soma                       ; adiciona um ao display
    MOV  R11, 0CH                   ; 
    CMP  R0, R11                    ; tecla premida foi C?
    JZ   subtrai                    ; subtrai um ao display
    JMP  teclado_handler            ; verifica qual a próxima tecla
    
soma:                               ;
    INC  R10                        ; incrementa o valor no display
    CALL update_displays            ; atualiza os displays com o novo valor
    JMP  teclado_handler            ; verifica qual a próxima tecla

subtrai:                            ;
    DEC  R10                        ; decrementa o valor no display
    CALL update_displays            ; atualiza os displays com o novo valor
    JMP  teclado_handler            ; verifica qual a próxima tecla

update_displays:                    ;
    PUSH R1                         ;
    MOV  R1, DISPLAYS               ; para endereçar os displays
    MOV  [R1], R10                  ; escreve o valor de r10 nos displays
    POP  R1                         ;
    RET                             ;

move_sonda:                         ;
    PUSH R1                         ;
    PUSH R2                         ;
    PUSH R4                         ;
    MOV  R4, DEF_SONDA              ; define a sonda como sprite a desenhar
    MOV  R2, COLUNA_SONDA           ; coordenada x a desenhar
    MOV  R1, LINHA_SONDA            ; coordenada y a desenhar
    SUB  R1, R6                     ; nº de vezes que já se moveu a sonda até agora
    CALL apaga_object               ; apaga a sonda
    ADD  R6, 1                      ; adiciona ao nº de vezes que já se moveu a sonda
    SUB  R1, 1                      ; move a sonda 1 para cima
    CALL desenha_main               ; desenha a sonda na nova posição
    POP  R4                         ;
    POP  R2                         ;
    POP  R1                         ;
    JMP  teclado_handler            ; verifica qual a próxima tecla

move_meteor:                        ;
    CALL play_sound                 ;
    PUSH R1                         ;
    PUSH R2                         ;
    PUSH R4                         ;
    MOV  R4, DEF_METEORO            ; define o meteoro como sprite a desenhar
    MOV  R2, COLUNA_METEORO         ; coordenada x e y a desenhar
    ADD  R2, R9                     ; nº de vezes que já se moveu o meteoro até agora
    MOV  R1, R2                     ; x = y
    CALL apaga_object               ; apaga o meteoro
    ADD  R9, 1                      ; adiciona ao nº de vezes que já se moveu o mteoro
    ADD  R2, 1                      ; move o meteoro 1 para a direita
    MOV  R1, R2                     ; move o meteoro 1 para baixo
    CALL desenha_main               ; desenha o meteoro na nova posição
    POP  R4                         ;
    POP  R2                         ;
    POP  R1                         ;
    JMP  teclado_handler            ; verifica qual a próxima tecla

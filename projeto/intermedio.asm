DISPLAYS   EQU 0A000H
POUT       EQU 0C000H 
PIN        EQU 0E000H  
MASK       EQU 0FH     
LINHAS     EQU 16
OP         EQU 4

SET_LINE    		EQU 600AH      ; endereço do comando para definir a linha
SET_COLUMN  		EQU 600CH      ; endereço do comando para definir a coluna
SET_PIXEL    		EQU 6012H      ; endereço do comando para escrever um pixel
CLEAR_WARNING     	EQU 6040H      ; endereço do comando para apagar o aviso de nenhum cenário selecionado
CLEAR_SCREEN 		EQU 6002H      ; endereço do comando para apagar todos os pixels já desenhados
SELECT_BG           EQU 6042H      ; endereço do comando para selecionar uma imagem de fundo
TOCA_SOM			EQU 605AH      ; endereço do comando para tocar um som
SELECT_PIXEL_SCREEN  EQU 6004H

LINE_METEOR        	EQU 1          ;
COLUMN_METEOR		EQU 1          ;
HEIGHT_METEOR       EQU 6
LENGTH_METEOR       EQU 6

LINE_SHIP        	EQU 27         ; 
COLUMN_SHIP			EQU 25         ;
HEIGHT_SHIP         EQU 5          ;
LENGTH_SHIP         EQU 15         ;

LINE_PROBE          EQU 26
COLUMN_PROBE        EQU 32
HEIGHT_PROBE        EQU 1
LENGHT_PROBE        EQU 1

RED           EQU 0FF00H
GRE         EQU 0F0A0H
WEI         EQU 07CAFH
YEL            EQU 0FFF0H


PLACE       1000H
pilha:
	STACK 100H			
SP_inicial:				

DEF_METEOR:					; tabela que define o boneco (cor, largura, pixels)
	WORD		LENGTH_METEOR
	WORD		HEIGHT_METEOR
	WORD		0,RED,RED,RED,RED,0,RED,RED,0,0,RED,RED,RED,0,0,0,0,RED,RED,0,0,0,0,RED,RED,RED,0,0,RED,RED,0,RED,RED,RED,RED,0

DEF_SHIP:
	WORD		LENGTH_SHIP
	WORD		HEIGHT_SHIP
	WORD		000,000,RED,RED,RED,RED,RED,RED,RED,RED,RED,RED,RED,000,000,
				000,RED,GRE,GRE,GRE,GRE,GRE,GRE,GRE,GRE,GRE,GRE,GRE,RED,000,
				RED,GRE,GRE,GRE,WEI,YEL,WEI,WEI,WEI,YEL,WEI,GRE,GRE,GRE,RED,
				RED,GRE,GRE,GRE,WEI,YEL,YEL,WEI,YEL,YEL,WEI,GRE,GRE,GRE,RED,
				RED,GRE,GRE,GRE,GRE,GRE,GRE,GRE,GRE,GRE,GRE,GRE,GRE,GRE,RED

DEF_PROBE:
    WORD        LENGHT_PROBE
    WORD        HEIGHT_PROBE
    WORD        YEL

PLACE   0				
start:                                                              ; Initializing registers
	MOV  SP, SP_inicial                                             ; Initialize the stack pointer at 1200H
    
    MOV [CLEAR_WARNING], R1	; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
    MOV [CLEAR_SCREEN], R1	; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
	MOV	R1, 0			; cenário de fundo número 0
    MOV [SELECT_BG], R1	; seleciona o cenário de fundo
    MOV  R0, DISPLAYS   ;
    MOVB [R0], R1 
    MOV R9,0            ; INICIALIZAR O REGISTO CONTDOR DA POSICAO DO METEORO
    MOV R6,0            ; INICIALIZAR O TREGISTO CONTADOR DA POSICAO DA SONDA


ship_position:
    MOV R1, LINE_SHIP
    MOV R2, COLUMN_SHIP
    MOV R4, DEF_SHIP
    MOV R7, 0
    MOV [SELECT_PIXEL_SCREEN], R7

display_ship:
    CALL graphics


probe_position:
    MOV R1, LINE_PROBE
    MOV R2, COLUMN_PROBE
    MOV R4, DEF_PROBE
    MOV R7, 1
    MOV [SELECT_PIXEL_SCREEN], R7

display_probe:
    CALL graphics

meteor_position:
    MOV R1, LINE_METEOR
    MOV R2, COLUMN_METEOR
    MOV R4, DEF_METEOR
    MOV R7, 2
    MOV [SELECT_PIXEL_SCREEN], R7

display_meteor:
    CALL graphics
    JMP keyboard_handler

graphics:
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R6

    MOV R8, R2
    MOV R5, [R4]
    MOV R6, [R4+2]
    ADD R4, 4
    reset_lenght:
        PUSH R5
    
draw:
    MOV R3, [R4]
    CALL write_pixel
    ADD R4, 2
    ADD R2, 1
    SUB R5, 1
    JNZ draw
    SUB R6, 1
    JZ end_graphics
    POP R5
    ADD R1,1
    MOV R2, R8
    JMP reset_lenght

end_graphics:     
    POP R5
    POP R6   
    POP R4   
    POP R3   
    POP R2   
    POP R1
    RET

erase_object:
	PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R6

    MOV R8, R2
    MOV R5, [R4]
    MOV R6, [R4+2]
    ADD R4, 4
    reset_lenght_erase:
        PUSH R5

erase_pixels:       		; desenha os pixels do boneco a partir da tabela
	MOV R3, 0
    CALL write_pixel
    ADD R4, 2
    ADD R2, 1
    SUB R5, 1
    JNZ erase_pixels
    SUB R6, 1
    JZ end_erase
    POP R5
    ADD R1,1
    MOV R2, R8
    JMP reset_lenght_erase

end_erase:
	POP	R5
    POP R6
	POP	R4
	POP	R3
	POP	R2
	POP R1
	RET

write_pixel:
    MOV [SET_LINE], R1
    MOV [SET_COLUMN], R2
    MOV [SET_PIXEL], R3
    RET

keyboard_handler:
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    MOV  R1, LINHAS     ; to iterate over every keyboard line 
    MOV  R2, POUT       ; address for accessing the output peripheral for keyboard lines
    MOV  R3, PIN        ; address for reading the input peripheral for keyboard columns
    MOV  R4, MASK       ; to isolate the 4 least weighted bits when reading the keyboard lines

detect_key:
    SHR  R1,1
    CMP  R1,0
    JZ   reset_lines
    MOVB [R2], R1
    MOVB R0, [R3]
    AND  R0, R4
    CMP  R0, 0
    JZ   detect_key
    MOV R5, R0

held_key:
    MOVB [R2], R1
    MOVB R0, [R3]
    AND  R0, R4
    CMP  R0, 0
    JNZ  held_key
    MOV R0, R5

convert_input:
    MOV  R2, 0
    CALL counter
    MOV  R3, R2
    MOV  R2, 0
    MOV  R1, R0
    CALL counter
    MOV  R4, OP
    MUL  R3, R4
    ADD  R3, R2
    MOV  R1, R3
    MOV  R0, R1
    JMP  controller
    

counter:
    SHR  R1,1
    CMP  R1,0
    JZ   end_counter
    INC  R2
    JMP  counter
    end_counter:
         RET

reset_lines:
    MOV  R1, LINHAS
    JMP  detect_key

play_sound:
    PUSH R9
    MOV  R9, 0
    MOV  [TOCA_SOM], R9
    POP  R9
    RET



controller:
    POP R4
    POP R3
    POP R2
    POP R1
    CMP  R0, 0
    JZ   move_sonda

    CMP  R0, 4
    JZ   move_meteor

    MOV  R11, 8
    CMP  R0,R11
    JZ   sum

    MOV  R11, 0CH
    CMP  R0, R11
    JZ   subtract
    JMP  keyboard_handler
    
sum:
    INC  R10
    CALL update_displays
    JMP  keyboard_handler

subtract:
    DEC  R10
    CALL update_displays
    JMP  keyboard_handler

update_displays:
    PUSH R1
    MOV  R1, DISPLAYS
    MOV  [R1],R10
    POP R1
    RET

move_sonda:
PUSH R1
PUSH R2
PUSH R4
MOV R4, DEF_PROBE
MOV R2, COLUMN_PROBE
MOV R1, LINE_PROBE
SUB R1,R6 
CALL erase_object
    ADD R6, 1
    SUB R1, 1
    CALL graphics
POP  R4
POP R2
POP R1
    JMP keyboard_handler
    
move_meteor:
CALL play_sound
PUSH R1
PUSH R2
PUSH R4
MOV R4, DEF_METEOR
MOV R2, COLUMN_METEOR
ADD R2, R9
MOV R1, R2 
CALL erase_object
    ADD R9, 1
    ADD R2, 1
    MOV R1, R2
    CALL graphics
POP R4
POP R2
POP R1
    JMP keyboard_handler

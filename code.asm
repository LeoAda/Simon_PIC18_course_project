#include "p18f25k40.inc"

; CONFIG1L
  CONFIG  FEXTOSC = ECH         ; External Oscillator mode Selection bits (EC (external clock) above 8 MHz; PFM set to high power)
  CONFIG  RSTOSC = HFINTOSC_64MHZ       ; Power-up default value for COSC bits (EXTOSC operating per FEXTOSC bits (device manufacturing default))

; CONFIG1H
  CONFIG  CLKOUTEN = OFF        ; Clock Out Enable bit (CLKOUT function is disabled)
  CONFIG  CSWEN = ON            ; Clock Switch Enable bit (Writing to NOSC and NDIV is allowed)
  CONFIG  FCMEN = ON            ; Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor enabled)

; CONFIG2L
  CONFIG  MCLRE = EXTMCLR       ; Master Clear Enable bit (If LVP = 0, MCLR pin is MCLR; If LVP = 1, RE3 pin function is MCLR )
  CONFIG  PWRTE = OFF           ; Power-up Timer Enable bit (Power up timer disabled)
  CONFIG  LPBOREN = OFF         ; Low-power BOR enable bit (ULPBOR disabled)
  CONFIG  BOREN = SBORDIS       ; Brown-out Reset Enable bits (Brown-out Reset enabled , SBOREN bit is ignored)

; CONFIG2H
  CONFIG  BORV = VBOR_2P45      ; Brown Out Reset Voltage selection bits (Brown-out Reset Voltage (VBOR) set to 2.45V)
  CONFIG  ZCD = OFF             ; ZCD Disable bit (ZCD disabled. ZCD can be enabled by setting the ZCDSEN bit of ZCDCON)
  CONFIG  PPS1WAY = ON          ; PPSLOCK bit One-Way Set Enable bit (PPSLOCK bit can be cleared and set only once; PPS registers remain locked after one clear/set cycle)
  CONFIG  STVREN = ON           ; Stack Full/Underflow Reset Enable bit (Stack full/underflow will cause Reset)
  CONFIG  DEBUG = OFF           ; Debugger Enable bit (Background debugger disabled)
  CONFIG  XINST = OFF           ; Extended Instruction Set Enable bit (Extended Instruction Set and Indexed Addressing Mode disabled)

; CONFIG3L
  CONFIG  WDTCPS = WDTCPS_31    ; WDT Period Select bits (Divider ratio 1:65536; software control of WDTPS)
  CONFIG  WDTE = OFF             ; WDT operating mode (WDT enabled regardless of sleep)

; CONFIG3H
  CONFIG  WDTCWS = WDTCWS_7     ; WDT Window Select bits (window always open (100%); software control; keyed access not required)
  CONFIG  WDTCCS = SC           ; WDT input clock selector (Software Control)

; CONFIG4L
  CONFIG  WRT0 = OFF            ; Write Protection Block 0 (Block 0 (000800-001FFFh) not write-protected)
  CONFIG  WRT1 = OFF            ; Write Protection Block 1 (Block 1 (002000-003FFFh) not write-protected)
  CONFIG  WRT2 = OFF            ; Write Protection Block 2 (Block 2 (004000-005FFFh) not write-protected)
  CONFIG  WRT3 = OFF            ; Write Protection Block 3 (Block 3 (006000-007FFFh) not write-protected)

; CONFIG4H
  CONFIG  WRTC = OFF            ; Configuration Register Write Protection bit (Configuration registers (300000-30000Bh) not write-protected)
  CONFIG  WRTB = OFF            ; Boot Block Write Protection bit (Boot Block (000000-0007FFh) not write-protected)
  CONFIG  WRTD = OFF            ; Data EEPROM Write Protection bit (Data EEPROM not write-protected)
  CONFIG  SCANE = ON            ; Scanner Enable bit (Scanner module is available for use, SCANMD bit can control the module)
  CONFIG  LVP = ON              ; Low Voltage Programming Enable bit (Low voltage programming enabled. MCLR/VPP pin function is MCLR. MCLRE configuration bit is ignored)

; CONFIG5L
  CONFIG  CP = OFF              ; UserNVM Program Memory Code Protection bit (UserNVM code protection disabled)
  CONFIG  CPD = OFF             ; DataNVM Memory Code Protection bit (DataNVM code protection disabled)

; CONFIG5H

; CONFIG6L
  CONFIG  EBTR0 = OFF           ; Table Read Protection Block 0 (Block 0 (000800-001FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR1 = OFF           ; Table Read Protection Block 1 (Block 1 (002000-003FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR2 = OFF           ; Table Read Protection Block 2 (Block 2 (004000-005FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR3 = OFF           ; Table Read Protection Block 3 (Block 3 (006000-007FFFh) not protected from table reads executed in other blocks)

; CONFIG6H
  CONFIG  EBTRB = OFF           ; Boot Block Table Read Protection bit (Boot Block (000000-0007FFh) not protected from table reads executed in other blocks)

INT_VAR        UDATA_ACS
    TEST RES 1
    VAL RES 1
    VAL_IN RES 1
    VAL_SAVE RES 1
    VAL_ALEA RES 1
    COUNTER_TM0 RES 1
    COMPTEUR RES 1
    COMPTEUR_IN RES 1
    FLAG_GAME_TIMER RES 1
    FLAG_WAIT_BUTTON RES 1
    LEVEL RES 1 
    WIN RES 1

ISRHV     CODE    0x0008
   GOTO    HIGH_ISR
ISRH      CODE                     
HIGH_ISR
    MOVLB 0x0F
    BTFSC IOCBF,0,1
    CALL routine_bouton_0
    BTFSC IOCBF,1,1
    CALL routine_bouton_1
    BTFSC IOCBF,2,1
    CALL routine_bouton_2
    BTFSC IOCBF,3,1
    CALL routine_bouton_3
    
    MOVLB 0x0E
    BTFSC PIR0,5,1
    CALL routine_timer
    
    RETFIE  FAST
RES_VECT  CODE    0x0000           
    GOTO    START2                   

MAIN_PROG CODE
    routine_bouton_0:
	BCF FLAG_WAIT_BUTTON,0
	MOVLW d'0'
	MOVWF TEST
	MOVLB 0x0F
	BCF IOCBF,0,1
	RETURN
    routine_bouton_1:
	BCF FLAG_WAIT_BUTTON,0
	MOVLW d'1'
	MOVWF TEST
	MOVLB 0x0F
	BCF IOCBF,1,1
	RETURN
    routine_bouton_2:
	BCF FLAG_WAIT_BUTTON,0
	MOVLW d'2'
	MOVWF TEST
	MOVLB 0x0F
	BCF IOCBF,2,1
	RETURN
    routine_bouton_3:
	BCF FLAG_WAIT_BUTTON,0
	MOVLW d'3'
	MOVWF TEST
	MOVLB 0x0F
	BCF IOCBF,3,1
	RETURN
    routine_tempo_led:
	BTG LATC,7
	MOVLW d'0'
	BTFSC COUNTER_TM0,0
	CALL RGB_START1
	BTFSS COUNTER_TM0,0
	CALL RGB_START2
	COMF COUNTER_TM0
	RETURN
    routine_timer:
	CALL unsec
	MOVLB 0x0E
	BCF PIR0,5,1
	BTFSS FLAG_GAME_TIMER,0
	call routine_tempo_led
	BTFSC FLAG_GAME_TIMER,0
	CALL routine_level
	BCF FLAG_GAME_TIMER,0
	RETURN
    routine_level:
	BTFSC LEVEL,0
	CALL quartsec
	BTFSS LEVEL,0
	CALL demisec
	RETURN

    RGB_START1
	CALL BLEU
	CALL JAUNE
	CALL VERT
	CALL ROUGE
	RETURN
    RGB_START2
	CALL ROUGE
	CALL BLEU
	CALL JAUNE
	CALL VERT
	RETURN
    
    ROUGE
	CALL off
	CALL on
	CALL off
	RETURN
    VERT
	CALL on
	CALL off
	CALL off
	RETURN
    BLEU
	CALL off
	CALL off
	CALL on
	RETURN
    JAUNE
	CALL on
	CALL on
	CALL off
    	RETURN
    ETEINT
	CALL off
	CALL off
	CALL off
	RETURN
    BLANC
	CALL on
	CALL on
	CALL on
	RETURN
COURT
	BSF LATB, 5
	NOP
	NOP
	NOP
	BCF LATB, 5
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	RETURN
LONG
	BSF LATB, 5
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	BCF LATB, 5
	NOP
	NOP
	NOP
	NOP
	NOP
	RETURN
    on
	CALL COURT
	CALL COURT
	CALL LONG
	CALL COURT
	CALL COURT
	CALL COURT
	CALL COURT
	CALL COURT
	RETURN
    off
	CALL COURT
	CALL COURT
	CALL COURT
	CALL COURT
	CALL COURT
	CALL COURT
	CALL COURT
	CALL COURT
	RETURN
START2
    CALL INIT
    CALL TIMER_SEC
    CALL STARTER
    
	
    GOTO $
INIT:
    BCF FLAG_GAME_TIMER,0
    CALL INIT_ALEA
    CALL INIT_BOUTON
    CALL INIT_RGB
    CALL INIT_GLED
    CALL INIT_BUZZER
    RETURN
STARTER:
    BOUCLE_START
    btfss PORTB,2			
    goto OFF_START		
    ON_START
    goto BOUCLE_START		
    OFF_START
    CALL C2
    BCF T0CON0,7
    BCF T1CON,0
    BTG LATC,6
    MOVFF TMR1L,VAL
    MOVFF VAL,VAL_ALEA
    CALL MENU
    
    goto BOUCLE_START
    return
MENU:
    CALL WIN_SCORE
    CLRF WIN
    CALL ETEINT
    CALL ROUGE
    CALL ETEINT
    CALL VERT
    BOUCLE_MENU
    btfss PORTB,3			
    goto OFF_MENU_EASY		
    GOTO MENU_HARD
    
    OFF_MENU_EASY
    MOVFF VAL,VAL_SAVE
    BCF LEVEL,0
    CALL C3
    CALL EASY
    goto BOUCLE_MENU
    
    MENU_HARD
    btfss PORTB,1
    goto OFF_MENU_HARD		
    GOTO BOUCLE_MENU
    
    OFF_MENU_HARD
    MOVFF VAL,VAL_SAVE
    BSF LEVEL,0
    CALL C1
    CALL HARD
    goto BOUCLE_MENU
    
    
    
    return
    

EASY:
    MOVFF VAL_SAVE,VAL
    CALL VERT
    CALL VERT
    CALL VERT
    CALL VERT
    MOVLW d'4'
    ADDWF WIN,0
    MOVWF COMPTEUR
    MOVFF COMPTEUR,COMPTEUR_IN
    
    CALL WAIT
    CALL ETEINT
    CALL ETEINT
    CALL ETEINT
    CALL ETEINT
    CALL WAIT
    
    BOUCLE_SEQUENCE_EASY
    CALL RANDOM
    MOVF VAL,0
    ANDLW d'3'
    MOVWF VAL_IN
    
    MOVLW 0x0
    SUBWF VAL_IN,w		;Choix - W -> W
    BTFSC STATUS,Z		;Z=1 si le resultat d'une operation est =0
    CALL C0
    MOVLW 0x1
    SUBWF VAL_IN,w		
    BTFSC STATUS,Z		
    CALL C1
    MOVLW 0x2
    SUBWF VAL_IN,w		
    BTFSC STATUS,Z		
    CALL C2
    MOVLW 0x3
    SUBWF VAL_IN,w		
    BTFSC STATUS,Z		
    CALL C3
    DECF COMPTEUR_IN
    TSTFSZ COMPTEUR_IN
    GOTO BOUCLE_SEQUENCE_EASY
    
    
    CALL ETEINT
    CALL ETEINT
    CALL ETEINT
    CALL ETEINT
    CALL WAIT
    
    MOVFF COMPTEUR,COMPTEUR_IN
    MOVLB 0x0E
    BSF PIE0,4,1
    MOVLB 0x0F
    MOVLW b'00001111'
    MOVWF IOCBN,1
    
    MOVFF VAL_SAVE,VAL
    
    TEST_EASY

    BSF FLAG_WAIT_BUTTON,0
    WAIT_BUTTON
    
    
    BTFSC FLAG_WAIT_BUTTON,0
    GOTO WAIT_BUTTON
    
    MOVLW 0x0
    SUBWF TEST,w		
    BTFSC STATUS,Z		
    CALL C0
    MOVLW 0x1
    SUBWF TEST,w		
    BTFSC STATUS,Z		
    CALL C1
    MOVLW 0x2
    SUBWF TEST,w		
    BTFSC STATUS,Z		
    CALL C2
    MOVLW 0x3
    SUBWF TEST,w		
    BTFSC STATUS,Z		
    CALL C3
    
    CALL RANDOM
    MOVF VAL,0
    ANDLW d'3'
    SUBWF TEST,w
    BTFSS STATUS,Z
    GOTO PERDU
    DECF COMPTEUR_IN
    
    CLRF WREG
    SUBWF COMPTEUR_IN,WREG
    BTFSC STATUS,Z
    GOTO WINS
    
    GOTO TEST_EASY
    GOTO PERDU

    
    WINS
    INCF WIN
    GOTO EASY
    
    PERDU
    CALL ROUGE
    CALL ROUGE
    CALL ROUGE
    CALL ROUGE
    CALL NOTE1
    CALL WAIT
    CALL OFF_NOTE
    CALL MENU
    return
HARD:
    CALL EASY
    CALL MENU
    return
INIT_ALEA:
    CLRF T1GCON
    MOVLW b'00000001'
    MOVWF T1CON
    MOVLW b'00000001'
    MOVWF T1CLK
    CLRF TMR1L
    MOVLB 0x0E
    bcf PIR4,0,1
    RETURN
INIT_BOUTON:
    MOVLW b'00001111'
    MOVWF TRISB
    MOVLW b'11110000'
    BANKSEL ANSELB
    MOVWF ANSELB
    RETURN
INIT_RGB:
    MOVLW b'01100000'
    MOVWF OSCCON1
    MOVLW b'00001111'
    MOVWF TRISB
    RETURN
INIT_GLED:
    CLRF PORTC
    BCF TRISC,7
    BCF TRISC,6
    BCF TRISC,5
    BCF TRISC,4
    RETURN
TIMER_SEC:
    CLRF COUNTER_TM0
    MOVLW b'10010000'
    MOVWF T0CON0
    MOVLW b'01001000'
    MOVWF T0CON1
    CALL unsec
    BSF INTCON,7
    BSF INTCON,6
    MOVLB 0x0E
    BSF PIE0,5,1
    RETURN
RANDOM:
    BCF     STATUS,C    
    RRCF    VAL,W
    BTFSC   STATUS,C
    XORWF VAL_ALEA,0
    ;XORLW   0x45 
    MOVWF   VAL   
    RETURN
C0:
    CALL NOTE1
    CALL BLEU
    CALL ETEINT
    CALL ETEINT
    CALL ETEINT
    CALL WAIT
    CALL OFF_NOTE
    RETURN
C1:
    CALL NOTE2
    CALL ETEINT
    CALL ROUGE
    CALL ETEINT
    CALL ETEINT
    CALL WAIT
    CALL OFF_NOTE
    RETURN
C2:
    CALL NOTE3
    CALL ETEINT
    CALL ETEINT
    CALL JAUNE
    CALL ETEINT
    CALL WAIT
    CALL OFF_NOTE
    RETURN
C3:
    CALL NOTE4
    CALL ETEINT
    CALL ETEINT
    CALL ETEINT
    CALL VERT
    CALL WAIT
    CALL OFF_NOTE
    RETURN
WAIT:
    BSF T0CON0,7
    BSF FLAG_GAME_TIMER,0
    wait1
    BTFSC FLAG_GAME_TIMER,0
    goto wait1
    BCF T0CON0,7
    RETURN
WIN_SCORE:
    BCF LATC,7
    BCF LATC,6
    BCF LATC,5
    BCF LATC,4
    BTFSC WIN,0
    BSF LATC,7
    BTFSC WIN,1
    BSF LATC,6
    BTFSC WIN,2
    BSF LATC,5
    BTFSC WIN,3
    BSF LATC,4
    RETURN
INIT_BUZZER:
    MOVLW b'11111111'
    MOVWF TRISC
    MOVLW b'00000000'
    MOVWF PWM3CON
    MOVLW 0x00 ;00
    MOVWF PWM3DCL
    MOVLB 0x0E
    BCF PIR4,2,1
    MOVLW b'00000001'
    MOVWF T2CLKCON  
    MOVLW b'11100000'
    MOVWF T2CON
    MOVLW b'00000000' 
    MOVWF LATC
    MOVLW b'00000000'
    MOVWF TRISC
    MOVLW b'00010000'
    MOVWF CCPTMRS
    MOVLW b'00000111'
    MOVWF RC1PPS,1
    RETURN
NOTE1:
    MOVLW 0xFF ; frequence 
    MOVWF T2PR
    MOVLW 0x7F ;80
    MOVWF  PWM3DCH
    MOVLW b'10000000'
    MOVWF PWM3CON
    RETURN
NOTE2:
    MOVLW 0xEB ; frequence 
    MOVWF T2PR
    MOVLW 0x75
    MOVWF  PWM3DCH
    MOVLW b'10000000'
    MOVWF PWM3CON
    RETURN
NOTE3:
    MOVLW 0xD7 ; frequence 
    MOVWF T2PR
    MOVLW 0x6B ;80
    MOVWF  PWM3DCH
    MOVLW b'10000000'
    MOVWF PWM3CON
    RETURN
NOTE4:
    MOVLW 0xC8 ; frequence 
    MOVWF T2PR
    MOVLW 0x64 
    MOVWF  PWM3DCH
    MOVLW b'10000000'
    MOVWF PWM3CON
    RETURN
OFF_NOTE:
    MOVLW b'00000000'
    MOVWF PWM3CON
    RETURN
    
unsec:
    MOVLW h'0B'
    MOVWF TMR0H
    MOVLW h'DB'
    MOVWF TMR0L
    RETURN
demisec:
    MOVLW h'85'
    MOVWF TMR0H
    MOVLW h'ED'
    MOVWF TMR0L
    RETURN
quartsec:
    MOVLW h'C2'
    MOVWF TMR0H
    MOVLW h'F6'
    MOVWF TMR0L
    RETURN
    
    

END
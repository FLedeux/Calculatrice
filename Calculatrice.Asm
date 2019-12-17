
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt


.model tiny        ;POUR RADASM : decommenter

        code    segment

        org     100h

DEB:

;org 100h   ;a commenter sur RADASM

JMP start


;======== constante======
X_ecran EQU 3
X_num1 EQU 3
X_num2 EQU 8
X_num3 EQU 13
X_num4 EQU 18
X_num5 EQU 23
X_num6 EQU 28

Y_ecran EQU 5
Y_num1 EQU 7
Y_num2 EQU 11
Y_num3 EQU 15
Y_num4 EQU 19


;===== variable =============
SAVE_SI DW ?

LBL_BTN DB ?

NB_PRINT DW ?

POS_ECRAN_X DB 5
POS_ECRAN_Y DB 2

NB1 DW 0
SIGNE_NB1 DW "+"

NB2 DW 0
SIGNE_NB2 DW "+"

NB3 DW ?
SIGNE_NB3 DW "+"

SIGNE DB "+"   ;correspond a l'operateur 
SWITCH_SIGNE DB 0 ;booleen permet de savoir si l'operateur a deja ete choisi

COMPTEUR DW 0

;=========affiche le chiffre du bouton numérique sur lequel on a appuie===================
DIGITPRESS_P MACRO
    CMP COMPTEUR,4
    JGE main_loop
    INC COMPTEUR
    
    MOV AH, 2
    MOV DH, POS_ECRAN_Y
    MOV DL, POS_ECRAN_X
    MOV BH, 0
    INT 10H

    MOV AX, NB_PRINT
    MOV AH, 0AH
    MOV CX, 1
    INT 10H
    INC DL
    MOV POS_ECRAN_X, DL
    
ENDM

;=================ecrit le signe de nb1 ou de nb======================
SIGNEPRESS MACRO
    
    MOV AH, 2
    MOV DH, POS_ECRAN_Y
    MOV DL, POS_ECRAN_X
    MOV BH, 0
    INT 10H

    MOV AH, 0AH
    MOV CX, 1
    INT 10H
    INC DL
    MOV POS_ECRAN_X, DL

    ENDM

;=========== affiche le le nombre qui est le plus haut dans la pile ================   
PRINT_D_NB3 PROC
    
    MOV SAVE_SI, SI
    POP SI
    
    MOV AH, 2
    MOV DH, POS_ECRAN_Y
    MOV DL, POS_ECRAN_X
    MOV BH, 0
    INT 10H
        
    POP AX
    ADD AX, 30H
    MOV AH, 0AH
    CMP AL, 58
    JB S_PRINT_D_NB3 
    
    ADD AL, 7
    
S_PRINT_D_NB3:    
    MOV CX, 1
    INT 10H
    INC DL
    MOV POS_ECRAN_X, DL
    
    PUSH SI
    MOV SI, SAVE_SI
    
    RET

PRINT_D_NB3 ENDP

;=========  permet  d'obtenir le signe de nb3 pour la multiplication et la division  =======================                     
CMP_SIGNE_REST PROC      ; regarde le signe 
    MOV AX, SIGNE_NB1
    CMP AX, SIGNE_NB2
    JE S_NB3_P
    
    MOV SIGNE_NB3, "-"
    JMP END_S_NB3_REST
    
S_NB3_P:
    
    MOV SIGNE_NB3, "+"

END_S_NB3_REST:

    ret

CMP_SIGNE_REST ENDP 


;==========nettoyage de l'ecran 
SCREEN_CLEAR PROC

    MOV SAVE_SI, SI
    POP SI
 
    XOR AX, AX
    MOV DL, 4
    MOV DH, 2
    
L_CLEAR:         ;clear les 3 lignes de l'ecran
    
    CMP AX, 3
    JGE CLEARED
    
    INC AX
    PUSH AX
    
    MOV AH, 2
    MOV BH, 0
    INT 10H

    MOV AH, 0AH
    MOV AL, 0
    MOV CX, 16
    INT 10H
    INC DH
    POP AX
    
    JMP L_CLEAR
 
CLEARED: 
    
    PUSH SI
    MOV SI, SAVE_SI

    RET

SCREEN_CLEAR ENDP




;========== ecriture des boutons =========== 
ECTBTN PROC
       
   MOV SAVE_SI, SI
   POP SI
   POP DX ;on ressort les valeur X Y
   
   
           ;partie gauche
    
    
    MOV AH, 2
    MOV BH, 0
    INT 10H

    MOV AH, 0AH
    MOV AL, 218
    MOV CX, 1
    INT 10H
    
    MOV AH, 2
    INC DH
    MOV BH, 0
    INT 10H
    
    MOV AH, 0AH
    MOV AL, 179
    MOV CX, 1
    INT 10H
            
    MOV AH, 2
    INC DH
    MOV BH, 0
    INT 10H
    
    MOV AH, 0AH
    MOV AL, 192
    MOV CX, 1
    INT 10H
    
    
   ;partie centrale
   
   
    MOV AH, 2
    SUB DH, 2
    INC DL
    MOV BH, 0
    INT 10H

    MOV AH, 0AH
    MOV AL, 196
    MOV CX, 1
    INT 10H
    
    MOV AH, 2
    INC DH
    MOV BH, 0
    INT 10H
    

    POP AX
    MOV CX, 1
    INT 10H
            
    MOV AH, 2
    INC DH
    MOV BH, 0
    INT 10H
    
    MOV AH, 0AH
    MOV AL, 196
    MOV CX, 1
    INT 10H
    
    ;partie droite
    
    MOV AH, 2
    SUB DH, 2
    INC DL
    MOV BH, 0
    INT 10H

    MOV AH, 0AH
    MOV AL, 191
    MOV CX, 1
    INT 10H
    
    MOV AH, 2
    INC DH
    MOV BH, 0
    INT 10H
    
    MOV AH, 0AH
    MOV AL, 179
    MOV CX, 1
    INT 10H
            
    MOV AH, 2
    INC DH
    MOV BH, 0
    INT 10H
    
    MOV AH, 0AH
    MOV AL, 217
    MOV CX, 1
    INT 10H
    
    PUSH SI
    MOV SI, SAVE_SI
        
        RET
ECTBTN  ENDP

;============procedure qui attribue une valeur on fonction de ou on click sur l'interface
CHECK PROC
   MOV SAVE_SI, SI
   POP SI

   POP DX
   POP CX
   ;test si X=btnX1
   
   MOV AL, X_num1
   MOV BX, 8
   PUSH DX
   MUL BX 
   POP DX
   DEC AX 
   
   CMP CX, AX         ;regarde X
   JB  HRS
   
   MOV AL, X_num1
   ADD AX, 3 
   PUSH DX
   MUL BX 
   POP DX
   
   CMP CX, AX
   JB X_1_vld 
   
   ;test si X=btnX2
   
   MOV AL, X_num2
   PUSH DX
   MUL BX 
   POP DX   
   DEC AX 
   
   CMP CX, AX         ;regarde X
   JB HRS
   
   MOV AL, X_num2
   ADD AX, 3 
   PUSH DX
   MUL BX 
   POP DX   
   
   CMP CX, AX
   JB X_2_vld
   
   ;test si X=btnX3
   
   MOV AL, X_num3
   PUSH DX
   MUL BX 
   POP DX   
   DEC AX 
   
   CMP CX, AX         ;regarde X
   JB HRS
   
   MOV AL, X_num3
   ADD AX, 3 
   PUSH DX
   MUL BX 
   POP DX   
   
   CMP CX, AX
   JB X_3_vld   
    
    
   ;test si X=btnX4 
    
   MOV AL, X_num4
   PUSH DX
   MUL BX 
   POP DX   
   DEC AX 
   
   CMP CX, AX         ;regarde X
   JB HRS
   
   MOV AL, X_num4
   ADD AX, 3 
   PUSH DX
   MUL BX 
   POP DX   
   
   CMP CX, AX
   JB X_4_vld   
   
   ;test si X=btnX5 
    
   MOV AL, X_num5
   PUSH DX
   MUL BX 
   POP DX   
   DEC AX 
   
   CMP CX, AX         ;regarde X
   JB HRS
   
   MOV AL, X_num5
   ADD AX, 3 
   PUSH DX
   MUL BX 
   POP DX   
   
   CMP CX, AX
   JB X_5_vld   
   
   
   ;test si X=btnX5 
   
   MOV AL, X_num6
   PUSH DX
   MUL BX 
   POP DX   
   DEC AX 
   
   CMP CX, AX         ;regarde X
   JB HRS
   
   MOV AL, X_num6
   ADD AX, 3 
   PUSH DX
   MUL BX 
   POP DX   
   
   CMP CX, AX
   JB X_6_vld   
   
   

   JMP HRS
   
   
   
   
   
;--------------------zone check X VALIDE-----------------------   
   
  ;assigne une valeur pour la position en absice de X 
   
X_1_vld:
   MOV AX, 1
   MOV LBL_BTN, AL
   JMP CHECK_COOR_Y
   
X_2_vld:
   MOV AX, 2
   MOV LBL_BTN, AL
   JMP CHECK_COOR_Y
      
X_3_vld:
   MOV AX, 3
   MOV LBL_BTN, AL
   JMP CHECK_COOR_Y
      
X_4_vld:
   MOV AX, 4
   MOV LBL_BTN, AL
   JMP CHECK_COOR_Y
      
X_5_vld:
   MOV AX, 5
   MOV LBL_BTN, AL
   JMP CHECK_COOR_Y
   
X_6_vld:
   MOV AX, 6
   MOV LBL_BTN, AL
   JMP CHECK_COOR_Y
;-------------------------zone check Y--------------------------

CHECK_COOR_Y:      ;regarde les coordonnees lors du click gauche et regarde si elle appartienne a un btn en Y

;test si Y=btnY1
   
   MOV AL, Y_num1
   PUSH DX
   MUL BX 
   POP DX
   DEC AX 
   
   CMP DX, AX         ;regarde Y
   JB HRS
   
   MOV AL, Y_num1
   ADD AX, 3 
   PUSH DX
   MUL BX 
   POP DX
   
   CMP DX, AX
   JB Y_1_vld 
   
   ;test si Y=btnY2
   
   MOV AL, Y_num2
   PUSH DX
   MUL BX 
   POP DX
   DEC AX 
   
   CMP DX, AX         ;regarde Y
   JB HRS
   
   MOV AL, Y_num2
   ADD AX, 3 
   PUSH DX
   MUL BX 
   POP DX
   
   CMP DX, AX
   JB Y_2_vld
   
   ;test si Y=btnY3
   
   MOV AL, Y_num3
   PUSH DX
   MUL BX 
   POP DX
   DEC AX 
   
   CMP DX, AX         ;regarde Y
   JB HRS
   
   MOV AL, Y_num3
   ADD AX, 3 
   PUSH DX
   MUL BX 
   POP DX
   
   CMP DX, AX
   JB Y_3_vld   
    
    
   ;test si Y=btnY4 
    
   MOV AL, Y_num4
   PUSH DX
   MUL BX 
   POP DX
   DEC AX 
   
   CMP DX, AX         ;regarde Y
   JB HRS
   
   MOV AL, Y_num4
   ADD AX, 3 
   PUSH DX
   MUL BX 
   POP DX
   
   CMP DX, AX
   JB Y_4_vld
   
   JMP HRS   
;--------------------zone check Y VALIDE-----------------------
   
; donne une position pour l'ordonnee de Y

Y_1_vld:
   MOV AL, LBL_BTN
   MOV BX, 10H
   MUL BX
   ADD AX, 1
   JMP END_CK
   
Y_2_vld:
   MOV AL, LBL_BTN
   MOV BX, 10H
   MUL BX
   ADD AX, 2
   JMP END_CK
      
Y_3_vld:
   MOV AL, LBL_BTN
   MOV BX, 10H
   MUL BX
   ADD AX, 3
   JMP END_CK
      
Y_4_vld:
   MOV AL, LBL_BTN 
   MOV BX, 10H
   MUL BX
   ADD AX, 4
   JMP END_CK

HRS:
   XOR AX, AX
END_CK:
   PUSH AX
   PUSH SI
   MOV SI, SAVE_SI
   RET
CHECK ENDP


start:    

    ;mettre mode video
    MOV AH, 0
    MOV AL, 03H
    INT 10H


;--------------------------------------------------------------------    
;|             creation affichage graphique                         |
;--------------------------------------------------------------------


;       ----------------------
;       |creation des boutons|
;       ----------------------

;-----------------premiere ligne---------    
        MOV AL, "7"
        MOV AH, 0AH
        PUSH AX 
        
        MOV AL, X_num1        
        MOV AH, Y_num1      
        PUSH AX
    
        CALL ECTBTN
    ;----    
        MOV AL, "8"
        MOV AH, 0AH
        PUSH AX 
    
        MOV AL, X_num2
        MOV AH, Y_num1      
        PUSH AX    
    
        CALL ECTBTN
    ;----
        MOV AL, "9"
        MOV AH, 0AH
        PUSH AX 
    
        MOV AL, X_num3
        MOV AH, Y_num1      
        PUSH AX
        
        CALL ECTBTN    
    ;----
        MOV AL, 246
        MOV AH, 0AH
        PUSH AX 
    
        MOV AL, X_num4
        MOV AH, Y_num1      
        PUSH AX
        
        CALL ECTBTN
        
        ;----
        
        MOV AL, "%"
        MOV AH, 0AH
        PUSH AX
        
        MOV AL, X_num5
        MOV AH, Y_num1
        PUSH AX
        
        CALL ECTBTN
    
    ;----
        
        MOV AL, "C"
        MOV AH, 0AH
        PUSH AX 
    
        MOV AL, X_num6
        MOV AH, Y_num1      
        PUSH AX
        
        CALL ECTBTN
           
        
;--------------deuxieme ligne  ----------


        MOV AL, "4"
        MOV AH, 0AH
        PUSH AX 
        
        MOV AL, X_num1        
        MOV AH, Y_num2      
        PUSH AX
    
        CALL ECTBTN
    ;----    
        MOV AL, "5"
        MOV AH, 0AH
        PUSH AX 
    
        MOV AL, X_num2
        MOV AH, Y_num2      
        PUSH AX    
    
        CALL ECTBTN
    ;----
        MOV AL, "6"
        MOV AH, 0AH
        PUSH AX 
    
        MOV AL, X_num3
        MOV AH, Y_num2      
        PUSH AX
        
        CALL ECTBTN    
    ;----
        MOV AL, "*"
        MOV AH, 0AH
        PUSH AX 
    
        MOV AL, X_num4
        MOV AH, Y_num2      
        PUSH AX
        
        CALL ECTBTN
        
    ;---- 
        MOV AL, "^"
        MOV AH, 0AH
        PUSH AX 
    
        MOV AL, X_num5
        MOV AH, Y_num2      
        PUSH AX
        
        CALL ECTBTN 
    
    ;---- 
        MOV AL, 174
        MOV AH, 0AH
        PUSH AX 
    
        MOV AL, X_num6
        MOV AH, Y_num2      
        PUSH AX
        
        CALL ECTBTN
               
        
;--------------troisieme ligne  ----------


        MOV AL, "1"
        MOV AH, 0AH
        PUSH AX 
        
        MOV AL, X_num1        
        MOV AH, Y_num3      
        PUSH AX
    
        CALL ECTBTN
    ;----    
        MOV AL, "2"
        MOV AH, 0AH
        PUSH AX 
    
        MOV AL, X_num2
        MOV AH, Y_num3      
        PUSH AX    
    
        CALL ECTBTN
    ;----
        MOV AL, "3"
        MOV AH, 0AH
        PUSH AX 
    
        MOV AL, X_num3
        MOV AH, Y_num3      
        PUSH AX
        
        CALL ECTBTN    
    ;----
        MOV AL, "-"
        MOV AH, 0AH
        PUSH AX 
    
        MOV AL, X_num4
        MOV AH, Y_num3      
        PUSH AX
        
        CALL ECTBTN
    ;----
        MOV AL, "H"
        MOV AH, 0AH
        PUSH AX 
    
        MOV AL, X_num5
        MOV AH, Y_num3      
        PUSH AX
        
        CALL ECTBTN
    ;----
        MOV AL, "="
        MOV AH, 0AH
        PUSH AX 
    
        MOV AL, X_num6
        MOV AH, Y_num3      
        PUSH AX
        
        CALL ECTBTN  

;--------------quatrieme ligne  ----------


        MOV AL, "0"
        MOV AH, 0AH
        PUSH AX 
        
        MOV AL, X_num1        
        MOV AH, Y_num4      
        PUSH AX
    
        CALL ECTBTN    
    ;----
        ;bouton signe du nombre   
        MOV AL, 196
        MOV AH, 0AH
        PUSH AX 
        
        MOV AL, X_num2        
        MOV AH, Y_num4      
        PUSH AX
    
        CALL ECTBTN    
      
    ;----
        MOV AL, "+"
        MOV AH, 0AH
        PUSH AX 
    
        MOV AL, X_num4
        MOV AH, Y_num4      
        PUSH AX
        
        CALL ECTBTN  
        
        
    ;----
        ;bouton sortie
        MOV AL, "X"
        MOV AH, 0AH
        PUSH AX 
        
        MOV AL, X_num6        
        MOV AH, Y_num4    
        PUSH AX
    
        CALL ECTBTN
        





;-------------------------------------   
    ;creation ecran   
;-------------------------------------
        MOV AH, 2
        MOV DH, Y_ecran
        MOV DL, X_ecran
        MOV BH, 0
        INT 10H

        MOV AH, 0AH
        MOV AL, 192
        MOV CX, 1
        INT 10H
     
     ;---

        MOV AH, 2
        DEC DH
        MOV BH, 0
        INT 10H

        MOV AH, 0AH
        MOV AL, 179
        MOV CX, 1
        INT 10H

     ;---

        MOV AH, 2
        DEC DH
        MOV BH, 0
        INT 10H

        MOV AH, 0AH
        MOV AL, 179
        MOV CX, 1
        INT 10H

     ;---

        MOV AH, 2
        DEC DH
        MOV BH, 0
        INT 10H

        MOV AH, 0AH
        MOV AL, 179
        MOV CX, 1
        INT 10H

     ;---

        MOV AH, 2
        DEC DH
        MOV BH, 0
        INT 10H

        MOV AH, 0AH
        MOV AL, 218
        MOV CX, 1
        INT 10H

     ;------------------
     
        MOV AH, 2
        INC DL
        MOV BH, 0
        INT 10H

        MOV AH, 0AH
        MOV AL, 196
        MOV CX, 26
        INT 10H

     ;---
     
        MOV AH, 2
        MOV DH, Y_ecran
        MOV BH, 0
        INT 10H

        MOV AH, 0AH
        MOV AL, 196
        MOV CX, 26
        INT 10H
     
     ;------------------

        MOV AH, 2
        ADD DL, 26 
        MOV BH, 0
        INT 10H

        MOV AH, 0AH
        MOV AL, 217
        MOV CX, 1
        INT 10H
     
     ;---

        MOV AH, 2
        DEC DH
        MOV BH, 0
        INT 10H

        MOV AH, 0AH
        MOV AL, 179
        MOV CX, 1
        INT 10H

     ;---

        MOV AH, 2
        DEC DH
        MOV BH, 0
        INT 10H

        MOV AH, 0AH
        MOV AL, 179
        MOV CX, 1
        INT 10H

     ;---

        MOV AH, 2
        DEC DH
        MOV BH, 0
        INT 10H

        MOV AH, 0AH
        MOV AL, 179
        MOV CX, 1
        INT 10H

     ;---

        MOV AH, 2
        DEC DH
        MOV BH, 0
        INT 10H

        MOV AH, 0AH
        MOV AL, 191
        MOV CX, 1
        INT 10H                     
        
    
;---------------------fin creation affichage graphique---------------------  

;---------------------initialisation souris--------------------------
	MOV AX, 0
	INT 33H
	MOV AX,1
	INT 33H
;--------------------- main loop-------------------------------------------
   
main_loop: ;ecoute la souris pour savoir quand il y a un click gauche
   XOR BX,BX
   MOV AX, 3
   INT 33h
   CMP BX, 1
   JE CHECK_COOR_X
   
   JMP main_loop
   
;---- reinitialise les valeur pour pouvoir faire un nouveau calcule-----
restart:

   MOV AX, 0
   MOV NB1, AX 
   MOV NB2, AX
   MOV COMPTEUR, AX
   MOV SWITCH_SIGNE, AL
   
   MOV POS_ECRAN_X, 5   
   MOV POS_ECRAN_Y, 2
   
   MOV AX, "+" 
   MOV SIGNE, AL
   MOV SIGNE_NB1, AX
   MOV SIGNE_NB2, AX
   MOV SIGNE_NB3, AX    

   JMP main_loop
;======================================determine la position de click ================================


;-------------------------zone check --------------------------
        
            
CHECK_COOR_X:        ;regarde les coordonnees lors du click gauche et regarde si elle appartienne a un btn en X 
    
    PUSH CX
    PUSH DX
CHECK_CLIQUEG:
    MOV AX, 3
    INT 33h
    CMP BX, 1               ;continue le programme quand le clique est relache
    JE CHECK_CLIQUEG

    PUSH CX     ;sauvegarde des coordonnees, prend celles ou le clic est relache
    PUSH DX
    
    CALL CHECK 
    
    POP AX      ;recuperation la position convertie du clic

;--------------la compare au position des boutons --------------
    CMP AX,11H
    JE GIVE_7

    CMP AX,12H
    JE GIVE_4
    
    CMP AX,13H
    JE GIVE_1

    CMP AX,14H
    JE GIVE_0

    CMP AX,21H
    JE GIVE_8

    CMP AX,22H
    JE GIVE_5

    CMP AX,23H
    JE GIVE_2

    CMP AX,24H
    JE GIVE_SIGNE_NB 

    CMP AX,31H
    JE GIVE_9

    CMP AX,32H
    JE GIVE_6

    CMP AX,33H
    JE GIVE_3

    CMP AX,63H
    JE GIVE_EQU

    CMP AX, 61H
    JE RESTART_BTN
    
    CMP AX, 62H
    JE SUPPR
    
    CMP AX,64H
    JE FIN 
    
    
 ;----------- partie operateur -----------   
    
    CMP SWITCH_SIGNE, 0     ; permet d'eviter d'appuyer plusieur fois sur les boutons d'operateur
    JG main_loop 
    
    CMP AX,41H
    JE GIVE_DIV

    CMP AX,42H
    JE GIVE_MUL

    CMP AX,43H
    JE GIVE_SUB

    CMP AX,44H
    JE RC_AND_PRS
    
    CMP AX, 53H
    JE HEXA
    
    CMP  AX, 51H
    JE MODULO
    
    CMP AX, 52H
    JE POWER


    JMP main_loop ;securite   

;--------- reinitialise la calculatrice ------    
RESTART_BTN:
    
    CALL SCREEN_CLEAR
    JMP restart
;=================  Assignement d'un chiffre ==========================
;assigne un nombre qui ve se faire ecrire et ajouter soit a nb1, soit a nb2        
GIVE_1:
    
    MOV NB_PRINT, "1"
    
    JMP DIGITPRESS

GIVE_2:
    
    MOV NB_PRINT, "2"
    
    JMP DIGITPRESS 
    
GIVE_3:
    
    MOV NB_PRINT, "3"
    
    JMP DIGITPRESS
    
GIVE_4:
    
    MOV NB_PRINT, "4"
    
    JMP DIGITPRESS
    
GIVE_5:
    
    MOV NB_PRINT, "5" 
    
    JMP DIGITPRESS
    
GIVE_6:
    
    MOV NB_PRINT, "6"
    
    JMP DIGITPRESS
    
GIVE_7: 

    MOV NB_PRINT, "7"
    
    JMP DIGITPRESS   
    
GIVE_8:
    MOV NB_PRINT, "8"
     
    
    JMP DIGITPRESS   
    
GIVE_9:       

    MOV NB_PRINT, "9" 
    
    JMP DIGITPRESS    
    
GIVE_0:            

    MOV NB_PRINT, "0"  
    

;========= impression du chiffre clicke =========    
DIGITPRESS:
    
    CMP SWITCH_SIGNE, 0
    JG DIGP_2
    
    DIGITPRESS_P              ; ecrit le chiffre et l'ajoute a nb1 
    
    MOV AX, NB1
    MOV BX, 10
    MUL BX
    
    MOV BX, NB_PRINT
    SUB BX, 30H
    ADD AX, BX
    MOV NB1, AX
    
    JMP main_loop
    
DIGP_2:              ; ecrit le chiffre et l'ajoute a nb2
    
    DIGITPRESS_P
    
    MOV AX, NB2
    MOV BX, 10
    MUL BX
    
    MOV BX, NB_PRINT
    SUB BX, 30H
    ADD AX, BX
    MOV NB2, AX
    
    JMP main_loop

;============ assigne le signe au nombre========
GIVE_SIGNE_NB:  
    
    CMP COMPTEUR, 0   ;regarde si il n'y a pas de nombre entré avant le nombre
    JG main_loop
    
    CMP SWITCH_SIGNE, 0    ;regarde sur qu'elle nombr eil faut placer le signe
    JG GIVE_S_NB2
    
    CMP SIGNE_NB1, "-"  ;regarde si nb1 est deja negatif
    JE main_loop
    
    MOV AX, "-"
    MOV SIGNE_NB1, AX  ;assigne le signe et l'ecrit
    SIGNEPRESS
    
    JMP main_loop
    
GIVE_S_NB2:    
    
    CMP SIGNE_NB2, "-"  ;regarde si nb2 est deja negatif
    JE main_loop
    
    MOV AX, "-"
    MOV SIGNE_NB2, AX  ;assigne le signe et l'ecrit
    SIGNEPRESS
    
    JMP main_loop    
    
    
;===================== supprime le dernier chiffre / le signe du nombre ================  
SUPPR:
    
    
    CMP POS_ECRAN_X, 5     ;regarde si on peu revenir en arriere
    JBE main_loop
    
    DEC POS_ECRAN_X    ;revient un cran en arrière dans l'ecran
    
       
    MOV AH, 2               ;place le curseur sur le nombre/signe
    MOV DH, POS_ECRAN_Y
    MOV DL, POS_ECRAN_X
    MOV BH, 0
    INT 10H

    MOV AH, 8
    INT 10H
    
    CMP AL, "-"            ; regarde si il faut supprimer le signe
    JE SUPPR_SIGNE
         
    DEC COMPTEUR     

    MOV AL, 0                 ;reinitiallise le caractere 
    MOV AH, 0AH
    MOV CX, 1
    INT 10H
    
    XOR DX, DX                ;preparation pour changer la valeur du bon NB
    MOV BX, 10
    
    CMP SWITCH_SIGNE, 0      ;regarde sur qu'elle ligne le nombre a modifier est positione
    JG SUPPR2
    
    MOV AX, NB1              ; rectifie nb1
    DIV BX
    MOV NB1, AX
    
    JMP main_loop
    
    
    
SUPPR2:
    
    MOV AX, NB2           ; rectifie nb2
    DIV BX
    MOV NB2, AX
    
    
    JMP main_loop

SUPPR_SIGNE:
    
    CMP SWITCH_SIGNE, 0
    JG SUPPR_SIGNE_2
    
    MOV AL, 0                 ;reinitiallise le caractere et le signe
    MOV AH, 0AH
    MOV CX, 1
    INT 10H
    
    MOV SIGNE_NB1, "+"
    JMP main_loop
    
SUPPR_SIGNE_2:    

    MOV AL, 0                 ;reinitiallise le caractere  et le signe
    MOV AH, 0AH
    MOV CX, 1
    INT 10H
    
    MOV SIGNE_NB2, "+"
    JMP main_loop

;====================== imprimme le caractere d'operation====================
POWER:

    MOV SIGNE, "^"   ;selection du caractere a imprimmer
    JMP RC_AND_PRS
    

MODULO:

    MOV SIGNE, "%"   ;selection du caractere a imprimmer
    JMP RC_AND_PRS    


HEXA:
    
    MOV SIGNE, "H" ;selection du caractere de l'operation plus impression
    MOV AH, 2
    MOV DH, POS_ECRAN_Y
    INC DH
    MOV DL, 5
    MOV BH, 0
    INT 10H
    
    MOV AL, SIGNE          ;imprimme H car H est un cas particulier: il n'attend âs de nb2
    MOV AH, 0AH
    MOV CX, 1
    INT 10H
    
    JMP GIVE_EQU     ; comme il n'y a pas de NB2 pour H, on donne directement le resultat
    

GIVE_MUL:
    MOV SIGNE, "*"   ;selection du caactere a imprimmer
    JMP RC_AND_PRS

GIVE_DIV:
    MOV SIGNE, 246   ;selection du caactere a imprimmer
    JMP RC_AND_PRS

GIVE_SUB:            ;selection du caactere a imprimmer
    MOV SIGNE, "-"
    
RC_AND_PRS:                      ;imprimme le l'operateur et retorune a main_loop pour saisir le nombre 2
    MOV AH, 2                    ; n'est pas utiliser pour H
    MOV DH, POS_ECRAN_Y
    INC DH
    MOV POS_ECRAN_Y, DH
    MOV DL, 4
    MOV BH, 0
    INT 10H
    
    MOV AL, SIGNE
    MOV AH, 0AH
    MOV CX, 1
    INT 10H
    INC DL
    MOV POS_ECRAN_X, DL
    
    MOV COMPTEUR, 0
    MOV SWITCH_SIGNE, 1
    
    JMP main_loop

;=============================================================
;                   PHASE CALCULE
;=============================================================

;==============impression = et selection du bon calcule=========================
GIVE_EQU:                  ; lance la pahse de calcule
    MOV AH, 2
    MOV DH, 4                 ;place le curseur au bonne endroit et ecrit =
    MOV POS_ECRAN_Y, DH
    MOV DL, 4
    MOV BH, 0
    INT 10H
        
    MOV AL, "="
    MOV AH, 0AH
    MOV CX, 1
    INT 10H
    INC DL
    MOV POS_ECRAN_X, DL
    
    CMP SIGNE, "*"          ; selectionne l'operation a effectuer
    JE DO_MUL
    
    CMP SIGNE, 246
    JE DO_DIV
    
    CMP SIGNE, "-"
    JE DO_SUB
    
    
    CMP SIGNE, "+"
    JE DO_ADD
    
    CMP SIGNE, "H"
    JE DO_HEXA
    
    CMP SIGNE, "%"
    JE DO_MODULO
    
    CMP SIGNE, "^"
    JE DO_POWER
    
    JMP CMD_RESTART          ; securiter pour eviter de se balader dans la code
    
;====================== operation puissance ==================
DO_POWER:    ;determine le signe final de la multiplication

    MOV AX, NB2
    MOV BX, 2
    XOR DX, DX
    DIV BX              ;si nb2 multiple de 2, alors positif, sinon signe nb1
    CMP DX, 0
    JE S_DO_POW
    
    MOV BX, SIGNE_NB1
    MOV SIGNE_NB3, BX   
    
S_DO_POW:
    
    MOV AX, NB2               ; regarde les 2 cas particulier: pow0 et pow1
    MOV COMPTEUR, AX
    
    CMP COMPTEUR, 0
    JE POW_ZERO
    
    CMP COMPTEUR, 1
    JE POW_ONE

    XOR SI, SI ; initialise les valeur de sauvegarde 32 bits pour commencer les operations de puissances
    MOV AX, NB1
    MOV DI, AX
    
L_POWER:

    CMP COMPTEUR, 1
    JBE POW_PREP_DECOMP
    
    
    MOV AX, DI
    MUL NB1
    
    MOV DI, AX   ; sauvegarde des poids faible et des poid fort de la multiplication
    PUSH DX
    
    MOV AX, SI
    MUL NB1
    
    POP BX  ; on recupère la valeur du poid fort de la premiere operation
    
    ADD AX, BX
    ADC DX, 0
    
    CMP DX, 0
    JG P_ERROR    ; si dx est superieur a 0, on en peut pas afficher le nombre , donc va a l'affichege d'une erreur
    
    MOV SI, AX
    DEC COMPTEUR
    
    JMP L_POWER

POW_PREP_DECOMP:

    
    CMP SI, 10000   ;regarde si la decomposition peut se faire: pour afficher SI:DI, SI doit imperativement etre inferieur a 10000
    JGE P_ERROR     
    
    MOV AX, DI
    MOV DX, SI 
    JMP DECOMP_32BITS 
    
; ------------ cas particulier ----------------   
POW_ZERO:   ; cas pow0

    MOV NB3, 1
    JMP DECOMP_NB3
    
POW_ONE:        ;cas pow1
    
    MOV AX, NB1
    MOV NB3, AX
    
    JMP DECOMP_NB3    
 
;===============operation modulo/reste====================== 
DO_MODULO:

    CMP NB2, 0        ; on regarde si on divise par 0, si c'est le cas, on vas afficher une erreur
    JE P_ERROR
    
    XOR DX, DX
    MOV AX, NB1        ; on effectue la division
    DIV NB2
    
    MOV SIGNE_NB3, "+"      ; le signe du reste est toujours positif
    
    MOV AX, SIGNE_NB1
    
    CMP AX, SIGNE_NB2
    JNE CALC_MODULO
    
    MOV AX, DX
    MOV NB3, DX
    
    JMP DECOMP_NB3
    
CALC_MODULO:

    MOV AX, NB2
    SUB AX, DX
    MOV NB3, AX
    
    JMP DECOMP_NB3 

;================= operation transformation en nombre hexa ======================
DO_HEXA:
    
    MOV AX, SIGNE_NB1
    MOV SIGNE_NB3, AX   ;donne le signe de nb3
    
    MOV COMPTEUR, 0  
    MOV AX, NB1
    MOV BX, 10H

L_DO_HEXA:
    
    CMP AX, 0
    JE PRINT_NB3
    
    XOR DX, DX
    DIV BX
    PUSH DX
    INC COMPTEUR
    
    JMP L_DO_HEXA
    
;============ operation de la multiplication ===============
    
DO_MUL:
    
    CALL CMP_SIGNE_REST
    
    MOV AX, NB1
    MUL NB2 
    
    JMP DECOMP_32BITS
    
;================= operation division ==========================
DO_DIV:
    
    CMP NB2, 0   ;verifie si la division est possible
    JE P_ERROR
    
    CALL CMP_SIGNE_REST
    
    XOR DX, DX
    MOV AX, NB1
    DIV NB2
    MOV NB3, AX
    JMP DECOMP_NB3
    

;================operation soustraction ====================================
DO_SUB:
        
    MOV AX, SIGNE_NB1
    CMP AX, SIGNE_NB2 ;compare les signes oiur savori quelle operation faire
    JE SUB_S_EQU
    CMP AX, "+"
    JE SUB_S_AMM
    
    MOV SIGNE_NB3, AX
    MOV AX, NB1
    ADD AX, NB2
    MOV NB3, AX
    JMP DECOMP_NB3

SUB_S_AMM:

    MOV SIGNE_NB3, "+"
    MOV AX, NB1
    ADD AX, NB2
    MOV NB3, AX
    JMP DECOMP_NB3
    
SUB_S_EQU:
    
    MOV AX, NB1
    CMP AX, NB2  ;determine si NB1>NB2, NB1<NB2, NB1=NB2
    JG DO_SUB_N1
    CMP AX, NB2
    JB DO_SUB_N2
    
    MOV NB3, 0
    MOV SIGNE_NB3, "+"
    JMP DECOMP_NB3

DO_SUB_N1:     

    MOV AX, SIGNE_NB1
    MOV SIGNE_NB3, AX
    MOV AX, NB1
    SUB AX, NB2
    MOV NB3, AX

    JMP DECOMP_NB3

DO_SUB_N2:

    CMP SIGNE_NB2, "+"
    JE INVERS_P
    
    MOV SIGNE_NB3, "+"
    JMP S_DO_SUB_N2
    
INVERS_P:
    
    MOV SIGNE_NB3, "-"
    
S_DO_SUB_N2:
    
    MOV AX, NB2
    SUB AX, NB1
    MOV NB3, AX

    JMP DECOMP_NB3   

;================operation addition ====================================
DO_ADD: 
   
    MOV AX, SIGNE_NB1
    CMP AX, SIGNE_NB2
    JNE DO_ADD_EXEP   
    
    MOV AX, NB1   ;cas meme signe
    ADD AX, NB2
    MOV NB3, AX
    MOV AX, SIGNE_NB1
    MOV SIGNE_NB3, AX
    MOV AX, NB1
    ADD AX, NB2
    JMP DECOMP_NB3

DO_ADD_EXEP:
    
    MOV AX, NB1  ; determine si NB1>NB2 , NB1<NB2, ou NB1=NB2
    CMP AX, NB2
    JG DO_ADD_N1
    CMP AX, NB2
    JB DO_ADD_N2
    MOV AX, 0
    MOV NB3, AX
    
    MOV SIGNE_NB3, "+"
    JMP DECOMP_NB3

DO_ADD_N1: ; cas ou NB1>NB2 et pas mem signe
    
    MOV AX, SIGNE_NB1
    MOV SIGNE_NB3, AX
    MOV AX, NB1
    SUB AX, NB2
    MOV NB3, AX
    JMP DECOMP_NB3


DO_ADD_N2:    ; cas ou NB1<NB2 et pas mem signe

    MOV AX, SIGNE_NB2
    MOV SIGNE_NB3, AX
    MOV AX, NB2
    SUB AX, NB1
    MOV NB3, AX


;=========== decomposition des nombres 32bits ==============     
DECOMP_32BITS:  ;decomposition de nmbre sur 32bits

    MOV COMPTEUR, 0   
    MOV BX, 10000   ;Division du registre DX:AX par BX
    ADD BX, 0 ; mettre le overlfow flag a 0
    DIV BX    ;On retrouve le nombre en deux morceau: AX: poid fort  DX: poid faible 
    JO P_ERROR
    MOV DI, AX
    MOV SI, DX
    MOV BX, 10
    
L_DECOMP_32BITS:                      ;decompose et stock le poid faible tant qu'il est >0 ou que le Poid fort>0 et que le compteur<4
    CMP SI, 0
    JG DECOMP_32BITS_PFAIBLE
    CMP DI, 0
    JG CHECK_CMT
    JMP PRINT_NB3   ; si le nombre 32 bits est nul on passe a la suite

CHECK_CMT:
    CMP COMPTEUR, 4
    JB DECOMP_32BITS_PFAIBLE
    
    MOV AX, DI
    JMP L_DECOMP_32BITS_2    

    
DECOMP_32BITS_PFAIBLE: ;decompose le digit le plus a gauche du poid faible
    
    MOV AX, SI
    XOR DX, DX
    DIV BX
    PUSH DX
    INC COMPTEUR    
    MOV SI, AX
    
    JMP L_DECOMP_32BITS


L_DECOMP_32BITS_2:

    
    CMP DI, 0
    JG DECOMP_32BITS_PFORT 
    
    JMP PRINT_NB3
    
DECOMP_32BITS_PFORT:
    
    MOV AX, DI
    XOR DX, DX
    DIV BX
    PUSH DX
    INC COMPTEUR
    MOV DI, AX

    JMP L_DECOMP_32BITS_2    
    
    
;=============== decomposition de nb3 16 bits ================
DECOMP_NB3:    
    MOV COMPTEUR, 0
    MOV BX, 10
    MOV AX, NB3
   
L_DECOMP_NB3:           ;recupere les valeur ascii de chaque digit de NB3
    XOR DX, DX
    CMP AX, 0
    JE PRINT_NB3     
    INC COMPTEUR
    DIV BX
    
    PUSH DX
    
    JMP L_DECOMP_NB3


;=================== affichage error=============   
P_ERROR:
    
    
    MOV AH, 2
    MOV DH, POS_ECRAN_Y
    MOV DL, POS_ECRAN_X
    MOV BH, 0
    INT 10H
        
    MOV AL, "E"
    MOV AH, 0AH
    MOV CX, 1
    INT 10H
    INC DL

    
    MOV AH, 2
    MOV BH, 0
    INT 10H
        
    MOV AL, "R"
    MOV AH, 0AH
    MOV CX, 2
    INT 10H
    INC DL
    INC DL
    
    MOV AH, 2
    MOV BH, 0
    INT 10H
        
    MOV AL, "O"
    MOV AH, 0AH
    MOV CX, 1
    INT 10H
    INC DL

    MOV AH, 2
    MOV BH, 0
    INT 10H
        
    MOV AL, "R"
    MOV AH, 0AH
    MOV CX, 1
    INT 10H
    INC DL
    MOV POS_ECRAN_X, DL

    JMP CMD_RESTART
    

;====================== affichage nb3 ==========================

PRINT_NB3:
    
    CMP COMPTEUR, 0
    JE PRINT_0
    
    
    CMP SIGNE_NB3, "+"  ;regarde si il faut ecrir ele signe "-"
    JE L_PRINT_NB3
    
    MOV AX, SIGNE_NB3
    SIGNEPRESS                ;ecriture du signe
    
L_PRINT_NB3: 

    CMP COMPTEUR,0
    JE CMD_RESTART
    
    CALL PRINT_D_NB3
    DEC COMPTEUR
    JMP L_PRINT_NB3


PRINT_0:

    MOV AX, 0
    PUSH AX
    CALL PRINT_D_NB3
    
    JMP CMD_RESTART


CMD_RESTART:
    MOV AX, 3
    INT 33H
    CMP BX, 1
    JNE CMD_RESTART
    
    CALL SCREEN_CLEAR 
    
    JMP restart


;================ fin du programme =============================
fin:

    XOR DX, DX
    MOV CX, 31
    XOR AX, AX

L_fin:             ;effacage de la calculatrice

    CMP DH, 23
    JGE TRUE_END        
        
    MOV AH, 2
    MOV BH, 0
    INT 10H

    MOV AH, 0AH
    INT 10H
    INC DH
    JMP L_fin

TRUE_END:
        
;  MOV AX, 0
;   PUSH AX 
;    ret      ; a commenter sur RADASM

                       ;Pour RADASM
    mov     ax, 4c00h
    int     21h

    code    ends
end DEB

;Nils Roger
;Ledeux Flavien
;GROUPE 1

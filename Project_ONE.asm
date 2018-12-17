ORG 100h ;compiler directive tells the compiler that the excutable file will be loaded at offset 100

counter  dW 0

;USER INTERFACE
;___________________________________________________________________________________
ID_START: 

       ;print welcome message:       
       MOV  DX, offset wlcmmsg
       CALL PRINT
              
    ID_START_AGAIN:
               
       ;read character in al :
       MOV  DX, offset ID_STRING
       CALL SCAN
          
       LEA  SI, ID_STRING 
       JMP  ID_CHECK


PSS_START:
       
       CALL PRNT_NLINE
       ; Print password message
              
       MOV  DX, offset pssmmsg
       CALL PRINT   
        
    PSS_START_AGAIN:
              
       ;read character in al :
       MOV  DX, offset ID_PASSWO
       CALL SCAN
          
       LEA  SI, ID_PASSWO
       JMP  ID_PASSCHECK
       
            
;CASE USER ENTERED WRONG ID 
WRONG_ID:
       CALL PRNT_NLINE
       MOV  DX, offset widmmsg
       CALL PRINT
       JMP  ID_START_AGAIN    
       

;CASE USER ENTERED WRONG PASSWORD
WARN:   
        CALL PRNT_NLINE
     
        CMP  counter,2
        JE   ONETRY
        JGE  ACESS_DENIED
   
        MOV  DX ,offset wrngmsg
        
     ACTUAL_WARN:
        CALL PRINT
        INC  counter
        JMP  PSS_START_AGAIN   
        
        
     ONETRY:
        MOV  DX ,offset trymmsg
        JMP  ACTUAL_WARN
        
               
ACESS_DENIED:
       CALL PRNT_NLINE
       MOV  DX, offset denmmsg
       CALL PRINT
       JMP  STOP
           
ACESS_ALLOWED:       
       CALL PRNT_NLINE
       MOV  DX, offset allmmsg
       CALL PRINT
       JMP  STOP  


       
            
; CHECKING IDDDDD :
;___________________________________________________________________________________  
ID_CHECK:  
       CALL RESET
       
ID_LOOP:    
       
       CMP  AL ,6
       JGE  PSS_START 
       
       ;Move and compare each digit of the decimal number   
       MOV  CL, [SI+02H]
       SUB  CL, 30H
       MOV  CH, ID(BP)
         
       CMP  CL,CH  
       JNE  ID_CHANGE   
       
       ADD  SI,1
       ADD  BP,1
       ADD  AL,1
       JMP  ID_LOOP
      
;___________________________________________________________________________________

;CHECKING PASSWORD :       
ID_PASSCHECK:
       CALL RESET
ID_PASSWLOOP:
       CMP AL ,4       
       JGE ACESS_ALLOWED
       
       ;Move and compare each digit of the decimal number
       MOV  CL, [SI+02H]
       SUB  CL, 30H
       MOV  CH, PSS(DI)
         
       CMP  CL,CH  
       JNE  WARN   
                 
       ADD  SI,1
       ADD  DI,1
       ADD  AL,1
       JMP  ID_PASSWLOOP
       
;___________________________________________________________________________________       
               
ID_CHANGE:

           JMP  IDS(BX)
                  
    ID2:   MOV  BP ,6  
           JMP  Change_END
       
    ID3:   MOV  BP ,12
           JMP  Change_END
           
    ID4:   MOV  BP ,18
           JMP  Change_END
           
    ID5:   MOV  BP ,24
           JMP  Change_END
           
    ID6:   MOV  BP ,30
           JMP  Change_END
    
    ID7:   MOV  BP ,36
           JMP  Change_END
           
    ID8:   MOV  BP ,42
           JMP  Change_END
           
    ID9:   MOV  BP ,48
           JMP  Change_END
    
    ID10:  MOV  BP ,54
           JMP  Change_END
           
    ID11:  MOV  BP ,60
           JMP  Change_END
           
    ID12:  MOV  BP ,66
           JMP  Change_END
           
    ID13:  MOV  BP ,72
           JMP  Change_END
           
    ID14:  MOV  BP ,78
           JMP  Change_END
           
    ID15:  MOV  BP ,84
           JMP  Change_END
           
    ID16:  MOV  BP ,90
           JMP  Change_END
           
    ID17:  MOV  BP ,96
           JMP  Change_END
    
    ID18:  MOV  BP ,102
           JMP  Change_END
           
    ID19:  MOV  BP ,108
           JMP  Change_END
           
    ID20:  MOV  BP ,114
           JMP  Change_END
           
    
    Change_END:
           ADD  DI ,4
           MOV  AH ,0
           SUB  SI ,AX 
           ADD  BX ,2
           JMP  ID_CHECK
           

;___________________________________________________________________________________
        
STOP:  RET  ; stop
          

;___________________________________________________________________________________
; Some functions that make modularity easier           


RESET:     
       MOV  AL,0
       RET 
       

PRINT:       
       MOV  AH,09
       INT  21h
       RET

SCAN:
       MOV  AH,0ah  
       INT  21h
       RET

PRNT_NLINE:
       
       ;Print new line 
       MOV  dl, 10
       MOV  ah, 02h
       INT  21h
       MOV  dl, 13
       MOV  ah, 02h
       INT  21h
       
       RET

;___________________________________________________________________________________
;YOUR MESSAGES
wlcmmsg db "HELLO , Please Enter your ID :  $"
pssmmsg db "Pleas now , Enter your password :  $"

wrngmsg db "Please enter your password again:  $" 
widmmsg db "Please enter valid ID : $"


trymmsg db "One try remaining ! $"
allmmsg db "Access Allowed ! $ "
denmmsg db "Access Denied  ! $ " 
;____________________________________________________________________________________


; DATA BASE OF IDS AND PASSWORDS ( EACH ONE IN SEPERATE ARRAY )  
ID      db 00H,01H,02H,03H,04H,05H, 05H,04H,03H,02H,01H,00H, 05H,04H,03H,03H,04H,05H, 05H,04H,04H,04H,04H,05H, 00H,02H,05H,05H,02H,00H, 05H,04H,03H,02H,04H,05H, 00H,00H,00H,00H,00H,01H, 00H,00H,00H,01H,01H,01H, 08H,00H,00H,00H,00H,00H, 01H,02H,03H,04H,05H,06H, 05H,05H,05H,05H,05H,06H, 05H,00H,00H,00H,03H,03H, 01H,02H,00H,00H,00H,00H, 00H,04H,04H,04H,04H,04H, 09H,09H,08H,08H,09H,09H, 04H,04H,03H,03H,04H,00H, 02H,09H,09H,09H,09H,09H, 09H,09H,09H,03H,08H,07H, 09H,08H,04H,03H,02H,01H, 03H,04H,04H,04H,04H,04H 
PSS     db 00H,00H,00H,00H        , 01H,01H,01H,01H        , 02H,02H,02H,02H        , 03H,03H,03H,03H        , 04H,04H,04H,04H        , 05H,05H,05H,05H        , 06H,06H,06H,06H        , 07H,07H,07H,07H        , 08H,08H,08H,08H        , 09H,09H,09H,09H        , 00H,01H,02H,03H        , 00H,00H,02H,02H        , 03H,02H,01H,00H        , 04H,03H,04H,03H        , 05H,00H,00H,00H        , 06H,05H,04H,00H        , 07H,00H,00H,01H        , 08H,09H,01H,00H        , 09H,00H,00H,02H        , 09H,08H,09H,08H
 
 
; ARRAY OF POINTERS ( as each pointer points to different ID )
IDS     dw ID2,ID3,ID4,ID5,ID6,ID7,ID8,ID9,ID10,ID11,ID12,ID13,ID14,ID15,ID16,ID17,ID18,ID19,ID20  



; arrays for inputs 

ID_STRING db 7
          db ?
          db 7 dup (?)
      
ID_PASSWO db 5
          db ?
          db 5 dup (?)
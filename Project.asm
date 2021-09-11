.model large
.stack 1000h 

.data


;========Loading Screen===========

    mLoading db "Loading Game"
    mLoaddot db "............"
    mCompany db "Nintendo Entertainment System"





    
;========Main Menu Data===========

    mTitle db "Super Mario"
    mPlay db "Play"
    mInst db "Instructions"
    mExit db "Exit"
    
    mGroup db "Group Members"
    mID1 db "Talha Zeb Khan (19I-0641)"
    mID2 db "Mustafa (19I-0544)"     
 
 
 
 
 
    
;=======INSTRUCTIONS/HELP=========

    iInstHead db "Instructions"
    iInst_line db "------------" 
    iInst1 db "1. Right button moves the mario in right direction."
    iInst2 db "2. Left button moves the mario in left direction."
    iInst3 db "3. Up button makes the mario to jump to a certain height."
    iInst4 db "4. There are three obstacles which the player has to jump."
    iInst5 db "5. There is monster between obstacles which will result "
    iInst5c db"   in failure if mario touches it."
    iInst6 db "6. There is also a flying monster throwing fire which "
    iInst6c db "   the mario will have to avoid."
    iInst7 db "7. The mario has to reach the Flag or Castle in order to be successful"
    iInst8 db "8. Enjoy! :)"     
    iInstEsc db "Press Escape to go back!"  
 
 
 
    

;=========WIN/LOSE=================
    
    mWin db "You WON !!"
    mLose db "You LOST!!" 
 
 
 
 
;======LOADING LEVEL==============    
    mLoad_level2 db "Loading Level 2"
    
    mLoad_level3 db "Loading Level 3"
    


    
;==========Coordinates============
    
    string_x_axis db 35
    string_y_axis db 10 
 
 
 
    
;=========Game Ground=============
    
    ;Position Axis
    x dw ?  
    y dw ?  
    
    ;Size Variables
    w dw ? 
    h dw ?          
    
    ;Colour
    col db ?   
    
    ;Count for cloud print
    cloud_count db 0
       
    ;Count for moon print
    moon_count db 0
    
    ;Count for mario_print
    mario_count dw 0   
    hat_count db 0  
    
    monster_count db 0
  
  
  
  
;========MArio Movement variables==========
    
    move_x_mario dw 0
    move_y_mario dw 0  
    
    move_up_mario dw 0
 
 
 
    
;========Monster1 Movement variables==========
    
    move_x_monster1 dw 0   
  
  
  
  
;=======Menu Pointer=============
    mp db 1    
 
 
 
;=======LEVEL COUNT==============    
    level db 1
   
   
        
.code 

    mov ax,@data
    mov ds,ax 
    

    ;Enter Graphics Mode
    mov ah,0
    mov al,12h
    int 10h
    
;======================GAME START LOADING SCREEN=========================
    call game_start
    
     
     
;======================ALL OBJECTS IN GAME==============================    
    game_screen: 
    
    mov ah,0
    mov al,12h
    int 10h
  
  
  
;===============GROUND / CLOUDS / FLAG / BACKGROUND DESIGN==============     
    call level_design 

    
    
    
;===============MONSTERS IN BETWEEN PIPES ONLY IN LEVELS GREATER THAN 1=============    
    .if(level>1)
        call monster_f
        call monster_s
    .endif

     
     
     
;=============INITIAL MARIO CALL TO CREATE MARIO AT START CALLED ONLY ONCE===========           
    call mario

    
    
    
;============MARIO MOVEMENTS UPDATED BASED ON MOVEMENT AND JUMPS================    
    left:
        sub move_x_mario,5
        call mario_left
        
    right:  
        add move_x_mario,5    
        call mario_right 
        
    up:                               
        call mario_up
 
 
 
 
  
;==============================LOADING SCREEN====================================
      
    game_start proc 
          
    ;===Print Loading
        ;Size loop set  	
    	mov cx, lengthof mLoading
    	;Row set
    	mov dh,string_y_axis 
    	;Col set
    	mov dl,string_x_axis
    	mov si,offset mLoading 
    	call stringprint
    	
    ;===Print Nitendo Messege
    	mov cx, lengthof mCompany
    	mov dh,string_y_axis
    	add dh, 10   
    	mov dl,string_x_axis
    	sub dl, 9
    	mov si,offset mCompany  
    	call stringprint
    		
    ;===Print Loading Dots with Delay                                         
    	mov cx, lengthof mLoaddot   
    	mov dl,string_x_axis
    	mov dh,string_y_axis
    	add dh, 2
    	mov si,offset mLoaddot  
    	call STRINGPRINT_DELAY  
    	
    	game_start endp
	
	
	
	
	                   
;===========================MAIN MENU SCREEN===================================  
    
    menu_screen:
    
    mov move_x_mario, 0
    mov move_y_mario, 0  
    mov move_up_mario, 0
    
    mov ah,0
    mov al,12h
    int 10h
	
;===Print Play
	mov cx, lengthof mPlay
	mov dh, string_y_axis
	sub dh, 0  
	mov dl, string_x_axis 
	add dl, 3
	mov si,offset mPlay  
	call stringprint 
	
;===Print Instructions
	mov cx, lengthof mInst
	mov dh, string_y_axis
	add dh, 3  
	mov dl, string_x_axis 
	sub dl, 1
	mov si,offset mInst  
	call stringprint 
	
;===Print Exit
	mov cx, lengthof mExit
	mov dh, string_y_axis
	add dh, 6  
	mov dl, string_x_axis 
	add dl, 3
	mov si,offset mExit  
	call stringprint

;===Print Group
	mov cx, lengthof mGroup
	mov dh, string_y_axis
	add dh, 12 
	mov dl, string_x_axis 
	add dl, -34
	mov si,offset mGroup  
	call stringprint
		
;===Print ID1
	mov cx, lengthof mID1
	mov dh, string_y_axis
	add dh, 14 
	mov dl, string_x_axis 
	add dl, -34
	mov si,offset mID1  
	call stringprint

;===Print ID2
	mov cx, lengthof mID2
	mov dh, string_y_axis
	add dh, 16  
	mov dl, string_x_axis 
	add dl, -34
	mov si,offset mID2  
	call stringprint
	

;=========================MENU POINTER MOVEMENT (TRIANGLE SHAPED)============================	
	menu_pointer:



;===============REMOVAL OF PREVIOUS POINTER AND REDRAW OF POINTER ON NEW POSITION===============	
	opt1: 
	mov x, 220  
    mov y, 200
    mov w, 20                           
    mov h, 26          
    mov col, 0 ;BLACK COLOUR
    
	butri2: 
	    inc y
	    sub h,2
    	call vline
    	inc x    
    	cmp x, 236
    	    jne butri2
	
	mov x, 220  
    mov y, 245
    mov w, 20 
    mov h, 26          
    mov col, 0 ;BLACK COLOUR
    
	btri3: 
	    inc y
	    sub h,2
    	call vline
    	inc x    
    	cmp x, 236
    	    jne btri3
	
	mov x, 220  
    mov y, 155
    mov w, 20 
    mov h, 26          
    mov col, 0110b ;BROWN COLOUR
    
	tri1: 
	    inc y
	    sub h,2
    	call vline
    	inc x    
    	cmp x, 236
    	    jne tri1
    
    jmp menu_keys
    
    opt2:
    
    mov x, 220  
    mov y, 245
    mov w, 20 
    mov h, 26          
    mov col, 0 ;BLACK COLOUR
    
	butri3: 
	    inc y
	    sub h,2
    	call vline
    	inc x    
    	cmp x, 236
    	    jne butri3      
          
    mov x, 220  
    mov y, 155
    mov w, 20 
    mov h, 26          
    mov col, 0 ;BLACK COLOUR
    
 
	btri1: 
	    inc y
	    sub h,2
    	call vline
    	inc x    
    	cmp x, 236
    	    jne btri1          
    	    
    	    	    
    mov x, 220  
    mov y, 200
    mov w, 20                           
    mov h, 26          
    mov col, 0110b ;BROWN COLOUR
    
	tri2: 
	    inc y
	    sub h,2
    	call vline
    	inc x    
    	cmp x, 236
    	    jne tri2	    
	
	jmp menu_keys
	
	opt3:     
	
	mov x, 220  
    mov y, 155
    mov w, 20 
    mov h, 26          
    mov col, 0 ;BLACK COLOUR
    
 
	butri1: 
	    inc y
	    sub h,2
    	call vline
    	inc x    
    	cmp x, 236
    	    jne butri1
	
	mov x, 220  
    mov y, 200
    mov w, 20                           
    mov h, 26          
    mov col, 0 ;BLACK COLOUR
    
	btri2: 
	    inc y
	    sub h,2
    	call vline
    	inc x    
    	cmp x, 236
    	    jne btri2
    	    
	mov x, 220  
    mov y, 245
    mov w, 20 
    mov h, 26          
    mov col, 0110b ;BROWN COLOUR
    
	tri3: 
	    inc y
	    sub h,2
    	call vline
    	inc x    
    	cmp x, 236
    	    jne tri3
        	        
	jmp menu_keys

 
 
 
;=============================SCREEN WIN========================================
         
    screen_win:
        mov ah,0
        mov al,12h
        int 10h 
        
        ;Size loop set  	
    	mov cx, lengthof mWin
    	;Row set
    	mov dh,string_y_axis 
    	;Col set
    	mov dl,string_x_axis
    	mov si,offset mWin
    	call stringprint  
    	
        .if(level==1)
        ;===Print Loading Level 2
            ;Size loop set  	
        	mov cx, lengthof mLoad_level2
        	;Row set
        	mov dh,string_y_axis 
        	;Col set
        	mov dl,string_x_axis
        	add dl, -4  
        	add dh  , 2
        	mov si,offset mLoad_level2
        	call stringprint 
    	
    
    		
        ;===Print Loading Dots with Delay                                         
        	mov cx, lengthof mLoaddot   
        	mov dl,string_x_axis
        	mov dh,string_y_axis
        	add dh, 4    
        	add dl, -2
        	mov si,offset mLoaddot  
        	call STRINGPRINT_DELAY 
        	
        	inc level
        .elseif(level==2)
            
        ;===Print Loading Level 2
            ;Size loop set  	
        	mov cx, lengthof mLoad_level3
        	;Row set
        	mov dh,string_y_axis 
        	;Col set
        	mov dl,string_x_axis
        	add dl, -4  
        	add dh  , 2
        	mov si,offset mLoad_level3
        	call stringprint 
    	
    
    		
        ;===Print Loading Dots with Delay                                         
        	mov cx, lengthof mLoaddot   
        	mov dl,string_x_axis
        	mov dh,string_y_axis
        	add dh, 4    
        	add dl, -2
        	mov si,offset mLoaddot  
        	call STRINGPRINT_DELAY 
        	
        	inc level
        	
        .elseif(level==3)
            ;Size loop set  	
        	mov cx, lengthof mWin
        	;Row set
        	mov dh,string_y_axis 
        	;Col set
        	mov dl,string_x_axis
        	mov si,offset mWin
        	call stringprint 
        	
        	;===Print Loading Dots with Delay                                         
        	mov cx, lengthof mLoaddot   
        	mov dl,string_x_axis
        	mov dh,string_y_axis
        	add dh, 4    
        	add dl, -2
        	mov si,offset mLoaddot  
        	call STRINGPRINT_DELAY 
        	
        	mov level,1
        	
        	jmp menu_screen
    	
    	.endif   
    	
    	
;===========RESET MARIO TO DEFAULT STARTING POSITION AFTER WIN==============    	
    mov move_x_mario,0	
    mov move_y_mario,0
    mov move_up_mario,0
    	
    jmp game_screen     
    

;=============================SCREEN WIN========================================
         
    screen_lose:
        mov ah,0
        mov al,12h
        int 10h 
        
        ;Size loop set  	
    	mov cx, lengthof mLose
    	;Row set
    	mov dh,string_y_axis 
    	;Col set
    	mov dl,string_x_axis
    	mov si,offset mLose
    	call stringprint
    	
    	mov level,1  
;===========DELAY IF LOST TO SHOW YOU LOST FOR SOME INTERVAL=====================    	
    	call Delay_WL


    	
;===========RESET MARIO TO DEFAULT STARTING POSITION AFTER WIN==============    	
    mov move_x_mario,0	
    mov move_y_mario,0
    mov move_up_mario,0
    	
    jmp menu_screen     
    
;==========RESET LEVEL====================   
    mov level, 1
 
;=============================INSTRUCTION SCREEN====================================    


    inst_screen: 
    mov ah,0
    mov al,12h
    int 10h
    
    ;Print Instruction Heading
    ;Size loop set  	
	mov cx, lengthof iInstHead
	;Row set
	mov dh, 5
	;Col set
	mov dl,2
	mov si,offset iInstHead  
	call stringprint
	
	;===Print Line
	mov cx, lengthof iInst_line
	mov dh, 6  
	mov dl, 2
	mov si,offset iInst_line  
	call stringprint
	
	;===Print First_Inst
	mov cx, lengthof iInst1
	mov dh, 8  
	mov dl, 2
	mov si,offset iInst1  
	call stringprint
	
	;===Print second_Inst
	mov cx, lengthof iInst2
	mov dh, 10  
	mov dl, 2
	mov si,offset iInst2  
	call stringprint
	
	;===Print third_Inst
	mov cx, lengthof iInst3
	mov dh, 12 
	mov dl, 2
	mov si,offset iInst3  
	call stringprint  
	
	;===Print 4th_Inst
	mov cx, lengthof iInst4
	mov dh, 14  
	mov dl, 2
	mov si,offset iInst4 
	call stringprint 
	
	;===Print 5th_Inst
	mov cx, lengthof iInst5
	mov dh, 16  
	mov dl, 2
	mov si,offset iInst5  
	call stringprint  
	
	;===Print 5th_InstC
	mov cx, lengthof iInst5c
	mov dh, 17  
	mov dl, 2
	mov si,offset iInst5c 
	call stringprint
	
	;===Print 6th_Inst6
	mov cx, lengthof iInst6
	mov dh, 19  
	mov dl, 2
	mov si,offset iInst6 
	call stringprint
    
    ;===Print 6th_InstC
	mov cx, lengthof iInst6c
	mov dh, 20  
	mov dl, 2
	mov si,offset iInst6c 
	call stringprint
	
	 ;===Print 7th_Inst7
	mov cx, lengthof iInst7
	mov dh, 22  
	mov dl, 2
	mov si,offset iInst7 
	call stringprint
	
	;===Print 8th_Inst8
	mov cx, lengthof iInst8
	mov dh, 24  
	mov dl, 2
	mov si,offset iInst8 
	call stringprint 
	
    ;===Print Inst_Escape
	mov cx, lengthof iInstEsc
	mov dh, 26  
	mov dl, 50
	mov si,offset iInstEsc 
	call stringprint
	

;=======RESET MENU POINTER TO INITIAL POSITION==========
	mov mp,1


;======ESCAPE PRESS GO BACK TO MENU SCREEN=============	
	mov ah,0
    int 16h
    
    cmp ah,1
	    jmp menu_screen
	
	

;==================================GAMEPLAY SCREEN===================================
	  
	level_design proc
	
	;------------------Set BackGround Colour To Blue
	mov x, 1  
    mov y, 0
    mov w, 640 
    ;mov h, 10          
    mov col, 1001b ;BLUE COLOUR
    
	background:
    	call line
    	inc y    
    	cmp y, 480
    	    jne background
    
    
;========================GROUND=============================
	     
	mov x, 1  
    mov y, 440
    mov w, 640 
    ;mov h, 10          
    mov col, 0110b ;BROWN COLOUR
    
	Ground:
    	call line
    	inc y    
    	cmp y, 480
    	    jne Ground
	
	mov w, 20
	;mov h, 10
	mov x, 10
	mov y, 450
	mov col, 1110B ;YELLOW COLOUR
	
	Inner_Ground_Boxes:
	
    	Box:
        	call line
        	inc y
        	cmp y, 470
        	    jne Box
    	
    	add x,40
    	mov y,450
    	cmp x, 640
            jbe Inner_Ground_Boxes	
            
	
	mov x, 40
	mov y, 440
	mov h, 40
	mov col, 1000B ;DARK GRAY COLOUR
	 
	Vertical_Lines_Ground:
    	call vLine
    	add x, 40
    	cmp x, 640
    	    jbe Vertical_Lines_Ground
	
	
;OBSTACLES 1-------------------------------------
    obstacle1:
        mov x, 100
        mov y, 439
        mov w, 30
        mov col, 0100b ;RED COLOUR

        Vertical1_Box:
            call line
            sub y,1
            cmp y, 390
                jne Vertical1_Box


        mov x, 90
        mov y, 390
        mov w, 50
        mov col, 0100b ;RED COLOUR

        Horizental1_Box:
            call line
            sub y,1
            cmp y, 370
                jne Horizental1_Box


;OBSTACLES 2-------------------------------------
    obstacle2:
        mov x, 290
        mov y, 439
        mov w, 30
        mov col, 0100b ;RED COLOUR

        Vertical2_Box:
            call line
            sub y,1
            cmp y, 370
                jne Vertical2_Box


        mov x, 270
        mov y, 370
        mov w, 70
        mov col, 0100b ;RED COLOUR

        Horizental2_Box:
            call line
            sub y, 1
            cmp y, 350
                jne Horizental2_Box 


;OBSTACLE 3---------------------------------------
    obstacle3:
        mov x, 485
        mov y, 439
        mov w, 30
        mov col, 0100b ;RED COLOUR

        Vertical3_Box:
            call line
            sub y,1
            cmp y, 350
                jne Vertical3_Box


        mov x, 465
        mov y, 350
        mov w, 70
        mov col, 0100b ;RED COLOUR

        Horizental3_Box:
            call line
            sub y, 1
            cmp y, 330
                jne Horizental3_Box
        	        
        	    
    ;Cloud 1-----------------------------
    Cloud1:
        mov x, 150  
        mov y, 40
        mov w, 10         
        mov col, 1111b ;WHITE COLOUR 
        print_cloud1:
            call line
            inc y
            inc cloud_count
            cmp cloud_count,4
                jne print_cloud1
            sub x, 10   
            add w, 20
            mov cloud_count, 0
            cmp y, 60
                jne print_cloud1
                
    ;Cloud 2-----------------------------
    Cloud2:
        mov x, 350  
        mov y, 20
        mov w, 10         
        mov col, 1111b ;WHITE COLOUR 
        print_cloud2:
            call line
            inc y
            inc cloud_count
            cmp cloud_count,4
                jne print_cloud2
            sub x, 10   
            add w, 20
            mov cloud_count, 0
            cmp y, 40
                jne print_cloud2                
                
                    


;===============================FLAG==================================== 
   
   .if(level==1 || level==2)
;FLAG POLE------------------------- 
     flag:
        mov x, 631
        mov y, 439
        mov w, 5
        mov col, 0000b ;BLACK COLOUR

        flag_pole:
            call line
            sub y,1
            cmp y, 250
                jne flag_pole 
                
        mov x, 560
        mov y, 249
        mov w, 75
        mov col, 1111b ;WHITE COLOUR

;FLAG TOP (BACK WHITE)----------------------------
        flag_top:
            call line
            sub y,1
            cmp y, 200
                jne flag_top
                
        mov x, 560
        mov y, 200
        mov w, 10
        mov col, 0000b ;WHITE COLOUR


;FLAG TOP(BLACK SQUARES ON WHITE)-----------------

        flag_in1:
            call line
            inc y
            cmp y, 210
                jne flag_in1
            
            add x, 20
            mov y, 200
            cmp x, 640
            jne flag_in1
            
        mov x, 570
        mov y, 210
        mov w, 10
        mov col, 0000b ;BLACK COLOUR

        flag_in2:
            call line
            inc y
            cmp y, 220
                jne flag_in2
            
            add x, 20
            mov y, 210
            cmp x, 630
            jne flag_in2
            
        mov x, 560
        mov y, 220
        mov w, 10
        mov col, 0000b ;BLACK COLOUR

        flag_in3:
            call line
            inc y
            cmp y, 230
                jne flag_in3
            
            add x, 20
            mov y, 220
            cmp x, 640
            jne flag_in3
            
        mov x, 570
        mov y, 230
        mov w, 10
        mov col, 0000b ;BLACK COLOUR

        flag_in4:
            call line
            inc y
            cmp y, 240
                jne flag_in4
            
            add x, 20
            mov y, 230
            cmp x, 630
            jne flag_in4
            
        mov x, 560
        mov y, 240
        mov w, 10
        mov col, 0000b ;BLACK COLOUR

        flag_in5:
            call line
            inc y
            cmp y, 250
                jne flag_in5
            
            add x, 20
            mov y, 240
            cmp x, 640
            jne flag_in5
        
   .endif     
;==============================CASTLE=================================
  .if(level==3)  
  castle:
                       
        mov x, 580
        mov y, 439
        mov w, 59
        mov col, 06H ;BROWN COLOUR

        Box_:
            call line
            sub y,1
            cmp y, 351
                jne Box_
       
        mov x, 580
        mov y, 439
        mov w, 59
        mov col, 00H ;BLACK COLOUR
        
        print_brick:
            call line
            dec y
            inc monster_count
            cmp monster_count,2
                jne print_brick
            sub y, 5    
            mov monster_count, 0
            cmp y, 348                                 
                jne print_brick
        
         
        mov x, 600
        mov y, 351
        mov w, 39
        mov col, 06H ;BROWN COLOUR

        Box_1:
            call line
            sub y,1
            cmp y, 300
                jne Box_1
       
        mov x,600
        mov y, 345
        mov w, 39
        mov col, 00H ;BLACK COLOUR
        
        print_brick1:
            call line
            dec y
            inc monster_count
            cmp monster_count,2
                jne print_brick1
            sub y, 5    
            mov monster_count, 0
            cmp y, 296                                 
                jne print_brick1       
                
        
        mov x, 620
        mov y, 439
        mov w, 19
        mov col, 00H ;BROWN COLOUR

        Box_2:
            call line
            sub y,1
            cmp y, 397
                jne Box_2
       
        mov x, 580
        mov y, 354
        mov w, 10
        mov col, 00H ;BROWN COLOUR

        Box_s:
            call line
            sub y,1
            cmp y, 340
                jne Box_s       
                
                
        mov x, 620
        mov y, 355
        mov w, 13
        mov col, 00H ;BROWN COLOUR

        Box_s1:
            call line
            sub y,1
            cmp y, 340
                jne Box_s1
                
         mov x, 600
        mov y, 300
        mov w, 10
        mov col, 00H ;BROWN COLOUR

        Box_ss:
            call line
            sub y,1
            cmp y, 286
                jne Box_ss       
                
                
        mov x, 620
        mov y, 300
        mov w, 13
        mov col, 00H ;BROWN COLOUR

        Box_s11:
            call line
            sub y,1
            cmp y, 286
                jne Box_s11
    .endif
            
          ret                  
        level_design endp
        
        
    
;=================================MONSTER - FIRST========================================= 
    
    monster_f proc
             
      monsterA: 
        
        
        ;MONSTER BODY----------------------------
        mov ax, move_x_monster1
        mov x, 180 
        mov y, 410
        mov w, 12         
        mov col, 06h ;BROWN COLOUR 
        print_monster1:
            call line
            inc y
            inc monster_count
            cmp monster_count,5
                jne print_monster1
            sub x, 6   
            add w,12 
            mov monster_count, 0
            cmp y, 430                                 
                jne print_monster1
           
       
       
       ;MONSTER EYES------------------------------    
       mov monster_count, 0
       mov x, 174   
       mov y,415
       mov w, 6         
       mov col, 00h ;Black COLOUR   
       MonsterEL:
            call line 
            inc y
            inc monster_count
            cmp monster_count,5
                jne MonsterEL
       
       
        
       mov monster_count, 0
       mov x, 192
       mov y,415
       mov w, 6         
       mov col, 00h ;Black COLOUR 
       MonsterEL1:
            call line 
            inc y
            inc monster_count
            cmp monster_count,5
             jne MonsterEL1
           
       
       
              
       mov monster_count, 0
       mov x, 180
       mov y,420
       mov w, 12         
       mov col, 00h ;Black COLOUR 
       MonsterELL:
            call line 
            inc y
            inc monster_count
            cmp monster_count,5
             jne MonsterELL
       
       
        
       mov monster_count, 0
       mov x, 180
       mov y,425
       mov w, 2         
       mov col, 00h ;Black COLOUR
       MonsterELL1:
            call line 
            inc y
            inc monster_count
            cmp monster_count,3
             jne MonsterELL1
       
       
           
       mov monster_count, 0
       mov x, 190
       mov y,425
       mov w, 2         
       mov col, 00h ;Black COLOUR  
       MonsterELL1_:
            call line 
            inc y
            inc monster_count
            cmp monster_count,3
             jne MonsterELL1_
             
       
       
             
       mov monster_count, 0
       mov x, 180
       mov y,428
       mov w, 12         
       mov col, 0Fh ;Black COLOUR  
       MonsterM:
            call line 
            inc y
            inc monster_count
            cmp monster_count,3
                jne MonsterM
            sub x, 3   
            add w,7 
            mov monster_count, 0
            cmp y, 434
                jne MonsterM
            
            
       
            
       mov x, 171
       mov y,431
       mov w, 3         
       mov col, 0h;Black COLOUR  
       MonsterLeg:
            call line 
            inc y
            inc monster_count
            cmp monster_count,3
                jne MonsterLeg
                
            add w,4 
            mov monster_count, 0
            cmp y, 440
                jne Monsterleg
            
        
            
       mov x, 195
       mov y,431
       mov w, 3         
       mov col, 0h;Black COLOUR 
       MonsterLeg1:
            call line 
            inc y
            inc monster_count    
            cmp monster_count,3
                jne MonsterLeg1    
            add w,4
            sub x, 4 
            mov monster_count, 0
            cmp y, 440
                jne Monsterleg1 
                
        ret
                
        monster_f endp
        
        
        
        
;=================================MONSTER - SECOND========================================= 
    
    monster_s proc
        
    monsterB:
        mov x, 380  
        mov y, 410
        mov w, 12         
        mov col, 06h ;BROWN COLOUR 
        print_monster2:
            call line
            inc y
            inc monster_count
            cmp monster_count,5
                jne print_monster2
            sub x, 6   
            add w,12 
            mov monster_count, 0
            cmp y, 430
                jne print_monster2
        
        
           
           
        mov monster_count, 0
        mov x, 374
        mov y,415
        mov w, 6         
        mov col, 00h ;Black COLOUR  
        MonsterELO:
            call line 
            inc y
            inc monster_count
            cmp monster_count,5
                jne MonsterELO
                
                
        
        
                
        mov monster_count, 0
        mov x, 392
        mov y,415
        mov w, 6         
        mov col, 00h ;Black COLOUR 
        MonsterELO1:
            call line 
            inc y
            inc monster_count
            cmp monster_count,5
                jne MonsterELO1
        
        
           
              
        mov monster_count, 0
        mov x, 380
        mov y,420
        mov w, 12         
        mov col, 00h ;Black COLOUR 
        MonsterELLO:
            call line 
            inc y
            inc monster_count
            cmp monster_count,5
                jne MonsterELLO
         
         
         
        mov monster_count, 0
        mov x, 380
        mov y,425
        mov w, 2         
        mov col, 00h ;Black COLOUR        
        MonsterELLO1:
            call line 
            inc y
            inc monster_count
            cmp monster_count,3
                jne MonsterELLO1
         
        
        
           
        mov monster_count, 0
        mov x, 390
        mov y,425
        mov w, 2         
        mov col, 00h ;Black COLOUR 
        MonsterELLO1_:
            call line 
            inc y
            inc monster_count
            cmp monster_count,3
                jne MonsterELLO1_
             
        
        
             
        mov monster_count, 0
        mov x, 380
        mov y,428
        mov w, 12         
        mov col, 0Fh ;Black COLOUR       
        MonsterMO:
            call line 
            inc y
            inc monster_count
            cmp monster_count,3
                jne MonsterMO
            sub x, 3   
            add w,7 
            mov monster_count, 0
            cmp y, 434
                jne MonsterMO
            
            
        
        
            
        mov x, 371
        mov y,431
        mov w, 3         
        mov col, 0h;Black COLOUR 
        MonsterLegO:
            call line 
            inc y
            inc monster_count
            cmp monster_count,3
                jne MonsterLegO    
            add w,4 
            mov monster_count, 0
            cmp y, 440
                jne MonsterlegO
            
        
        
            
        mov x, 395
        mov y,431
        mov w, 3         
        mov col, 0h;Black COLOUR 
        MonsterLeg1O:
            call line 
            inc y
            inc monster_count    
            cmp monster_count,3
                jne MonsterLeg1O    
            add w,4
            sub x, 4 
            mov monster_count, 0
            cmp y, 440
                jne Monsterleg1O
        
        ret                       
        monster_s endp
	

  
  
     
;========================MARIO CHARACTER INITIAL======================= 
 
    mario proc 
        
        mov x, 30  
        mov y, 340
        mov ax, 0 
        mov ax, y
        mov mario_count, ax
        add mario_count,25
        mov w, 28         
        mov col, 02 ;Green COLOUR 
        print_marioH:
            call line
            inc y
            mov ax, 0
            mov ax, mario_count
            cmp  y, ax 
            
            
            jne print_marioH
        mov x, 40    
        mov ax, y
        mov mario_count, ax
        add mario_count,10
        mov w, 7          
        mov col, 0Eh ;YELLOW COLOUR
        print_marioN:
           call line
            inc y
            mov ax, mario_count
            cmp  y, ax 
            jne print_marioN         
            
        mov x, 23    
        mov ax, y
        mov mario_count, ax
        add mario_count,35
        mov w,40           
        mov col, 6h ;BROWN COLOUR
        print_marioB:
           call line
            inc y
            mov ax, mario_count
            cmp  y, ax 
            jne print_marioB 
         
        mov x, 30    
        mov ax, y
        mov mario_count, ax
        add mario_count,30
        mov w,5          
        mov col, 0Eh ;YELLOW COLOUR
        print_marioL1:
           call line
            inc y
            mov ax, mario_count
            cmp  y, ax 
            jne print_marioL1
            
               
    
        mov x, 50    
        sub y,30
        mov ax, y
        mov mario_count, ax
        add mario_count,30
        mov w,5           
        mov col, 0Eh ;YELLOW COLOUR
        print_marioL2:
           call line
            inc y
            mov ax, mario_count
            cmp  y, ax 
            jne print_marioL2    
    
    
     
;        mov x, 50
;        mov y, 405
;        mov ax, x
;        mov w, ax
;        sub w,25 
;        mov h, 25
;        mov ax, y
;        mov mario_count, ax
;        add mario_count,40
;        
;        
;        ;print_marioH1:
;         Call dline
;           ;inc y
;         ;mov ax, mario_count
;         ;cmp  y, ax 
;         ;jne print_marioL2
;       ; mov x, 50
;       ; mov y, 420
;        mov ax, x
;        mov w, ax
;        sub w,25 
;        mov h, 15
;        mov ax, y
;        mov mario_count, ax
;        add mario_count,40
;        
;        mov x, 106
;        mov y, 405
;        mov ax, x
;        mov w, ax
;        add w,25 
;        mov h, 25
;        mov ax, y
;        mov mario_count, ax
;        add mario_count,40
;        
;        
;        ;print_marioH1:
;         Call dline1
;           ;inc y
;         ;mov ax, mario_count
;         ;cmp  y, ax 
;         ;jne print_marioL2
;       ; mov x, 50
;       ; mov y, 420
;        mov ax, x
;        mov w, ax
;        sub w,25 
;        mov h, 15
;        mov ax, y
;        mov mario_count, ax
;        add mario_count,40
;        
;        ;print_marioH1:
;         ;Call dline
;          Cloud:
;        mov x, 75  
;        mov y, 338
;        mov w, 5         
;        mov col, 0Ch ;WHITE COLOUR 
;        print_cloud:
;            call line
;            inc y
;            inc cloud_count
;            cmp cloud_count,3
;            jne print_cloud
;            sub x, 5
;            add w, 10
;            mov cloud_count, 0
;            cmp y, 350
;                jne print_cloud
    
        ;mov x,96
;        mov y,347
;        mov ax, y
;        mov mario_count, ax
;        add mario_count,3
;        mov w,15           
;        mov col, 0Ch ;YELLOW COLOUR
;        print_marioC:
;           call line
;            inc y
;            mov ax, mario_count
;            cmp  y, ax 
;            jne print_marioC    
     
        
        mario endp
        
        
;DIRECT JUMP TO KEYS FOR MOVEMENTS AFTE CHARACTER DRAWN
        
        jmp keys
        
        

;============================RIGHT MOVEMENT MARIO===================================   
        
    mario_right proc
        
        ;FACE 
        mov x, 0
        mov ax, 0    
        add x, -5
        mov ax,0    
        add ax, move_x_mario
        add x, ax
        add x, 30   
        
;===========================ALL BOUNDRY CHECKS===================================

        .if(x==55)
            add move_x_mario, -5
            
        .elseif(x==235)
            add move_x_mario, -5
            
        .elseif(x==430)
            add move_x_mario, -5  
            
        .elseif(x==525) 
        
            mov move_x_mario,510
            mov move_y_mario, 0     
            
            mov x, 450  
            mov y, 100
            mov w, 110         
            mov col, 1001b ;BLUE COLOUR
        	remove1:
            	call line
            	inc y    
            	cmp y, 330
            	    jne remove1
         
          
        
        .elseif(x==135 && level==1) 
        
            mov x, 80  
            mov y, 270
            mov w, 100      
            mov col, 1001b ;BLUE COLOUR
            rl5:
            	call line
            	inc y    
            	cmp y, 370
            	    jne rl5 
            	    
            mov x, 30
            mov move_x_mario,130
            mov move_y_mario, 0  
            
        .elseif(x==335 && level==1) 
        
            mov x, 250
            mov y, 100
            mov w, 150        
            mov col, 1001b ;BLUE COLOUR                    
        	rl7:
            	call line
            	inc y    
            	cmp y, 350
            	    jne rl7
            
            	    
            mov x, 30
            mov move_x_mario,330
            mov move_y_mario, 0
            	    
            
            
        .elseif(x==135 && level!=1)
            jmp screen_lose 
            
        .elseif(x==335)
            jmp screen_lose
            
        .elseif(x==600)
            jmp screen_win 
             
        .endif
        
          
        mov y, 340 
        mov dx,0
        mov dx, move_y_mario
        add y, dx
        mov ax, 0 
        mov ax, y
        mov mario_count, ax
        add mario_count,25
        mov w, 28         
        mov col, 1001b ;BLUE COLOUR 
        print_marioRBH:
            call line
            inc y
            mov ax, 0
            mov ax, mario_count
            cmp  y, ax 
                jne print_marioRBH 
        
        
            
        ;FACE 
        mov x, 0
        mov ax, 0
        add ax, move_x_mario
        add x, ax
        add x, 30 
        mov y, 340  
        mov dx,0
        mov dx, move_y_mario
        add y, dx
        mov ax, 0 
        mov ax, y
        mov mario_count, ax
        add mario_count,25
        mov w, 28         
        mov col, 02 ;Green COLOUR 
        print_marioRH:
            call line
            inc y
            mov ax, 0
            mov ax, mario_count
            cmp  y, ax 
                jne print_marioRH
        
        
        
        
        ;Neck 
        mov x, 0
        mov ax, 0
        add ax, move_x_mario
        add x, -5
        add x, ax    
        add x, 40    
        mov ax, y
        mov mario_count, ax
        add mario_count,10
        mov w, 7          
        mov col, 1001b ;BLUE COLOUR
        print_marioRBN:
            call line
            inc y
            mov ax, mario_count
            cmp  y, ax 
                jne print_marioRBN
        
        
        
        ;Neck 
        mov x, 0
        mov ax, 0
        add ax, move_x_mario
        add x, ax    
        add x, 40        
        mov y, 365
        mov dx,0
        mov dx, move_y_mario
        add y, dx
        mov dx,0
        mov dx, move_y_mario
        add dx, y    
        mov ax, y
        mov mario_count, ax
        add mario_count,10
        mov w, 7          
        mov col, 0Eh ;YELLOW COLOUR
        print_marioRN:
            call line
            inc y
            mov ax, mario_count
            cmp  y, ax 
                jne print_marioRN
            
        
        
        
        ;Body 
        mov x, 0
        mov ax, 0
        add ax, move_x_mario
        add x, -5
        add x, ax   
        add x, 23   
        mov ax, y
        mov mario_count, ax
        add mario_count,35
        mov w,40           
        mov col, 1001b ;BLUE COLOUR
        print_marioRBB:
            call line
            inc y
            mov ax, mario_count
            cmp  y, ax 
                jne print_marioRBB
         
         
                
        ;Body 
        mov x, 0
        mov ax, 0
        add ax, move_x_mario
        add x, ax   
        add x, 23
        mov y, 375  
        mov dx,0
        mov dx, move_y_mario
        add y, dx  
        mov ax, y
        mov mario_count, ax
        add mario_count,35
        mov w,40           
        mov col, 0110B ;BROWN COLOUR
        print_marioRB:
            call line
            inc y
            mov ax, mario_count
            cmp  y, ax 
                jne print_marioRB 
        
         
         
        ;Left Leg 
        mov x, 0
        mov ax, 0       
        add x, -5
        add ax, move_x_mario
        add x, ax 
        add x, 30    
        mov ax, y
        mov mario_count, ax
        add mario_count,30
        mov w,5           
        mov col, 1001b ;BLUE COLOUR
        print_marioRBL1:
            call line
            inc y
            mov ax, mario_count
            cmp  y, ax 
                jne print_marioRBL1
        
        
                
        ;Left Leg 
        mov x, 0
        mov ax, 0
        add ax, move_x_mario
        add x, ax 
        add x, 30    
        mov y, 410 
        mov dx,0
        mov dx, move_y_mario
        add y, dx   
        mov ax, y
        mov mario_count, ax
        add mario_count,30
        mov w,5           
        mov col, 0Eh ;YELLOW COLOUR
        print_marioRL1:
            call line
            inc y
            mov ax, mario_count
            cmp  y, ax 
                jne print_marioRL1
        
         
         
               
        ;Right Leg 
        mov x, 0
        mov ax, 0
        add ax, move_x_mario
        add x, -5
        add x, ax
        add  x, 50    
        mov y,410   
        mov dx,0
        mov dx, move_y_mario
        add y, dx
        mov ax, y
        mov mario_count, ax
        add mario_count, 30
        mov w, 5          
        mov col, 1001b ;BLUE COLOUR
        print_marioRBL2:
            call line
            inc y
            mov ax, mario_count
            cmp  y, ax 
                jne print_marioRBL2
        
        
            
        ;Right Leg 
        mov x, 0
        mov ax, 0
        add ax, move_x_mario
        add x, ax
        add  x, 50    
        mov y,410   
        mov dx,0
        mov dx, move_y_mario
        add y, dx
        mov ax, y
        mov mario_count, ax
        add mario_count, 30
        mov w, 5          
        mov col, 0Eh ;YELLOW COLOUR
        print_marioRL2:
            call line
            inc y
            mov ax, mario_count
            cmp  y, ax 
                jne print_marioRL2    
    
    
        
        ;;Hands
;        mov x, 50
;        mov y, 405
;        mov ax, x
;        mov w, ax
;        sub w,25 
;        mov h, 25
;        mov ax, y
;        mov mario_count, ax
;        add mario_count,40
;        
;        
;        ;print_marioH1:
;         Call dline
;           ;inc y
;         ;mov ax, mario_count
;         ;cmp  y, ax 
;         ;jne print_marioL2
;       ; mov x, 50
;       ; mov y, 420
;        mov ax, x
;        mov w, ax
;        sub w,25 
;        mov h, 15
;        mov ax, y
;        mov mario_count, ax
;        add mario_count,40
;        
;        mov x, 106
;        mov y, 405
;        mov ax, x
;        mov w, ax
;        add w,25 
;        mov h, 25
;        mov ax, y
;        mov mario_count, ax
;        add mario_count,40
;        
;        
;        ;print_marioH1:
;         Call dline1
;           ;inc y
;         ;mov ax, mario_count
;         ;cmp  y, ax 
;         ;jne print_marioL2
;       ; mov x, 50
;       ; mov y, 420
;        mov ax, x
;        mov w, ax
;        sub w,25 
;        mov h, 15
;        mov ax, y
;        mov mario_count, ax
;        add mario_count,40
;        
;        ;print_marioH1:
;         ;Call dline 
;        
;       ;HAT 
;        Hat:
;        mov x, 50  
;        mov y, 300  
;        mov w, 5         
;        mov col, 0Ch ;RED COLOUR 
;        print_hat:
;            call line
;            inc y
;            inc hat_count
;            cmp hat_count,2
;                jne print_hat
;            sub x, 5
;            add w, 10
;            mov hat_count, 0
;            cmp y, 330
;                jbe print_hat
;        
;        ;Hat Extension
;        mov x,96
;        mov y,347
;        mov ax, y
;        mov mario_count, ax
;        add mario_count,3
;        mov w,15           
;        mov col, 0Ch ;YELLOW COLOUR
;        print_marioC:
;           call line
;            inc y
;            mov ax, mario_count
;            cmp  y, ax 
;            jne print_marioC 
        
        
        mario_right endp
         
;---------------------------------
         
        jmp keys
               
;---------------------------------        
        mario_left proc
            
        ;FACE 
        mov x, 0
        mov ax, 0    
        add x, 5
        mov ax,0    
        add ax, move_x_mario
        add x, ax                  
        add x, 30 
        
;================================ALL BOUNDRY CHECKS================================== 

        .if(x==10)              
            add move_x_mario, 5
            
        .elseif(x==540)
            add move_x_mario,5 
        
        .elseif(x==65)
            .if(move_y_mario==-70)
            
                mov x, 35  
                mov y, 270
                mov w, 100          
                mov col, 1001b ;BLUE COLOUR
            	remove:
                	call line
                	inc y    
                	cmp y, 370
                	    jne remove
                
                	    
                mov x, 30
                mov move_x_mario,0
                mov move_y_mario, 0 
  	    
             .endif
        
        .elseif(x==250 && level==1)
        
            mov x, 230
            mov y, 100
            mov w, 100         
            mov col, 1001b ;BLUE COLOUR
        	rl6:
            	call line
            	inc y    
            	cmp y, 350
            	    jne rl6
             
             
            mov move_x_mario, 180
            mov move_y_mario, 0 
            
            
        .elseif(x==445 && level==1) 
        
            mov x, 430  
            mov y, 100
            mov w, 110           
            mov col, 1001b ;BLUE COLOUR
        	remov4:
            	call line
            	inc y    
            	cmp y, 330
            	    jne remov4
            
                
            mov move_x_mario, 390
            mov move_y_mario, 0     
   
        .elseif(x==150)
            add move_x_mario,5 
             
            
        .elseif(x==350)
            add move_x_mario,5 
            
            
        .elseif(x==250 && level!=1)
            jmp screen_lose 
             
            
        .elseif(x==445 && level!=1)
            jmp screen_lose 
                    
            
        .endif
         
        mov y, 340 
        mov dx,0
        mov dx, move_y_mario
        add y, dx
        mov ax, 0 
        mov ax, y
        mov mario_count, ax
        add mario_count,25
        mov w, 28         
        mov col, 1001b ;BLUE COLOUR
        print_marioLBH:
            call line
            inc y
            mov ax, 0
            mov ax, mario_count
            cmp  y, ax            
                jne print_marioLBH
         
            
        ;FACE 
        mov x, 0
        mov ax, 0
        add ax, move_x_mario
        add x, ax
        add x, 30  
        mov y, 340    
        mov dx,0
        mov dx, move_y_mario
        add y, dx
        mov ax, 0 
        mov ax, y
        mov mario_count, ax
        add mario_count,25
        mov w, 28         
        mov col, 02 ;Green COLOUR 
        print_marioLH:
            call line
            inc y
            mov ax, 0
            mov ax, mario_count
            cmp  y, ax 
                jne print_marioLH
                
                
        
        ;Neck 
        mov x, 0
        mov ax, 0
        add ax, move_x_mario
        add x, 5
        add x, ax    
        add x, 40
        ;mov y, 365    
        mov ax, y
        mov mario_count, ax
        add mario_count,10
        mov w, 7          
        mov col, 1001b ;BLUE COLOUR
        print_marioLBN:
           call line
            inc y
            mov ax, mario_count
            cmp  y, ax 
            jne print_marioLBN
         
         
         
        ;Neck 
        mov x, 0
        mov ax, 0
        add ax, move_x_mario
        add x, ax    
        add x, 40
        mov y, 365     
        mov dx,0
        mov dx, move_y_mario
        add y, dx
        mov ax, y
        mov mario_count, ax
        add mario_count,10
        mov w, 7          
        mov col, 0Eh ;YELLOW COLOUR
        print_marioLN:
            call line
            inc y
            mov ax, mario_count
            cmp  y, ax 
                jne print_marioLN
         
            
        
        ;Body 
        mov x, 0
        mov ax, 0
        add ax, move_x_mario
        add x, 5
        add x, ax   
        add x, 23    
        mov ax, y
        mov mario_count, ax
        add mario_count,35
        mov w,40           
        mov col, 1001b ;BLUE COLOUR
        print_marioLBB:
            call line
            inc y
            mov ax, mario_count
            cmp  y, ax 
                jne print_marioLBB
         
         
            
        ;Body 
        mov x, 0
        mov ax, 0
        add ax, move_x_mario
        add x, ax   
        add x, 23
        mov y, 375     
        mov dx,0
        mov dx, move_y_mario
        add y, dx
        mov ax, y
        mov mario_count, ax
        add mario_count,35
        mov w,40           
        mov col, 0110B ;BROWN COLOUR
        print_marioLB:
            call line
            inc y
            mov ax, mario_count
            cmp  y, ax 
                jne print_marioLB 
        
       
       
        
        ;Left Leg 
        mov x, 0
        mov ax, 0       
        add x, 5
        add ax, move_x_mario
        add x, ax 
        add x, 30    
        mov ax, y
        mov mario_count, ax
        add mario_count,30
        mov w,5           
        mov col, 1001b ;BLUE COLOUR
        print_marioLBL1:
            call line
            inc y
            mov ax, mario_count
            cmp  y, ax 
                jne print_marioLBL1
            
            
                
        ;Left Leg 
        mov x, 0
        mov ax, 0
        add ax, move_x_mario
        add x, ax 
        add x, 30
        mov y, 410 
        mov dx,0
        mov dx, move_y_mario
        add y, dx  
        mov ax, y
        mov mario_count, ax
        add mario_count,30
        mov w,5           
        mov col, 0Eh ;YELLOW COLOUR
        print_marioLL1:
            call line
            inc y
            mov ax, mario_count
            cmp  y, ax 
                jne print_marioLL1
        
           
           
               
        ;Right Leg 
        mov x, 0
        mov ax, 0
        add ax, move_x_mario
        add x, 5
        add x, ax
        add  x, 50    
        mov y,410  
        mov dx,0
        mov dx, move_y_mario
        add y, dx
        mov ax, y
        mov mario_count, ax
        add mario_count, 30
        mov w, 5          
        mov col, 1001b ;BLUE COLOUR
        print_marioLBL2:
            call line
            inc y
            mov ax, mario_count
            cmp  y, ax 
                jne print_marioLBL2
           
           
            
        ;Right Leg 
        mov x, 0
        mov ax, 0
        add ax, move_x_mario
        add x, ax
        add  x, 50    
        mov y,410  
        mov dx,0
        mov dx, move_y_mario
        add y, dx
        mov ax, y
        mov mario_count, ax
        add mario_count, 30
        mov w, 5          
        mov col, 0Eh ;YELLOW COLOUR
        print_marioLL2:
            call line
            inc y
            mov ax, mario_count
            cmp  y, ax 
                jne print_marioLL2    


      
        ;;Hands
;        mov x, 50
;        mov y, 405
;        mov ax, x
;        mov w, ax
;        sub w,25 
;        mov h, 25
;        mov ax, y
;        mov mario_count, ax
;        add mario_count,40
;        
;        
;        ;print_marioH1:
;         Call dline
;           ;inc y
;         ;mov ax, mario_count
;         ;cmp  y, ax 
;         ;jne print_marioL2
;       ; mov x, 50
;       ; mov y, 420
;        mov ax, x
;        mov w, ax
;        sub w,25 
;        mov h, 15
;        mov ax, y
;        mov mario_count, ax
;        add mario_count,40
;        
;        mov x, 106
;        mov y, 405
;        mov ax, x
;        mov w, ax
;        add w,25 
;        mov h, 25
;        mov ax, y
;        mov mario_count, ax
;        add mario_count,40
;        
;        
;        ;print_marioH1:
;         Call dline1
;           ;inc y
;         ;mov ax, mario_count
;         ;cmp  y, ax 
;         ;jne print_marioL2
;       ; mov x, 50
;       ; mov y, 420
;        mov ax, x
;        mov w, ax
;        sub w,25 
;        mov h, 15
;        mov ax, y
;        mov mario_count, ax
;        add mario_count,40
;        
;        ;print_marioH1:
;         ;Call dline 
;        
;       ;HAT 
;        Hat:
;        mov x, 50  
;        mov y, 300  
;        mov w, 5         
;        mov col, 0Ch ;RED COLOUR 
;        print_hat:
;            call line
;            inc y
;            inc hat_count
;            cmp hat_count,2
;                jne print_hat
;            sub x, 5
;            add w, 10
;            mov hat_count, 0
;            cmp y, 330
;                jbe print_hat
;        
;        ;Hat Extension
;        mov x,96
;        mov y,347
;        mov ax, y
;        mov mario_count, ax
;        add mario_count,3
;        mov w,15           
;        mov col, 0Ch ;YELLOW COLOUR
;        print_marioC:
;           call line
;            inc y
;            mov ax, mario_count
;            cmp  y, ax        
;            jne print_marioC 
        
        
        mario_left endp

;-----------------------------------
        
        jmp keys

;-----------------------------------
        
        mario_up proc

        mov x, 0
        add x, 30
        mov ax, 0
        mov ax, move_x_mario 
        add x, ax
        
        .if(move_y_mario==0 && x<350)
            add ax, 0
            mov ax, move_x_mario
            mov move_up_mario, ax
            mov move_x_mario, 70 
            mov move_y_mario, -70
            
            jmp first_jump
          
            
        .elseif(move_y_mario==-70)
            mov ax, 0
            mov ax, move_x_mario
            mov move_up_mario, ax
            mov move_x_mario, 260 
            mov move_y_mario, -90
            
            jmp second_jump
         
        .elseif(move_y_mario==-90)
            mov ax, 0
            mov ax, move_x_mario
            mov move_up_mario, ax
            mov move_x_mario, 455 
            mov move_y_mario, -110
            
            jmp third_jump
                
                
        .else
            jmp keys           

       
        .endif
         

;===========================JUMPING ON FIRST OBSTACLE================================
         
        first_jump:
        
        mov x, 20  
        mov y, 370
        mov w, 50          
        mov col, 1001b ;BLUE COLOUR
    	rl4:
        	call line
        	inc y    
        	cmp y, 440
        	    jne rl4
        

        mov x, 0 
        add x, 30
        mov ax, 0
        mov ax, move_up_mario 
        add x, ax    
        add y, 10 
        mov y, 340
        mov ax, 0 
        mov ax, y
        mov mario_count, ax
        add mario_count,25
        mov w, 28         
        mov col, 1001b ;BLUE COLOUR 
        print_marioU1BH:
            call line
            inc y
            mov ax, 0
            mov ax, mario_count
            cmp  y, ax 
                jne print_marioU1BH
         
         
         
            
        ;FACE 
        mov x, 0
        mov ax, 0
        add ax, move_x_mario
        add x, ax
        add x, 30 
        mov y, 340
        mov ax, 0
        mov ax, move_y_mario  
        add y, ax
        mov ax, 0               
        mov ax, y
        mov mario_count, ax
        add mario_count,25
        mov w, 28         
        mov col, 02 ;Green COLOUR 
        print_marioU1H:
            call line
            inc y
            mov ax, 0
            mov ax, mario_count
            cmp  y, ax 
                jne print_marioU1H
         
         
         
        ;Neck 
        mov x, 0
        mov ax, 0
        add ax, move_up_mario
        add x, ax    
        add x, 40
        mov ax,0
        mov y, 365    
        mov ax, y
        mov mario_count, ax
        add mario_count,10
        mov w, 7          
        mov col, 1001b ;BLUE COLOUR
        print_marioU1BN:
            call line
            inc y           
            mov ax, mario_count
            cmp  y, ax      
                jne print_marioU1BN
              
              
              
        ;Neck 
        mov x, 0
        mov ax, 0
        add ax, move_x_mario
        add x, ax    
        add x, 40
        mov y, 365
        mov ax,0 
        mov dx,0
        mov dx, move_y_mario 
        add y, dx
        add ax,y 
        mov mario_count, ax
        add mario_count,10
        mov w, 7      
        mov col, 0Eh ;YELLOW COLOUR
        print_marioU1N:
            call line
            inc y
            mov ax, mario_count
            cmp  y, ax 
                jne print_marioU1N
         
         
         
        ;Body 
        mov x, 0
        mov ax, 0
        add ax, move_up_mario
        add x, ax   
        add x, 23
        mov y, 375    
        mov ax, y
        mov mario_count, ax
        add mario_count,35
        mov w,40           
        mov col, 1001b ;BLUE COLOUR
        print_marioU1BB:
            call line
            inc y
            mov ax, mario_count
            cmp  y, ax 
                jne print_marioU1BB

       
    
        ;Body 
        mov x, 0
        mov ax, 0
        add ax, move_x_mario
        add x, ax   
        add x, 23
        mov y, 375 
        mov dx, 0
        mov dx, move_y_mario  
        add y, dx  
        mov ax, y
        mov mario_count, ax
        add mario_count,35
        mov w,40           
        mov col, 0110B ;BROWN COLOUR
        print_marioU1B:
            call line
            inc y
            mov ax, mario_count
            cmp  y, ax 
                jne print_marioU1B 


        
        ;Left Leg 
        mov x, 0
        mov ax, 0       
        add ax, move_up_mario
        add x, ax 
        add x, 30
        mov y, 410    
        mov ax, y
        mov mario_count, ax
        add mario_count,30
        mov w,5           
        mov col, 1001b ;BLUE COLOUR
        print_marioU1BL1:
            call line
            inc y
            mov ax, mario_count
            cmp  y, ax 
                jne print_marioU1BL1
               
               
                
        ;Left Leg 
        mov x, 0
        mov ax, 0
        add ax, move_x_mario
        add x, ax 
        add x, 30
        mov y, 410
        mov dx, 0
        mov dx, move_y_mario  
        add y, dx    
        mov ax, y
        mov mario_count, ax
        add mario_count,30
        mov w,5           
        mov col, 0Eh ;YELLOW COLOUR
        print_marioU1L1:
            call line
            inc y
            mov ax, mario_count
            cmp  y, ax 
                jne print_marioU1L1
           
           
               
        ;Right Leg 
        mov x, 0
        mov ax, 0 
        add ax, move_up_mario
        add x, ax
        add x, ax
        add  x, 50    
        mov y,410         
        mov ax, y
        mov mario_count, ax
        add mario_count, 30       
        mov w, 5          
        mov col, 1001b ;BLUE COLOUR
        print_marioU1BL2:
           call line
            inc y
            mov ax, mario_count
            cmp  y, ax 
            jne print_marioU1BL2

        
            
        ;Right Leg 
        mov x, 0
        mov ax, 0                                   
        add ax, move_x_mario
        add x, ax
        add  x, 50    
        mov y,410   
        mov dx, 0
        mov dx, move_y_mario  
        add y, dx 
        mov ax, y
        mov mario_count, ax
        add mario_count, 30
        mov w, 5          
        mov col, 0Eh ;YELLOW COLOUR
        print_marioU1L2:
            call line
            inc y
            mov ax, mario_count
            cmp  y, ax 
                jne print_marioU1L2    
           
           
           
           
        ;;Hands
;        mov x, 50
;        mov y, 405
;        mov ax, x
;        mov w, ax
;        sub w,25 
;        mov h, 25
;        mov ax, y
;        mov mario_count, ax
;        add mario_count,40
;        
;        
;        ;print_marioH1:
;         Call dline
;           ;inc y
;         ;mov ax, mario_count
;         ;cmp  y, ax 
;         ;jne print_marioL2
;       ; mov x, 50
;       ; mov y, 420
;        mov ax, x
;        mov w, ax
;        sub w,25 
;        mov h, 15
;        mov ax, y
;        mov mario_count, ax
;        add mario_count,40
;        
;        mov x, 106
;        mov y, 405
;        mov ax, x
;        mov w, ax
;        add w,25 
;        mov h, 25
;        mov ax, y
;        mov mario_count, ax
;        add mario_count,40
;        
;        
;        ;print_marioH1:
;         Call dline1
;           ;inc y
;         ;mov ax, mario_count
;         ;cmp  y, ax 
;         ;jne print_marioL2
;       ; mov x, 50
;       ; mov y, 420
;        mov ax, x
;        mov w, ax
;        sub w,25 
;        mov h, 15
;        mov ax, y
;        mov mario_count, ax
;        add mario_count,40
;        
;        ;print_marioH1:
;         ;Call dline 
;        
;       ;HAT 
;        Hat:
;        mov x, 50  
;        mov y, 300  
;        mov w, 5         
;        mov col, 0Ch ;RED COLOUR 
;        print_hat:
;            call line
;            inc y
;            inc hat_count
;            cmp hat_count,2
;                jne print_hat
;            sub x, 5
;            add w, 10
;            mov hat_count, 0
;            cmp y, 330
;                jbe print_hat
;        
;        ;Hat Extension
;        mov x,96
;        mov y,347
;        mov ax, y
;        mov mario_count, ax
;        add mario_count,3
;        mov w,15           
;        mov col, 0Ch ;YELLOW COLOUR
;        print_marioC:
;           call line
;            inc y
;            mov ax, mario_count
;            cmp  y, ax 
;            jne print_marioC 

;-------------------------------------

        jmp keys
 
;-------------------------------------
       
        second_jump:
        
        mov x, 80  
        mov y, 270
        mov w, 100         
        mov col, 1001b ;BLUE COLOUR
    	rl2:
        	call line
        	inc y    
        	cmp y, 370
        	    jne rl2 
        	    
        
        ;FACE 
        mov x, 0
        mov ax, 0
        add ax, move_x_mario
        add x, ax
        add x, 30 
        mov y, 340
        mov ax, 0
        mov ax, move_y_mario  
        add y, ax
        mov ax, 0               
        mov ax, y
        mov mario_count, ax
        add mario_count,25
        mov w, 28         
        mov col, 02 ;Green COLOUR 
        print_marioU2H:
            call line
            inc y
            mov ax, 0
            mov ax, mario_count
            cmp  y, ax 
                jne print_marioU2H
            
         
         
        ;Neck 
        mov x, 0
        mov ax, 0
        add ax, move_x_mario
        add x, ax    
        add x, 40
        mov y, 365 
        mov dx,0
        mov dx, move_y_mario 
        add y, dx 
        mov ax,0
        add ax,y 
        mov mario_count, ax
        add mario_count,10
        mov w, 7        
        mov col, 0Eh ;YELLOW COLOUR
        print_marioU2N:
            call line
            inc y
            mov ax, mario_count
            cmp  y, ax 
                jne print_marioU2N    
         
        
          
          
        ;Body 
        mov x, 0
        mov ax, 0
        add ax, move_x_mario
        add x, ax   
        add x, 23
        mov y, 375 
        mov dx, 0
        mov dx, move_y_mario  
        add y, dx  
        mov ax, y
        mov mario_count, ax
        add mario_count,35
        mov w,40           
        mov col, 0110B ;BROWN COLOUR
        print_marioU2B:
            call line
            inc y
            mov ax, mario_count
            cmp  y, ax 
                jne print_marioU2B
                
                
                
                
        ;Left Leg 
        mov x, 0
        mov ax, 0
        add ax, move_x_mario
        add x, ax 
        add x, 30
        mov y, 410
        mov dx, 0
        mov dx, move_y_mario  
        add y, dx    
        mov ax, y
        mov mario_count, ax
        add mario_count,30
        mov w,5           
        mov col, 0Eh ;YELLOW COLOUR
        print_marioU2L1:
            call line
            inc y
            mov ax, mario_count
            cmp  y, ax 
                jne print_marioU2L1
            
            
            
            
        ;Right Leg 
        mov x, 0
        mov ax, 0                                   
        add ax, move_x_mario
        add x, ax
        add  x, 50    
        mov y,410   
        mov dx, 0
        mov dx, move_y_mario  
        add y, dx 
        mov ax, y
        mov mario_count, ax
        add mario_count, 30
        mov w, 5          
        mov col, 0Eh ;YELLOW COLOUR
        print_marioU2L2:
            call line
            inc y
            mov ax, mario_count
            cmp  y, ax 
                jne print_marioU2L2 

;-------------------------------------
                        
        jmp keys              

;-------------------------------------
        
        third_jump:
        
        mov x, 250
        mov y, 100
        mov w, 100          
        mov col, 1001b ;BLUE COLOUR
    	rl3:
        	call line
        	inc y    
        	cmp y, 350
        	    jne rl3 
        	    
         
         
        ;FACE 
        mov x, 0
        mov ax, 0
        add ax, move_x_mario
        add x, ax
        add x, 30 
        mov y, 340
        mov ax, 0
        mov ax, move_y_mario  
        add y, ax
        mov ax, 0               
        mov ax, y
        mov mario_count, ax
        add mario_count,25
        mov w, 28         
        mov col, 02 ;Green COLOUR 
        print_marioU3H:
            call line
            inc y
            mov ax, 0
            mov ax, mario_count
            cmp  y, ax 
                jne print_marioU3H
            
            
            
        ;Neck 
        mov x, 0
        mov ax, 0
        add ax, move_x_mario
        add x, ax    
        add x, 40
        mov y, 365 
        mov dx,0
        mov dx, move_y_mario 
        add y, dx 
        mov ax,0
        add ax,y 
        mov mario_count, ax
        add mario_count,10
        mov w, 7        
        mov col, 0Eh ;YELLOW COLOUR
        print_marioU3N:
            call line
            inc y
            mov ax, mario_count
            cmp  y, ax 
                jne print_marioU3N    
         
        
         
         
        ;Body 
        mov x, 0
        mov ax, 0
        add ax, move_x_mario
        add x, ax   
        add x, 23
        mov y, 375 
        mov dx, 0
        mov dx, move_y_mario  
        add y, dx  
        mov ax, y
        mov mario_count, ax
        add mario_count,35
        mov w,40           
        mov col, 0110B ;BROWN COLOUR
        print_marioU3B:
            call line
            inc y
            mov ax, mario_count
            cmp  y, ax 
                jne print_marioU3B
                
                
                
        ;Left Leg 
        mov x, 0
        mov ax, 0
        add ax, move_x_mario
        add x, ax 
        add x, 30
        mov y, 410
        mov dx, 0
        mov dx, move_y_mario  
        add y, dx    
        mov ax, y
        mov mario_count, ax
        add mario_count,30
        mov w,5           
        mov col, 0Eh ;YELLOW COLOUR
        print_marioU3L1:
            call line
            inc y
            mov ax, mario_count
            cmp  y, ax 
                jne print_marioU3L1
              
              
              
        ;Right Leg 
        mov x, 0
        mov ax, 0                                   
        add ax, move_x_mario
        add x, ax
        add  x, 50    
        mov y,410   
        mov dx, 0
        mov dx, move_y_mario  
        add y, dx 
        mov ax, y
        mov mario_count, ax
        add mario_count, 30
        mov w, 5          
        mov col, 0Eh ;YELLOW COLOUR
        print_marioU3L2:
            call line
            inc y
            mov ax, mario_count
            cmp  y, ax 
                jne print_marioU3L2 


;-----------------------------------

        jmp keys 
 
;-----------------------------------
          
        mario_up endp  


;=============MARIO MOVEMENT KEY DETECTION==================    
    keys:
        
    mov ah,0
    int 16h 
    
    cmp ah,4Bh
        je left
    
    cmp ah,4Dh  
        je right
    
    cmp ah,48h
        je up
        
    cmp ah,1
        je menu_screen        
        
        

;=============MENU MOVEMENT KEY DETECTION==================    
    menu_keys:
    
    mov ah,0
    int 16h 
    
    cmp ah, 28
    je select_opt
    
    cmp ah,48h
    je menu_up 
    
    cmp ah,50h
    je menu_down
    
    

;---------------------------------------    
    menu_down:
    
    .if(mp==1)
        inc mp
        jmp opt2
    .elseif(mp==2)
        inc mp
        jmp opt3
    .elseif(mp==3)
        mov mp,1
        jmp opt1
    .endif 
    
    
;----------------------------------------    
    menu_up:
    
    .if(mp==1)
        mov mp,3
        jmp opt3
    .elseif(mp==2)
        dec mp
        jmp opt1
    .elseif(mp==3)
        dec mp
        jmp opt2
    .endif
    

;----------------------------------------        
    select_opt:
    
    .if(mp==1)
        jmp game_screen
    
    .elseif(mp==2)
        jmp inst_screen
    
    .elseif(mp==3)
        jmp exit_all
    
    .endif   
    
;-----------------------------------------    
    exit_all:
    
    mov ah,0
    mov al,12h
    int 10h
    
    mov ah,4ch
    int 21h
    
    
    
 
;================ALL FUNCTIONS FOR CALLING AND DRAWING=========================

    		 
    STRINGPRINT proc
	
		charprint:
		mov ah,02h
		mov bh,0
		int 10h
        
        ;Push to save String Address
		push dx
		
		mov dl,[si]
		int 21h   
		
		;Pop to retrieve String Address
		pop dx
		
		inc si
		inc dl
		loop charprint
		    
	    ret
	stringprint endp
    
    ;=========================================== 
    
    ;===========================================
    
    STRINGPRINT_DELAY proc
	
		charprint1:
		mov ah,02h
		mov bh,0
		int 10h
        
        ;Push to save String Address
		push dx
		
		call delay
		mov dl,[si]
		int 21h   
		
		;Pop to retrieve String Address
		pop dx
		
		inc si                                                             
		inc dl
		loop charprint1
		    
	    ret                                                                                                      
	stringprint_delay endp    
    
    ;=========================================== 
    
    ;===========================================
    
    Line proc
            
        mov ax,x
        add ax,w
        mov cx, ax         
        mov dx, y         
        mov al, col       
        upper_line: 
            mov ah, 0ch   
            int 10h
           
            dec cx
            cmp cx, x
            jae upper_line
         RET
    Line endp
              
    ;=========================================== 
    
    ;===========================================
              
    vLine proc
        mov ax,y
        add ax,h
        mov cx, x    
        mov dx, ax   
        mov al, col     
        left_line: 
            mov ah, 0ch   
            int 10h
           
            dec dx
            cmp dx, y
            ja left_line
            ret 
    vLine endp
    
    ;=========================================== 
    
    ;===========================================
	 dline proc
        mov cx, x         
        mov dx, y         
        mov al, 0Eh       
        upper_line1: 
            mov ah, 0ch   
            int 10h
           
            dec cx
            inc dx
            cmp cx, w
            jne upper_line1
            mov ax, h
            add x, ax
            add y, ax
            ret
     dline endp
	 
	;=========================================== 
    
    ;===========================================
    
	 dline1 proc
        mov cx, x         
        mov dx, y         
        mov al, 0Eh       
        upper_lined: 
            mov ah, 0ch   
            int 10h
           
            inc cx
            inc dx
            cmp cx, w
            jne upper_lined
            mov ax, h
            add x, ax
            add y, ax
            ret
     dline1 endp
	 
    
   
    ;=========================================== 
    
    ;===========================================
    
                                                                                                             
    DELAY proc

        push ax
        push bx
        push cx
        push dx
        
        mov cx,1000
        mydelay:
            mov bx,700 ;Increase this num to increase Delay
        mydelay1:
            dec bx
            jnz mydelay1
            loop mydelay
        
        pop dx
        pop cx
        pop bx
        pop ax
        
        ret

    delay endp
    
    ;======================================= 
    
    ;===========================================
    
                                                                                                             
    DELAY_WL proc

        push ax
        push bx
        push cx
        push dx
        
        mov cx,1000
        mydelay:
            mov bx,7000 ;Increase this num to increase Delay
        mydelay1:
            dec bx
            jnz mydelay1
            loop mydelay
        
        pop dx
        pop cx
        pop bx
        pop ax
        
        ret

    delay_wl endp
    
    ;======================================= 
       
    
end 
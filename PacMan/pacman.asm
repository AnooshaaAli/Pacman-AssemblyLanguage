INCLUDE Irvine32.inc
INCLUDELIB WINMM.LIB

PlaySound PROTO, pszSound:PTR BYTE, hmod:DWORD, fdwSound:DWORD

.data
    
    beginSound byte "pacman_beginning.wav", 0
    eatfruit byte "pacman_eatfruit.wav", 0
    pacmanDeath byte "pacman_death.wav", 0
    intermission byte "pacman_intermission.wav", 0

    pacman byte "WELCOME TO PACMAN!", 0
    askName byte "What's your name? ", 0

    menu1 byte "Press 1 to start the game.", 0
    menu2 byte "Press 2 to read the instructions.", 0
    menu3 byte "Press 3 to check the high scores.", 0
    menu4 byte "Press 4 to exit.", 0

    Instruction1 byte "1. Eat all the dots and fruits while avoiding ghosts to advance to the next level.", 0
    Instruction2 byte "2. Use a,s,w,d to navigate Pacman through the maze.", 0
    Instruction3 byte "3. Collect dots (1 points each) and fruits (5 points each) to increase your score.", 0
    Instruction4 byte "4. Avoid ghosts; they will cost you a life if caught.", 0
    Instruction5 byte "5. You start with 3 lives. Losing a life occurs when caught by a ghost. Extra lives are awarded at certain score milestones.", 0
    Instruction6 byte "6. Complete each level by eating all the dots. Each new level increases in difficulty.", 0
    Instruction7 byte "7. Press P to pause the screen.", 0
    Instruction8 byte "Press 0 to Move to previous page.", 0

    gameOverLine1 BYTE "  _______ ", 0
    gameOverLine2 BYTE " |  _____| ", 0
    gameOverLine3 BYTE " | | ", 0      
    gameOverLine4 BYTE " | | _____", 0   
    gameOverLine5 BYTE " | |___| |", 0 
    gameOverLine6 BYTE " |_______|", 0

    gameover byte "Game Over", 0

    pauseMsg1 byte "Want to Resume?", 0
    pauseTitle byte ">>>> PACMAN <<<<", 0

    playerName byte 80 dup(?)
    strPlayer byte "Player Name: ", 0
    playerNamesArray byte 5000 dup(?)

    heart byte 3,0
    filename byte "players.txt", 0
    filename2 byte "scores.txt", 0
    filename3 byte "levels.txt", 0
    filename4 byte "highscore.txt", 0

    filehandle dd ?
    bytesWritten dword ?
    downwards byte 0
    backwards byte 0
    forwards byte 0
    upwards byte 0

    temp byte ?
    strScore BYTE "Your score is: ",0
    score dw 0
    scoreString byte 5 dup(?)
    ScoresArray byte 500 dup(?)

    livesRemaining BYTE "Lives Remaining: ", 0
    lives BYTE 3
    
    levelStr byte "Current Level : ", 0
    level byte 1
    levelsArray byte 100 dup(?)

    xPos BYTE 75
    yPos BYTE 19
    prevXPos byte 75
    prevYPos byte 19

    xGhostPos byte 71, 57, 100, 115, 71
    yGhostPos byte 7, 19, 16, 28, 26

    OgxGhostPos byte 71, 57, 100, 115, 71
    OgyGhostPos byte 7, 19, 16, 28, 26

    prevXGhostPos byte 71, 57, 100, 115, 71
    prevYGhostPos byte 7, 19, 16, 28, 26

    numGhosts dd 2
    GhostsColors dd 4, 5, 6, 2, 11

    ghostsSpeed dd 100

    xCoinPos BYTE ?
    yCoinPos BYTE ?

    xMazePos BYTE 38
    yMazePos BYTE 10
    boxHeight BYTE 6
    boxWidth BYTE 4
    numBoxes dd ?

    walls byte 30000 dup(0)

    array1 byte 40 dup(?)
    array2 byte 40 dup(?)
    array3 byte 40 dup(?)
    array4 byte 40 dup(?)

    foodArray1 byte 40 dup(?)
    foodArray2 byte 40 dup(?)
    foodArray3 byte 40 dup(?)
    foodArray4 byte 40 dup(?)

    foodCheck1 byte 30000 dup(0)
    foodCheck2 byte 3000 dup(0)

    numFood dd ?

    xCherryPos byte ?
    yCherryPos byte ?

    cherry1 byte 10 dup(0)
    cherry2 byte 10 dup(0)

    cherryCheck byte 10 dup(0)

    numCherries dd ?

    xFoodPos BYTE ?
    yFoodPos BYTE ?
    Vquantity BYTE ?
    Hquantity BYTE ?

    NumMazes dd 9 ;(Roll no: 1242 ; Sum: 1+2+4+2 = 9)
    inputChar BYTE ?
    randomChar Byte ?
    answer dword ?

	bufsize = 5000
	buffer byte bufsize dup(?)
	bytesRead dword ?

.code

; ---------------------------------------------------------------- Page 1 --------------------------------------------------------------------------------- ;

page1 proc 
    mov dl, 50
    mov dh, 10
    call gotoxy

    mov edx, offset pacman
    mov eax, yellow + (black*16)
    call setTextColor
    call WriteString
    call crlf

    mov dl, 45
    mov dh, 11
    call gotoxy

    ; ----- Ask user name ----- ;

    mov edx, offset askName
    call WriteString
    mov edx, offset playerName
    mov ecx, lengthof playerName - 1
    call ReadString

    mov dl, 88
    mov dh, 20
    call gotoxy

    call waitmsg
    call resetTextColor
    ret
page1 endp

; ---------------------------------------------------------------------- Page 2 ---------------------------------------------------------------------------- ;

page2 proc  

    call clrscr
    ; ------------- Display The menu -------------- ;

    mov dl, 50
    mov dh, 8
    call gotoxy

    mov eax, 1000
    call delay

    mov edx, offset menu1
    mov eax, yellow + (black*16)
    call setTextColor
    call WriteString
    call crlf

    mov dl, 50
    mov dh, 9
    call gotoxy

    mov eax, 1000
    call delay

    mov edx, offset menu2
    mov eax, yellow + (black*16)
    call setTextColor
    call WriteString
    call crlf

    mov dl, 50
    mov dh, 10
    call gotoxy

    mov eax, 1000
    call delay

    mov edx, offset menu3
    mov eax, yellow + (black*16)
    call setTextColor
    call WriteString
    call crlf

    mov dl, 50
    mov dh, 11
    call gotoxy

    mov eax, 1000
    call delay

    mov edx, offset menu4
    mov eax, yellow + (black*16)
    call setTextColor
    call WriteString
    call crlf

    mov eax, 1000
    call delay

    call readInt

    ret
page2 endp

; --------------------- Change Color ---------------------- ;

; ---------------------- Reset Text Color --------------------- ;

resetTextColor proc 
    mov eax, white + (black*16)
    call setTextColor
    ret
resetTextColor endp

; --------------------- Move to Mid ------------------------- ;

moveToMid proc uses edx
    mov dl, 50
    mov dh, 10
    add dh, downwards
    sub dh, upwards
    sub dl, backwards
    add dl, forwards
    call gotoxy
    ret
moveToMid endp

; --------------------- Move to Bottom ------------------------- ;

moveToBottom proc uses edx
    mov dl, 88
    mov dh, 20
    call gotoxy
    ret
moveToBottom endp

; ------------------------ Procedure to convert integer to string ---------------------------- ;

IntToStr PROC
    push    eax
    push    ecx
    push    edi

    mov     ecx, 10                  ; Set divisor to 10
    mov     ax, score
    mov esi, lengthof scoreString

    mov     edi, edi                 ; Clear EDI to use it as an index

    repeatLoop:
        xor     edx, edx             ; Clear any previous remainder
        div     ecx                  ; Divide EAX by 10, result in EAX, remainder in EDX

        add     dl, '0'              ; Convert remainder to ASCII
        dec     esi                ; Move EDI to the next position in the string
        mov     scoreString [esi], dl ; Store the ASCII character in the string

        test    eax, eax             ; Check if quotient is zero
        jnz     repeatLoop           ; If not, continue the loop

    pop     edi
    pop     ecx
    pop     eax
    ret

IntToStr ENDP


; -------------------- Get Input ---------------------------- ;

saveToFile PROC USES eax ecx edx

    	mov ax, 0
		mov bx, 0
		mov cx, 0
		mov dx, 0

		; ------------------------ Opening the file ----------------------- ;

		;mov edx, offset filename
		;call openInputFile
		;mov filehandle, eax

		;mov  edx, OFFSET playerNamesArray
		;mov  ecx, 5000 
		;call ReadFromFile
		;jc show_error_message
		;mov  bytesRead, eax

		;mov eax,fileHandle
		;call CloseFile

		;mov ecx, lengthof playerName - 1
		;mov esi, bytesRead
        ;mov ebx, 0
        ;inc esi
        ;mov [playerNamesArray+esi], 0ah
        ;inc esi
		;L1:
			;mov al, playerName[ebx]
			;mov [playerNamesArray+esi], al
			;inc esi
            ;inc ebx
		;loop L1

		mov edx, offset filename
		call createOutputFile
		mov filehandle, eax

		mov  eax,fileHandle
		mov  edx,OFFSET playerName
		mov  ecx, lengthof playerName - 1
		call WriteToFile
		jc   show_error_message
		mov  bytesWritten,eax

    ; ------- Convert Score to String -------- ;

    ; Assuming your score variable is a DWORD
    movzx eax, score
    mov edx, offset scoreString  ; Assuming scoreString is a buffer to hold the string
    call IntToStr

    	mov ax, 0
		mov bx, 0
		mov cx, 0
		mov dx, 0

		; ------------------------ Opening the file ----------------------- ;

		;mov edx, offset filename2
		;call openInputFile
		;mov filehandle, eax

		;mov  edx, OFFSET scoresArray
		;mov  ecx, 5000 
		;call ReadFromFile
		;jc show_error_message
		;mov  bytesRead, eax

		;mov eax,fileHandle
		;call CloseFile

		;mov ecx, lengthof scoreString - 1
		;mov esi, bytesRead
        ;mov ebx, 0
        ;inc esi
        ;mov [scoresArray+esi], 0ah
        ;inc esi
		;L2:
			;mov al, scoreString[ebx]
			;mov [scoresArray+esi], al
			;inc esi
            ;inc ebx
		;loop L2

		mov edx, offset filename2
		call createOutputFile
		mov filehandle, eax

		mov  eax,fileHandle
		mov  edx,OFFSET scoreString
		mov  ecx, lengthof scoreString 
		call WriteToFile
		jc   show_error_message
		mov  bytesWritten,eax


    	mov ax, 0
		mov bx, 0
		mov cx, 0
		mov dx, 0

		; ------------------------ Opening the file ----------------------- ;

		;mov edx, offset filename3
		;call openInputFile
		;mov filehandle, eax

		;mov  edx, OFFSET levelsArray
		;mov  ecx, 5000 
		;call ReadFromFile
		;jc show_error_message
		;mov  bytesRead, eax

		;mov eax,fileHandle
		;call CloseFile

		;mov ecx, lengthof level 
		;mov esi, bytesRead
        ;mov ebx, 0
        ;inc esi
        ;mov [levelsArray+esi], 0ah
        ;inc esi
		;L3:
			;mov al, level[ebx]
			;mov [scoresArray+esi], al
			;inc esi
            ;inc ebx
		;loop L3

		mov edx, offset filename3
		call createOutputFile
		mov filehandle, eax

		mov  eax,fileHandle
		mov  edx,OFFSET level
		mov  ecx, lengthof level
        add level, '0'
		call WriteToFile
		jc   show_error_message
		mov  bytesWritten,eax

    ; Jump to label 'dafa'
    jmp dafa

show_error_message:
    ; Call WriteWindowsMsg for error handling
    call WriteWindowsMsg

dafa:

    ret

saveToFile ENDP


; -------------------------------------------------------------------- Level 3 ------------------------------------------------------------------------ ;

level3 PROC
    
     call clrscr
     mov eax, 1500
     call delay
     inc level

    ; --------------------- Draw Boundaries -------------------------- ;

    call DrawBoundaries

    ; -------------------------- Draw Basic maze ------------------------ ;
    
    call DrawBasicMaze

    ; -------------------------- Draw Food ------------------------ ;
    
    call distributeFood

    ; -------------------------- Draw Cherry ------------------------ ;
    
    call drawCherry

    ; --------------------- Draw the Player --------------------- ;

    mov xPos, 75
    mov yPos, 19

    call DrawPlayer

    ; --------------------- Draw the Ghost --------------------- ;

    mov xGhostPos[0], 71
    mov yGhostPos[0], 7
    mov xGhostPos[1], 57
    mov yGhostPos[1], 19
    mov xGhostPos[2], 100
    mov yGhostPos[2], 16
    mov xGhostPos[3], 115
    mov yGhostPos[3], 28
    mov xGhostPos[4], 71
    mov yGhostPos[4], 26

    add numGhosts, 2
    mov ghostsSpeed, 25
    mov esi, 0
    call DrawGhost

    ; -------------------- The Sound ---------------------------- ;

    invoke PlaySound, offset intermission, null, 11h
    mov eax, 6000
    call delay

    mov ecx, numMazes

    gameLoop:
         
        ; ---------------- Player Cherry Collision ----------------- ;

        call checkPlayerCherryCollision

        ; ------------- Check lives ----------------;

        cmp lives, 0
        jle exitGame

        ; ------------ Level Up ------------------ ;

        cmp score, 400
        jge exitGame

        ; ---------- write player name ------------ ;

        mov eax, white (black * 16)
        call SetTextColor

        mov dl,2
        mov dh,3
        call Gotoxy
        mov edx,OFFSET playerName
        call WriteString

        ; ---------- Update the score ------------ ;

        mov eax,white (black * 16)
        call SetTextColor

        mov dl,2
        mov dh,5
        call Gotoxy
        mov edx,OFFSET strScore
        call WriteString

        mov eax,Green (black * 16)
        call SetTextColor

        mov ax,score
        call WriteInt

        ; ---------- Update the level ------------ ;

        mov eax,white (black * 16)
        call SetTextColor

        mov dl,2
        mov dh,6
        call Gotoxy
        mov edx,OFFSET levelStr
        call WriteString

        mov eax, magenta
        call SetTextColor

        mov al,level
        call WriteDec

        ; ---------- Update Lives ------------ ;

        mov eax,white (black * 16)
        call SetTextColor

        mov dl,2
        mov dh,27
        call Gotoxy
        mov edx,OFFSET livesRemaining
        call WriteString

        mov eax,Green (black * 16)
        call SetTextColor

        mov al,lives
        call WriteDec

        ; ------------ Check Player Ghost Collision ------------- ;

        call checkPlayerGhostCollision
        cmp al, 'y'
        je updateLives

        jmp onGround

        updateLives:
            invoke PlaySound, offset pacmanDeath, null, 0
            dec lives
            mov eax, 1000
            call delay
            mov xPos, 75
            mov yPos, 19
            call updatePlayer
            call drawPlayer

        onGround:

        ; ----------------------- Ghost Movement ----------------------------- ;

        Ghost:

            call Randomize
            mov eax, 200
            call RandomRange

            mov randomChar,al

            cmp randomChar, 50
            jbe moveGhostUp

            cmp randomChar, 100
            jbe moveGhostDown

            cmp randomChar, 150
            jbe moveGhostLeft

            cmp randomChar, 200
            jbe moveGhostRight

        moveGhostUp:

        call GhostUpwardsMovement

        jmp playerMovement

        moveGhostDown:

        call GhostDownwardsMovement

        jmp playerMovement

        moveGhostLeft:

        call GhostLeftMovement

        jmp playerMovement

        moveGhostRight:

        call GhostRightMovement

        jmp playerMovement

        ; -------------- get user key input ------------------ ;

        PlayerMovement:

            call ReadKey
            mov inputChar,al

            cmp inputChar,"x"
            je exitGame

            cmp inputChar,"p"
            je pauseScreen

            cmp inputChar,"w"
            je moveUp

            cmp inputChar,"s"
            je moveDown

            cmp inputChar,"a"
            je moveLeft

            cmp inputChar,"d"
            je moveRight

            jmp gameLoop

        ; --------------------- Player Movement ---------------------- ;

        moveUp:
       
            mov ebx, 0
            mov bl, xPos
            mov bh, yPos
            dec bh
            cmp walls[bx], 1
            je gameLoop

            mov ebx, 0
            mov bl, xPos
            mov bh, yPos
            cmp [foodCheck1+bx], 1
            je IncreaseScore1

            jmp NoIncrease1

            IncreaseScore1:
                ;invoke PlaySound, offset eatFruit, null, 0
                mov ebx, 0
                mov bl, xPos
                mov bh, yPos
                mov [foodCheck1+bx], 0
                inc score

            NoIncrease1:

            call UpdatePlayer
            mov al, yPos
            mov prevYPos, al
            mov al, xPos
            mov prevXPos, al
            dec yPos
            call DrawPlayer
            mov eax,70
            call Delay

        jmp gameLoop

        moveDown:

            mov ebx, 0
            mov bl, xPos
            mov bh, yPos
            inc bh
            cmp walls[bx], 1
            je gameLoop

            mov ebx, 0
            mov bl, xPos
            mov bh, yPos
            cmp [foodCheck1+bx], 1
            je IncreaseScore2

            jmp NoIncrease2
            IncreaseScore2:
                ;invoke PlaySound, offset eatFruit, null, 0
                mov ebx, 0
                mov bl, xPos
                mov bh, yPos
                mov [foodCheck1+bx], 0
                inc score
            NoIncrease2:

            call UpdatePlayer
            mov al, yPos
            mov prevYPos, al
            mov al, xPos
            mov prevXPos, al
            inc yPos
            call DrawPlayer
            jmp gameLoop

        moveLeft:

            mov ebx, 0
            mov bl, xPos
            mov bh, yPos
            dec bl
            cmp walls[bx], 1
            je gameLoop

            mov ebx, 0
            mov bl, xPos
            mov bh, yPos
            cmp [foodCheck1+bx], 1
            je IncreaseScore

            jmp NoIncrease
            IncreaseScore:
                ;invoke PlaySound, offset eatFruit, null, 0
                mov ebx, 0
                mov bl, xPos
                mov bh, yPos
                mov [foodCheck1+bx], 0
                inc score
            NoIncrease:

            call UpdatePlayer
            mov al, yPos
            mov prevYPos, al
            mov al, xPos
            mov prevXPos, al
            dec xPos
            call DrawPlayer
            jmp gameLoop

        moveRight:

            mov ebx, 0
            mov bl, xPos
            mov bh, yPos
            inc bl
            cmp walls[bx], 1
            je gameLoop

            mov ebx, 0
            mov bl, xPos
            mov bh, yPos
            cmp [foodCheck1+bx], 1
            je IncreaseScore4

            jmp NoIncrease4
            IncreaseScore4:
                ;invoke PlaySound, offset eatFruit, null, 0
                mov ebx, 0
                mov bl, xPos
                mov bh, yPos
                mov [foodCheck1+bx], 0
                inc score
            NoIncrease4:
            call UpdatePlayer
            mov al, yPos
            mov prevYPos, al
            mov al, xPos
            mov prevXPos, al
            inc xPos
            call DrawPlayer
            jmp gameLoop
    
    pauseScreen:
        mov edx, offset pauseMsg1
        mov ebx, offset pauseTitle
        call MsgBoxAsk
        cmp  answer,IDYES
        jne exitGame
        jmp gameloop

    exitGame:
        mov eax, 500
        call delay
        call displayGameOver
        ret

level3 ENDP

; -------------------------------------------------------------------- Level 1 ------------------------------------------------------------------------ ;

level1 PROC
    
     call clrscr
    ; --------------------- Draw Boundaries -------------------------- ;

    call DrawBoundaries

    ; -------------------------- Draw Basic maze ------------------------ ;
    
    call DrawBasicMaze2

    ; -------------------------- Draw Food ------------------------ ;
    
    call distributeFood2

    ; --------------------- Draw the Player --------------------- ;

    call DrawPlayer

    ; --------------------- Draw the Ghost --------------------- ;

    call DrawGhost

    ; -------------------- The Sound ---------------------------- ;

    invoke PlaySound, offset beginSound, null, 11h
    mov eax, 4000
    call delay

    mov ecx, numMazes
    
    ; ------------------- Game Loop ----------------------- ;

    gameLoop:

        ; ------------- Check lives ----------------;

        cmp lives, 0
        jle exitGame

        ; ------------ Level Up ------------------ ;

        mov ax, score
        cmp ax, 100
        jge levelUp

        ; ---------- write player name ------------ ;

        mov eax, white (black * 16)
        call SetTextColor

        mov dl,2
        mov dh,3
        call Gotoxy
        mov edx,OFFSET playerName
        call WriteString

        ; ---------- Update the score ------------ ;

        mov eax,white (black * 16)
        call SetTextColor

        mov dl,2
        mov dh,5
        call Gotoxy
        mov edx,OFFSET strScore
        call WriteString

        mov eax,Green (black * 16)
        call SetTextColor

        mov ax,score
        call WriteInt

        ; ---------- Update the level ------------ ;

        mov eax,white (black * 16)
        call SetTextColor

        mov dl,2
        mov dh,6
        call Gotoxy
        mov edx,OFFSET levelStr
        call WriteString

        mov eax, magenta
        call SetTextColor

        mov al,level
        call WriteDec

        ; ---------- Update Lives ------------ ;

        mov eax,white (black * 16)
        call SetTextColor

        mov dl,2
        mov dh,27
        call Gotoxy
        mov edx,OFFSET livesRemaining
        call WriteString

        mov eax,Green (black * 16)
        call SetTextColor

        mov al,lives
        call WriteDec

        ; ------------ Check Player Ghost Collision ------------- ;

        call checkPlayerGhostCollision
        cmp al, 'y'
        je updateLives

        jmp onGround

        updateLives:
            invoke PlaySound, offset pacmanDeath, null, 0
            dec lives
            mov eax, 1000
            call delay
            mov xPos, 75
            mov yPos, 19
            call updatePlayer
            call drawPlayer

        onGround:

        ; ----------------------- Ghost Movement ----------------------------- ;

        Ghost:

            call Randomize
            mov eax, 200
            call RandomRange

            mov randomChar,al

            cmp randomChar, 50
            jbe moveGhostUp

            cmp randomChar, 100
            jbe moveGhostDown

            cmp randomChar, 150
            jbe moveGhostLeft

            cmp randomChar, 200
            jbe moveGhostRight

        moveGhostUp:

        call GhostUpwardsMovement

        jmp playerMovement

        moveGhostDown:

        call GhostDownwardsMovement

        jmp playerMovement

        moveGhostLeft:

        call GhostLeftMovement

        jmp playerMovement

        moveGhostRight:

        call GhostRightMovement

        jmp playerMovement

        ; -------------- get user key input ------------------ ;

        PlayerMovement:

            call ReadKey
            mov inputChar,al

            cmp inputChar,"x"
            je exitGame

            cmp inputChar,"p"
            je pauseScreen

            cmp inputChar,"w"
            je moveUp

            cmp inputChar,"s"
            je moveDown

            cmp inputChar,"a"
            je moveLeft

            cmp inputChar,"d"
            je moveRight

            jmp gameLoop

        ; --------------------- Player Movement ---------------------- ;

        moveUp:

            mov ebx, 0
            mov bl, xPos
            mov bh, yPos
            dec bh
            cmp walls[bx], 1
            je gameLoop

            mov ebx, 0
            mov bl, xPos
            mov bh, yPos
            cmp [foodCheck1+bx], 1
            je IncreaseScore1

            jmp NoIncrease1

            IncreaseScore1:
                ;invoke PlaySound, offset eatFruit, null, 0
                mov ebx, 0
                mov bl, xPos
                mov bh, yPos
                mov [foodCheck1+bx], 0
                inc score

            NoIncrease1:

            call UpdatePlayer
            mov al, yPos
            mov prevYPos, al
            mov al, xPos
            mov prevXPos, al
            dec yPos
            call DrawPlayer
            mov eax,70
            call Delay

        jmp gameLoop

        moveDown:

            mov ebx, 0
            mov bl, xPos
            mov bh, yPos
            inc bh
            cmp walls[bx], 1
            je gameLoop

            mov ebx, 0
            mov bl, xPos
            mov bh, yPos
            cmp [foodCheck1+bx], 1
            je IncreaseScore2

            jmp NoIncrease2
            IncreaseScore2:
                ;invoke PlaySound, offset eatFruit, null, 0
                mov ebx, 0
                mov bl, xPos
                mov bh, yPos
                mov [foodCheck1+bx], 0
                inc score
            NoIncrease2:

            call UpdatePlayer
            mov al, yPos
            mov prevYPos, al
            mov al, xPos
            mov prevXPos, al
            inc yPos
            call DrawPlayer
            jmp gameLoop

        moveLeft:

            mov ebx, 0
            mov bl, xPos
            mov bh, yPos
            dec bl
            cmp walls[bx], 1
            je gameLoop

            mov ebx, 0
            mov bl, xPos
            mov bh, yPos
            cmp [foodCheck1+bx], 1
            je IncreaseScore

            jmp NoIncrease
            IncreaseScore:
                ;invoke PlaySound, offset eatFruit, null, 0
                mov ebx, 0
                mov bl, xPos
                mov bh, yPos
                mov [foodCheck1+bx], 0
                inc score
            NoIncrease:

            call UpdatePlayer
            mov al, yPos
            mov prevYPos, al
            mov al, xPos
            mov prevXPos, al
            dec xPos
            call DrawPlayer
            jmp gameLoop

        moveRight:

            mov ebx, 0
            mov bl, xPos
            mov bh, yPos
            inc bl
            cmp walls[bx], 1
            je gameLoop

            mov ebx, 0
            mov bl, xPos
            mov bh, yPos
            cmp [foodCheck1+bx], 1
            je IncreaseScore4

            jmp NoIncrease4
            IncreaseScore4:
                ;invoke PlaySound, offset eatFruit, null, 0
                mov ebx, 0
                mov bl, xPos
                mov bh, yPos
                mov [foodCheck1+bx], 0
                inc score
            NoIncrease4:
            call UpdatePlayer
            mov al, yPos
            mov prevYPos, al
            mov al, xPos
            mov prevXPos, al
            inc xPos
            call DrawPlayer
            jmp gameLoop
    
    pauseScreen:
        mov edx, offset pauseMsg1
        mov ebx, offset pauseTitle
        call MsgBoxAsk
        cmp  answer,IDYES
        jne exitGame
        mov al, 'q'
        jmp gameloop

    exitGame:
        mov eax, 500
        call delay
        call displayGameOver
        ret

    levelUp:
        call level2
        ret

level1 ENDP

; -------------------------------------------------------------------- Level 2 ------------------------------------------------------------------------ ;

level2 PROC
    
     call clrscr
     mov eax, 1500
     call delay
     inc level

    ; --------------------- Draw Boundaries -------------------------- ;

    call DrawBoundaries

    ; -------------------------- Draw Basic maze ------------------------ ;
    
    call DrawBasicMaze3

    ; -------------------------- Draw Food ------------------------ ;
    
    call distributeFood3

    ; -------------------------- Draw Cherry ------------------------ ;
    
    call drawCherry

    ; --------------------- Draw the Player --------------------- ;

    mov xPos, 75
    mov yPos, 19

    call DrawPlayer

    ; --------------------- Draw the Ghost --------------------- ;

    mov xGhostPos, 71
    mov yGhostPos, 7
    inc numGhosts
    mov ghostsSpeed, 50
    call DrawGhost

    ; -------------------- The Sound ---------------------------- ;

    invoke PlaySound, offset intermission, null, 11h
    mov eax, 6000
    call delay

    mov ecx, numMazes

    gameLoop:
         
        ; ---------------- Player Cherry Collision ----------------- ;

        call checkPlayerCherryCollision

        ; ------------- Check lives ----------------;

        cmp lives, 0
        jle exitGame

        ; ------------ Level Up ------------------ ;

        cmp score, 200
        jge levelUp

        ; ---------- write player name ------------ ;

        mov eax, white (black * 16)
        call SetTextColor

        mov dl,2
        mov dh,3
        call Gotoxy
        mov edx,OFFSET playerName
        call WriteString

        ; ---------- Update the score ------------ ;

        mov eax,white (black * 16)
        call SetTextColor

        mov dl,2
        mov dh,5
        call Gotoxy
        mov edx,OFFSET strScore
        call WriteString

        mov eax,Green (black * 16)
        call SetTextColor

        mov ax,score
        call WriteInt

        ; ---------- Update the level ------------ ;

        mov eax,white (black * 16)
        call SetTextColor

        mov dl,2
        mov dh,6
        call Gotoxy
        mov edx,OFFSET levelStr
        call WriteString

        mov eax, magenta
        call SetTextColor

        mov al,level
        call WriteDec

        ; ---------- Update Lives ------------ ;

        mov eax,white (black * 16)
        call SetTextColor

        mov dl,2
        mov dh,27
        call Gotoxy
        mov edx,OFFSET livesRemaining
        call WriteString

        mov eax,Green (black * 16)
        call SetTextColor

        mov al,lives
        call WriteDec

        ; ------------ Check Player Ghost Collision ------------- ;

        call checkPlayerGhostCollision
        cmp al, 'y'
        je updateLives

        jmp onGround

        updateLives:
            invoke PlaySound, offset pacmanDeath, null, 0
            dec lives
            mov eax, 1000
            call delay
            mov xPos, 75
            mov yPos, 19
            call updatePlayer
            call drawPlayer

        onGround:

        ; ----------------------- Ghost Movement ----------------------------- ;

        Ghost:

            call Randomize
            mov eax, 200
            call RandomRange

            mov randomChar,al

            cmp randomChar, 50
            jbe moveGhostUp

            cmp randomChar, 100
            jbe moveGhostDown

            cmp randomChar, 150
            jbe moveGhostLeft

            cmp randomChar, 200
            jbe moveGhostRight

        moveGhostUp:

        call GhostUpwardsMovement

        jmp playerMovement

        moveGhostDown:

        call GhostDownwardsMovement

        jmp playerMovement

        moveGhostLeft:

        call GhostLeftMovement

        jmp playerMovement

        moveGhostRight:

        call GhostRightMovement

        jmp playerMovement

        ; -------------- get user key input ------------------ ;

        PlayerMovement:

            call ReadKey
            mov inputChar,al

            cmp inputChar,"x"
            je exitGame

            cmp inputChar,"p"
            je pauseScreen

            cmp inputChar,"w"
            je moveUp

            cmp inputChar,"s"
            je moveDown

            cmp inputChar,"a"
            je moveLeft

            cmp inputChar,"d"
            je moveRight

            jmp gameLoop

        ; --------------------- Player Movement ---------------------- ;

        moveUp:
       
            mov ebx, 0
            mov bl, xPos
            mov bh, yPos
            dec bh
            cmp walls[bx], 1
            je gameLoop

            mov ebx, 0
            mov bl, xPos
            mov bh, yPos
            cmp [foodCheck1+bx], 1
            je IncreaseScore1

            jmp NoIncrease1

            IncreaseScore1:
                ;invoke PlaySound, offset eatFruit, null, 0
                mov ebx, 0
                mov bl, xPos
                mov bh, yPos
                mov [foodCheck1+bx], 0
                inc score

            NoIncrease1:

            call UpdatePlayer
            mov al, yPos
            mov prevYPos, al
            mov al, xPos
            mov prevXPos, al
            dec yPos
            call DrawPlayer
            mov eax,70
            call Delay

        jmp gameLoop

        moveDown:

            mov ebx, 0
            mov bl, xPos
            mov bh, yPos
            inc bh
            cmp walls[bx], 1
            je gameLoop

            mov ebx, 0
            mov bl, xPos
            mov bh, yPos
            cmp [foodCheck1+bx], 1
            je IncreaseScore2

            jmp NoIncrease2
            IncreaseScore2:
                ;invoke PlaySound, offset eatFruit, null, 0
                mov ebx, 0
                mov bl, xPos
                mov bh, yPos
                mov [foodCheck1+bx], 0
                inc score
            NoIncrease2:

            call UpdatePlayer
            mov al, yPos
            mov prevYPos, al
            mov al, xPos
            mov prevXPos, al
            inc yPos
            call DrawPlayer
            jmp gameLoop

        moveLeft:

            mov ebx, 0
            mov bl, xPos
            mov bh, yPos
            dec bl
            cmp walls[bx], 1
            je gameLoop

            mov ebx, 0
            mov bl, xPos
            mov bh, yPos
            cmp [foodCheck1+bx], 1
            je IncreaseScore

            jmp NoIncrease
            IncreaseScore:
                ;invoke PlaySound, offset eatFruit, null, 0
                mov ebx, 0
                mov bl, xPos
                mov bh, yPos
                mov [foodCheck1+bx], 0
                inc score
            NoIncrease:

            call UpdatePlayer
            mov al, yPos
            mov prevYPos, al
            mov al, xPos
            mov prevXPos, al
            dec xPos
            call DrawPlayer
            jmp gameLoop

        moveRight:

            mov ebx, 0
            mov bl, xPos
            mov bh, yPos
            inc bl
            cmp walls[bx], 1
            je gameLoop

            mov ebx, 0
            mov bl, xPos
            mov bh, yPos
            cmp [foodCheck1+bx], 1
            je IncreaseScore4

            jmp NoIncrease4
            IncreaseScore4:
                ;invoke PlaySound, offset eatFruit, null, 0
                mov ebx, 0
                mov bl, xPos
                mov bh, yPos
                mov [foodCheck1+bx], 0
                inc score
            NoIncrease4:
            call UpdatePlayer
            mov al, yPos
            mov prevYPos, al
            mov al, xPos
            mov prevXPos, al
            inc xPos
            call DrawPlayer
            jmp gameLoop
    
    pauseScreen:
        mov edx, offset pauseMsg1
        mov ebx, offset pauseTitle
        call MsgBoxAsk
        cmp  answer,IDYES
        jne exitGame
        jmp gameloop

    exitGame:
        mov eax, 500
        call delay
        call displayGameOver
        ret

    levelUp:
        call level3
        ret

level2 ENDP


         ; ------------------------------------------------------ Draw the Player -----------------------------------------------------------------;

DrawPlayer PROC

    ; draw player at (xPos, yPos)
    mov eax, yellow ;(blue*16)
    call SetTextColor
    mov dl, xPos
    mov dh, yPos
    call Gotoxy
    mov al, 'X'
    call WriteChar
    ret

DrawPlayer ENDP

         ; ------------------------------------------------------ Update The Player -----------------------------------------------------------------;

UpdatePlayer PROC
    ; Clear the previous position of the player

    mov eax, black
    call setTextColor

    mov dl, xPos
    mov dh, yPos
    call Gotoxy
    mov al, " "
    call WriteChar
    ret
UpdatePlayer ENDP

         ; ------------------------------------------------------ Draw the Ghost -----------------------------------------------------------------;

DrawGhost PROC uses esi ecx
    
    mov eax, [GhostsColors + esi*4]
    mov bl, 16
    mul bl
    or eax, 7
    call SetTextColor
    mov dl, xGhostPos[esi]
    mov dh, yGhostPos[esi]
    call Gotoxy
    mov al, 248
    call WriteChar

    ret

DrawGhost ENDP

         ; ------------------------------------------------------ Update The Ghost -----------------------------------------------------------------;

UpdateGhost PROC uses esi ecx

    mov eax, black
    call setTextColor

    mov dl, xGhostPos[esi]
    mov dh, yGhostPos[esi]
    call Gotoxy
    mov al, " "
    call WriteChar

    ret
UpdateGhost ENDP

         ; ------------------------------------------------------ Update The Food -----------------------------------------------------------------;

updateFood proc uses esi ecx

        mov ebx, 0
        mov bl, xGhostPos[esi]
        mov bh, yGhostPos[esi]
        cmp [foodCheck1+bx], 0
        je noUpdate

        mov al, xGhostPos[esi]
        mov xFoodPos, al
        mov al, yGhostPos[esi]
        mov yFoodPos, al
        mov Hquantity, 1
        mov Vquantity, 1
        call drawFood

    noUpdate:
    ret

updateFood endp

         ; ------------------------------------------------------- Move Ghost Up ------------------------------------------------------------- ;

GhostUpwardsMovement proc 

        mov ecx, numGhosts
        mov esi, 0

        GhostLoop:

            cmp yGhostPos[esi], 2
            je noMovement

            mov bl, xGhostPos[esi]
            mov bh, yGhostPos[esi]
            dec bh

            cmp walls[bx], 1
            je noMovement

            call UpdateGhost

            call UpdateFood

            mov al, yGhostPos[esi]
            mov prevYGhostPos, al
            mov al, xGhostPos[esi]
            mov prevXGhostPos, al
            dec yGhostPos[esi]
            call DrawGhost
            mov eax, ghostsSpeed
            call Delay

            noMovement:
            inc esi

        loop GhostLoop
        ret

GhostUpwardsMovement endp

         ; ------------------------------------------------------- Move Ghost Down ------------------------------------------------------------- ;

GhostDownwardsMovement proc 

        mov ecx, numGhosts
        mov esi, 0
        GhostLoop:

            cmp yGhostPos[esi], 28
            je noMovement

            mov bl, xGhostPos[esi]
            mov bh, yGhostPos[esi]
            inc bh

            cmp walls[bx], 1
            je noMovement

            call UpdateGhost

            call UpdateFood

            mov al, yGhostPos[esi]
            mov prevYGhostPos, al
            mov al, xGhostPos[esi]
            mov prevXGhostPos, al
            inc yGhostPos[esi]
            call DrawGhost
            mov eax, ghostsSpeed
            call Delay

            noMovement:
            inc esi

        loop GhostLoop
        ret

GhostDownwardsMovement endp


         ; ------------------------------------------------------- Move Ghost Left ------------------------------------------------------------- ;

GhostLeftMovement proc uses esi

        mov ecx, numGhosts
        mov esi, 0
        GhostLoop:

            cmp xGhostPos[esi], 33
            je noMovement

            mov bl, xGhostPos[esi]
            mov bh, yGhostPos[esi]
            dec bl

            cmp walls[bx], 1
            je noMovement

            call UpdateGhost

            call UpdateFood

            mov al, yGhostPos[esi]
            mov prevYGhostPos, al
            mov al, xGhostPos[esi]
            mov prevXGhostPos, al
            dec xGhostPos[esi]
            call DrawGhost
            mov eax, ghostsSpeed
            call Delay

            noMovement:
            inc esi

        loop GhostLoop
        ret

GhostLeftMovement endp

         ; ------------------------------------------------------- Move Ghost Right ------------------------------------------------------------- ;

GhostRightMovement proc uses esi

        mov ecx, numGhosts
        mov esi, 0
        GhostLoop:

            cmp xGhostPos[esi], 116
            je noMovement

            mov bl, xGhostPos[esi]
            mov bh, yGhostPos[esi]
            inc bl

            cmp walls[bx], 1
            je noMovement

            call UpdateGhost

            call UpdateFood

            mov al, yGhostPos[esi]
            mov prevYGhostPos, al
            mov al, xGhostPos[esi]
            mov prevXGhostPos, al
            inc xGhostPos[esi]
            call DrawGhost
            mov eax, ghostsSpeed
            call Delay

            noMovement:
            inc esi

        loop GhostLoop
        ret

GhostRightMovement endp

         ; ------------------------------------------------------ Walls Collsion  -----------------------------------------------------------------;

CheckCollisionWithWalls PROC
    mov esi, 0  ; Start with the first box

CheckNextBox:
    ; Check collision with the current box
    mov al, array1[esi]
    mov bl, xPos
    inc bl
    cmp bl, al  
    jl NoCollisionWithCurrentBox 

    mov al, array1[esi]
    add al, array4[esi]
    mov bl, xPos
    dec bl
    cmp bl, al        
    jg NoCollisionWithCurrentBox 

    mov al, array2[esi]
    mov bl, yPos
    cmp bl, al  
    jg NoCollisionWithCurrentBox
    
    mov al, array2[esi]
    sub al, array3[esi]
    mov bl, yPos
    cmp bl, al        
    jl NoCollisionWithCurrentBox 

    ; Collision with the current box, return 'y'
    mov al, 'y'        
    ret

NoCollisionWithCurrentBox:
    ; Move to the next box
    inc esi
    cmp esi, numBoxes
    jl CheckNextBox

    ; No collision with any box, return 'n'
    mov al, 'n'        
    ret

CheckCollisionWithWalls ENDP

         ; ------------------------------------------------------ Ghost - Walls Collsion  -----------------------------------------------------------------;

CheckCollisionWithWalls2 PROC
    mov esi, 0  ; Start with the first box

CheckNextBox:
    ; Check collision with the current box
    mov al, array1[esi]
    mov bl, xGhostPos
    inc bl
    cmp bl, al  
    jl NoCollisionWithCurrentBox 

    mov al, array1[esi]
    add al, array4[esi]
    mov bl, xGhostPos
    dec bl
    cmp bl, al        
    jg NoCollisionWithCurrentBox 

    mov al, array2[esi]
    mov bl, yGhostPos
    dec bl
    cmp bl, al  
    jg NoCollisionWithCurrentBox
    
    mov al, array2[esi]
    sub al, array3[esi]
    mov bl, yGhostPos
    inc bl
    cmp bl, al        
    jl NoCollisionWithCurrentBox 

    ; Collision with the current box, return 'y'
    mov al, 'y'        
    ret

NoCollisionWithCurrentBox:
    ; Move to the next box
    inc esi
    cmp esi, numBoxes
    jl CheckNextBox

    ; No collision with any box, return 'n'
    mov al, 'n'        
    ret

CheckCollisionWithWalls2 ENDP

; ------------------------------------------------------- Player - Ghost Collision ---------------------------------------------------------------;

checkPlayerGhostCollision proc
        mov ecx, numGhosts
        mov esi, 0

        L1:
            mov al, xPos
            cmp al, xGhostPos[esi]
            jne noCollision

            mov al, yPos
            cmp al, yGhostPos[esi]
            jne noCollision

            mov al, 'y'
            ret

            noCollision:
            inc esi
        loop L1

        mov al, 'n'
        ret

checkPlayerGhostCollision endp

        ; ------------------------------------------------------ Draw Coin ------------------------------------------------------------------;

DrawCoin PROC
    mov eax,yellow 
    call SetTextColor
    mov dl,xCoinPos
    mov dh,yCoinPos
    call Gotoxy
    mov al,'.'
    call WriteChar
    ret
DrawCoin ENDP

CreateRandomCoin PROC
    mov eax, 55
    inc eax
    call RandomRange
    add eax, 34
    mov xCoinPos,al
    mov eax, 27
    inc eax
    call RandomRange
    mov yCoinPos, al
    ret
CreateRandomCoin ENDP

          ; ------------------------------------------------------ Draw the Walls -----------------------------------------------------------------;

DrawVerticalWall Proc

    ;---------- Print lower ground -----------;

    mov eax,blue 
    call SetTextColor
    mov dl, xMazePos
    mov dh, yMazePos
    mov ebx, 0
    mov bl, xMazePos
    mov bh, yMazePos
    call Gotoxy
    movzx ecx, boxWidth
    dec ecx

    mov eax, 200
    call WriteChar
    mov walls[bx], 1
    inc bl
    PrintMazeGround1:
        mov eax, 205
        call WriteChar
        mov walls[bx], 1
        inc bl
    loop PrintMazeGround1
    mov eax, 188
    call WriteChar
    mov walls[bx], 1
    inc bl

    ;---------- Print upper line -----------;

    mov dl, xMazePos
    mov dh, yMazePos
    sub dh, boxHeight                 ;height
    mov ebx, 0
    mov bl, dl
    mov bh, dh
    call Gotoxy
    movzx ecx, boxWidth
    dec ecx

    mov eax, 201
    call WriteChar
    mov walls[bx], 1
    inc bl
    PrintMazeGround2:
        mov eax, 205
        call WriteChar
        mov walls[bx], 1
        inc bl
    loop PrintMazeGround2
    mov eax, 187
    call WriteChar
    mov walls[bx], 1
    inc bl

    ;---------------- Wall 1 ----------------;

    movzx ecx, boxHeight
    dec ecx
    mov dh, yMazePos 
    sub dh, boxHeight                  ;height
    inc dh
    MazeWall1:
        mov dl, xMazePos
        mov ebx, 0
        mov bl, dl
        mov bh, dh
        mov walls[bx], 1
        call Gotoxy
        mov eax, 186
        call WriteChar
        inc dh
    loop MazeWall1

    ;---------------- Wall 2 ----------------;

    movzx ecx, boxHeight
    dec ecx
    mov dh, yMazePos
    sub dh, boxHeight                  ;height
    inc dh
    mov temp,dh
    mov dl, xMazePos
    add dl, boxWidth                 ;width
    MazeWall2:
        mov dh,temp
        mov ebx, 0
        mov bl, dl
        mov bh, dh
        mov walls[bx], 1
        call Gotoxy
        mov eax, 186
        call WriteChar
        inc temp
    loop MazeWall2
    ret

DrawVerticalWall endp

          ; ------------------------------------------------------ Disable Walls -----------------------------------------------------------------;

DisableWalls Proc

    ;---------- Print lower ground -----------;

    mov eax,blue 
    call SetTextColor
    mov dl, xMazePos
    mov dh, yMazePos
    mov ebx, 0
    mov bl, xMazePos
    mov bh, yMazePos
    call Gotoxy
    movzx ecx, boxWidth
    dec ecx

    mov eax, ' '
    call WriteChar
    mov walls[bx], 0
    inc bl
    PrintMazeGround1:
        mov eax, ' '
        call WriteChar
        mov walls[bx], 0
        inc bl
    loop PrintMazeGround1
    mov eax, ' '
    call WriteChar
    mov walls[bx], 0
    inc bl

    ;---------- Print upper line -----------;

    mov dl, xMazePos
    mov dh, yMazePos
    sub dh, boxHeight                 ;height
    mov ebx, 0
    mov bl, dl
    mov bh, dh
    call Gotoxy
    movzx ecx, boxWidth
    dec ecx

    mov eax, ' '
    call WriteChar
    mov walls[bx], 0
    inc bl
    PrintMazeGround2:
        mov eax, ' '
        call WriteChar
        mov walls[bx], 0
        inc bl
    loop PrintMazeGround2
    mov eax, ' '
    call WriteChar
    mov walls[bx], 0
    inc bl

    ;---------------- Wall 1 ----------------;

    movzx ecx, boxHeight
    dec ecx
    mov dh, yMazePos 
    sub dh, boxHeight                  ;height
    inc dh
    MazeWall1:
        mov dl, xMazePos
        mov ebx, 0
        mov bl, dl
        mov bh, dh
        mov walls[bx], 0
        call Gotoxy
        mov eax, ' '
        call WriteChar
        inc dh
    loop MazeWall1

    ;---------------- Wall 2 ----------------;

    movzx ecx, boxHeight
    dec ecx
    mov dh, yMazePos
    sub dh, boxHeight                  ;height
    inc dh
    mov temp,dh
    mov dl, xMazePos
    add dl, boxWidth                 ;width
    MazeWall2:
        mov dh,temp
        mov ebx, 0
        mov bl, dl
        mov bh, dh
        mov walls[bx], 0
        call Gotoxy
        mov eax, ' '
        call WriteChar
        inc temp
    loop MazeWall2
    ret

DisableWalls endp

          ; ------------------------------------------------------ Draw the Boundaries -----------------------------------------------------------------;

DrawBoundaries proc

    ;---------- Print lower ground -----------;

    mov eax,blue 
    call SetTextColor
    mov dl,32
    mov dh,29
    mov ebx, 0
    mov bl, dl
    mov bh, dh
    call Gotoxy
    mov ecx, 84

    mov eax, 200
    call WriteChar
    mov walls[bx], 1
    inc bl
    PrintGround1:
        mov eax, 205
        call WriteChar
        mov walls[bx], 1
        inc bl
    loop PrintGround1
    mov eax, 188
    call WriteChar
    mov walls[bx], 1
    inc bl

    ;---------- Print upper line -----------;

    mov dl,32
    mov dh,1
    mov ebx, 0
    mov bl, dl
    mov bh, dh
    call Gotoxy
    mov ecx, 84

    mov eax, 201
    call WriteChar
    mov walls[bx], 1
    inc bl

    PrintGround2:
        mov eax, 205
        call WriteChar
        mov walls[bx], 1
        inc bl
    loop PrintGround2
    mov eax, 187
    call WriteChar
    mov walls[bx], 1
    inc bl

    ;---------------- Wall 1 ----------------;

    mov ecx,27
    mov dh,2
    wall1:
        mov dl, 32
        mov ebx, 0
        mov bl, dl
        mov bh, dh
        call Gotoxy
        mov eax, 186
        call WriteChar
        mov walls[bx], 1
        inc bl
        inc dh
    loop wall1

    ;---------------- Wall 2 ----------------;

    mov ecx,27
    mov dh,2
    mov temp,dh
    wall2:
        mov dh,temp
        mov dl,117
        mov ebx, 0
        mov bl, dl
        mov bh, dh
        call Gotoxy
        mov eax, 186
        call WriteChar
        mov walls[bx], 1
        inc bl
        inc temp
    loop wall2

    ;------------- Division ---------------;

    ;---------- Print lower ground -----------;

    mov eax,blue 
    call SetTextColor
    mov dl,0
    mov dh,29
    call Gotoxy
    mov ecx, 28

    mov eax, 200
    call WriteChar
    PrintGround3:
        mov eax, 205
        call WriteChar
    loop PrintGround3
    mov eax, 188
    call WriteChar

    ;---------- Print upper line -----------;

    mov dl,0
    mov dh,1
    call Gotoxy
    mov ecx, 28

    mov eax, 201
    call WriteChar
    PrintGround4:
        mov eax, 205
        call WriteChar
    loop PrintGround4
    mov eax, 187
    call WriteChar

    ;---------------- Wall 1 ----------------;

    mov ecx,27
    mov dh,2
    wall3:
        mov dl,0
        call Gotoxy
        mov eax, 186
        call WriteChar
        inc dh
    loop wall3

    ;---------------- Wall 2 ----------------;

    mov ecx,27
    mov dh,2
    mov temp,dh
    wall4:
        mov dh,temp
        mov dl, 29
        call Gotoxy
        mov eax, 186
        call WriteChar
        inc temp
    loop wall4
    ret

DrawBoundaries endp

      ; ------------------------------------------------------ Player Boundary Collision -----------------------------------------------------------------;

CheckCollisionWithBoundaries PROC

    ; Check if the next move is out of bounds (hits the wall)
    mov al, yPos
    mov bl, xPos
    cmp al, 2 ; Check top boundary
    jl CollisionDetected
    cmp al, 28 ; Check bottom boundary
    jg CollisionDetected
    cmp bl, 34 ; Check left boundary
    jl CollisionDetected
    cmp bl, 115 ; Check right boundary
    jg CollisionDetected

    ; No collision
    mov al, 'n'
    ret

    ; Collision detected
    CollisionDetected:
    mov al, 'y'
    ret

CheckCollisionWithBoundaries ENDP

        ; ------------------------------------------------------ Draw the Maze Layout -----------------------------------------------------------------;

DrawBasicMaze proc

    mov ecx, 30000
    mov esi, 0
    L1:
        mov walls[esi], 0
        inc esi
    loop L1
    
    mov esi, 0

    ; -------- middle wala box --------- ;

    mov xMazePos, 61
    mov array1[esi], 61

    mov yMazePos, 18
    mov array2[esi], 18

    mov boxHeight, 6
    mov array3[esi], 6

    mov boxWidth, 27
    mov array4[esi], 27

    call updateGrid

    call drawVerticalWall

    ; --------- Line 1 : boxes (5) --------- ;
    inc esi

    mov xMazePos, 37
    mov array1[esi], 37

    mov yMazePos, 6
    mov array2[esi], 6

    mov boxHeight, 3
    mov array3[esi], 3

    mov boxWidth, 10
    mov array4[esi], 10

    call updateGrid

    call drawVerticalWall
    inc esi

    mov xMazePos, 52
    mov array1[esi], 52

    mov yMazePos, 6
    mov array2[esi], 6

    mov boxHeight, 3
    mov array3[esi], 3

    mov boxWidth, 15
    mov array4[esi], 15

    call updateGrid

    call drawVerticalWall
    inc esi

    mov xMazePos, 72
    mov array1[esi], 72

    mov yMazePos, 6
    mov array2[esi], 6

    mov boxHeight, 5
    mov array3[esi], 5

    mov boxWidth, 5
    mov array4[esi], 5

    call updateGrid

    call drawVerticalWall
    inc esi

    mov xMazePos, 82
    mov array1[esi], 82

    mov yMazePos, 6
    mov array2[esi], 6

    mov boxHeight, 3
    mov array3[esi], 3

    mov boxWidth, 15
    mov array4[esi], 15

    call updateGrid

    call drawVerticalWall
    inc esi

    mov xMazePos, 102
    mov array1[esi], 102

    mov yMazePos, 6
    mov array2[esi], 6

    mov boxHeight, 3
    mov array3[esi], 3

    mov boxWidth, 10
    mov array4[esi], 10

    call updateGrid

    call drawVerticalWall
    inc esi

   ; --------- Line 2 : boxes (5) --------- ;

    mov xMazePos, 37
    mov array1[esi], 37

    mov yMazePos, 10
    mov array2[esi], 10

    mov boxHeight, 2
    mov array3[esi], 2

    mov boxWidth, 10
    mov array4[esi], 10

    call updateGrid

    call drawVerticalWall
    inc esi

    mov xMazePos, 52
    mov array1[esi], 52

    mov yMazePos, 15
    mov array2[esi], 15

    mov boxHeight, 7
    mov array3[esi], 7

    mov boxWidth, 4
    mov array4[esi], 4

    call updateGrid

    call drawVerticalWall
    inc esi

    mov xMazePos, 61
    mov array1[esi], 61

    mov yMazePos, 10
    mov array2[esi], 10

    mov boxHeight, 2
    mov array3[esi], 2

    mov boxWidth, 27
    mov array4[esi], 27

    call updateGrid

    call drawVerticalWall
    inc esi

    mov xMazePos, 93
    mov array1[esi], 93

    mov yMazePos, 15
    mov array2[esi], 15

    mov boxHeight, 7
    mov array3[esi], 7

    mov boxWidth, 4
    mov array4[esi], 4

    call updateGrid

    call drawVerticalWall
    inc esi

    mov xMazePos, 102
    mov array1[esi], 102

    mov yMazePos, 10
    mov array2[esi], 10

    mov boxHeight, 2
    mov array3[esi], 2

    mov boxWidth, 10
    mov array4[esi], 10

    call updateGrid

    call drawVerticalWall
    inc esi

   ; --------- Line 3 : boxes (3) --------- ;

    mov xMazePos, 52
    mov array1[esi], 52

    mov yMazePos, 22
    mov array2[esi], 22

    mov boxHeight, 5
    mov array3[esi], 5

    mov boxWidth, 4
    mov array4[esi], 4

    call updateGrid

    call drawVerticalWall
    inc esi

    mov xMazePos, 61
    mov array1[esi], 61

    mov yMazePos, 22
    mov array2[esi], 22

    mov boxHeight, 2
    mov array3[esi], 2

    mov boxWidth, 27
    mov array4[esi], 27

    call updateGrid

    call drawVerticalWall
    inc esi

    mov xMazePos, 93
    mov array1[esi], 93

    mov yMazePos, 22
    mov array2[esi], 22

    mov boxHeight, 5
    mov array3[esi], 5

    mov boxWidth, 4
    mov array4[esi], 4

    call updateGrid

    call drawVerticalWall
    inc esi

   ; --------- Line 4 : boxes (5) --------- ;

    mov xMazePos, 37
    mov array1[esi], 37

    mov yMazePos, 27
    mov array2[esi], 27

    mov boxHeight, 5
    mov array3[esi], 5

    mov boxWidth, 10
    mov array4[esi], 10

    call updateGrid

    call drawVerticalWall
    inc esi

    mov xMazePos, 52
    mov array1[esi], 52

    mov yMazePos, 27
    mov array2[esi], 27

    mov boxHeight, 3
    mov array3[esi], 3

    mov boxWidth, 16
    mov array4[esi], 16

    call updateGrid

    call drawVerticalWall
    inc esi

    mov xMazePos, 72
    mov array1[esi], 72

    mov yMazePos, 29
    mov array2[esi], 29

    mov boxHeight, 5
    mov array3[esi], 5

    mov boxWidth, 5
    mov array4[esi], 5

    call updateGrid

    call drawVerticalWall
    inc esi

    mov xMazePos, 81
    mov array1[esi], 81

    mov yMazePos, 27
    mov array2[esi], 27

    mov boxHeight, 3
    mov array3[esi], 3

    mov boxWidth, 16
    mov array4[esi], 16

    call updateGrid

    call drawVerticalWall
    inc esi

    mov xMazePos, 102
    mov array1[esi], 102

    mov yMazePos, 27
    mov array2[esi], 27

    mov boxHeight, 5
    mov array3[esi], 5

    mov boxWidth, 10
    mov array4[esi], 10

    call updateGrid

    call drawVerticalWall
    inc esi

    ; -------- Side boxes (2) --------- ;

    mov xMazePos, 34
    mov array1[esi], 34

    mov yMazePos, 20
    mov array2[esi], 20

    mov boxHeight, 8
    mov array3[esi], 8

    mov boxWidth, 13
    mov array4[esi], 13

    call updateGrid

    call drawVerticalWall
    inc esi

    mov xMazePos, 102
    mov array1[esi], 102

    mov yMazePos, 20
    mov array2[esi], 20

    mov boxHeight, 8
    mov array3[esi], 8

    mov boxWidth, 13
    mov array4[esi], 13

    call updateGrid

    call drawVerticalWall
    inc esi

    ret
DrawBasicMaze endp

; ------------------------------------------------------------------ Grid ------------------------------------------------------------------------------- ;

updateGrid proc
    
    movzx ecx, boxHeight
    mov ebx, 0
    mov bl, xMazePos
    mov bh, yMazePos

    L1:
        mov walls[bx], 1
        dec bh
    loop L1

    movzx ecx, boxWidth
    mov ebx, 0
    mov bl, xMazePos
    mov bh, yMazePos

    L2:
        mov walls[bx], 1
        inc bl
    loop L2

    movzx ecx, boxHeight
    mov ebx, 0
    mov bl, xMazePos
    add bl, boxWidth
    mov bh, yMazePos

    L3:
        mov walls[bx], 1
        dec bh
    loop L3

    movzx ecx, boxWidth
    mov ebx, 0
    mov bl, xMazePos
    mov bh, yMazePos
    add bh, boxWidth

    L4:
        mov walls[bx], 1
        inc bl
    loop L4

    ret
updateGrid endp

        ; ------------------------------------------------------ Draw the Maze Layout (2) -----------------------------------------------------------------;

DrawBasicMaze2 proc

    mov esi, 0

    ; -------- middle wala box --------- ;

    mov xMazePos, 63
    mov array1[esi], 63

    mov yMazePos, 18
    mov array2[esi], 18

    mov boxHeight, 6
    mov array3[esi], 6

    mov boxWidth, 23
    mov array4[esi], 23
    
    call drawVerticalWall

    ; --------- Line 1 : boxes (3) --------- ;

    inc esi

    mov xMazePos, 43
    mov array1[esi], 43

    mov yMazePos, 6
    mov array2[esi], 6

    mov boxHeight, 3
    mov array3[esi], 3

    mov boxWidth, 18
    mov array4[esi], 18

    call drawVerticalWall
    inc esi

    mov xMazePos, 72
    mov array1[esi], 72

    mov yMazePos, 6
    mov array2[esi], 6

    mov boxHeight, 5
    mov array3[esi], 5

    mov boxWidth, 5
    mov array4[esi], 5

    call drawVerticalWall
    inc esi

    mov xMazePos, 88
    mov array1[esi], 88

    mov yMazePos, 6
    mov array2[esi], 6

    mov boxHeight, 3
    mov array3[esi], 3

    mov boxWidth, 18
    mov array4[esi], 18

    call drawVerticalWall
    inc esi

   ; --------- Line 4 : boxes (3) --------- ;

    mov xMazePos, 43
    mov array1[esi], 43

    mov yMazePos, 27
    mov array2[esi], 27

    mov boxHeight, 3
    mov array3[esi], 3

    mov boxWidth, 18
    mov array4[esi], 18

    call drawVerticalWall
    inc esi

    mov xMazePos, 72
    mov array1[esi], 72

    mov yMazePos, 29
    mov array2[esi], 29

    mov boxHeight, 5
    mov array3[esi], 5

    mov boxWidth, 5
    mov array4[esi], 5

    call drawVerticalWall
    inc esi

    mov xMazePos, 88
    mov array1[esi], 88

    mov yMazePos, 27
    mov array2[esi], 27

    mov boxHeight, 3
    mov array3[esi], 3

    mov boxWidth, 18
    mov array4[esi], 18

    call drawVerticalWall
    inc esi

    ; -------- Side boxes (2) --------- ;

    mov xMazePos, 39
    mov array1[esi], 39

    mov yMazePos, 18
    mov array2[esi], 18

    mov boxHeight, 6
    mov array3[esi], 6

    mov boxWidth, 11
    mov array4[esi], 11

    call drawVerticalWall
    inc esi

    mov xMazePos, 99
    mov array1[esi], 99

    mov yMazePos, 18
    mov array2[esi], 18

    mov boxHeight, 6
    mov array3[esi], 6

    mov boxWidth, 11
    mov array4[esi], 11

    call drawVerticalWall
    inc esi

    ret
DrawBasicMaze2 endp

        ; ------------------------------------------------------ Draw the Maze Layout (3) -----------------------------------------------------------------;

DrawBasicMaze3 proc

    mov ecx, 30000
    mov esi, 0
    L1:
        mov walls[esi], 0
        inc esi
    loop L1
    
    mov esi, 0

    ; -------- middle wala box --------- ;

    mov xMazePos, 61
    mov array1[esi], 61

    mov yMazePos, 19
    mov array2[esi], 19

    mov boxHeight, 5
    mov array3[esi], 5

    mov boxWidth, 27
    mov array4[esi], 27

    call drawVerticalWall

    mov xMazePos, 68

    mov yMazePos, 19

    mov boxHeight, 5

    mov boxWidth, 13

    call DisableWalls

    ; --------- Line 1 : boxes (5) --------- ;
    inc esi

    mov xMazePos, 37
    mov array1[esi], 37

    mov yMazePos, 6
    mov array2[esi], 6

    mov boxHeight, 3
    mov array3[esi], 3

    mov boxWidth, 10
    mov array4[esi], 10

    call drawVerticalWall
    inc esi

    mov xMazePos, 40

    mov yMazePos, 6

    mov boxHeight, 3

    mov boxWidth, 4

    call DisableWalls

    mov xMazePos, 52
    mov array1[esi], 52

    mov yMazePos, 6
    mov array2[esi], 6

    mov boxHeight, 3
    mov array3[esi], 3

    mov boxWidth, 15
    mov array4[esi], 15

    call drawVerticalWall

    mov xMazePos, 56

    mov yMazePos, 6

    mov boxHeight, 3

    mov boxWidth, 7

    call DisableWalls

    mov xMazePos, 82
    mov array1[esi], 82

    mov yMazePos, 6
    mov array2[esi], 6

    mov boxHeight, 3
    mov array3[esi], 3

    mov boxWidth, 15
    mov array4[esi], 15

    call drawVerticalWall
    inc esi

    mov xMazePos, 86

    mov yMazePos, 6

    mov boxHeight, 3

    mov boxWidth, 7

    call DisableWalls

    mov xMazePos, 102
    mov array1[esi], 102

    mov yMazePos, 6
    mov array2[esi], 6

    mov boxHeight, 3
    mov array3[esi], 3

    mov boxWidth, 10
    mov array4[esi], 10

    call drawVerticalWall
    inc esi

    mov xMazePos, 105

    mov yMazePos, 6

    mov boxHeight, 3

    mov boxWidth, 4

    call DisableWalls

   ; --------- Line 2 : boxes (5) --------- ;

    mov xMazePos, 37
    mov array1[esi], 37

    mov yMazePos, 11
    mov array2[esi], 11

    mov boxHeight, 2
    mov array3[esi], 2

    mov boxWidth, 10
    mov array4[esi], 10

    call drawVerticalWall
    inc esi

    mov xMazePos, 40

    mov yMazePos, 11

    mov boxHeight, 2

    mov boxWidth, 4

    call DisableWalls

    mov xMazePos, 61
    mov array1[esi], 61

    mov yMazePos, 11
    mov array2[esi], 11

    mov boxHeight, 2
    mov array3[esi], 2

    mov boxWidth, 27
    mov array4[esi], 27

    call drawVerticalWall
    inc esi

    mov xMazePos, 68

    mov yMazePos, 11

    mov boxHeight, 2

    mov boxWidth, 13

    call DisableWalls

    mov xMazePos, 102
    mov array1[esi], 102

    mov yMazePos, 11
    mov array2[esi], 11

    mov boxHeight, 2
    mov array3[esi], 2

    mov boxWidth, 10
    mov array4[esi], 10

    call drawVerticalWall
    inc esi

    mov xMazePos, 105

    mov yMazePos, 11

    mov boxHeight, 2

    mov boxWidth, 4

    call DisableWalls

   ; --------- Line 4 : boxes (5) --------- ;

    mov xMazePos, 37
    mov array1[esi], 37

    mov yMazePos, 27
    mov array2[esi], 27

    mov boxHeight, 5
    mov array3[esi], 5

    mov boxWidth, 10
    mov array4[esi], 10

    call drawVerticalWall
    inc esi

    mov xMazePos, 40

    mov yMazePos, 27

    mov boxHeight, 5

    mov boxWidth, 4

    call DisableWalls

    mov xMazePos, 54
    mov array1[esi], 54

    mov yMazePos, 26
    mov array2[esi], 26

    mov boxHeight, 3
    mov array3[esi], 3

    mov boxWidth, 16
    mov array4[esi], 16

    call updateGrid

    call drawVerticalWall
    inc esi

    mov xMazePos, 59

    mov yMazePos, 26

    mov boxHeight, 3

    mov boxWidth, 6

    call DisableWalls

    mov xMazePos, 79
    mov array1[esi], 79

    mov yMazePos, 26
    mov array2[esi], 26

    mov boxHeight, 3
    mov array3[esi], 3

    mov boxWidth, 16
    mov array4[esi], 16

    call drawVerticalWall
    inc esi

    mov xMazePos, 84

    mov yMazePos, 26

    mov boxHeight, 3

    mov boxWidth, 6

    call DisableWalls

    mov xMazePos, 102
    mov array1[esi], 102

    mov yMazePos, 27
    mov array2[esi], 27

    mov boxHeight, 5
    mov array3[esi], 5

    mov boxWidth, 10
    mov array4[esi], 10

    call drawVerticalWall
    inc esi

    mov xMazePos, 105

    mov yMazePos, 27

    mov boxHeight, 5

    mov boxWidth, 4

    call DisableWalls

    ; -------- Side boxes (2) --------- ;

    mov xMazePos, 36
    mov array1[esi], 36

    mov yMazePos, 19
    mov array2[esi], 19

    mov boxHeight, 5
    mov array3[esi], 5

    mov boxWidth, 13
    mov array4[esi], 13

    call drawVerticalWall
    inc esi

    mov xMazePos, 40

    mov yMazePos, 19

    mov boxHeight, 5

    mov boxWidth, 5

    call DisableWalls

    mov xMazePos, 100
    mov array1[esi], 100

    mov yMazePos, 19
    mov array2[esi], 19

    mov boxHeight, 5
    mov array3[esi], 5

    mov boxWidth, 13
    mov array4[esi], 13

    call drawVerticalWall
    inc esi

    mov xMazePos, 104

    mov yMazePos, 19

    mov boxHeight, 5

    mov boxWidth, 5

    call DisableWalls

    ret
DrawBasicMaze3 endp

          ; ------------------------------------------------------ Draw the Food -----------------------------------------------------------------;

distributeFood proc

   mov ecx, 30000
   L1:
        mov foodcheck1[ecx], 0
   loop L1
   
    mov esi, 0
    ; --------------------- Starting from y = 2 (6) ------------------------- ;

    mov xFoodPos, 34
    mov foodArray1[esi], 34

    mov yFoodPos, 2
    mov foodArray2[esi], 2

    mov Vquantity, 10
    mov foodArray3[esi], 10

    mov Hquantity, 18
    mov foodArray4[esi], 18

    call DrawFood
    inc esi

    mov xFoodPos, 50
    mov foodArray1[esi], 50

    mov yFoodPos, 3
    mov foodArray2[esi], 3

    mov Vquantity, 26
    mov foodArray3[esi], 26

    mov Hquantity, 1
    mov foodArray4[esi], 1

    call DrawFood
    inc esi

    mov xFoodPos, 70
    mov foodArray1[esi], 70

    mov yFoodPos, 2
    mov foodArray2[esi], 2

    mov Vquantity, 6
    mov foodArray3[esi], 6

    mov Hquantity, 1
    mov foodArray4[esi], 1

    call DrawFood
    inc esi

    mov xFoodPos, 79
    mov foodArray1[esi], 79

    mov yFoodPos, 2
    mov foodArray2[esi], 2

    mov Vquantity, 6
    mov foodArray3[esi], 6

    mov Hquantity, 18
    mov foodArray4[esi], 18

    call DrawFood
    inc esi

    mov xFoodPos, 100
    mov foodArray1[esi], 100

    mov yFoodPos, 3
    mov foodArray2[esi], 3

    mov Vquantity, 26
    mov foodArray3[esi], 26

    mov Hquantity, 1
    mov foodArray4[esi], 1

    call DrawFood
    inc esi

    mov xFoodPos, 115
    mov foodArray1[esi], 115

    mov yFoodPos, 2
    mov foodArray2[esi], 2

    mov Vquantity, 10
    mov foodArray3[esi], 10

    mov Hquantity, 1
    mov foodArray4[esi], 1

    call DrawFood
    inc esi


    ; --------------------- Starting from y = 7 (2) ------------------------- ;

    mov xFoodPos, 58
    mov foodArray1[esi], 58

    mov yFoodPos, 8
    mov foodArray2[esi], 8

    mov Vquantity, 16
    mov foodArray3[esi], 16

    mov Hquantity, 1
    mov foodArray4[esi], 1

    call DrawFood
    inc esi

    mov xFoodPos, 91
    mov foodArray1[esi], 91

    mov yFoodPos, 8
    mov foodArray2[esi], 8

    mov Vquantity, 16
    mov foodArray3[esi], 16

    mov Hquantity, 1
    mov foodArray4[esi], 1

    call DrawFood
    inc esi

    ; --------------------- Starting from y = 21 (2) ------------------------- ;

    mov xFoodPos, 34
    mov foodArray1[esi], 34

    mov yFoodPos, 21
    mov foodArray2[esi], 21

    mov Vquantity, 8
    mov foodArray3[esi], 8

    mov Hquantity, 8
    mov foodArray4[esi], 8

    call DrawFood
    inc esi

    mov xFoodPos, 115
    mov foodArray1[esi], 115

    mov yFoodPos, 21
    mov foodArray2[esi], 21

    mov Vquantity, 8
    mov foodArray3[esi], 8

    mov Hquantity, 1
    mov foodArray4[esi], 1

    call DrawFood
    inc esi

    ; --------------------- Starting from y = 23 (2) ------------------------- ;

    mov xFoodPos, 70
    mov foodArray1[esi], 70

    mov yFoodPos, 23
    mov foodArray2[esi], 23

    mov Vquantity, 6
    mov foodArray3[esi], 6

    mov Hquantity, 1
    mov foodArray4[esi], 1

    call DrawFood
    inc esi

    mov xFoodPos, 79
    mov foodArray1[esi], 79

    mov yFoodPos, 23
    mov foodArray2[esi], 23

    mov Vquantity, 6
    mov foodArray3[esi], 6

    mov Hquantity, 11
    mov foodArray4[esi], 11

    call DrawFood
    inc esi

    ; --------------- Vertical Food ------------------ ;

    mov xFoodPos, 34
    mov foodArray1[esi], 34

    mov yFoodPos, 7
    mov foodArray2[esi], 7

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 41
    mov foodArray4[esi], 41

    call DrawFood
    inc esi

    mov xFoodPos, 100
    mov foodArray1[esi], 100

    mov yFoodPos, 21
    mov foodArray2[esi], 21

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 8
    mov foodArray4[esi], 8

    call DrawFood
    inc esi

    mov xFoodPos, 50
    mov foodArray1[esi], 50

    mov yFoodPos, 23
    mov foodArray2[esi], 23

    mov Vquantity, 6
    mov foodArray3[esi], 6

    mov Hquantity, 15
    mov foodArray4[esi], 15

    call DrawFood
    inc esi

    mov xFoodPos, 34
    mov foodArray1[esi], 34

    mov yFoodPos, 28
    mov foodArray2[esi], 28

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 18
    mov foodArray4[esi], 18

    call DrawFood
    inc esi

    mov xFoodPos, 79
    mov foodArray1[esi], 79

    mov yFoodPos, 28
    mov foodArray2[esi], 28

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 18
    mov foodArray4[esi], 18

    call DrawFood
    inc esi

    mov xFoodPos, 34
    mov foodArray1[esi], 34

    mov yFoodPos, 11
    mov foodArray2[esi], 11

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 8
    mov foodArray4[esi], 8

    call DrawFood
    inc esi

    mov xFoodPos, 58
    mov foodArray1[esi], 58

    mov yFoodPos, 11
    mov foodArray2[esi], 11

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 17
    mov foodArray4[esi], 17

    call DrawFood
    inc esi

    mov xFoodPos, 100
    mov foodArray1[esi], 100

    mov yFoodPos, 11
    mov foodArray2[esi], 11

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 8
    mov foodArray4[esi], 8

    call DrawFood
    inc esi

    mov xFoodPos, 58
    mov foodArray1[esi], 58

    mov yFoodPos, 19
    mov foodArray2[esi], 19

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 17
    mov foodArray4[esi], 17

    call DrawFood
    inc esi

    mov numBoxes, esi

    ret
distributeFood endp

    ; -------------------------------------------------------- Draw Food (2) --------------------------------------------------------------------------;

distributeFood2 proc 

    mov esi, 0

    ; --------------------- Starting from y = 2 (6) ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 2
    mov foodArray2[esi], 2

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 18
    mov foodArray4[esi], 18

    call DrawFood2
    inc esi

    mov xFoodPos, 62
    mov foodArray1[esi], 62

    mov yFoodPos, 2
    mov foodArray2[esi], 2

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 5
    mov foodArray4[esi], 5

    call DrawFood2
    inc esi

    mov xFoodPos, 78
    mov foodArray1[esi], 78

    mov yFoodPos, 2
    mov foodArray2[esi], 2

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 19
    mov foodArray4[esi], 19

    call DrawFood2
    inc esi

    mov xFoodPos, 107
    mov foodArray1[esi], 107

    mov yFoodPos, 2
    mov foodArray2[esi], 2

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 5
    mov foodArray4[esi], 5

    ; --------------------- Starting from y = 3 (2) ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 3
    mov foodArray2[esi], 3

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 5
    mov foodArray4[esi], 5

    call DrawFood2
    inc esi

    mov xFoodPos, 62
    mov foodArray1[esi], 62

    mov yFoodPos, 3
    mov foodArray2[esi], 3

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 5
    mov foodArray4[esi], 5

    call DrawFood2
    inc esi

    mov xFoodPos, 78
    mov foodArray1[esi], 78

    mov yFoodPos, 3
    mov foodArray2[esi], 3

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 5
    mov foodArray4[esi], 5

    call DrawFood2
    inc esi

    mov xFoodPos, 107
    mov foodArray1[esi], 107

    mov yFoodPos, 3
    mov foodArray2[esi], 3

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 5
    mov foodArray4[esi], 5

    call DrawFood2
    inc esi

    ; --------------------- Starting from y = 4 (2) ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 4
    mov foodArray2[esi], 4

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 5
    mov foodArray4[esi], 5

    call DrawFood2
    inc esi

    mov xFoodPos, 62
    mov foodArray1[esi], 62

    mov yFoodPos, 4
    mov foodArray2[esi], 4

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 5
    mov foodArray4[esi], 5

    call DrawFood2
    inc esi

    mov xFoodPos, 78
    mov foodArray1[esi], 78

    mov yFoodPos, 4
    mov foodArray2[esi], 4

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 5
    mov foodArray4[esi], 5

    call DrawFood2
    inc esi

    mov xFoodPos, 107
    mov foodArray1[esi], 107

    mov yFoodPos, 4
    mov foodArray2[esi], 4

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 5
    mov foodArray4[esi], 5

    call DrawFood2
    inc esi

    ; --------------------- Starting from y = 5 (2) ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 5
    mov foodArray2[esi], 5

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 5
    mov foodArray4[esi], 5

    call DrawFood2
    inc esi

    mov xFoodPos, 62
    mov foodArray1[esi], 62

    mov yFoodPos, 5
    mov foodArray2[esi], 5

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 5
    mov foodArray4[esi], 5

    call DrawFood2
    inc esi

    mov xFoodPos, 78
    mov foodArray1[esi], 78

    mov yFoodPos, 5
    mov foodArray2[esi], 5

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 5
    mov foodArray4[esi], 5

    call DrawFood2
    inc esi

    mov xFoodPos, 107
    mov foodArray1[esi], 107

    mov yFoodPos, 5
    mov foodArray2[esi], 5

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 5
    mov foodArray4[esi], 5

    call DrawFood2
    inc esi

    ; --------------------- Starting from y = 6 (2) ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 6
    mov foodArray2[esi], 6

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 5
    mov foodArray4[esi], 5

    call DrawFood2
    inc esi

    mov xFoodPos, 62
    mov foodArray1[esi], 62

    mov yFoodPos, 6
    mov foodArray2[esi], 6

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 5
    mov foodArray4[esi], 5

    call DrawFood2
    inc esi

    mov xFoodPos, 78
    mov foodArray1[esi], 78

    mov yFoodPos, 6
    mov foodArray2[esi], 6

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 5
    mov foodArray4[esi], 5

    call DrawFood2
    inc esi

    mov xFoodPos, 107
    mov foodArray1[esi], 107

    mov yFoodPos, 6
    mov foodArray2[esi], 6

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 5
    mov foodArray4[esi], 5

    call DrawFood2
    inc esi

    ; ----------------------- y = 7 ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 7
    mov foodArray2[esi], 7

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 42
    mov foodArray4[esi], 42

    call DrawFood2
    inc esi

    ; ----------------------- y = 8 ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 8
    mov foodArray2[esi], 8

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 42
    mov foodArray4[esi], 42

    call DrawFood2
    inc esi

    ; ----------------------- y = 9 ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 9
    mov foodArray2[esi], 9

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 42
    mov foodArray4[esi], 42

    call DrawFood2
    inc esi

    ; ----------------------- y = 10 ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 10
    mov foodArray2[esi], 10

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 42
    mov foodArray4[esi], 42

    call DrawFood2
    inc esi

    ; ----------------------- y = 11 ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 11
    mov foodArray2[esi], 11

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 42
    mov foodArray4[esi], 42

    call DrawFood2
    inc esi

   ; ----------------------- y = 12 ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 12
    mov foodArray2[esi], 12

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 3
    mov foodArray4[esi], 3

    call DrawFood2
    inc esi

    mov xFoodPos, 51
    mov foodArray1[esi], 51

    mov yFoodPos, 12
    mov foodArray2[esi], 12

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 6
    mov foodArray4[esi], 6

    call DrawFood2
    inc esi

    mov xFoodPos, 87
    mov foodArray1[esi], 87

    mov yFoodPos, 12
    mov foodArray2[esi], 12

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 6
    mov foodArray4[esi], 6

    call DrawFood2
    inc esi

    mov xFoodPos, 111
    mov foodArray1[esi], 111

    mov yFoodPos, 12
    mov foodArray2[esi], 12

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 3
    mov foodArray4[esi], 3

    call DrawFood2
    inc esi

   ; ----------------------- y = 13 ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 13
    mov foodArray2[esi], 13

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 3
    mov foodArray4[esi], 3

    call DrawFood2
    inc esi

    mov xFoodPos, 51
    mov foodArray1[esi], 51

    mov yFoodPos, 13
    mov foodArray2[esi], 13

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 6
    mov foodArray4[esi], 6

    call DrawFood2
    inc esi

    mov xFoodPos, 87
    mov foodArray1[esi], 87

    mov yFoodPos, 13
    mov foodArray2[esi], 13

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 6
    mov foodArray4[esi], 6

    call DrawFood2
    inc esi

    mov xFoodPos, 111
    mov foodArray1[esi], 111

    mov yFoodPos, 13
    mov foodArray2[esi], 13

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 3
    mov foodArray4[esi], 3

    call DrawFood2
    inc esi

   ; ----------------------- y = 14 ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 14
    mov foodArray2[esi], 14

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 3
    mov foodArray4[esi], 3

    call DrawFood2
    inc esi

    mov xFoodPos, 51
    mov foodArray1[esi], 51

    mov yFoodPos, 14
    mov foodArray2[esi], 14

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 6
    mov foodArray4[esi], 6

    call DrawFood2
    inc esi

    mov xFoodPos, 87
    mov foodArray1[esi], 87

    mov yFoodPos, 14
    mov foodArray2[esi], 14

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 6
    mov foodArray4[esi], 6

    call DrawFood2
    inc esi

    mov xFoodPos, 111
    mov foodArray1[esi], 111

    mov yFoodPos, 14
    mov foodArray2[esi], 14

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 3
    mov foodArray4[esi], 3

    call DrawFood2
    inc esi

   ; ----------------------- y = 15 ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 15
    mov foodArray2[esi], 15

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 3
    mov foodArray4[esi], 3

    call DrawFood2
    inc esi

    mov xFoodPos, 51
    mov foodArray1[esi], 51

    mov yFoodPos, 15
    mov foodArray2[esi], 15

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 6
    mov foodArray4[esi], 6

    call DrawFood2
    inc esi

    mov xFoodPos, 87
    mov foodArray1[esi], 87

    mov yFoodPos, 15
    mov foodArray2[esi], 15

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 6
    mov foodArray4[esi], 6

    call DrawFood2
    inc esi

    mov xFoodPos, 111
    mov foodArray1[esi], 111

    mov yFoodPos, 15
    mov foodArray2[esi], 15

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 3
    mov foodArray4[esi], 3

    call DrawFood2
    inc esi

   ; ----------------------- y = 16 ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 16
    mov foodArray2[esi], 16

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 3
    mov foodArray4[esi], 3

    call DrawFood2
    inc esi

    mov xFoodPos, 51
    mov foodArray1[esi], 51

    mov yFoodPos, 16
    mov foodArray2[esi], 16

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 6
    mov foodArray4[esi], 6

    call DrawFood2
    inc esi

    mov xFoodPos, 87
    mov foodArray1[esi], 87

    mov yFoodPos, 16
    mov foodArray2[esi], 16

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 6
    mov foodArray4[esi], 6

    call DrawFood2
    inc esi

    mov xFoodPos, 111
    mov foodArray1[esi], 111

    mov yFoodPos, 16
    mov foodArray2[esi], 16

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 3
    mov foodArray4[esi], 3

    call DrawFood2
    inc esi

   ; ----------------------- y = 17 ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 17
    mov foodArray2[esi], 17

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 3
    mov foodArray4[esi], 3

    call DrawFood2
    inc esi

    mov xFoodPos, 51
    mov foodArray1[esi], 51

    mov yFoodPos, 17
    mov foodArray2[esi], 17

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 6
    mov foodArray4[esi], 6

    call DrawFood2
    inc esi

    mov xFoodPos, 87
    mov foodArray1[esi], 87

    mov yFoodPos, 17
    mov foodArray2[esi], 17

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 6
    mov foodArray4[esi], 6

    call DrawFood2
    inc esi

    mov xFoodPos, 111
    mov foodArray1[esi], 111

    mov yFoodPos, 17
    mov foodArray2[esi], 17

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 3
    mov foodArray4[esi], 3

    call DrawFood2
    inc esi

   ; ----------------------- y = 18 ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 18
    mov foodArray2[esi], 18

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 3
    mov foodArray4[esi], 3

    call DrawFood2
    inc esi

    mov xFoodPos, 51
    mov foodArray1[esi], 51

    mov yFoodPos, 18
    mov foodArray2[esi], 18

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 6
    mov foodArray4[esi], 6

    call DrawFood2
    inc esi

    mov xFoodPos, 87
    mov foodArray1[esi], 87

    mov yFoodPos, 18
    mov foodArray2[esi], 18

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 6
    mov foodArray4[esi], 6

    call DrawFood2
    inc esi

    mov xFoodPos, 111
    mov foodArray1[esi], 111

    mov yFoodPos, 18
    mov foodArray2[esi], 18

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 3
    mov foodArray4[esi], 3

    call DrawFood2
    inc esi

    ; ----------------------- y = 19 ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 19
    mov foodArray2[esi], 19

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 42
    mov foodArray4[esi], 42

    call DrawFood2
    inc esi

    ; ----------------------- y = 20 ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 20
    mov foodArray2[esi], 20

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 42
    mov foodArray4[esi], 42

    call DrawFood2
    inc esi

    ; ----------------------- y = 21 ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 21
    mov foodArray2[esi], 21

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 42
    mov foodArray4[esi], 42

    call DrawFood2
    inc esi

    ; ----------------------- y = 22 ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 22
    mov foodArray2[esi], 22

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 42
    mov foodArray4[esi], 42

    call DrawFood2
    inc esi

    ; ----------------------- y = 23 ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 23
    mov foodArray2[esi], 23

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 42
    mov foodArray4[esi], 42

    call DrawFood2
    inc esi

    ; --------------------- Starting from y = 28 ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 28
    mov foodArray2[esi], 28

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 18
    mov foodArray4[esi], 18

    call DrawFood2
    inc esi

    mov xFoodPos, 62
    mov foodArray1[esi], 62

    mov yFoodPos, 28
    mov foodArray2[esi], 28

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 5
    mov foodArray4[esi], 5

    call DrawFood2
    inc esi

    mov xFoodPos, 78
    mov foodArray1[esi], 78

    mov yFoodPos, 28
    mov foodArray2[esi], 28

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 19
    mov foodArray4[esi], 19

    call DrawFood2
    inc esi

    mov xFoodPos, 107
    mov foodArray1[esi], 107

    mov yFoodPos, 28
    mov foodArray2[esi], 28

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 5
    mov foodArray4[esi], 5

    ; --------------------- Starting from y = 27------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 27
    mov foodArray2[esi], 27

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 5
    mov foodArray4[esi], 5

    call DrawFood2
    inc esi

    mov xFoodPos, 62
    mov foodArray1[esi], 62

    mov yFoodPos, 27
    mov foodArray2[esi], 27

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 5
    mov foodArray4[esi], 5

    call DrawFood2
    inc esi

    mov xFoodPos, 78
    mov foodArray1[esi], 78

    mov yFoodPos, 27
    mov foodArray2[esi], 27

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 5
    mov foodArray4[esi], 5

    call DrawFood2
    inc esi

    mov xFoodPos, 107
    mov foodArray1[esi], 107

    mov yFoodPos, 27
    mov foodArray2[esi], 27

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 5
    mov foodArray4[esi], 5

    call DrawFood2
    inc esi

    ; --------------------- Starting from y = 26  ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 26
    mov foodArray2[esi], 26

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 5
    mov foodArray4[esi], 5

    call DrawFood2
    inc esi

    mov xFoodPos, 62
    mov foodArray1[esi], 62

    mov yFoodPos, 26
    mov foodArray2[esi], 26

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 5
    mov foodArray4[esi], 5

    call DrawFood2
    inc esi

    mov xFoodPos, 78
    mov foodArray1[esi], 78

    mov yFoodPos, 26
    mov foodArray2[esi], 26

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 5
    mov foodArray4[esi], 5

    call DrawFood2
    inc esi

    mov xFoodPos, 107
    mov foodArray1[esi], 107

    mov yFoodPos, 26
    mov foodArray2[esi], 26

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 5
    mov foodArray4[esi], 5

    call DrawFood2
    inc esi

    ; --------------------- Starting from y = 25 ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 25
    mov foodArray2[esi], 25

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 5
    mov foodArray4[esi], 5

    call DrawFood2
    inc esi

    mov xFoodPos, 62
    mov foodArray1[esi], 62

    mov yFoodPos, 25
    mov foodArray2[esi], 25

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 5
    mov foodArray4[esi], 5

    call DrawFood2
    inc esi

    mov xFoodPos, 78
    mov foodArray1[esi], 78

    mov yFoodPos, 25
    mov foodArray2[esi], 25

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 5
    mov foodArray4[esi], 5

    call DrawFood2
    inc esi

    mov xFoodPos, 107
    mov foodArray1[esi], 107

    mov yFoodPos, 25
    mov foodArray2[esi], 25

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 5
    mov foodArray4[esi], 5

    call DrawFood2
    inc esi

    ; --------------------- Starting from y = 24 ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 24
    mov foodArray2[esi], 24

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 5
    mov foodArray4[esi], 5

    call DrawFood2
    inc esi

    mov xFoodPos, 62
    mov foodArray1[esi], 62

    mov yFoodPos, 24
    mov foodArray2[esi], 24

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 5
    mov foodArray4[esi], 5

    call DrawFood2
    inc esi

    mov xFoodPos, 78
    mov foodArray1[esi], 78

    mov yFoodPos, 24
    mov foodArray2[esi], 24

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 5
    mov foodArray4[esi], 5

    call DrawFood2
    inc esi

    mov xFoodPos, 107
    mov foodArray1[esi], 107

    mov yFoodPos, 24
    mov foodArray2[esi], 24

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 5
    mov foodArray4[esi], 5

    call DrawFood2
    inc esi

    mov numBoxes, esi

    ret
distributeFood2 endp

    ; -------------------------------------------------------- Draw Food (3) --------------------------------------------------------------------------;

distributeFood3 proc 

    mov esi, 0

    ; --------------------- Starting from y = 2 ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 2
    mov foodArray2[esi], 2

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 42
    mov foodArray4[esi], 42

    call DrawFood
    inc esi

   ; --------------------- Starting from y = 3 ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 3
    mov foodArray2[esi], 3

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 42
    mov foodArray4[esi], 42

    call DrawFood
    inc esi

    ; --------------------- Starting from y = 4 ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 4
    mov foodArray2[esi], 4

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 42
    mov foodArray4[esi], 42

    call DrawFood
    inc esi

    ; --------------------- Starting from y = 5 ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 5
    mov foodArray2[esi], 5

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 42
    mov foodArray4[esi], 42

    call DrawFood
    inc esi

    ; --------------------- Starting from y = 6 ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 6
    mov foodArray2[esi], 6

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 42
    mov foodArray4[esi], 42

    call DrawFood
    inc esi

    ; --------------------- Starting from y = 7 ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 7
    mov foodArray2[esi], 7

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 42
    mov foodArray4[esi], 42

    call DrawFood
    inc esi

    ; --------------------- Starting from y = 8 ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 8
    mov foodArray2[esi], 8

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 42
    mov foodArray4[esi], 42

    call DrawFood
    inc esi

    ; --------------------- Starting from y = 9 ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 9
    mov foodArray2[esi], 9

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 42
    mov foodArray4[esi], 42

    call DrawFood
    inc esi

    ; --------------------- Starting from y = 10 ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 10
    mov foodArray2[esi], 10

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 42
    mov foodArray4[esi], 42

    call DrawFood
    inc esi

    ; --------------------- Starting from y = 11 ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 11
    mov foodArray2[esi], 11

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 42
    mov foodArray4[esi], 42

    call DrawFood
    inc esi

    ; --------------------- Starting from y = 12 ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 12
    mov foodArray2[esi], 12

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 42
    mov foodArray4[esi], 42

    call DrawFood
    inc esi

    ; --------------------- Starting from y = 13 ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 13
    mov foodArray2[esi], 13

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 42
    mov foodArray4[esi], 42

    call DrawFood
    inc esi

    ; --------------------- Starting from y = 14 ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 14
    mov foodArray2[esi], 14

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 42
    mov foodArray4[esi], 42

    call DrawFood
    inc esi

    ; --------------------- Starting from y = 15 ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 15
    mov foodArray2[esi], 15

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 42
    mov foodArray4[esi], 42

    call DrawFood
    inc esi

    ; --------------------- Starting from y = 16 ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 16
    mov foodArray2[esi], 16

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 42
    mov foodArray4[esi], 42

    call DrawFood
    inc esi

    ; --------------------- Starting from y = 17 ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 17
    mov foodArray2[esi], 17

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 42
    mov foodArray4[esi], 42

    call DrawFood
    inc esi

    ; --------------------- Starting from y = 18 ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 18
    mov foodArray2[esi], 18

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 42
    mov foodArray4[esi], 42

    call DrawFood
    inc esi

    ; --------------------- Starting from y = 19 ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 19
    mov foodArray2[esi], 19

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 42
    mov foodArray4[esi], 42

    call DrawFood
    inc esi

    ; --------------------- Starting from y = 20 ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 20
    mov foodArray2[esi], 20

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 42
    mov foodArray4[esi], 42

    call DrawFood
    inc esi

    ; --------------------- Starting from y = 21 ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 21
    mov foodArray2[esi], 21

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 42
    mov foodArray4[esi], 42

    call DrawFood
    inc esi

    ; --------------------- Starting from y = 22 ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 22
    mov foodArray2[esi], 22

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 42
    mov foodArray4[esi], 42

    call DrawFood
    inc esi

    ; --------------------- Starting from y = 23 ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 23
    mov foodArray2[esi], 23

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 42
    mov foodArray4[esi], 42

    call DrawFood
    inc esi

    ; --------------------- Starting from y = 24 ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 24
    mov foodArray2[esi], 24

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 42
    mov foodArray4[esi], 42

    call DrawFood
    inc esi

    ; --------------------- Starting from y = 25 ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 25
    mov foodArray2[esi], 25

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 42
    mov foodArray4[esi], 42

    call DrawFood
    inc esi

    ; --------------------- Starting from y = 26 ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 26
    mov foodArray2[esi], 26

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 42
    mov foodArray4[esi], 42

    call DrawFood
    inc esi

    ; --------------------- Starting from y = 27 ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 27
    mov foodArray2[esi], 27

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 42
    mov foodArray4[esi], 42

    call DrawFood
    inc esi

    ; --------------------- Starting from y = 28 ------------------------- ;

    mov xFoodPos, 33
    mov foodArray1[esi], 33

    mov yFoodPos, 28
    mov foodArray2[esi], 28

    mov Vquantity, 1
    mov foodArray3[esi], 1

    mov Hquantity, 42
    mov foodArray4[esi], 42

    call DrawFood
    inc esi

    ret
distributeFood3 endp
; -------------------------------------------------------- Draw Food --------------------------------------------------------------------------;

DrawFood proc

    mov eax, yellow
    call SetTextColor
    movzx ecx, Vquantity
    mov dh, yFoodPos
    food:
        mov dl, xFoodPos
        mov ebx, 0
        mov bl, dl
        mov bh, dh
        cmp walls[bx], 1
        je skip
        mov foodcheck1[bx], 1
        call Gotoxy
        mov eax, '.'
        call WriteChar
        skip:
        inc dh
    loop food

    movzx ecx, Hquantity
    mov dh, yFoodPos
    mov dl, xFoodPos
    food2:
        mov ebx, 0
        mov bl, dl
        mov bh, dh
        cmp walls[bx], 1
        je skip2
        mov foodcheck1[bx], 1
        call Gotoxy
        mov eax, '.'
        call WriteChar
        skip2:
        add dl, 2
    loop food2

    mov numFood, esi

ret
DrawFood endp

; -------------------------------------------------------- Draw Food (2) --------------------------------------------------------------------------;

DrawFood2 proc

    mov eax, yellow
    call SetTextColor
    movzx ecx, Vquantity
    mov dh, yFoodPos
    food:
        mov dl, xFoodPos
        mov ebx, 0
        mov bl, dl
        mov bh, dh
        mov foodcheck1[bx], 1
        call Gotoxy
        mov eax, '.'
        call WriteChar
        inc dh
    loop food

    movzx ecx, Hquantity
    shl ecx, 1
    mov dh, yFoodPos
    mov dl, xFoodPos
    food2:
        mov ebx, 0
        mov bl, dl
        mov bh, dh
        mov foodcheck1[bx], 1
        call Gotoxy
        mov eax, '.'
        call WriteChar
        inc dl
    loop food2

    mov numFood, esi

ret
DrawFood2 endp

; ------------------------------------------------------------- Draw Cherry ------------------------------------------------------------------------;

DrawCherryHelper proc

    mov eax, red
    call SetTextColor
    mov dh, yCherryPos
    mov dl, xCherryPos
    call Gotoxy
    mov eax, 254
    call WriteChar

ret
DrawCherryHelper endp
    
DrawCherry proc

    mov esi, 0

    mov xCherryPos, 34
    mov cherry1[esi], 34

    mov yCherryPos, 2
    mov cherry2[esi], 2

    call DrawCherryHelper
    inc esi

    mov xCherryPos, 70
    mov cherry1[esi], 70

    mov yCherryPos, 27
    mov cherry2[esi], 27

    call DrawCherryHelper
    inc esi

    mov xCherryPos, 50
    mov cherry1[esi], 50

    mov yCherryPos, 10
    mov cherry2[esi], 10

    call DrawCherryHelper
    inc esi

    mov xCherryPos, 91
    mov cherry1[esi], 91

    mov yCherryPos, 20
    mov cherry2[esi], 20

    call DrawCherryHelper
    inc esi

    mov xCherryPos, 115
    mov cherry1[esi], 115

    mov yCherryPos, 3
    mov cherry2[esi], 3

    call DrawCherryHelper
    inc esi

    mov xCherryPos, 75
    mov cherry1[esi], 75

    mov yCherryPos, 7
    mov cherry2[esi], 7

    call DrawCherryHelper
    inc esi

    mov numCherries, esi

    ret
DrawCherry endp

; ------------------------------------------------------- Player - Cherry Collision ---------------------------------------------------------------;

checkPlayerCherryCollision proc uses esi

        mov ecx, numCherries
        mov esi, 0

        CherryLoop:
            mov al, xPos
            cmp al, cherry1[esi]
            jne noCollision

            mov al, yPos
            cmp al, cherry2[esi]
            jne noCollision

            cmp cherryCheck[ecx], 1
            je noBonus
            add score, 9
            mov cherryCheck[ecx], 1
            invoke PlaySound, offset eatFruit, null, 0
            noBonus:
            ret

            noCollision:
            inc esi
        loop CherryLoop

        ret

checkPlayerCherryCollision endp

; -------------------------------------------------------------------- Instructions Screen ------------------------------------------------------------------ ;

displayInstructions proc
    
    call clrscr
    ; ------------- Instructions -------------- ;

    mov dl, 3
    mov dh, 4
    call gotoxy

    mov eax, 1000
    call delay

    mov edx, offset Instruction1
    mov eax, yellow + (black*16)
    call setTextColor
    call WriteString
    call crlf

    mov dl, 3
    mov dh, 6
    call gotoxy

    mov eax, 1000
    call delay

    mov edx, offset Instruction2
    mov eax, yellow + (black*16)
    call setTextColor
    call WriteString
    call crlf

    mov dl, 3
    mov dh, 8
    call gotoxy

    mov eax, 1000
    call delay

    mov edx, offset Instruction3
    mov eax, yellow + (black*16)
    call setTextColor
    call WriteString
    call crlf

    mov dl, 3
    mov dh, 10
    call gotoxy

    mov eax, 1000
    call delay

    mov edx, offset Instruction4
    mov eax, yellow + (black*16)
    call setTextColor
    call WriteString
    call crlf

    mov dl, 3
    mov dh, 12
    call gotoxy

    mov eax, 1000
    call delay

    mov edx, offset Instruction5
    mov eax, yellow + (black*16)
    call setTextColor
    call WriteString
    call crlf

    mov dl, 3
    mov dh, 14
    call gotoxy

    mov eax, 1000
    call delay

    mov edx, offset Instruction6
    mov eax, yellow + (black*16)
    call setTextColor
    call WriteString
    call crlf

    mov dl, 3
    mov dh, 16
    call gotoxy

    mov eax, 1000
    call delay

    mov edx, offset Instruction7
    mov eax, yellow + (black*16)
    call setTextColor
    call WriteString
    call crlf

    mov dl, 3
    mov dh, 18
    call gotoxy

    mov eax, 1000
    call delay

    mov edx, offset Instruction8
    mov eax, yellow + (black*16)
    call setTextColor
    call WriteString
    call crlf

    mov dl, 3
    mov dh, 16
    call gotoxy

    mov eax, 1000
    call delay

    call readInt
    ret
displayInstructions endp   


          ; ------------------------------------------------------ Game Over Screen -----------------------------------------------------------------;

displayGameOver proc
    
    call saveToFile
    call resetTextColor

    call clrscr
    mov dl, 55
    mov dh, 5
    call gotoxy
    mov eax, red
    call setTextColor
    mov edx, OFFSET gameOver
    call WriteString

    mov eax, blue
    call setTextColor

    mov dl, 47
    mov dh, 8
    call gotoxy

    mov edx, offset strPlayer
    call writeString

    mov edx, offset playerName
    call writeString

    mov dl, 47
    mov dh, 9
    call gotoxy

    mov edx, offset strScore
    call writeString

    mov ax, score
    call writeDec

    mov dl, 88
    mov dh, 20
    call gotoxy

    call waitmsg
    call resetTextColor
    ret

displayGameOver endp

; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ------ Main Procedure ------ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%;

main proc

    ; ------------------------ Pages ----------------------------- ;

    call page1

    again:
        call page2
        cmp eax, 1
        je Game
        cmp eax, 2
        je Instructions
        cmp eax, 3
        je endFunc
        cmp eax, 4
        je endFunc

        Game:
            call level1
            jmp endFunc
        Instructions:
            call displayInstructions
            cmp eax, 0
            je again

    endFunc:

main endp

end main

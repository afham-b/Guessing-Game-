; main.asm - Main assembly file for usage with the cisc225-project template.
;	This project links with a subset of the Irvine library written in C/C++
;	and wrapper procedures written in assembly.

; Guessing Game  
; Date: 04.2.2021
; Author: Afham Bashir 


.386
.model flat,c
.stack 4096

include cisc225.inc


.data
	random_n  sdword ?   ;variable to contain random number 
	n_guesses sdword 0   ;variable to keep track of number of guesses 
	user_n    sdword 0   ;holds the user inputed guess 

	intro_prompt byte "Let's play the guessing game", 0ah, 
					  "I'll think of a number from 1 to 100, and you try to guess what it is",0ah,
					  "I'll keep track of the number of guesses", 0ah, 
					  "I have my number, now it's your turn.", 13,10,0
					  ; holds the strings for the intro prompt 

	guess_prompt  byte "Enter your guess: ", 13,10,0 
	low_prompt    byte "That's too low. Try Again.", 13,10,0 
	high_prompt   byte "That's too high. Try Again.", 13,10,0 
	range_prompt  byte "Valid guesses are from 1 to 100. Try Again.", 13,10,0 
	sucess_prompt byte "That's Correct!", 13,10,0 
	result1       byte "You guessed it in ",0
	result2       byte " guesses.",13,10,0 


.code

main PROC

	call Randomize   ;set randomizer 
	mov eax,99       ;pick random numbers up to 99 
	call RandomRange ;set EAX to a random number
	inc eax			 ;to avoid 0
	mov random_n,eax ;move random number into memory 

	mov edx,offset intro_prompt ;to use address of the intro prompt
	call WriteString			;output the prompt to the console 

L1: 
	mov edx,offset guess_prompt ;ask to enter guess
	call CrLf					;next line 
	call WriteString            ;output propmt 
	call ReadInt                ;read user input 
	mov user_n,eax				;store user guess in user_n

	call validation             ;call input validation, if invalid, eax will be 0
	cmp eax,0					;eax will equal zero if input if invalid
	JNE	L3						;if value if not zero

		mov edx,offset range_prompt  ;out of range prompt addres
		call WriteString			 ;output out of range prompt
		jmp L1						 ;retry guess 

L3:                             ;once input has been validated 
	inc n_guesses               ;increament number of guesses 
	call guess_comparison       ;call function to see how guess it to random number	
	cmp ecx,0					;guess function will set to zero is the guess is correct 
	JNE L1						;loop guessing while ecx isn't 0. 

mov edx,offset sucess_prompt    ;load address of sucress prompt
call WriteString				;print the sucess prompt 

mov edx,offset result1			;address of "You guessed it in "
call WriteString				;output string
mov eax,n_guesses				;move number of guesses to eax 
call WriteInt					;print eax and output number of guesses
mov edx,offset result2			;address of "guesses"
call WriteString				;print last part of string


call ReadChar		
;hold console window open until keystroke

call EndProgram	
; Terminates the program

	ret
main ENDP

;input validation to make sure guess is between 1 and 100
validation PROC
	
	cmp eax,0   ; compares the guess to 0 
	JLE L2	    ; if the gues is equal to zero or less than zero, go to L2 
	cmp eax,100 ; compares the guess to 100, should be less than or equal to
	JG L2       ; if guess is more than 100, go to L2
	jmp L3      ; if the value is not negative, non-zero, and equal to or less than 100, L3
L2:
	mov eax,0   ; L2 makes eax 0  
L3:             ; do nothing if value is within parameters 
	ret
validation ENDP

;compare the user's guess to the random generated number
guess_comparison PROC

	cmp eax,random_n  ;compares the user input (in eax) to the random number
	JG L4			  ;if the guess is greater than the number
	JL L5             ;if the guess is less than the number 
	JE L6             ;if the guess value is equal to random number
L4: 
	mov edx, offset high_prompt ;address of too high prompt
	call WriteString			;output too high prompt to console 
	ret 
L5:
	mov edx,offset low_prompt	;address of too low prompt
	call WriteString			;output too low prompt to console
	ret 
L6: 
	mov ecx,0					;change ecx to 0 if the guess is correct 
	ret
guess_comparison ENDP

END
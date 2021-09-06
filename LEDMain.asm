# LED Main
# This is going to test our LED.
# https://repl.it/@WMeacham/LEDFinalProjectExample
#Chiona Clemons 
#May 4 2020
  #Stuff for MMIO to connect just setting names
 .eqv KC 0xffff0004   # MMMI  Address that we use to check if data is ready (Key stored in this address)
 .eqv KR 0xffff0000   # MMI Address we use to read (just says 1 or 0 if a key has been pressed)
.data
  prompt: .asciiz "How big do you want your LED? (Best sizes are 4-7, 2 and 3 work but don't look good. Anything past 8 does not work within the size of this Bitmap Display)\nEnter A number: "
  invalid: .asciiz "\tYou entered an invalid key. Try again\n"
.text
  .globl main
  main:
  
  li $v0, 4
  la $a0, prompt
  syscall
  li $v0, 5
  syscall
  move $s3, $v0 #store 'size' of LED in s3
  
  li $s4, KC	# This stores the key pressed 
  li $s5, KR    # This flat tells if a key has been pressed
  jal InitializeLED
  jal TurnOnLED #keep in mind that the led is initalized as ON
  
   loop:	     # Polling, constantly checking
    jal DELAY
    jal RainbowPC      #Use PC for Power concious otherwise just use rainbow
    lw $t0, 0($s5)   # Load if a key has been pressed from 0xffff0000 mmio memory
    beqz $t0, loop   # So if nothing in the keyboard buffer, then just wait
      lw $t2, 0($s4) # Read the key pressed into $s4
      move $a0, $t2
      li $v0, 1
      syscall# moves to a0 to print the key pressed in Run I/O
      #not needed but nice if you don't wanna look at memory addressses.
    
    
    beq $t2, 48, LEDOFF
    beq $t2, 49, LEDON
    beq $t2, 50, LEDTOGGLE
    move $s7, $a0
    beq $t2, 97, MOVE  #a 97
    beq $t2, 100, MOVE #d 100
    beq $t2, 115, MOVE #s 115
    beq $t2, 119, MOVE #w 119
    
    li $v0, 4
    la $a0, invalid 
    syscall
      
   b loop
   
      LEDOFF:
      jal TurnOffLED
      b loop
      LEDON:
      jal TurnOnLED
      b loop
      LEDTOGGLE:
      jal ToggleLED
      b loop
      MOVE:
      jal MoveLED
      b loop
     
  li $v0, 10
  syscall

# Simple Delay Routine
DELAY:
  li $v0, 32
  li $a0, 10
  syscall
  jr $ra
.include "LED.asm"
  

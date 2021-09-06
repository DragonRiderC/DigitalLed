# LED.asm
# We are going to implement a class.  

# Constants
.eqv LED_SURROUND 	0x00F0FFFF	 # OffWhite
.eqv LED_OFF 		0X0030110D       # Coffee
.eqv LED_ON  		0x00722620       # Red
.eqv LED_LEG            0x00696969       # Grey
.eqv LED_CLEAR		0x00000000	 # Black
.eqv RED		0x00FF0000	 #RED

# Instance Variables

.data   # Instance Variables
  State: 	.word 0   # Is the LED on or off?
  XYLoc: 	.word 0   # Where is it displayed on the screen
  LEDSurround:  .word 0 # Hold the colors in memory
  LEDOff:       .word 0 
  LEDOn:        .word 0 #Where we store our colors
  LEDLeg:	.word 0 #ughhhhh
  LEDClear:     .word 0 #really roundabout away of saving a color 
  Initalized:   .word 0 #Has the LED been drawn at least once?
  Rain:		.word 0 #Rainbow
  POWERCYCLE:	.word 0 #tells us if we are adding or subtracting a color
  HAHANo: 	.asciiz "HAHA No."
  Sides:	.word 0
.text
# Constructor
InitializeLED:
  # Prolog
  addi $sp, $sp, -20
  sw $ra, 0($sp)
  sw $s0, 4($sp)
  sw $s1, 8($sp)
  sw $s2, 12($sp)
  sw $s3, 16($sp)
  
  # Logic!!!
  # Since we are storing our Bitmap in the Heap
  # My Display is 64 units wide by 64 units deep
  # Have 4096 units.  64 x 64   I have 4096 words I need to store
  # Need to allocate 4096 x 4 bytes, or 4096 bytes
  #each line is going to be 256 long
  li $a0, 16384
  li $v0, 9   
  syscall        # This allocates in the heap.
  # I now have 16384 bytes
  #Move it to the center, approximately.
  # Every row is 128 bytes.  Every column is 4 bytes
  # So you can start anywhere by modifying $v0
  # Remember, when you allocate memory, the address is returned in $v0
  # LET's calculate where the center is for this led instead of having it be "roughly there"
  #something about 512
  addi $v0, $v0, 640 #move this sucker down two lines and center it
  div $t0, $s3, 2 #take half of whatever the initial value is
  mul $t0, $t0, 4 #now "byte it"
  sub $v0, $v0, $t0 # now the starting point is exactly where the middle is for whatever initalized number is input
  
  sw $v0, XYLoc  # This stores XY loc where it should be.
  
  li $s0, LED_SURROUND
  sw $s0, LEDSurround
  
  li $s0, LED_ON
  sw $s0, LEDOn
  
  li $s0, LED_OFF
  sw $s0, LEDOff
  
  li $s0, LED_LEG
  sw $s0, LEDLeg
  
  li $s0, LED_CLEAR
  sw $s0, LEDClear
  
  li $s0, RED
  sw $s0, Rain
  
  # Epilog  
  lw $ra, 0($sp)
  lw $s0, 4($sp)
  lw $s1, 8($sp)
  lw $s2, 12($sp)
  lw $s3, 16($sp)
  addi $sp, $sp, 20
  jr $ra
  
  
# Methods
# Turn on LED
TurnOnLED:
  # Prolog
  addi $sp, $sp, -20
  sw $ra, 0($sp)
  sw $s0, 4($sp)
  sw $s1, 8($sp)
  sw $s2, 12($sp)
  sw $s3, 16($sp)
  
  # Logic
  lw $s0, State
  beq $s0, 1, TurnOnLEDEpilogue #check to make sure the LED is on.
  #if the led is on there's no reason to draw it again.
  li $s0, 1      # 1 is on, 0 is off
  sw $s0, State  # We are setting our state to 1. i.e. on
  lw $a0, Rain #get current color  # We are going to load our on color into $a0 to be passed
  jal DrawLED    # Call our subroutine
  TurnOnLEDEpilogue:
  # Epilog
  lw $ra, 0($sp)
  lw $s0, 4($sp)
  lw $s1, 8($sp)
  lw $s2, 12($sp)
  lw $s3, 16($sp)
  addi $sp, $sp, 20
  jr $ra
 
# Turn off LED
TurnOffLED:
  # Prolog
  addi $sp, $sp, -20
  sw $ra, 0($sp)
  sw $s0, 4($sp)
  sw $s1, 8($sp)
  sw $s2, 12($sp)
  sw $s3, 16($sp)
  # Logic
  lw $s0, State
  beqz $s0, TurnOffLEDEpilog #let's check to see if the LED is already off.
  #if it is there's no need to draw it again. for real.

  li $s0, 0      # 1 is on, 0 is off
  sw $s0, State  # We are setting our state to 0 i.e. off
  lw $a0, LEDClear #use LEDClear to clear # We are going to load our on color into $a0 to be passed
  jal DrawLED    # Call our subroutine
  
  TurnOffLEDEpilog:
  # Epilog  
  lw $ra, 0($sp)
  lw $s0, 4($sp)
  lw $s1, 8($sp)
  lw $s2, 12($sp)
  lw $s3, 16($sp)
  addi $sp, $sp, 20
  jr $ra
  
# Toggle LED
ToggleLED:
  # Prolog
  addi $sp, $sp, -20
  sw $ra, 0($sp)
  sw $s0, 4($sp)
  sw $s1, 8($sp)
  sw $s2, 12($sp)
  sw $s3, 16($sp)
  
  # Logic
  lw $s0, State		# Let's get the state of our LED
  # If Statement
  seq  $t0, $s0, $zero   # Using the standard protocol we've been following  #if state is 0(off) go turn LED on
  beqz $t0, TLEDElse    #
    jal TurnOnLED	
    b TLEDendIf		
  TLEDElse:		#if the statement is true 
    jal TurnOffLED
  TLEDendIf:
  
   # Epilog  
  lw $ra, 0($sp)
  lw $s0, 4($sp)
  lw $s1, 8($sp)
  lw $s2, 12($sp)
  lw $s3, 16($sp)
  addi $sp, $sp, 20
  jr $ra

  #Move the LED
MoveLED:
  # Prolog
  addi $sp, $sp, -20
  sw $ra, 0($sp)
  sw $s0, 4($sp)
  sw $s1, 8($sp)
  sw $s2, 12($sp)
  sw $s3, 16($sp)
  move $a0, $s6 #s6 last register not being used save current color in there
  #this is super toxic but We're gonna do it to save instructions 
  lw $a0, LEDClear  #go clear out the led currently drawn.
  sw $a0, LEDSurround
  sw $a0, LEDLeg #make everything black so it dedraws it. 
  li $s0, 0
  sw $s0, Initalized #a little work here saves a lot of work in the program later
  
  jal DrawLED #I could loop just putting in black for every single square but this is ACTUALLY faster
  li $s0, 0
  sw $s0, Initalized 
  
  li $s0, LED_SURROUND
  sw $s0, LEDSurround
  
  li $s0, LED_LEG
  sw $s0, LEDLeg
  
  li $s0, LED_CLEAR
  sw $s0, LEDClear #including redoing these instructions.
  
  #li $s0, -1
  #sw $s0, State #comment out after done with the moving function
  #just here so if you clear it in on state and then turn it on again it redraws it
  #really messes up toggle.
  #^^Code above here clears out the led completely^^
  #it puts the colors back where they belong too.
  
  #Move LED
  
  
  # Every row is 128 bytes.  Every column is 4 bytes
  # So you can start anywhere by modifying $v0
  # Remember, when you allocate memory, the address is returned in $v0
  # LET's calculate where the center is for this led instead of having it be "roughly there"
  lw   $s0, XYLoc #moving our led around we will use the starting location to do so.
  #addi $v0, $v0, 640 #move this sucker down two lines and center it
  li $t8, 0x10040000 #upper left corner of display
  # UpperLeftCorner = 0x10044000
  # XY = 0x10040278 is our starting point for the LED (+640)
  #something about 512
  
  beq $s7, 97, A  #a 97
  beq $s7, 100, D #d 100
  beq $s7, 115, S #s 115
  beq $s7, 119, W #w 119
  
  #include math to contain led drawing HERE<V<V
  move $t1, $s3  # get the initalization size of our array 
  mul $t0, $t1, $t1, #square inital 
  div $t0, $t0, 2 #divide that by 2 to get halfway of the LED
  mul $t0, $t0, 4 #now "byte it" for heap math
  
  
  W:
  	addi $s0, $s0, -256 #up a row
  	slt $t9, $s0, $t8 #IF XYLoc < Upper Left Corner $t9 = 1 
  	 beqz $t9 MoveEpilog #if t9 > upper left coner go ahead and move it otherwise move it back down
  	addi $s0, $s0, 256
  	li $v0, 4
  	la $a0, HAHANo
    	b MoveEpilog
  A:
  	addi $s0, $s0, -4 #left a pixel
  	b MoveEpilog
  S:
    	addi $s0, $s0, 256 #down
  	b MoveEpilog
  D:
 	addi $s0, $s0, 4 #right
  	b MoveEpilog
 
  MoveEpilog: 
  sw $s0, XYLoc
  
  #modify toggle if statement to just turn the led back on in the new location.
  lw $s0, State		#get the state
  seq  $t0, $s0, $zero  #if it is off t0 = 1
  beqz $t0, DLEDElse    #else load on color in and draw
    lw $a0, LEDClear	#load off color in and draw
    b DLEDendIf		#go draw silly
  DLEDElse: 
    lw $a0, Rain#change this color if needed    
  DLEDendIf:
  
  jal DrawLED #go draw in the color of the state the led is in~!
  
  # Epilog  
  lw $ra, 0($sp)
  lw $s0, 4($sp)
  lw $s1, 8($sp)
  lw $s2, 12($sp)
  lw $s3, 16($sp)
  addi $sp, $sp, 20
  jr $ra
  
# Draw the LED 
# The inside color is passed to this method in $a0
DrawLED:   # This is where we will do all the work!!!
  # Prolog
  addi $sp, $sp, -20
  sw $ra, 0($sp)
  sw $s0, 4($sp)
  sw $s1, 8($sp)
  sw $s2, 12($sp)
  sw $s3, 16($sp)
  
  # Logic
  # Fun Starts!!!
  lw   $s0, XYLoc        # Load the address in memory of our pixels.
  lw   $s1, LEDSurround  # Load up our surround color
  move $s2, $a0          # Save our inside color
  move $t1, $s3          # get the initalization size of our array 
 
  # Top & Body Prologue
  
  li $t0, 0     #initalize I=0
  		#li $t1, t1 WAS the number used to draw the LED originally. If you do not want to prompt the user in the Main file then uncomment this and use it.
  li $t2, 0     #totaldrawnPreviousLINE. This is the total number of pixels drawn each time Start at 4 because we have s0 pointing where we want and we want to draw 4 pixels
  move $t3, $t1 #total to draw \\\ will make sense and be useful later \\\ for now just know it needs to be the same as whatever t1 is
  
  li $t4, 2 	#this is totally fake and made up but! it is our entry and exitpoint of the drawing loop. 
  		#This adds 10 to the height of the LED So 10+width/2 
  sub $t4, $t4, $t1 #t4= 2 - initalization size
  sub $t4, $t4, $t1 #t4= 2 - initalization size again
  li $t9, 0     #if everything else is looking nice and working well why can't our led body height be porportional too?
  li $t8, 4     #gotta be able to have some offhand varibale to do some quickie math with ;)
  
  #Begin the Draw.
  TopCurve: 
  beq $t3, $t0 ExitTopCurve #if total drawn is equal to i++ exit
  	
  	#Since total # to draw is in t3 Draw outside will run twice to draw both sides
  	DrawOutside:#needs for i++ t1  draw outside edges
  	beq $t1, $t0 DrawInside #IT'S TIME TO DRAW THE INSIDE 1st outside has been drawn
  	sw $s1, 0($s0)	# Write LEDSurround into memory at $s0
  	addi $t0, $t0, 1
  	addi $s0, $s0, 4 #move pointer
  	b TopCurve
  	
  	DrawInside:
  	slt $t8, $t0, $t2 #exit if total drawn previous + how many to draw outside are more than the count 
  			  #let's say you start with 4 surround well now you draw this 4 times.
  	beqz $t8, TopCurve#branch to the top of this massive loop
  	sw $s2, 0($s0)	  # Write LEDon/LEDoff to this spot in the heap
  	addi $t0, $t0, 1  #i++
  	addi $s0, $s0, 4  #move pointer to next position in the heap
  	
  	b DrawInside #branch back to the loop
  	
  b TopCurve
  
  ExitTopCurve:

  move $t2, $t0 #ensure we are working with the previous number drawn (Seriously. This fixed everything.)

  #reinitilization
  addi $t4, $t4, 1 #incrimnet line number 
  #fake epilogue here's a crap ton of math to figure out how to draw a "nice" curve (specific to this program only other curves larger or smaller will vary)
  
  li $t0, 0         #initialize i at 0 again.
  mul $t8, $t2, 4   #t2 x 4 = bytes PREV # DRAWN PIXELS to move for the pointer to move back
  sub $s0, $s0, $t8 #reset pointer to where it started first pixel drawn (surr on line 1, ledon/off all other lines)
  subi $t1, $t1, 1  #move t1 to being back one to draw one less surrounding pixel this time.
  add $t2, $t1, $t2 #How many dots from the first wall and the inside color will be drawn (gives exitpoint for draw inside.)
  
  mul $t8, $t1, 4    #multiply again to move s0 to draw at the right position next line #where outside lines will be drawn
  sub $s0, $s0, $t8  #pointer shows where to draw again
  addi $s0, $s0, 256 #this is next line for the pointer
  beqz $t1, NoSides  #if there are no sides that is ... an issue ... let's resolve this 
  add $t3, $t2, $t1  #total drawn next
  NoSidesResolution: #This resolution gives us the ablity to build the walls of the LED too
  
  
  #How are we going to make this porportional the the line number created? Simple take advantage of the fact that t3 will get stuck at some point.
  div $t9, $t3, 2 #if t3 is stuck at a big number it will take longer to get there thus the led is more porportional 
  
  beq $t4, $t9, TrueCurveExit #exit in porportion to the curve created

  b TopCurve
  
  NoSides:
  addi $t1, $t1, 1 #if there are no sides then make 1 so the program works
  subi $t2, $t2, 1 #if there are no sides to draw then there is one less pixel to be drawn inside
  #Yes it's a bit confusing but this resolves the issue of what happens when t1 =0
  b NoSidesResolution
  
  TrueCurveExit:
  #REAL epilogue of Curve exit
  #everything that's in the fake epilogue is initalized and set up for us to draw the bottom of the led.
  	
  	lw $t5, Initalized #has this been initalized?, if the bottom and legs have been drawn on then there's no need to run this.
  	bne $t5, $zero DrawExit
  	Bottom:
  	sw $s1, 0($s0)	# Write LEDSurround into memory at $s0
  	addi $t0, $t0, 1
  	addi $s0, $s0, 4 #move pointer
  	bne $t3, $t0 Bottom #Exit the bottom loop when all the bottom has been drawn
  	#//////#
  	
	addi $s0, $s0, 256 #256 because the pointer is pointing at a blank space and we need it right under the led on the next line
	mul $t8, $t3, 4 #more memory address stuff :)
	sub $s0, $s0, $t8 #move the pointer back to the beginning of where it was
	#where do we point to for the legs to go??
	div $t0, $t3, 4 #on a 4 size this should return 4 on something like 7 idk but this should work with any size given.
	mul $t8, $t0, 4 #Why are we divididing and then multiplying by 4? Well if t3 is odd (and it can be) we want the code to work with it. might upset word boundry gods
	add $s0, $s0, $t8 #point to a qauarter of the total size of the LED
	lw $t7, LEDLeg  #cahnged 
	mul $t0, $t0, 3 # PORPORTIONS Okay so let's say we do have a big boi a 7 starter so it's like ... 49 pixels long at the end (Seriously the size of the led at the end is it's inital squared.)
	#so we want t0 to be 1/4 of 49, then to make the legs somewhat in porportion to the LED created this changes based on that inital value.
	Legs: #now let's draw some leggy bois
	beq $t0, $t3 DrawExit
	sw $t7, 0($s0) #so the pointer is looking at the right space( a quarter inbetween of our bottom width) so immediately store the word
	add $s0, $s0, $t8 #move it another quarter
	add $s0, $s0, $t8 #move it another quarter NOT going to use a loop for two instructions inside a loop...
	sw $t7, 0($s0) #we're pointing at 3/4ths the bottom of the LED put another leg pixel
	addi $t0, $t0, 1 
	sub $s0, $s0, $t8
	sub $s0, $s0, $t8
	addi $s0, $s0, 256
	b Legs
	#hehe wouldn't it be crazy if the leg thickness was also based on the led size? We could do that but i'm getting tired of being silly with this
	
  DrawExit:
  #prologue of creating the bottom walls 
  
  li $s0, 1
  sw $s0, Initalized
  
  # Epilog  
  lw $ra, 0($sp)
  lw $s0, 4($sp)
  lw $s1, 8($sp)
  lw $s2, 12($sp)
  lw $s3, 16($sp)
  addi $sp, $sp, 20
  jr $ra
  
  Rainbow:
  
  # Prolog
  addi $sp, $sp, -20
  sw $ra, 0($sp)
  sw $s0, 4($sp)
  sw $s1, 8($sp)
  sw $s2, 12($sp)
  sw $s3, 16($sp)
  lw $t9, State
  beqz $t9 RainbowSkip
  #Rain Has our current hex color 
  lw $t4, Rain #starts at red
  lw $a1, POWERCYCLE #Which cycle the color is on and going to.
  
  
  sge $t0, $a1, 306 #if cycle complete  
  	bgtz $t0, RESET
  sge $t0, $a1, 255 #if Purple sub blue
  	bgtz $t0, SUBBLUE
  sge $t0, $a1, 204
  	bgtz $t0, ADDRED
  sge $t0, $a1, 153
  	bgtz $t0, SUBGREEN 
  sge $t0, $a1, 102
  	bgtz $t0, ADDBLUE
  sge $t0, $a1, 51
  	bgtz $t0, SUBRED
  sge $t0, $a1, 0
  	bgtz $t0, ADDGREEN
  
  ADDRED:
  addi $t4, $t4, 0x00050000
  b RainbowEpilogue
  ADDGREEN:
  addi $t4, $t4, 0x00000500
  b RainbowEpilogue
  ADDBLUE:
  addi $t4, $t4, 0x00000005
  b RainbowEpilogue
  SUBRED:
  subi $t4, $t4, 0x00050000
  b RainbowEpilogue
  SUBGREEN:
  subi $t4, $t4, 0x00000500
  b RainbowEpilogue
  SUBBLUE:
  subi $t4, $t4, 0x00000005
  b RainbowEpilogue
  
  RESET:
  subi $a1, $a1, 307 #because it adds on at the end
  
  b RainbowEpilogue
  
  # Write the epilog
  RainbowEpilogue:
  addi $a1, $a1, 1 #every time this function is called add 1 to the cycle
  sw $a1, POWERCYCLE
  sw $t4, Rain
 
  #li $v0, 1
  #add $a0, $a1, $zero
  #syscall
  
  lw $a0, Rain
  jal DrawLED
  RainbowSkip: #use if led is off.
  # Epilog  
  lw $ra, 0($sp)
  lw $s0, 4($sp)
  lw $s1, 8($sp)
  lw $s2, 12($sp)
  lw $s3, 16($sp)
  addi $sp, $sp, 20
  jr $ra

#########Power Concious
  RainbowPC:
  
  # Prolog
  addi $sp, $sp, -20
  sw $ra, 0($sp)
  sw $s0, 4($sp)
  sw $s1, 8($sp)
  sw $s2, 12($sp)
  sw $s3, 16($sp)
  lw $t9, State
  beqz $t9 RainbowSkipPC
  lw $t4, Rain #starts at red
  lw $a1, POWERCYCLE #Which cycle the color is on and going to.
  
  sge $t0, $a1, 153 #if cycle complete  
  	bgtz $t0, RESET2
  sge $t0, $a1, 102 #if Purple sub blue
  	bgtz $t0, SUBBLUEADDRED
  sge $t0, $a1, 51
  	bgtz $t0, ADDBLUESUBGREEN
  sge $t0, $a1, 0
  	bgtz $t0, ADDGREENSUBRED 

  
  ADDGREENSUBRED:
  addi $t4, $t4, 0x00000500
  subi $t4, $t4, 0x00050000
  b RainbowEpiloguePC
  ADDBLUESUBGREEN:
  addi $t4, $t4, 0x00000005
  subi $t4, $t4, 0x00000500
  b RainbowEpiloguePC
  SUBBLUEADDRED:
  subi $t4, $t4, 0x00000005
  addi $t4, $t4  0x00050000
  b RainbowEpiloguePC
  
  RESET2:
  subi $a1, $a1, 154 #because it adds on at the end
  
  b RainbowEpiloguePC
  
  # Write the epilog
  RainbowEpiloguePC:
  addi $a1, $a1, 1 #every time this function is called add 1 to the cycle
  sw $a1, POWERCYCLE
  sw $t4, Rain
 
  #li $v0, 1
  #add $a0, $a1, $zero
  #syscall
  
  lw $a0, Rain
  jal DrawLED
  RainbowSkipPC: #skips this if led is off
  # Epilog  
  lw $ra, 0($sp)
  lw $s0, 4($sp)
  lw $s1, 8($sp)
  lw $s2, 12($sp)
  lw $s3, 16($sp)
  addi $sp, $sp, 20
  jr $ra

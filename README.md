# Simon PIC18 course project
In the context of a course of digital electronics, we had to solder, on a pre-made PCB, SMD and Through-hole component and program the microcontroller PIC18f25k40 to remake the game "Simon"

##The PCB
![alt text](https://github.com/LeoAda/Simon_PIC18_course_project/blob/main/pcb_picture.jpg "PCB picture")
There is RGB led associate with 4 buttons, 4 green led, 1 commutator, 1 buzzer
The circuit is powered by a 9v supply.

## Operating
At the beginning, color of the rgb led change in sequence(blue, yellow, green, red) with a counter. We wait for a button pressure and after that a number is record with another timer randomly that will be use as a seed to the pseudo random sequence.
You arrive to the menu with the choice of difficulty (only the tempo is changing) with green (easy) or hard (red)
The sequence is play once with a LFSR use with the seed store before. So you only have to save 1 byte rather than an fully random sequence.
After that the game wait that you play the sequence : if it's good, the sequence is play again with 1 more color. Else, you go back to the menu and your score is display with the help of the 4 green led as a binary number (so the maximum diplayable score is 2^4=16 but it's hard :) )
Also, different sound is played with the buzzer when you press a button or when a led turn on

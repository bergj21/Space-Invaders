*******************************************************************************
*       Project: Space Invaders                                               *
*       Authors: Jack Berg, Noah Tervalon, Braun Lippe, Alex Lee              *
*******************************************************************************

We set out to create a version of the arcade game Space Invaders for our final project. Space Invaders is a fixed shooter in which the player moves a laser cannon horizontally across the bottom of the screen and fires at aliens above. In our version of the game, the aliens begin as two rows of 10 that move left and right as a group, shifting downward each time they reach the left screen edge. The goal is to eliminate all of the aliens by shooting them. As aliens are defeated, their movement speed increases. If the aliens reach the bottom of the screen, the game ends and the player has lost. If the player eliminates all of the aliens before they have reached the bottom, the game will end with a You Win screen. Regardless of win or lose, the player can restart the game after it is over.  
- In order for this to be an interactive game, we have a module for the NES controller. Using the controller, the player’s inputs affect the state and logic of the game.
- We also have a module for the game logic. This module handles all of the logic associated with the player movement and shooting, alien movement, bullet movement, and collisions between the aliens and bullets. 
- We have a module for the state of the game. The game state module is a finite state machine that changes the current state of the game depending on the inputs from the controller and the game logic. 
- Taking into account the overall state of the game, the pattern generation module produces the pixel to be displayed onto the screen. The pattern generation module accomplishes this by interacting with the read-only memory. 
- The ROM files contain the data for our sprites and backgrounds. The pattern generation module takes data from the ROM and the logic of the game to determine the current pixel that must be displayed in a given (row, col). 
- Lastly, in order to display the game, we needed a module to display pixels onto a screen (VGA). With all of this working together, we are able to display a fully functioning Space Invaders game.

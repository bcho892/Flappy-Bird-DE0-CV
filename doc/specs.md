# Entity Specifications

This document is to be used for planning and documenting the implementaion details of each entity.

> _Every significant change to the implementation is to accompany an update to this document_

## Entities

### Bird

#### Requirements

The _Bird_ is a sprite that is fixed horizontally on the screen, and travels up and down. The upwards motion is to be triggered on a mouse click.

#### Constants

-   **Max fall speed** caps the rate at which the bird can fall

-   **Acceleration**: To be added to fall speed

-   **Up speed**: To be added while ascending

#### Important Signals

-   **Ascending**: (_Flag_) Set to 1 if the bird is currently ascending

-   **Bird on**: Outputs 1 if the bird sprite is present in the current vsync pixel (x,y).

-   **Size**: (_Constant_) determines how much space the bird will take up relative to its center.

-   **Y Motion**: Acts as fall speed, can be positive or negative.

-   **Mouse In**: 1 or 0, comes from PS/2 mouse module

#### Game state

-   **Game Over**
    Do not accept user inputs

-   **Game Start**
    Stay in middle of screen

-   **Gameplay (Game/Training)**
    _See below_

#### Implementation Details

**On:**

VGA_SYNC (Normal Operation)

```
IF mouse is pressed
    - Set fall speed to go up
ELSE IF mouse is NOT pressed (bird is falling)
    - Minus CONST from fall speed
    - Add fall speed (negative) to y position
```

VGA_SYNC (Edge cases)

```
IF at ground
    - Set fall speed to 0
Else if at top
    - Set Rise speed to 0
```

### Pipe

#### Requirements

The pipe is an entity which has a random height gap with a constant width, starts from the right of the screen and stops operation when it passes the left side of the screen.

#### Constants

-   **Pipe Gap**: Distance from the end of the pipe to the start of the next gap

-   **Pipe Width**: Distance from start of pipe top end of pipe

-   **Random Heights**: Vector of fixed size containing different pipe Heights

#### Important Signals

-   **Init**: Sets a scrolling speed

-   **Enable Next**: Inits the next pipe

-   **Scroll speed**: Input from FSM that determines how fast the pipes will scroll

-   **L Offset**: How far the start of the pipe is from the start of the screen

-   **Pipe Index**: Randomly generated number to index a height from the random height vector

-   **Reset**: Sets the pipe position to off the screen

-   **Scroll Speed**: How fast the pipes scroll, determined by game difficulty

#### Game State

-   **Game Over**: All pipes stop scrolling

-   **Game Start**: All pipes reset

-   **Game (Train)**: All pipes scrolling

-   **Game (Normal)**: All pipes scrolling, depends on game mode

#### Implementation

**On:**

Init:

```
Store a random height using the random index
Set scroll speed to input scroll speed
```

Reset:

```
Set L offset to 639 (Max width) and scroll speed to 0
```

VGA_Sync:

```
Move left by scroll speed (decrease L offset)
```

**VGA Display Conditions:**

```
PIPE_ON IF
(column >= L offset) AND (column <= L+Pipe Width)
***AND***
(row =< Pipe Height) AND (row >= Pipe Height + Pipe Gap)
```

### Display MUX

#### Requirements

This multiplexer requires bus inputs for **R,G,B** for the following components:

-   Background x 1
-   Bird x 1
-   Pipe x 5
-   Ground x 1
-   Text x 1

The select input will need to be priority encoded

#### Important Signals

-   **RGB Inputs**: These come from every display component
-   **RGB Outputs**: Three signals, RGB to be sent to the vga sync
-   **Select**: Comes from the "On" signal of each component

#### Implementation Details

```
 Chain 2x1 MUX for non pipes to create a priority multiplexer
 Create a separate MUX for all the pipes that feeds into the MUX chain
```

The priority should be as follows:

1. Text
2. Bird
3. Ground
4. Pipes
5. Background

### Collision Detection

#### Requirements

This will output a bit that is fed into the FSM when the bird touches the ground or pipe

#### Important Signals

-   **Reset**: resets the output back to 0 (for game restart)

### Random Number Generator

#### Requirements

This will generate a random number within a range to be fed into the pipes. (Possibly clock triggered?)

#### Important Signals

-   **Number**: The number generated, likely represented as STD_LOGIC_VECTOR

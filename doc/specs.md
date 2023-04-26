# Entity Specifications

This document is to be used for planning and documenting the implementaion details of each entity.

> _Every significant change to the implementation is to accompany an update to this document_

## Entities

### Bird

#### Requirements

The _Bird_ is a sprite that is fixed horizontally on the screen, and travels up and down. The upwards motion is to be triggered on a mouse click.

#### Constants

-   **Acceleration**: To be added to fall speed

-   **Up speed**: To be added while ascending

#### Important Signals

-   **Counter** Used to track how long the bird will be travelling up for

-   **Ascending**: (_Flag_) Set to 1 if the bird is currently ascending

-   **Ball on**: Outputs 1 if the bird sprite is present in the current vsync pixel (x,y).

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

Mouse in

```
IF HIGH:
- Check if bird is already ascending
    IF NO
    - Set ascending flag to TRUE
    - Set counter to zero
    ELSE
    - Do nothing
```

VGA_SYNC (Normal Operation)

```
IF ascending flag is set
    IF counter < MAX
    - Increment y position by CONST
    - Increment counter
    ELSE IF counter = MAX
    - Set ascending flag to FALSE
    - Set fall speed to 0
ELSE IF ascending flag is NOT set (bird is falling)
    - Minus CONST from fall speed
    - Add fall speed (negative) to y position
```

VGA_SYNC (Edge cases)

```
IF at ground
    - Set fall speed to 0
Else if at top
    - Do not increment y pos
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

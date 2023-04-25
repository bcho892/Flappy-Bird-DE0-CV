# Entity Specifications

This document is to be used for planning and documenting the implementaion details of each entity.

> _Every significant change to the implementation is to accompany an update to this document_

## Entities

### Bird

#### Requirements

The _Bird_ is a sprite that is fixed horizontally on the screen, and travels up and down. The upwards motion is to be triggered on a mouse click.

#### Constants

- **Acceleration**: To be added to fall speed

- **Up speed**: To be added while ascending

#### Important Signals

- **Counter** Used to track how long the bird will be travelling up for

- **Ascending**: (_Flag_) Set to 1 if the bird is currently ascending

- **Ball on**: Outputs 1 if the bird sprite is present in the current vsync pixel (x,y).

- **Size**: (_Constant_) determines how much space the bird will take up relative to its center.

- **Y Motion**: Acts as fall speed, can be positive or negative.

- **Mouse In**: 1 or 0, comes from PS/2 mouse module

#### Game state

- **Game Over**
Do not accept user inputs

- **Game Start** 
Stay in middle of screen

- **Gameplay (Game/Training)**
*See below*

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

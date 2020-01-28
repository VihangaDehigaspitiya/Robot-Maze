/* Maze
 * Author: Vihanga
 * Creation date: 12/12/2019
 */
MACHINE
    Maze
    
SETS
    STATE_MESSAGES = {cant_move_obstacle_in_the_way, out_of_boundary, cant_immediately_teleport_to_exit, moved_North, moved_South, moved_West, moved_East, teleported, cannot_teleport_to_the_same_node}

    
CONSTANTS
    CORDINATE_X, CORDINATE_Y,
    Obstacle,
    Exit
    
PROPERTIES
    CORDINATE_X = 1..7 &
    CORDINATE_Y = 1..5 &
    
    Obstacle : CORDINATE_X <-> CORDINATE_Y &
    Obstacle = {(2 |-> 1), (6 |-> 1), (4 |-> 2), (6 |-> 2), (1 |-> 3), (2 |-> 3), (3 |-> 3), (4 |-> 3), (4 |-> 4), (6 |-> 4), (7 |-> 4), (2 |-> 5)} &
    
    Exit = (1 |-> 5)

END

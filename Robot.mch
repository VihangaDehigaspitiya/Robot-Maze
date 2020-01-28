/* Robot
 * Author: Vihanga
 * Creation date: 12/12/2019
 */
MACHINE
    Robot
SEES Maze
    
VARIABLES
    //x,y cordinate of the robot
    robot_X, robot_Y,
    //path of the robot
    robot_Path
    
INVARIANT
    robot_X : NATURAL1 &
    robot_Y : NATURAL1 &
    robot_Path : seq(CORDINATE_X * CORDINATE_Y)
    
INITIALISATION
    robot_X, robot_Y, robot_Path := 1, 1, []
    
DEFINITIONS

    //Animation Functions
    ANIMATION_FUNCTION == ({ y, x, i | x:CORDINATE_X & y:CORDINATE_Y & i=0 });
    ANIMATION_FUNCTION1 == ({ y, x, i | x:CORDINATE_X & y:CORDINATE_Y  & i=1 & (x, 6-y) : Obstacle });
    ANIMATION_FUNCTION2 == ({ y, x, i | x:CORDINATE_X & y:CORDINATE_Y & i=2 & x=robot_X & y=(6-robot_Y) });
    
    //Grid Images
    ANIMATION_IMG0 == "/Images/white.gif";
    ANIMATION_IMG1 == "/Images/black.gif";
    ANIMATION_IMG2 == "/Images/robot.gif";
    
OPERATIONS

    /*
    Moving robot to the nothern(up) node
    @validation1 - check if the visiting node is in the grid or not
    @validation2 - check if the visitiong node is obstacle or not
    */
    result <-- MoveNorth =
        BEGIN
            IF
                robot_Y + 1 /: CORDINATE_Y
            THEN
                result := out_of_boundary
            ELSE
                IF
                    robot_X |-> (robot_Y + 1) : Obstacle
                THEN
                    result := cant_move_obstacle_in_the_way
                ELSE
                    robot_Path, robot_Y := robot_Path <- (robot_X, robot_Y), robot_Y + 1 ||
                    result := moved_North
                    
                END
            END
       END;
       
    /*
    Moving robot to the southern(down) node
    @validation1 - check if the visiting node is in the grid or not
    @validation2 - check if the visitiong node is obstacle or not
    @return - information message from the 'STATE_MESSAGES' set
    */
    result <-- MoveSouth =
        BEGIN
            IF
                robot_Y - 1 /: CORDINATE_Y
            THEN
                result := out_of_boundary
            ELSE
                IF
                    robot_X |-> (robot_Y - 1) : Obstacle
                THEN
                    result := cant_move_obstacle_in_the_way
                ELSE
                    robot_Path, robot_Y := robot_Path <- (robot_X, robot_Y), robot_Y - 1 ||
                    result := moved_South
                    
                END
            END
       END;
       
    /*
    Moving robot to the eastern(right) node
    @validation1 - check if the visiting node is in the grid or not
    @validation2 - check if the visitiong node is obstacle or not
    @return - information message from the 'STATE_MESSAGES' set
    */
    result <-- MoveEast  =
        BEGIN
            IF
                robot_X + 1 /: CORDINATE_X
            THEN
                result := out_of_boundary
            ELSE
                IF
                    (robot_X + 1) |-> (robot_Y) : Obstacle
                THEN
                    result := cant_move_obstacle_in_the_way
                ELSE
                    robot_Path, robot_X := robot_Path <- (robot_X, robot_Y), robot_X + 1 ||
                    result := moved_East
                    
                END
            END
       END;
       
       
    /*
    Moving robot to the western(left) node
    @validation1 - check if the visiting node is in the grid or not
    @validation2 - check if the visitiong node is obstacle or not
    @return - information message from the 'STATE_MESSAGES' set
    */
    result <-- MoveWest  =
        BEGIN
            IF
                robot_X - 1 /: CORDINATE_X
            THEN
                result := out_of_boundary
            ELSE
                IF
                    (robot_X - 1) |-> (robot_Y) : Obstacle
                THEN
                    result := cant_move_obstacle_in_the_way
                ELSE
                    robot_Path, robot_X := robot_Path <- (robot_X, robot_Y), robot_X - 1 ||
                    result := moved_West
                    
                END
            END
       END;
       
    /*
    Moving robot to the node which is entered by the user
    @parameter1(pos_X) - x cordinate of the user's input
    @parameter1(pos_Y) - y cordinate of the user's input
    @validation1 - check if the robot is in the initial stage
    @validation2 - check if the visitiong node is obstacle or not
    @validation3 - check if the visiting node is in the grid or not
    @validation4 - check if the visitiong node is current node of the robot or not
    @return - information message from the 'STATE_MESSAGES' set
    */
    result <-- Teleport (pos_X, pos_Y) = 
        PRE
            pos_X : NATURAL1 &
            pos_Y : NATURAL1 
        THEN
            IF
                (pos_X |-> pos_Y) = Exit &
                size(robot_Path) = 0
            THEN
                result := cant_immediately_teleport_to_exit
            ELSE
                IF
                    (pos_X |-> pos_Y) : Obstacle
                THEN
                    result := cant_move_obstacle_in_the_way
                ELSE
                    IF
                        pos_X /: CORDINATE_X &
                        pos_Y /: CORDINATE_Y
                    THEN
                        result := out_of_boundary
                    ELSE
                        IF
                            (pos_X |-> pos_Y) = (robot_X |-> robot_Y)
                        THEN
                            result := cannot_teleport_to_the_same_node
                        ELSE
                            robot_X, robot_Y,  robot_Path := pos_X, pos_Y, robot_Path <- (robot_X, robot_Y) ||
                            result := teleported
                        END
                    END
                 END
             END
         END;
         
    /*
    Get current position of the robot
    @return - (x,y) cordinate of the robot
    */
    state <-- getPosition =
        BEGIN
            state := (robot_X |-> robot_Y)
        END;
        
    /*
    Check if robot found the exit or not
    @return - true or false (boolean)
    */
    state <-- foundExit =
        BEGIN
            IF
                (robot_X |-> robot_Y) /= Exit
            THEN
                state := FALSE
            ELSE
                state := TRUE
            END
        END;
        
    /*
    Check if robot visited a specific node or not
    @parameter1(pos_X) - x cordinate of the node
    @parameter1(pos_Y) - y cordinate of the node
    @return - true or false (boolean)
    */
    state <-- visitedSquare(pos_X, pos_Y) = 
        PRE
            pos_X : CORDINATE_X &
            pos_Y : CORDINATE_Y
        THEN
            IF
                (pos_X |-> pos_Y) /: ran(robot_Path)
            THEN
                state := FALSE
            ELSE
                state := TRUE
            END
        END;
        
    /*
    Get path of the robot
    @return - (x,y) cordinate that robot has been visisted
    */
    state <-- robotsRoute = 
        BEGIN
            state := robot_Path
        END
     
            
END

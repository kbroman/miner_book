# Random Walks in the Minecraft World

Let's first find out which player you are. We will connect to our minecraft server, retrieve the IDs of all currently playing players, as well as their current positions. We'll then go into a quick `Sys.sleep` at which time you should try and move your player around in the minecraft world. Assuming no one else has been moving or dying you should catch your player ID's in a variable called `me`.


```r
mc_connect('52.168.137.73')
whoami <- function() {

  ids <- getPlayerIds()
  prev_pos <- sapply(ids, getPlayerPos)
  Sys.sleep(10)
  # move around in game
  new_pos <- sapply(ids, getPlayerPos)
  ids[(which.max(colSums(abs(new_pos - prev_pos))))]

}
me <- whoami()
```

## Recurrent Random Walks

Let's try a random walk in one and two dimensions. These should be recurrent, so you shouldn't find your character drifting too far out of the Minecraft world.

We will first retrieve our position again in the Minecraft world. We will then randomly step in the minecraft lattice, provided by the awesome Maze in [the Maze vignette](https://github.com/kbroman/miner/blob/master/extra_vignettes/maze.md)


```r
my_pos <- getPlayerPos(me)
n_moves <- 1000
moves <- replicate(n_moves, c(0,0,0))

move_right <- function(me) {

  # move right
  turnLeft(me, angle = -90)
  # look for wall
  wall <- lookForward(me, 0.5)[1] != 0

  if (wall == FALSE) {

    moveForward(me, 0.5)
    make_move(me, phase = 1)
  } else {
    #
    turnLeft(me, angle = -90)
    # turnLeft(me, angle = -90)
    move_right(me)
  }

}


make_move <- function(id = me, phase = 1) {

  if (phase == 2) {

    # look for wall to the right
    turnLeft(me, -90)
    check_pos <- lookForward(me, 0.5)
    turnLeft(me, 90)

    if (check_pos[1] != 0) {
      # situation 3
      # wall to the right
      # follow wall to the right
      turnLeft(me, -180)
      moveForward(me, 0.5)
      turnLeft(me, 90)
    } else { # situation 1 or 2
      turnLeft(me, -90)
      moveForward(me, 0.5)
      turnLeft(me, 90)
      wall_in_front <- lookForward(me, 0.5)
      if (wall_in_front[1] == 0) {
        # situation 1
        moveForward(me, 0.5)
        turnLeft(me, 90)

      } else {
      # situation 2
        turnLeft(me, -90)
        moveForward(me, 0.5)
        turnLeft(me, 90)
      }
    }
  }

  if (phase == 1) { # while no wall

    # is there any wall in front
    next_pos <- sample(c(0.5, 0.5), size = 1)
    check_pos <- lookForward(me, distance = next_pos)

    if (check_pos[1] == 0) {
      ## no wall move forward
      moveForward(player_id = id, next_pos)
    } else {
      # start phase 2, move against wall
      phase <- 2
    }
  }

  new_pos <- getPlayerPos(id)
  moves[, i] <<- new_pos


  return(phase)

}

initHeading(me)

phase <- 1
for (i in 1:n_moves) {
  phase <- make_move(me, phase)
}
```

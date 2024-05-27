# TODO List

## Issues

### 1. Change Infection Calculation Method and Cellular Automata??
- **Description**: My code currently uses Euclidean distance to determine infection spread. Update the code to use Moore neighborhood for infection or find an alternative way.(New code allow user to choose their methods)
- **Status**: Closed
- **Tasks**:
  - [x] try to update the infection calculation logic in the simulation code.
  - [x] find other way to have cellular automata.
  - [x] Verify results and compare with previous implementation.
### 2. Implement Variation of Infection Radius
- **Description**: infection radius implementation is still very primitive meaning as long as it is in the infection radius it has the same infection probability.(to hard giveup on thinking about it a simple uniform probability is enough i think)
- **Status**: Hanging
- **Tasks**:
  - [x] Think about it more lol.
  - [x] Implement a prototype.
  - [x] See how the infection radius is going to work with variation in value (having overlaying infection radius affecting the probability)
  - [x] Compare it with expected scenario ?
### 3. Improving Immunity/Recovery State
- **Description**: ~~The immunity is still complete immunity for set number of days instead of probability based immunity~~ Basically, recovered agents now have a 'resistance' to reinfection. Their probability of reinfection decreases with time, and decreases by 0.75 every time infected again (initally has max reinfection probability of 60% for now)(is this a little overkill ??)
- **Status**: Did this, but could be better. 
- **Task**:
  - [ ] ~~Still don't know what to do with this yet~~
  - [ ] could change equation used to model disease tolerance/resillience better
### 4. Improving Random walks
- **Description**: Random walks is still primitive need to be improve
- **Status**:Open
- **Task**:
  - [ ] possible implementation: bias random walks, random walks on already define pattern, corelated random walks ??
        Actually, drifting towards an epicentre is really easy but maybe not worth it since it'll slow down the execution time with all the if statements compared to Tom's current one line version. 
  - [ ] implement a path tracer for 1 particle to check if needed
  - [ ] implementation time
  - [ ] compare to human trajectory in some closed space ?
## Completed Tasks
- 1, 2
## Ongoing Tasks
 - more reading on continuous automata and continuous spatial automaton
 - more random walks
 - possible implementation of infection trail using a model of continuous automaton(currently useless but i thought it would be interesting)
   - this cellular automaton won't check for the cell surrounding value but the rate of change of the value around it and having the infected particle have maximum value of 1 which is 100% infection spreading rate and the surrounding decrease in a slow ? manners and if the particle don't have any reinforcement from infected particle the infection slowly decay to 0


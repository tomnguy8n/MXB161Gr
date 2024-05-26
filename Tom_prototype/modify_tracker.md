%# Modify Tracker
## Tracking what i change on the local machine for everyone
### ImprovedVer:
* change the probability of infection to $1 - (1 - p)^x$ where p is the infection probability and x is the number of infection patient around them. This would simplify the if statement to 2 case instead of multiple 
* added a real-time graph update
* added immunity period
* changing the moore neighborhood to euclidean distance(questionable change really) I thought it would bring more performance and less complicated but also mirror the real world more
* added a time counter for anyone who want to benchmark there test mine was 324s to simulate 100 agent at 1000 steps with infection probability of 0.3 and radius of infection of 4

### ImprovedVer_addedResistance:
* moved axis equals up so graph doesn't wiggle
* removed immunity period (recovered agents stay in 'recovered' state) - changed to a step counter for recovered agents
* added resistance for recovered agents based on an S curve (equation: p_reinfection = 0.3tanh(0.08(steps)-2)+0.3) - currently they initially have a max of 40%-60% chance of reinfection (ie when immunity wears off after ~65 steps), which decreases by 0.75 each time they get infected again.
* their reinfection probability increases with time (immunity reduces).
* every agent has a random 'reinfection immunity' (currently from 40%-60% max chance of reinfection)

### Modular_ver:
* implement multiple choice for neighborhood
* implement multiple visualization techniques
* implement a simpler version of immunity and resistance model after $1-(1-p)^x$ where p is the reinfection probability and reinfection probability is model after $p = (p1)^n * p0$ where p1 is how much the chance of reinfection is compare to the initial probability for example if reinfection effectiveness is 50% or 0.5 and the initial probability of infection is 20% then the reinfection probability is 10%. N is the number of recoveries the agent has gone through
* every time an agent heal its immunity time after it recover is increase by 1 steps
* I'm still on the fence with implementing more infection mechanism I'm wondering implementing things like more random walks and maybe even death or turning image into map for the particle to interact with just like what obi recommended
### Modular_ver*1:
* small updates on dead
* if a cell is dead they won't be able to move anymore

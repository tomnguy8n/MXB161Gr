# Modify Tracker
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
* added resistance for recovered agents based on an S curve - currently they have a max of 60% chance of reinfection, which decreases by 0.75 each time they get infected again. Their infection probability increases with time (immunity reduces).
(Could look at disease tolerance/resillience models for better equation)

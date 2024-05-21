# Modify Tracker
## Tracking what i change on the local machine for everyone
### List:
* change the probability of infection to $' 1 - (1 - p)^x '$ where p is the infection probability and x is the number of infection patient aroudn them. This would simplify the if statement to 2 case instead of multiple 
* added a real-time graph update
* added immunity period
* changing the moore neighborhood to euclidean distance(questionable change really) I thought it would bring more performance and less complicated but also mirror the real world more
* added a time counter for anyone who want to benchmark there test mine was 324s to simulate 100 agent at 1000 steps with infection probability of 0.3 and radius of infection of 4


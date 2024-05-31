function agentPositions = random_walk(agentPositions, gridSize, agentStates)
    % Only move agents that are not dead
    alive_agents = agentStates ~= 3; % Find indices of agents that are not dead
    
    % Random walk: move agents to new positions
    agentPositions(alive_agents, :) = agentPositions(alive_agents, :) + randi([-1, 1], sum(alive_agents), 2);
    agentPositions = max(min(agentPositions, gridSize), 1); % Keep within bounds
end

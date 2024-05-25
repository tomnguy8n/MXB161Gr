function agentPositions = random_walk(agentPositions, gridSize)
    % Random walk: move agents to new positions
    nAgents = size(agentPositions, 1);
    agentPositions = agentPositions + randi([-1, 1], nAgents, 2);
    agentPositions = max(min(agentPositions, gridSize), 1); % Keep within bounds
end
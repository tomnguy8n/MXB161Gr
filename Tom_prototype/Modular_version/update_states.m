function [agentStates, agentInfectionTime, agentImmunityTime] = update_states(agentStates, agentInfectionTime, agentImmunityTime, infectionDuration, immunityDuration)
    % Update infection time and states using logical indexing
    infected_agents = (agentStates == 1);
    agentInfectionTime(infected_agents) = agentInfectionTime(infected_agents) - 1;
    recovered_agents = (agentInfectionTime == 0) & infected_agents;
    
    % Update states of recovered agents to recovered
    agentStates(recovered_agents) = 2;
    agentImmunityTime(recovered_agents) = immunityDuration;
    
    % Update immunity time and states for recovered agents
    recovered_agents = (agentStates == 2);
    agentImmunityTime(recovered_agents) = agentImmunityTime(recovered_agents) - 1;
    susceptible_agents = (agentImmunityTime == 0) & recovered_agents;
    agentStates(susceptible_agents) = 0; % Return to susceptible state
end

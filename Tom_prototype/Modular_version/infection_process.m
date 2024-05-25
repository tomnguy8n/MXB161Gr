function [newStates, newInfectionTime] = infection_process(agentStates, agentPositions, gridSize, p0, infectionRadius, neighborhoodType, infectionDuration, agentRecoveries, reinfectionProbBase)
    % Initialize new states and infection time arrays
    newStates = agentStates;
    newInfectionTime = zeros(size(agentStates));
    
    % Infection process using specified neighborhood
    for i = 1:numel(agentStates)
        if newStates(i) == 0 % Only consider susceptible agents
            nSurrounding = count_infected_neighbors(agentPositions(i, :), agentPositions, agentStates, gridSize, infectionRadius, neighborhoodType);
            
            % Calculate reinfection probability based on recoveries and number of infected neighbors
            if nSurrounding > 0
                if agentRecoveries(i) > 0
                    reinfectionProbability = (reinfectionProbBase) ^ agentRecoveries(i) * p0;
                else
                    reinfectionProbability = p0;
                end
                
                % Calculate the final infection probability considering all infected neighbors
                infectionProbability = 1 - (1 - reinfectionProbability) ^ nSurrounding;
                if rand <= infectionProbability
                    newStates(i) = 1;
                    newInfectionTime(i) = infectionDuration;
                end
            end
        end
    end
end

function nSurrounding = count_infected_neighbors(currentPos, agentPositions, agentStates, gridSize, infectionRadius, neighborhoodType)
    nSurrounding = 0;
    for surrounding_x = -infectionRadius:infectionRadius
        for surrounding_y = -infectionRadius:infectionRadius
            if strcmp(neighborhoodType, 'Moore')
                if surrounding_x == 0 && surrounding_y == 0
                    continue;
                end
            elseif strcmp(neighborhoodType, 'Neumann')
                if abs(surrounding_x) + abs(surrounding_y) > infectionRadius || (surrounding_x == 0 && surrounding_y == 0)
                    continue;
                end
            elseif strcmp(neighborhoodType, 'Euclidean')
                distance = sqrt(surrounding_x^2 + surrounding_y^2);
                if distance > infectionRadius || distance == 0
                    continue;
                end
            else
                error('Invalid neighborhood type');
            end
            check_x = currentPos(1) + surrounding_x;
            check_y = currentPos(2) + surrounding_y;
            if check_x >= 1 && check_x <= gridSize && check_y >= 1 && check_y <= gridSize
                % Find if there's an infected agent at this position
                neighborIndex = find(agentPositions(:,1) == check_x & agentPositions(:,2) == check_y, 1);
                if ~isempty(neighborIndex) && agentStates(neighborIndex) == 1
                    nSurrounding = nSurrounding + 1;
                end
            end
        end
    end
end

function epidemic_simulation(gridSize, nAgents, infectionDuration, immunityDuration, p0, nSteps, videoFile, neighborhoodType, infectionRadius, visualizationType, reinfectionProbBase, deathProbBase)
    % Initialize positions and states
    agentPositions = ceil(rand(nAgents, 2) * gridSize);
    agentStates = zeros(nAgents, 1); % 0 = Susceptible, 1 = Infected, 2 = Recovered, 3 = Dead
    agentInfectionTime = zeros(nAgents, 1); % Track infection duration
    agentImmunityTime = zeros(nAgents, 1); % Track immunity duration
    agentRecoveries = zeros(nAgents, 1); % Track number of recoveries
    
    % Initialize some agents as infected
    initiallyInfected = randperm(nAgents, 5);
    agentStates(initiallyInfected) = 1;
    agentInfectionTime(initiallyInfected) = infectionDuration;
    
    % Set up video writer
    writer = VideoWriter(videoFile);
    open(writer);
    
    % Initialize arrays to track counts
    susceptible_counts = zeros(nSteps, 1);
    infected_counts = zeros(nSteps, 1);
    recovered_counts = zeros(nSteps, 1);
    dead_counts = zeros(nSteps, 1); % Current number of dead individuals
    
    % Array to track agent states and positions over time
    agentStatesHistory = zeros(nAgents, nSteps);
    agentPositionsHistory = zeros(nAgents, 2, nSteps);
    
    % Get screen size and adjust figure size dynamically
    screenSize = get(0, 'ScreenSize');
    figWidth = screenSize(3) - 200;
    figHeight = screenSize(4) - 200;
    figPosition = [50, 50, figWidth, figHeight];
    
    % Create a figure for the real-time plot with specific size
    figure('Position', figPosition);
    
    % Subplot for the counts (this will always be the same)
    subplot('Position', [0.55, 0.1, 0.4, 0.8]); % Left, bottom, width, height
    hold on;
    susceptible_plot = plot(1:nSteps, susceptible_counts, 'g', 'LineWidth', 2);
    infected_plot = plot(1:nSteps, infected_counts, 'r', 'LineWidth', 2);
    recovered_plot = plot(1:nSteps, recovered_counts, 'b', 'LineWidth', 2);
    dead_plot = plot(1:nSteps, dead_counts, 'k', 'LineWidth', 2); % Dead: Black
    xlabel('Time Step');
    ylabel('Number of Agents');
    legend('Susceptible', 'Infected', 'Recovered', 'Dead');
    title('Epidemic Curve');
    hold off;
    xlim([1 nSteps]); % Set x-axis limits to cover all steps
    ylim([0 nAgents]); % Set y-axis limits to cover the range of agent counts
    
    % Start timing the simulation
    tic;
    
    % Simulation loop
    for step = 1:nSteps
        % Update infection time and states
        [agentStates, agentInfectionTime, agentImmunityTime, agentRecoveries] = update_states(agentStates, agentInfectionTime, agentImmunityTime, infectionDuration, immunityDuration, agentRecoveries, deathProbBase);
        
        % Random walk: move agents to new positions
        agentPositions = random_walk(agentPositions, gridSize);
        
        % Infection process using specified neighborhood
        [newStates, newInfectionTime] = infection_process(agentStates, agentPositions, gridSize, p0, infectionRadius, neighborhoodType, infectionDuration, agentRecoveries, reinfectionProbBase);
        
        % Update agent states and infection times
        agentStates = newStates;
        agentInfectionTime = max(agentInfectionTime, newInfectionTime); % Ensure new infection times are considered
        
        % Store agent states and positions in history
        agentStatesHistory(:, step) = agentStates;
        agentPositionsHistory(:, :, step) = agentPositions;
        
        % Plotting for the Cellular Automata Graph
        visualize_grid(agentPositions, agentStates, gridSize, step, visualizationType);
        
        % Update counts
        susceptible_counts(step) = sum(agentStates == 0);
        infected_counts(step) = sum(agentStates == 1);
        recovered_counts(step) = sum(agentStates == 2);
        dead_counts(step) = sum(agentStates == 3);
        
        % Update the real-time plot
        update_plot(susceptible_plot, infected_plot, recovered_plot, dead_plot, susceptible_counts, infected_counts, recovered_counts, dead_counts, step);
        
        % Capture frame for video
        frame = getframe(gcf);
        writeVideo(writer, frame);
    end
    
    % End timing the simulation
    elapsedTime = toc;
    
    close(writer); % Finalize the video file
    disp(['Video saved as ' videoFile]);
    disp(['Total simulation time: ' num2str(elapsedTime) ' seconds']);
end

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

function agentPositions = random_walk(agentPositions, gridSize)
    % Random walk: move agents to new positions
    nAgents = size(agentPositions, 1);
    agentPositions = agentPositions + randi([-1, 1], nAgents, 2);
    agentPositions = max(min(agentPositions, gridSize), 1); % Keep within bounds
end

function [agentStates, agentInfectionTime, agentImmunityTime, agentRecoveries] = update_states(agentStates, agentInfectionTime, agentImmunityTime, infectionDuration, immunityDuration, agentRecoveries, deathProbBase)
    % Update infection time and states using logical indexing
    infected_agents = (agentStates == 1);
    agentInfectionTime(infected_agents) = agentInfectionTime(infected_agents) - 1;
    recovered_agents = (agentInfectionTime == 0) & infected_agents;
    
    % Update states of recovered agents to recovered
    agentStates(recovered_agents) = 2;
    agentRecoveries(recovered_agents) = agentRecoveries(recovered_agents) + 1; % Increment recovery count
    agentImmunityTime(recovered_agents) = agentImmunityTime(recovered_agents) + immunityDuration; % Increase immunity duration after each recovery
    
    % Update immunity time and states for recovered agents
    recovered_agents = (agentStates == 2);
    agentImmunityTime(recovered_agents) = agentImmunityTime(recovered_agents) - 1;
    susceptible_agents = (agentImmunityTime == 0) & recovered_agents;
    agentStates(susceptible_agents) = 0; % Return to susceptible state

    % Determine death based on reinfections
    for i = find(infected_agents)'
        deathProb = (1 - deathProbBase) ^ agentRecoveries(i);
        if rand >= deathProb % Adjusted to reflect the decreased death probability
            agentStates(i) = 3; % Dead
        end
    end
end

function update_plot(susceptible_plot, infected_plot, recovered_plot, dead_plot, susceptible_counts, infected_counts, recovered_counts, dead_counts, step)
    % Update the real-time plot
    set(susceptible_plot, 'XData', 1:step, 'YData', susceptible_counts(1:step));
    set(infected_plot, 'XData', 1:step, 'YData', infected_counts(1:step));
    set(recovered_plot, 'XData', 1:step, 'YData', recovered_counts(1:step));
    set(dead_plot, 'XData', 1:step, 'YData', dead_counts(1:step));
    drawnow;
end

function visualize_grid(agentPositions, agentStates, gridSize, step, visualizationType)
    if visualizationType == 1
        % Visualization Type 1: Rectangles
        subplot('Position', [0.05, 0.1, 0.4, 0.8]); % Left, bottom, width, height
        cla;
        hold on;
        % Plot squares for agents using rectangle function
        for i = 1:numel(agentStates)
            if agentStates(i) == 0
                color = 'g'; % Susceptible: Green
            elseif agentStates(i) == 1
                color = 'r'; % Infected: Red
            elseif agentStates(i) == 2
                color = 'b'; % Recovered: Blue
            else
                color = 'k'; % Dead: Black
            end
            rectangle('Position', [agentPositions(i,1), agentPositions(i,2), 1, 1], 'FaceColor', color, 'EdgeColor', color, 'LineWidth', 1.5);
        end
        grid on; % Ensure the grid is on
        set(gca, 'xtick', 1:gridSize, 'ytick', 1:gridSize);
        set(gca, 'XTickLabel', [], 'YTickLabel', []); % Remove labels
        set(gca, 'GridColor', 'k', 'GridAlpha', 1, 'LineWidth', 1); 
        box on; % Add box around the plot
        axis([1 gridSize+1 1 gridSize+1]);
        axis square;
        hold off;
        title(sprintf('Step %d', step));
    elseif visualizationType == 2
        % Plotting
        subplot(1, 2, 1);
        cla;
        hold on;
        plot(agentPositions(agentStates == 0, 1), agentPositions(agentStates == 0, 2), 'go'); % Susceptible: Green
        plot(agentPositions(agentStates == 1, 1), agentPositions(agentStates == 1, 2), 'ro'); % Infected: Red
        plot(agentPositions(agentStates == 2, 1), agentPositions(agentStates == 2, 2), 'bo'); % Recovered: Blue
        plot(agentPositions(agentStates == 3, 1), agentPositions(agentStates == 3, 2), 'ko'); % Dead: Black
        axis([1 gridSize 1 gridSize]);
        hold off;
        title(sprintf('Step %d', step));
    end
end

epidemic_simulation(50, 100, 50, 80, 0.3, 1000, 'epidemicSimulationMooreRect.avi', 'Moore', 2, 1, 0.8, 0);

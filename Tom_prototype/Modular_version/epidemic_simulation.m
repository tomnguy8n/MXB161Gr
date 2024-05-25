function epidemic_simulation(gridSize, nAgents, infectionDuration, immunityDuration, p0, nSteps, videoFile, neighborhoodType, infectionRadius, visualizationType)
    % Initialize positions and states
    agentPositions = ceil(rand(nAgents, 2) * gridSize);
    agentStates = zeros(nAgents, 1); % 0 = Susceptible, 1 = Infected, 2 = Recovered
    agentInfectionTime = zeros(nAgents, 1); % Track infection duration
    agentImmunityTime = zeros(nAgents, 1); % Track immunity duration
    
    % Initialize some agents as infected
    initiallyInfected = randperm(nAgents, 5);
    agentStates(initiallyInfected) = 1;
    agentInfectionTime(initiallyInfected) = infectionDuration;
    
    % Set up video writer
    writer = VideoWriter(videoFile, 'Uncompressed AVI');
    open(writer);
    
    % Initialize arrays to track counts
    susceptible_counts = zeros(nSteps, 1);
    infected_counts = zeros(nSteps, 1);
    recovered_counts = zeros(nSteps, 1); % Current number of recovered individuals
    
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
    xlabel('Time Step');
    ylabel('Number of Agents');
    legend('Susceptible', 'Infected', 'Recovered');
    title('Epidemic Curve');
    hold off;
    
    % Start timing the simulation
    tic;
    
    % Simulation loop
    for step = 1:nSteps
        % Update infection time and states
        [agentStates, agentInfectionTime, agentImmunityTime] = update_states(agentStates, agentInfectionTime, agentImmunityTime, infectionDuration, immunityDuration);
        
        % Random walk: move agents to new positions
        agentPositions = random_walk(agentPositions, gridSize);
        
        % Infection process using specified neighborhood
        [newStates, newInfectionTime] = infection_process(agentStates, agentPositions, gridSize, p0, infectionRadius, neighborhoodType, infectionDuration);
        
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
        
        % Update the real-time plot
        update_plot(susceptible_plot, infected_plot, recovered_plot, susceptible_counts, infected_counts, recovered_counts);
        
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

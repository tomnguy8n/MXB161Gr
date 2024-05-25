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
            else
                color = 'b'; % Recovered: Blue
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
        hold off;
        title(sprintf('Step %d', step));
    end
end

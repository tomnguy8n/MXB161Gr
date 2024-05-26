function update_plot(susceptible_plot, infected_plot, recovered_plot, dead_plot, susceptible_counts, infected_counts, recovered_counts, dead_counts, step)
    % Update the real-time plot
    set(susceptible_plot, 'XData', 1:step, 'YData', susceptible_counts(1:step));
    set(infected_plot, 'XData', 1:step, 'YData', infected_counts(1:step));
    set(recovered_plot, 'XData', 1:step, 'YData', recovered_counts(1:step));
    set(dead_plot, 'XData', 1:step, 'YData', dead_counts(1:step));
    drawnow;
end

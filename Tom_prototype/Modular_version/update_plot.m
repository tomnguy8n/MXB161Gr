function update_plot(susceptible_plot, infected_plot, recovered_plot, susceptible_counts, infected_counts, recovered_counts)
    % Update the real-time plot
    set(susceptible_plot, 'YData', susceptible_counts);
    set(infected_plot, 'YData', infected_counts);
    set(recovered_plot, 'YData', recovered_counts);
    drawnow;
end

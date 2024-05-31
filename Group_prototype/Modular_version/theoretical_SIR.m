function [S,I,R,time] = theoretical_SIR(beta,gamma,delta,N,I0,T,dt)
    
    % initialise 'susceptable' array:
    S = zeros(1,T/dt);
    % Susceptable population at time 1 is equal to total population (assuming small initial infection count)
    S(1) = N;
    % Initialise 'infected' array:
    I = zeros(1,T/dt);
    % Infections at time 1 is equal to initial infection count.
    I(1) = I0;
    % Initialise 'recovered' array:
    R = zeros(1,T/dt);
    % Recovered at time 1 is equal to 0 since no infections have concluded in any ammount of people.
    time = 1:(T/dt);

    % For loop uses Euler's method to compute S,I,R arrays.
    % if delta = 0 we assume a model without immunity loss
    for tt = 1:(T/dt)-1
        % Equations of the model uses Euler's method for solving differential equations:
        dS = (-beta*I(tt)*S(tt) + delta*R(tt)) * dt;
        dI = (beta*I(tt)*S(tt) - gamma*I(tt)) * dt;
        dR = (gamma*I(tt) - delta*R(tt)) * dt;
        S(tt+1) = S(tt) + dS;
        I(tt+1) = I(tt) + dI;
        R(tt+1) = R(tt) + dR;
    end
end

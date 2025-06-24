clc; clear; close all;

% PARAMETERS
numQuadcopters = 15;        % Number of quadcopters in the swarm
discRadius = 0.25;          % Quadcopter treated as 0.5 m diameter disc
initialPosition = rand(2, numQuadcopters) * 15;   % Random initial positions (X,Y)
initialVelocity = randn(2, numQuadcopters) * 0.1; % Random initial velocities (X,Y)

% Load quadcopter image (top view)
quadImage = imread("Path");

% SETUP FIGURE
figure;
ax = gca;
hold(ax, 'on');
title(ax, 'Flocking Quadcopter Swarm');
xlabel(ax, 'X [m]');
ylabel(ax, 'Y [m]');

% SIMULATION PARAMETERS
numSteps = 120;                   % Number of time steps
goalDirection = [30; 0];          % Desired swarm drift direction (X positive)

% Initialize position and velocity
position = initialPosition;
velocity = initialVelocity;

% GIF filename
gifFilename = 'quadcopter_swarm.gif';

for t = 1:numSteps
    % Update position and velocity using flocking rules
    [position, velocity] = flockingStep(position, velocity, goalDirection);
    
    % Clear axes and set limits for plotting
    cla(ax);
    axis(ax, 'equal');
    xlim(ax, [-2 20]);
    ylim(ax, [-2 14]);

    % Plot each quadcopter as an image
    iconSize = 0.7; % Display size of quadcopter icon
    for i = 1:numQuadcopters
        xLeft = position(1,i) - iconSize/2;
        yBottom = position(2,i) - iconSize/2;
        image(ax, [xLeft, xLeft + iconSize], [yBottom, yBottom + iconSize], quadImage);
    end
    
    drawnow;
    
    % --- Capture and write frame to GIF ---
    frame = getframe(gcf);
    img = frame2im(frame);
    [imind, cm] = rgb2ind(img, 256);

    if t == 1
        imwrite(imind, cm, gifFilename, 'gif', 'Loopcount', inf, 'DelayTime', 0.01);
    else
        imwrite(imind, cm, gifFilename, 'gif', 'WriteMode', 'append', 'DelayTime', 0.01);
    end
    
    pause(0.005); % Small pause for smooth animation (optional)
end

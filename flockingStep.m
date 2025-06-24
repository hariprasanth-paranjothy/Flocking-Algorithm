% FUNCTION: Apply flocking rules to compute new position and velocity
function [newPosition, newVelocity] = flockingStep(position, velocity, goalDirection)
    numAgents = size(position,2);
    maxSpeed = 0.35;                         % Speed limit
    goalForce = 0.02 * goalDirection / norm(goalDirection);  % Normalized goal force
    
    newVelocity = velocity; % Initialize new velocity
    
    for i = 1:numAgents
        pos_i = position(:,i);
        vel_i = velocity(:,i);
        
        % All other agents (exclude self)
        othersPos = position;
        othersPos(:,i) = [];

        % --- Separation force: repel from nearby agents ---
        diff = pos_i - othersPos;
        dists = vecnorm(diff);
        sepForce = sum(diff ./ (dists.^2 + 1e-6), 2); % Avoid division by zero

        % --- Cohesion force: move toward center of mass of others ---
        centerOfMass = mean(othersPos, 2);
        cohForce = centerOfMass - pos_i;

        % --- Alignment force: align velocity with neighbors ---
        avgVelocity = mean(velocity(:, setdiff(1:numAgents,i)), 2);
        alignForce = avgVelocity - vel_i;

        % --- Combine forces ---
        force = 2.5 * sepForce + 1.5 * cohForce + 2.0 * alignForce + 2.0 * goalForce;

        % --- Update velocity ---
        newVelocity(:,i) = vel_i + 0.05 * force;

        % --- Enforce speed limit ---
        speed = norm(newVelocity(:,i));
        if speed > maxSpeed
            newVelocity(:,i) = newVelocity(:,i) * maxSpeed / speed;
        end
    end
    
    % Update position
    newPosition = position + newVelocity;
end

% returns 2D rotation matrix given an angle
function R = twoD_rotation(angle)
R = [cos(angle) -sin(angle);sin(angle) cos(angle)];
end
function x = double(p)
%DOUBLE Convert polygon to double.
%   If the polygon is bounded, DOUBLE returns the vertices in an Nx2
%   matrix. Otherwise, it returns a cell array whose first component is
%   the vertex matrix and whose second component is the vector of
%   interior normalized angles.

%   Copyright 1998 by Toby Driscoll.
%   $Id: double.m 298 2009-09-15 14:36:37Z driscoll $

if ~any(isinf(p.vertex))
  x = p.vertex;
  x = [real(x) imag(x)];
else
  x = { [real(p.vertex) imag(p.vertex)] p.angle };
end

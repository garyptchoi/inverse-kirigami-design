function L = perimeter(p)
%PERIMETER Perimeter of a polygon.

%   $Id: perimeter.m 298 2009-09-15 14:36:37Z driscoll $

if isinf(p)
  L = Inf;
else
  w = vertex(p);
  L = sum( abs( diff( w([1:end 1]) ) ) );
end
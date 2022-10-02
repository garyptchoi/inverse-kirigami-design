function M = plus(M,a)
%   Add a constant to the map (i.e., translate its image).

%   Copyright (c) 1998 by Toby Driscoll.
%   $Id: plus.m 298 2009-09-15 14:36:37Z driscoll $

% May need to swap arguments
if isa(M,'double') & isa(a,'crdiskmap')
  tmp = M;
  M = a;
  a = tmp;
end

if length(a)==1 & isa(a,'double')
  M.affine(:,2) = M.affine(:,2) + a;
  M.scmap = M.scmap + a;
  M = center(M,M.center{1}+a);
else
  error('Addition is not defined for these operands.')
end

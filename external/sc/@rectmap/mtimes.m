function M = mtimes(M,c)
%   Scale the image of a map by a complex constant.

%   Copyright (c) 1998 by Toby Driscoll.
%   $Id: mtimes.m 298 2009-09-15 14:36:37Z driscoll $

% May need to swap arguments
if isa(M,'double') & isa(c,'rectmap')
  tmp = M;
  M = c;
  c = tmp;
end

M.constant = c*M.constant;
M.scmap = c*M.scmap;

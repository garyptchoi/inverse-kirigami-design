function wp = eval(Md,zp)
%EVAL Evaluate differentiated SC map.
%   EVAL(MD,ZP), where MD is an SCMAPDIFF object and ZP is a vector of
%   points in canonical domain of the map, returns the derivative of the
%   map used to create MD at the points ZP.
%   
%   See also SCMAPDIFF, SCMAPDIFF/SUBSREF.

%   Copyright 1998 by Toby Driscoll.
%   $Id: eval.m 298 2009-09-15 14:36:37Z driscoll $

wp = evaldiff(Md.themap,zp);

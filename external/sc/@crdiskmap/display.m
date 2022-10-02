function out = display(M)
%DISPLAY Display parameters of a Schwarz-Christoffel crossratio disk map.

%   Copyright 1998 by Toby Driscoll.
%   $Id: display.m 298 2009-09-15 14:36:37Z driscoll $

p = polygon(M);
w = vertex(p);
beta = angle(p)-1;
cr = M.crossratio;
Q = M.qlgraph;

L = {' '; '  crdiskmap object:'; ' '};
L{4}='   Quadrilateral vertices        Prevertex crossratio  ';
L{5}=' ------------------------------------------------------';
for j = 1:length(cr)
  L{end+1}=sprintf('      %2i  %2i  %2i  %2i                   %8.5f',...
      Q.qlvert(:,j),cr(j));
end
wc = center(M);
if imag(wc) < 0
  s = '-';
else
  s = '+';
end
L{end+1} = ' ';
L{end+1} = sprintf('   Conformal center at %.4f %c %.4fi',real(wc),s,abs(imag(wc)));
L{end+1} = ' ';
L{end+1} = sprintf('   Apparent accuracy is %.2e',M.accuracy);
L{end+1} = ' ';


if nargout==0
  fprintf('%s\n',L{:})
else
  out = L;
end
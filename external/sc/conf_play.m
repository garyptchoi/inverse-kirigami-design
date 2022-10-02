p = polygon([1+i,-1+i,-1-i,1-i]);
f = diskmap(p);
f = center(f,0);

pts = rand(10,2)*2-1;


figure(1)
clf
plot(exp(i*linspace(0,2*pi,180)), '-k');
hold on, axis equal, axis off

res = 20;
[X,Y] = meshgrid((-(res-1):(res-1))/res,(-100:100)/100);
plot(evalinv(f,X+i*Y),'k')
[X,Y] = meshgrid((-100:100)/100,(-(res-1):(res-1))/res);
plot(evalinv(f,X'+i*Y'),'k')
saveas(gca, '/Users/ldudte/Desktop/conformal.png')

%plot(evalinv(f,pts(:,1)+i*pts(:,2)), '-or')


figure(2)
clf
hold on
plot(p)
plot(pts(:,1), pts(:,2), '-or')



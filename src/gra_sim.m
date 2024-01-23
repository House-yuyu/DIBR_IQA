function [quality_map] = gra_sim(Y1, Y2)



[rows, cols] = size(Y1);
dx = [1 0 -1; 1 0 -1; 1 0 -1]/3;
dy = dx';%·­×ª


T = 190;


if (rows <= cols)
     filter = 'motion';
else
    filter = 'average';
end

aveKernel = fspecial(filter,2);

aveY1 = conv2(Y1, aveKernel,'full');
aveY2 = conv2(Y2, aveKernel,'full');
Y1 = aveY1(1 : 2 : rows, 1 : 2 : cols);
Y2 = aveY2(1 : 2 : rows, 1 : 2 : cols);

IxY1 = conv2(Y1, dx, 'same');     
IyY1 = conv2(Y1, dy, 'same');    
gradientMap1 = sqrt(IxY1.^2 + IyY1.^2);

IxY2 = conv2(Y2, dx, 'same');     
IyY2 = conv2(Y2, dy, 'same');

gradientMap2 = sqrt(IxY2.^2 + IyY2.^2);
quality_map = (2*gradientMap1.*gradientMap2 + T) ./(gradientMap1.^2+gradientMap2.^2 + T);

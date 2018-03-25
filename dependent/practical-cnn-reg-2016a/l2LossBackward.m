function dx = l2LossBackward(x,r,p)
dx = 2 * p * (x - r) ;
dx = dx / (size(x,1) * size(x,2)) ;  % normalize by image size

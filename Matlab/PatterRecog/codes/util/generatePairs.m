function [xy x y] = generatePairs(xrange,yrange)
    % generate grid coordinates. this will be the basis of the decision
    % boundary visualization.
    [x, y] = meshgrid(xrange, yrange);

    xy = [x(:) y(:)]; % make (x,y) pairs as a bunch of row vectors.
end
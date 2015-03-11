
function bayesDecision(x,y,fnc)
    %cmap1 = [1 0.8 0.8; 0.95 1 0.95; 0.9 0.9 1];
    %cmap2 = cmap1 - 0.2;
    
    [m n] = size(x);
    [m nCls] = size(y);
    labelsL = decode1ofk(y);
     
    cmap2 = lines(nCls);
    cmap1 = (cmap2 + 0.6) * 1.2;
    cmap1(cmap1 > 1) = 1;
    
    
    mx = max(x,[],1);
    mn = min(x,[],1);  
    
    res = 100;
    
    rangex = linspace(mn(1),mx(1),res);
    
    if(n==2)
        rangey = linspace(mn(2),mx(2),res);
        xy = generatePairs(rangex, rangey);
    else
        xy = rangex';
    end
    
    [cls p] = bayes(xy,x,y,fnc);
    
    P = max(p);
    error = sum(p) - max(p);
    fprintf('Total error: %f', sum(error(:)));
    if(n==2)
        P = reshape(P, [res res]);
        colors = reshape(cmap1(cls,:),[res res 3]);       
        error = reshape(error,[res res]);

        figure;surf(P,colors);
        figure;surf(error,'faceColor','r');
    else 
        plot(p');
    end
    
end
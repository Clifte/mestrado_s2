
function showDecision(x,y,call,nCls)
    %cmap1 = [1 0.8 0.8; 0.95 1 0.95; 0.9 0.9 1];
    %cmap2 = cmap1 - 0.2;
    
    cmap2 = jet(nCls);
    cmap1 = (cmap2 + 0.6) * 1.25;
    cmap1(cmap1 > 1) = 1
    
    
    mx = max(x,[],1);
    mn = min(x,[],1);
    res = 100;
    
    rangex = linspace(mn(1),mx(1),res);
    rangey = linspace(mn(2),mx(2),res);

    
    xy = generatePairs(rangex, rangey);
    
    eval(call);
    %decisionmap = reshape(cls, [res res]);
    
   % imagesc([mn(1) mx(1)],[mn(2) mx(2)],decisionmap);    

    scatter(xy(:,1),xy(:,2),300,cmap1(cls,:),'filled')
    hold on;
    scatter(x(:,1),x(:,2),20,cmap2(y,:),'filled');


end
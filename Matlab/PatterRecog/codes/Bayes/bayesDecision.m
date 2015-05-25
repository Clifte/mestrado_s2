 
function bayesDecision(model)
    %cmap1 = [1 0.8 0.8; 0.95 1 0.95; 0.9 0.9 1];
    %cmap2 = cmap1 - 0.2;
    %teste

    x = model.data;
    y = model.labels;
    
    
    [m n] = size(x);
    [m nCls] = size(y);
    %labelsL = decode1ofk(y);
     
    cmap2 = lines(nCls+1);
    cmap1 = (cmap2 + 0.6) * 1.2;
    cmap1(cmap1 > 1) = 1;
    
    
    mx = max(x,[],1);
    %mn = min(x,[],1);
    mn = -mx;
    
    if( model.lim )
         mx = model.lim(2);
         mn = model.lim(1);
    end
    
    res = 200;
    
    rangex = linspace(mn(1),mx(1),res);
    

    [xy xx yy] = generatePairs(rangex, rangex);

    
    [cls p] = bayes(xy,model);
    
    P = max(p);
    error = sum(p) - max(p);
    
%    fprintf('Total error: %f', sum(error(:)));
    
    
    if(n==2)
        P = reshape(P, [res res]);
        colors = reshape(cmap1(cls,:),[res res 3]);
       
        values = (P/(3*max(max(P))) + 0.66);
        values(values>1) = 1;
        col2 = colors .* repmat(values,[1 1 3]);  
        
        error = reshape(error,[res res]);
        
        surf(xx,yy,P,col2,'edgecolor','none');hold on;
        
        
        if(model.exibirPontos)
            scatter3( x(:,1),x(:,2),ones(m,1)*20,...
                     ones(m,1) * 40, cmap1(decode1ofk(y),:),...
                     'filled','MarkerEdgeColor','k')
        end
        view([0 60]);
        %figure;surf(error,'faceColor','r','edgecolor','none');
        %figure;surf(error);
    else 
        plot(p');
    end
    
end
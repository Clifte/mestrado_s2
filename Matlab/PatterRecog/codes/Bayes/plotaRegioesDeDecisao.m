
if(strcmp(fnc ,'parzenGauss') && 0 == 1)
    figure; hold on
    plot(parzenSearchResult(:,[1])',parzenSearchResult(:,[2]) + parzenSearchResult(:,[3]),'r');
    plot(parzenSearchResult(:,[1])',parzenSearchResult(:,[2]),'b' );
    plot(parzenSearchResult(:,[1])',parzenSearchResult(:,[2])-parzenSearchResult(:,[3]),'r' );
    
    path = sprintf('%sfigura/%s_%s.eps',exportDir,base,'BAYES_ParzenSearch');
    saveas(gca, path,'epsc');
    
    [v l ] = max(parzenSearchResult);

    fprintf('*Tamanho da janela : %.4f\n',parzenSearchResult(l(2),1));
    fprintf('*Acurácia : %.4f\n',parzenSearchResult(l(2),2));
    fprintf('*Desvio padrão : %.4f\n',parzenSearchResult(l(2),3));
    
end

if(length(p)==2)
    xx = x(:,p);
    [xx ia] = unique(xx,'rows');
    yy = (y(ia,:));
    
    yl=yy;
    
    [tmp, clsT] = max(yy,[],2);

    lbda = lambda;    
    
    
    
    bayesDecision(xx,yy,lambda,fnc,[2 2; -2 -2]); 
    path = sprintf('%sfigura/%s/%s/%s_%s_%d_%d.eps',exportDir,fnc,base,base,'BAYES_BayesDecP1',p(1),p(2));
    set(gcf,'renderer','zbuffer') 
    saveas(gcf, path,'epsc');
    view([0 90]);
    path = sprintf('%sfigura/%s/%s/%s_%s_%d_%d.eps',exportDir,fnc,base,base,'BAYES_BayesDecP2',p(1),p(2));
    saveas(gcf, path,'epsc');
    
    
    showDecision(xx,clsT,'global yl;global lbda;global fnc;cls=bayes(xy,x,yl,lbda,fnc);',nClasses);
    path = sprintf('%sfigura/%s/%s/%s_%s_%d_%d.eps',exportDir,fnc,base,base,'BAYES_RegDec',p(1),p(2));
    saveas(gca, path,'epsc');
end


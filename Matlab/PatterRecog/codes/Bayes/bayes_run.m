addpath(genpath('../util/'))
clear all; clear;clc;close all;
warning('off','all')

exportDir = '../../../../Latex/ReconhecimentoDePadroes/trabalho2/matlab/';
%%
global yl;
global lbda;
global fnc;
global parzenh;
parzenh= 0.000005;


rangeParzenSearch = [0.01]; %linspace(0.001,3,50);
rangeParzenSearch = 0.005;
parzenSearchResult = zeros(50,3);

%%
%Configurações
base = 'iris';     %Nome da base
pTeste = 0.25;     %Percentual da base para teste
nIt = 0;         %Número de repetições para o cálculo da acurácia

%p = [1 3]; %parametro para a região de decisão. O indice indica qual atributo levar em conta
%p = [1  3];
p = [ 1 4];
lambda = [ 0 1 1 
           1 0 1
           1 1 0
           ];
       
fnc = 'ndiag';
%%
%Inicializa��o

[ x , y ,labels ] = carregaDatabase(base);


%Filtrar colunas desejadas e resolver problema das linhas duplicadas
x = x(:,p);

[x ia] = unique(x,'rows');
y = y(ia,:);

%Normalizando
x = bsxfun(@minus,x,min(x));
x = bsxfun(@rdivide,x,max(x));


[m n] = size(x);
[m nClasses] = size(y);



%%
acuracia = zeros(1,nIt);


meanCM = zeros(nClasses,nClasses);
meanPer = zeros(nClasses,4);
    
fprintf('Número de repetições %d:\n',nIt);
for ph = 1:length(rangeParzenSearch)
    parzenh = rangeParzenSearch(ph);
    for i=1:nIt
        [ xd yd xt yt ] = preparaDados( x , y, pTeste);

        clsC = bayes(xt,xd,yd,lambda,fnc);

        clsCEnc = encode1ofk(clsC',nClasses);

        [acc,cm,ind,per] = confusion(yt',clsCEnc');

        meanCM = meanCM + cm;
        %meanPer = meanPer + per;
        acuracia(i) = 1-acc;
    end
    CM = bsxfun(@rdivide,meanCM,sum(meanCM,2)');

    %Centroid médio
    csvwrite([exportDir base '_BAYES_cmNorm.csv'],CM);
    csvwrite([exportDir base '_BAYES_cmAnalise.csv'],meanPer);

    fprintf('Acurácia : %.4f\n',mean(acuracia));
    fprintf('Desvio padrão : %.4f\n',std(acuracia));
    
    parzenSearchResult(ph,1) = parzenh;
    parzenSearchResult(ph,2) = mean(acuracia);
    parzenSearchResult(ph,3) = std(acuracia);
end

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
    csvwrite([exportDir base '_BAYES_parzenSearchResult.csv'],CM);
end

if(length(p)==2)
    [tmp, clsT] = max(y,[],2);

    lbda = lambda;
 
    yl=y;
    
    bayesDecision(x,y,lambda,fnc,[2 2; -2 -2]); 
    path = sprintf('%sfigura/%s_%s_%d_%d.eps',exportDir,base,'BAYES_BayesDecP1',p(1),p(2));
    set(gcf,'renderer','zbuffer') 
    saveas(gcf, path,'epsc');
    view([0 90]);
    path = sprintf('%sfigura/%s_%s_%d_%d.eps',exportDir,base,'BAYES_BayesDecP2',p(1),p(2));
    saveas(gcf, path,'epsc');
    
    
    showDecision(x,clsT,'global yl;global lbda;global fnc;cls=bayes(xy,x,yl,lbda,fnc);',nClasses);
    path = sprintf('%sfigura/%s_%s_%d_%d.eps',exportDir,base,'BAYES_RegDec',p(1),p(2));
    saveas(gca, path,'epsc');
end



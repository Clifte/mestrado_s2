addpath(genpath('../util/'))
clear all; clear;clc;close all;
warning('off','all')

exportDir = '../../../../Latex/ReconhecimentoDePadroes/trabalho1/matlab/';
%%
global C;
%%
%Configurações
base = 'iris';     %Nome da base
pTeste = 0.25;     %Percentual da base para teste
nIt = 100;         %Número de repetições para o cálculo da acurácia

p = [1 3]; %parametro para a região de decisão. O indice indica qual atributo levar em conta

%%
%Inicialização
[ x , y ,labels ] = carregaDatabase(base);

%Filtrar colunas desejadas e resolver problema das linhas duplicadas
x = x(:,p);
[x ia] = unique(x,'rows');
y = y(ia,:);

[m n] = size(x);
[m nClasses] = size(y);

%%
acuracia = zeros(1,nIt);
centroids = zeros(nClasses,n,nIt);
meanCM = zeros(nClasses,nClasses);
meanPer = zeros(nClasses,4);
    
for i=1:nIt
    [ xd yd xt yt ] = preparaDados( x, y, pTeste);

    C = DMC_centroids(xd,yd);
    centroids(:,:,i) = C;
    %Aplica o DMC em todas amostras retornando apenas a classe
    %sem codificação
    clsC = DMC(C,xt);
    clsCEnc = encode1ofk(clsC,nClasses);
    
    [acc,cm,ind,per] = confusion(yt',clsCEnc');

    meanCM = meanCM + cm;
    %meanPer = meanPer + per;
    acuracia(i) = 1-acc;
end
CM = bsxfun(@rdivide,meanCM,sum(meanCM,2)');

%Centroid médio
csvwrite([exportDir base '_DMC_meanCentroid.csv'],mean(centroids,3));
csvwrite([exportDir base '_DMC_STDCentroid.csv'],std(centroids,0,3));
csvwrite([exportDir base '_DMC_cmNorm.csv'],CM);
csvwrite([exportDir base '_DMC_cmAnalise.csv'],meanPer);

fprintf('Acurácia obtida após %d repetições: %.4f\n',nIt,mean(acuracia));
fprintf('Desvio padrão da acurácia obtida após %d repetições: %.4f\n',nIt,std(acuracia));

if(length(p)==2)
    [tmp, clsT] = max(y,[],2);
    showDecision(x,clsT,'global C;cls=DMC(C,xy);',nClasses);
    scatter(C(:,1),C(:,2),80,'k','fill');
    path = sprintf('%sfigura/%s_%s_%d_%d.eps',exportDir,base,'DMC_RegDec',p(1),p(2));
    saveas(gca, path,'epsc');    
    
end

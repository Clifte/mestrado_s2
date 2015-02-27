addpath(genpath('../util/'))
clear all; clear;clc;close all;
warning('off','all')

exportDir = '../../../../Latex/ReconhecimentoDePadroes/trabalho1/matlab/';
%%
global C;
%%
%Configura��es
base = 'iris';     %Nome da base
pTeste = 0.25;     %Percentual da base para teste
nIt = 100;         %N�mero de repeti��es para o c�lculo da acur�cia

%p = [1 3]; %parametro para a regi�o de decis�o. O indice indica qual atributo levar em conta
p = [1 2 3 4];
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
centroids = zeros(nClasses,n,nIt);
meanCM = zeros(nClasses,nClasses);
meanPer = zeros(nClasses,4);
    
for i=1:nIt
    [ xd yd xt yt ] = preparaDados( x, y, pTeste);

    C = DMC_centroids(xd,yd);
    centroids(:,:,i) = C;
    %Aplica o DMC em todas amostras retornando apenas a classe
    %sem codifica��o
    clsC = DMC(C,xt);
    clsCEnc = encode1ofk(clsC,nClasses);
    
    [acc,cm,ind,per] = confusion(yt',clsCEnc');

    meanCM = meanCM + cm;
    %meanPer = meanPer + per;
    acuracia(i) = 1-acc;
end
CM = bsxfun(@rdivide,meanCM,sum(meanCM,2)');

%Centroid m�dio
csvwrite([exportDir base '_DMC_meanCentroid.csv'],mean(centroids,3));
csvwrite([exportDir base '_DMC_STDCentroid.csv'],std(centroids,0,3));
csvwrite([exportDir base '_DMC_cmNorm.csv'],CM);
csvwrite([exportDir base '_DMC_cmAnalise.csv'],meanPer);

fprintf('Acur�cia obtida ap�s %d repeti��es: %.4f\n',nIt,mean(acuracia));
fprintf('Desvio padr�o da acur�cia obtida ap�s %d repeti��es: %.4f\n',nIt,std(acuracia));

if(length(p)==2)
    [tmp, clsT] = max(y,[],2);
    showDecision(x,clsT,'global C;cls=DMC(C,xy);',nClasses);
    scatter(C(:,1),C(:,2),80,'k','fill');
    path = sprintf('%sfigura/%s_%s_%d_%d.eps',exportDir,base,'DMC_RegDec',p(1),p(2));
    saveas(gca, path,'epsc');    
    
end

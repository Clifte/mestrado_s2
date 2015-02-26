addpath(genpath('../util/'))
clear all; clear;clc;close all;
warning('off','all')

exportDir = '../../../../Latex/ReconhecimentoDePadroes/trabalho1/matlab/';

global yl;
global xd;
global yd;

%%
%Configurações
base = 'iris';
pTeste = 0.25;
nIt = 1;
%valores que serão utilizados na pesquisa de k
kSearch = [1:20  25:5:60  70:10:150];
kSearch = 1;
%parametro para a região de decisão
p = [1 4];
%%
%Inicializa��o
[ x , y ,labels ] = carregaDatabase(base);

%Filtra colunas desejadas e introduz problema das linhas duplicadas
x = x(:,p);
[x ia] = unique(x,'rows');
y = y(ia,:);

yl = y;
     
[m n] = size(x);
[m nClasses] = size(y);

%%
result = zeros(length(kSearch),3);
result2 = zeros(length(kSearch),nIt);

for contk=1:length(kSearch)
    k = kSearch(contk);
    acuracia = zeros(1,nIt);
    meanCM = zeros(nClasses,nClasses);
    meanPer = zeros(nClasses,4);
    for i=1:nIt
        [ xd yd xt yt ] = preparaDados( x, y, pTeste);
        xd = x;
        yd = y;
        xt = x;
        yt = y;
        
        
        acc=0;
        
        clsC = knn(xd,yd,xt,k);
        clsCEnc = encode1ofk(clsC,nClasses);
        
        [tmp clsT] = max(yt');
        
        %acc = sum(clsC == clsT');
        [acc,cm,ind,per] = confusion(yt',clsCEnc');
        
        %acuracia(i) = (acc/size(xt,1));
        acuracia(i) = 1 - acc;
        meanCM = meanCM + cm;
        meanPer = meanPer + per;
    end

     meanPer = meanPer./nIt;
        
    result(contk,:) = [ k mean(acuracia) std(acuracia)];
    result2(contk,:) = acuracia;
end
result
% 


%csvwrite([exportDir base '_acuracia.csv'],result);
boxplot(result2',kSearch);
plot(result(:,1),result(:,[2 3]));
title('Acurácia em função do valor de K');

if(length(p)==2)
    [tmp, clsT] = max(y,[],2); 
    showDecision(x,clsT,'global yl;cls=knn(x,yl,xy,1);',nClasses)
    title('K=1');
    showDecision(x,clsT,'global yl;cls=knn(x,yl,xy,10);',nClasses)
    title('K=5');
    showDecision(x,clsT,'global yl;cls=knn(x,yl,xy,50);',nClasses)
    title('K=50');
    showDecision(x,clsT,'global yl;cls=knn(x,yl,xy,75);',nClasses)
    title('K=100');
end
CM = bsxfun(@rdivide,meanCM,sum(meanCM')');
%csvwrite([exportDir base '_cmNorm.csv'],CM);
% 
 
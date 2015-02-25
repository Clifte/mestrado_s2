addpath(genpath('../util/'))
clear all; clear;clc;close all;
warning('off','all')

exportDir = '../../../../Latex/ReconhecimentoDePadroes/trabalho1/matlab/';
%%
%Configurações
base = 'iris';
pTeste = 0.25;
nIt = 100;
%valores que serão utilizados na pesquisa de k
kSearch = [1:20  25:5:60  70:10:150];
%kSearch = 10;
%parametro para a região de decisão
p = [1 3];
%%
%Inicialização
[ x , y ,labels ] = carregaDatabase(base);
x = x(:,p);
[m n] = size(x);
[m nClasses] = size(y);
global xd;
global yd;
%%
result = zeros(length(kSearch),3);
result2 = zeros(length(kSearch),nIt);

for contk=1:length(kSearch)
    k = kSearch(contk);
    acuracia = [];
    for i=1:nIt
        [ xd yd xt yt ] = preparaDados( x, y, pTeste);
        acc=0;
        
        clsC = knn(xd,yd,xt,k);

        [tmp clsT] = max(yt');
        
        acc = sum(clsC == clsT');

        acuracia = [acuracia (acc/size(xt,1))];
    end

    result(contk,:) = [ k mean(acuracia) std(acuracia)];
    result2(contk,:) = acuracia;
end
result

csvwrite([exportDir base '_acuracia.csv'],result);
boxplot(result2',kSearch);
%title('Acurácia em função do valor de K');

if(length(p)==2)
    [tmp, clsT] = max(y,[],2);
    showDecision(x,clsT,'global xd;global yd;cls=knn(xd,yd,xy,1);',nClasses)
    title('K=1');
    showDecision(x,clsT,'global xd;global yd;cls=knn(xd,yd,xy,5);',nClasses)
    title('K=5');
    showDecision(x,clsT,'global xd;global yd;cls=knn(xd,yd,xy,50);',nClasses)
    title('K=50');
    showDecision(x,clsT,'global xd;global yd;cls=knn(xd,yd,xy,100);',nClasses)
    title('K=100');
end




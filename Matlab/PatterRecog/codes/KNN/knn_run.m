addpath(genpath('../util/'))
clear all; clear;clc
warning('off','all')

%%
%Configurações
base = 'iris';
pTeste = 0.25;
nIt = 1000;
k=3;

%%
%Inicialização
[ x , y ,labels ] = carregaDatabase(base);
[m n] = size(x);
[m nClasses] = size(y);

%%
acuracia = [];
for i=1:nIt
    [ xd yd xt yt ] = preparaDados( x, y, pTeste);
    acc=0;
    for j=1:size(xt,1)
        clsC = knn(xd,yd,xt(j,:),k);
    
        [tmp clsT] = max(yt(j,:));
        if(clsC == clsT)
            acc = acc + 1;
        end
    end

    acuracia = [acuracia (acc/size(xt,1))];
end

MEAN = mean(acuracia)
STD = std(acuracia)

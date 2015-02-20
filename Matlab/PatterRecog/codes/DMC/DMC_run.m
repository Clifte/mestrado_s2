addpath(genpath('../util/'))
clear all; clear;clc
warning('off','all')

%%
%Configurações
base = 'iris';
pTeste = 0.25;
nIt = 1000;
k=3;
%atributos utilizados
%p = 1:4;
p = [1 3];

%%
%Inicialização
[ x , y ,labels ] = carregaDatabase(base);
x = x(:,p);
[m n] = size(x);
[m nClasses] = size(y);
global C;
%%
acuracia = [];
for i=1:nIt
    [ xd yd xt yt ] = preparaDados( x, y, pTeste);
    acc=0;
    C = DMC_centroids(xd,yd);
    
    for j=1:size(xt,1)
        clsC = DMC(C,xt(j,:));
    
        [tmp clsT] = max(yt(j,:));
        if(clsC == clsT)
            acc = acc + 1;
        end
    end

    acuracia = [acuracia (acc/size(xt,1))];
end

if(length(p)==2)
    [tmp clsT] = max(y,[],2);
    showDecision(x,clsT,'global C;cls=DMC(C,xy);',nClasses)
end


MEAN = mean(acuracia)
STD = std(acuracia)

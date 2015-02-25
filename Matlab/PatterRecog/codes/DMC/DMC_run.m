addpath(genpath('../util/'))
clear all; clear;clc;close all;
warning('off','all')

%%
%Configura��es
base = 'iris';
pTeste = 0.25;
nIt = 100;
k=3;
%atributos utilizados
%p = 1:4;
p = [1 3];

%%
%Inicializa��o
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
    
    %Aplica o DMC em todas amostras retornando apenas a classe
    %sem codificação
    clsC = DMC(C,xt);
    [tmp, clsT] = max(yt');
    acc = sum(clsT==clsC');
 
    acuracia = [acuracia (acc/size(xt,1))];
end

if(length(p)==2)
    [tmp, clsT] = max(y,[],2);
    showDecision(x,clsT,'global C;cls=DMC(C,xy);',nClasses)
end


MEAN = mean(acuracia)
STD = std(acuracia)

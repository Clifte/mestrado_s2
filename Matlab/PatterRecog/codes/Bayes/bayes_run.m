addpath(genpath('../util/'))
clear all; clear;clc;close all;
warning('off','all')

exportDir = '../../../../Latex/ReconhecimentoDePadroes/trabalho3/matlab/';
%%
global yl;
global lbda;
global fnc;
global parametro1;
parametro1 = 0.05;

nWin = 50;
rangeParzenSearch = linspace(0.001,3,nWin);
parzenSearchResult = zeros(nWin,3);

%%
%Carrega e prepara a base
carregaPreparaBase;
%%

pTeste = 0.20;         %Percentual da base para teste
nIt = 30;              %Número de repetições para o cálculo da acurácia

%p = [1 3]; %parametro para a região de decisão. O indice indica qual atributo levar em conta
%p = [1  3];

lambda = [ 0 1 1 
           1 0 1
           1 1 0
           ];
       
fprintf('Número de repetições %d:\n',nIt);


%Teste para a matriz CV diferente
fnc = 'gmm';
parametro1 = 3;
bayes_test_repete;

% %Teste para a matriz CV diferente
% fnc = 'gauss';
% bayes_test_repete;
% 
% %Teste para as mesmas matrizes
% fnc = 'same';
% bayes_test_repete;
% 
% fnc = 'ndiag';
% bayes_test_repete;
% 
% fnc = 'diag';
% bayes_test_repete;

%fnc = 'parzenGauss';
%executaParzen

if(strcmp('iris',base))

    close all;
    p = [1 4];
    fnc = 'same';
    plotaRegioesDeDecisao

    close all;
    p = [3 4];
    fnc = 'same';
    plotaRegioesDeDecisao


    close all;
    p = [1 4];
    fnc = 'diag';
    plotaRegioesDeDecisao

    close all;
    p = [3 4];
    fnc = 'diag';
    plotaRegioesDeDecisao
end

if(strcmp('vertebra',base))

    close all;
    p = [1 2];
    fnc = 'same';
    plotaRegioesDeDecisao

    close all;
    p = [1 5];
    fnc = 'same';
    plotaRegioesDeDecisao


    close all;
    p = [1 2];
    fnc = 'diag';
    plotaRegioesDeDecisao

    close all;
    p = [1 5];
    fnc = 'diag';
    plotaRegioesDeDecisao
end


if(strcmp('derme',base))
    close all;
    p = [1 16];
    fnc = 'diag';
    plotaRegioesDeDecisao

    close all;
    p = [1 17];
    fnc = 'diag';
    plotaRegioesDeDecisao
    
    
    
    close all;
    p = [1 16];
    fnc = 'same';
    plotaRegioesDeDecisao

    close all;
    p = [1 17];
    fnc = 'same';
    plotaRegioesDeDecisao
end

sprintf('\n\nDONE!!!\n\n')
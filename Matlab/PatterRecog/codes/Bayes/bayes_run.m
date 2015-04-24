addpath(genpath('../util/'))
clear all; clear;clc;close all;
warning('off','all')

exportDir = '../../../../Latex/ReconhecimentoDePadroes/trabalho2/matlab/';
%%
global yl;
global lbda;
global fnc;
global parzenh;
parzenh = 0.000005;

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
       
fnc = 'parzenGauss';


    
fprintf('Número de repetições %d:\n',nIt);


%Teste para a matriz CV diferente
fnc = 'gauss';
bayes_test_repete;

%Teste para as mesmas matrizes
fnc = 'same';
executaSigmaIBayes;

fnc = 'ndiag';
%bayes_test_repete;

fnc = 'diag';
bayes_test_repete;

fnc = 'parzenGauss';
executaParzen

plotaRegioesDeDecisao

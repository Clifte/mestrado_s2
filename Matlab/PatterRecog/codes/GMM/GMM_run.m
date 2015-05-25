addpath(genpath('../util/'))
clear all; clear;clc;close all;
warning('off','all')

global exportDir;
exportDir = '../../../../Latex/ReconhecimentoDePadroes/trabalho3/matlab/';


show_anim = 1;

%%
%Carrega e prepara a base
carregaPreparaBase;
%%
carregaParametrosGMM;


exportDir = ['../../../../Latex/ReconhecimentoDePadroes/trabalho3/matlab/gmm/'   baseSelecionada '/'];

x = x(:,[2 3]);


GMM_train(x,K,1);



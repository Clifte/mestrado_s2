addpath(genpath('../util/'))
clear all; clear;clc;close all;
warning('off','all')

exportDir = '../../../../Latex/ReconhecimentoDePadroes/trabalho2/matlab/';

%%
%Carrega e prepara a base
carregaPreparaBase;
%%
carregaParametrosGMM;
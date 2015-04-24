addpath(genpath('../util/'))
clear all; clear;clc;close all;
warning('off','all')

exportDir = '../../../../Latex/ReconhecimentoDePadroes/trabalho2/matlab/figura/';

imagePath  ='../database/imagens/';
imageFilename = 'brasil.jpg';
imageFilename ='japanFlag.png';
imageFilename = 'paradise.jpg';



fnc ='parzenGauss';
global parzenh;
parzenh = 1;

image = imread([imagePath imageFilename]);

imgFig = figure;
imshow(image);

nClasses = input('Indique o número de classes para segmentar: \n');

amostras = [];
labels = [];
sprintf('Iniciando Segmentação\n')
%Obtendo dados das classes
for i=1:nClasses
    sprintf('Selecione uma região para a classe %d\n', i)
    rect = int32(getrect(imgFig));
    rx = rect(1):(rect(1) + rect(3)-1);
    ry = rect(2):(rect(2) + rect(4)-1);
    amostrai = image(int32(ry),int32(rx),:);
    ni = int32(rect(3) * rect(4));
    figure;
    imshow(amostrai);
    amostrai = permute(reshape(amostrai,[1 ni 3]),[2 3 1]);
    amostrai = unique(amostrai,'rows');
    amostras = [amostras;amostrai];
    
    labels = [labels;ones(length(amostrai),1) * i];
end


sprintf('Iniciando Segmentação\n')
%Aplicando classificação
[m n ~] = size(image);
xt = double(permute(reshape(image,[1 m*n 3]),[2 3 1]));
yd = encode1ofk(labels,nClasses);
xd = double(amostras);

tic;
[xtu ia ic] = unique(xt,'rows');

clsC = bayes(xtu,xd,yd,0,fnc);

clsC = clsC(ic);

toc



nImage = reshape(clsC,[m n]);
figure;
imagesc(nImage);
%imwrite(nImage,[exportDir imageFilename '_' fnc '_' 'result.jpg'])


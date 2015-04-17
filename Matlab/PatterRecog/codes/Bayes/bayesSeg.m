addpath(genpath('../util/'))
clear all; clear;clc;close all;
warning('off','all')

exportDir = '../../../../Latex/ReconhecimentoDePadroes/trabalho2/matlab/';


%image = imread('../database/imagens/japanFlag.png');
%image = imread('../database/imagens/brasil.jpg');
image = imread('../database/imagens/paradise.jpg');

imgFig = figure;
imshow(image);

nClasses = input('Indique o número de classes para segmentar: ');

amostras = [];
labels = [];

%Obtendo dados das classes
for i=1:nClasses
    rect = int32(getrect(imgFig));
    rx = rect(1):(rect(1) + rect(3)-1);
    ry = rect(2):(rect(2) + rect(4)-1);
    amostrai = image(int32(ry),int32(rx),:);
    ni = int32(rect(3) * rect(4));
    figure;
    imshow(amostrai);
    amostrai = permute(reshape(amostrai,[1 ni 3]),[2 3 1]);
    amostras = [amostras;amostrai];
    labels = [labels;ones(ni,1) * i];
end

%Aplicando classificação
[m n ~] = size(image);
xt = double(permute(reshape(image,[1 m*n 3]),[2 3 1]));
yd = encode1ofk(labels,nClasses);
xd = double(amostras);


clsC = bayes(xt,xd,yd,0,'gauss');
nImage = reshape(clsC,[m n]);
figure;
imagesc(nImage);


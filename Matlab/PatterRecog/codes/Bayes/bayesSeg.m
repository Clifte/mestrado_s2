addpath(genpath('../util/'))
%clear all; clear;clc;
close all;
warning('off','all')

exportDir = '../../../../Latex/ReconhecimentoDePadroes/trabalho3/matlab/parzenGauss/Seg/';
mkdir(exportDir);
map = jet(64);
nCores = size(map,1);

carregaImagemEMascara;

sprintf('Iniciando Segmentação\n')
%Aplicando classificação
[m n ~] = size(image);

%Convertendo imagem para vetor e filtrando valores unicos
xt = double(permute(reshape(image,[1 m * n 3]),[2 3 1]));
[xtu ia ic] = unique(xt,'rows');

tic;

model = {};
model.lambda=[];
model.fnc = fnc;
model.forcaEquip = 0;
model.rejOpc =0;


%Dados de treinamento
yd = encode1ofk(labels,nClasses);
xd = double(amostras)/256; %Normalizando
model.data = xd;
model.labels = yd;

delete(sprintf('%s%s_%s_AccVsH_Result.png',exportDir,imageFilename,fnc));
fileID=fopen(sprintf('%s%s_%s_AccVsH_Result.csv',exportDir,imageFilename,fnc),'a');

janelas = linspace(1E-6,5E-5,4)
for parametro1=janelas   

    %Classificando
    clsC = bayes(xtu/256,model);

    %Recuperando imagem
    clsC = clsC(ic);

    toc

    %Gerando imagem com as classes segmentadas
    nImageSC = ceil((clsC/nClasses) * nCores) ;
    nImageSC  = map(nImageSC,:);
    nImageSC = reshape(nImageSC,[m n 3]);
    figure;
    imshow(nImageSC);
    imwrite(nImageSC,...
        sprintf('%s%s_%s_%.3g_Result.png',exportDir,imageFilename,fnc,parametro1));

    
    %Calculando Acurácia
    acc = sum(clsC == imageMask)/(m*n);
    fprintf('Acurácia:%.2f',acc);
    fprintf(fileID,'%.3f,%.3g\n',acc,parametro1)
end

parametro1= 1E-1;
for t = 0.6:0.15:0.9
    model.rejOpc = t;
    
    t
    %Classificando
    clsC = bayes(xtu/256,model);

    %Recuperando imagem
    clsC = clsC(ic);

    toc

    %Gerando imagem com as classes segmentadas
    nImageSC = ceil((clsC/(nClasses+1)) * nCores) ;
    nImageSC  = map(nImageSC,:);
    nImageSC = reshape(nImageSC,[m n 3]);
    figure;
    imshow(nImageSC);
%    imwrite(nImageSC,...
%        sprintf('%s%s_%s_%.3f_Result.png',exportDir,imageFilename,fnc,parametro1));

    
    %Calculando Acurácia
    acc = sum(clsC == imageMask)/(m*n);
    fprintf('Acurácia:%.2f',acc);    
end



addpath(genpath('../util/'))
addpath(genpath('../Bayes/'))
clear all; clear;clc;
close all;
warning('off','all')

exportDir = '../../../../Latex/ReconhecimentoDePadroes/trabalho3/matlab/gmm/Seg/';
mkdir(exportDir);
map = jet(64);
nCores = size(map,1);

%%
imagePath  ='../database/imagens/';
images = {'brasil.jpg','japanFlag.png','paradise.jpg','euaDif.png'};
imagesMask = {'brasil.jpg','japanFlag_mask.png','paradise.jpg','euaDif_mask.png'};


[s,v] = listdlg('PromptString','Selecione uma Imagem:',...
                'SelectionMode','single','ListString',images)

if(~v) return;end;

%%


imageFilename = cell2mat(images(s));
imageMaskFilename = cell2mat(imagesMask(s));

fnc ='parzenGauss';
global parametro1;
parametro1 = 0.5;



image = imread([imagePath imageFilename]);

imgFig = figure;
imshow(image);

nClasses = input('Indique o número de classes para segmentar: \n');



%%

sprintf('Iniciando Segmentação\n')
%Aplicando classificação
[m n ~] = size(image);

%Convertendo imagem para vetor e filtrando valores unicos
xt = double(permute(reshape(image,[1 m * n 3]),[2 3 1]));
[xtu ia ic] = unique(xt,'rows');
xtu=xtu/256;

%Estimando modelos
modelGMM = GMM_train(xtu,nClasses,0);

model = {};
model.lambda=[];
model.fnc = 'gauss';
model.forcaEquip = 0;
model.rejOpc =0;


ct = [];
yt = [];
for i=1:nClasses
    ci = mvnrnd(modelGMM.medias(i,:),modelGMM.covariancias(:,:,i),100);
    yi = ones(100,1) * i;    

    ct = [ct;ci];
    yt = [yt;yi];
end

yt = encode1ofk(yt,nClasses);

model.data= ct;
model.labels = yt;

clsC= bayes(xtu,model);

%Recuperando imagem
clsC = clsC(ic);



%Gerando imagem com as classes segmentadas
nImageSC = ceil((clsC/nClasses) * nCores) ;
nImageSC  = map(nImageSC,:);
nImageSC = reshape(nImageSC,[m n 3]);
figure;
imshow(nImageSC);

imwrite(nImageSC,...
    sprintf('%s%s_%s_%d_Result.png',exportDir,imageFilename,fnc,nClasses));


%%






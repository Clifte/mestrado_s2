
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
    
    imwrite(amostrai,...
       sprintf('%s%s_%s_classe_%d.png',exportDir,imageFilename,fnc,i));
    
    amostrai = permute(reshape(amostrai,[1 ni 3]),[2 3 1]);
    amostrai = unique(amostrai,'rows');
    amostras = [amostras;amostrai];
    
    labels = [labels;ones(length(amostrai),1) * i];
end

imageMask = imread([imagePath imageMaskFilename]);
[m n] = size(imageMask);
imageMask = reshape(imageMask,[1 m*n]);


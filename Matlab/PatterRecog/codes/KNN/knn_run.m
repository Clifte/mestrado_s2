addpath(genpath('../util/'))
clear all; clear;clc;close all;
warning('off','all')

exportDir = '../../../../Latex/ReconhecimentoDePadroes/trabalho1/matlab/';

%%
global yl;
%%
%Configura��es
base = 'iris';     %Nome da base
pTeste = 0.25;     %Percentual da base para teste
nIt = 100;         %N�mero de repeti��es para o c�lculo da acur�cia

kSearch = [1:20  25:5:60  70:10:150]; %valores que ser�o utilizados na pesquisa de k
%kSearch = 10
p = [1 2 3 4]; %parametro para a regi�o de decis�o. O indice indica qual atributo levar em conta
%%
%Inicializa��o
[ x , y ,labels ] = carregaDatabase(base);

%Filtrar colunas desejadas e resolver problema das linhas duplicadas
x = x(:,p);
[x ia] = unique(x,'rows');
y = y(ia,:);

%Normalizando
x = bsxfun(@minus,x,min(x));
x = bsxfun(@rdivide,x,max(x));


yl = y;

[m n] = size(x);
[m nClasses] = size(y);

%%
result = zeros(length(kSearch),3);
result2 = zeros(length(kSearch),nIt);

%Avaliando todos os valores de k existentes no vetor kSearch
for contk=1:length(kSearch)
    k = kSearch(contk);
    
    %Inicializa��o de vari�veis
    acuracia = zeros(1,nIt);
    meanCM = zeros(nClasses,nClasses);
    meanPer = zeros(nClasses,4);
    
    
    for i=1:nIt
        [ xd yd xt yt ] = preparaDados( x, y, pTeste);
        
        %Aplicando o KNN em batch para toda a base de teste
        clsC = knn(xd,yd,xt,k);
        clsCEnc = encode1ofk(clsC,nClasses);
        
        [tmp clsT] = max(yt,[],2);
        
        %acc = sum(clsC == clsT');
        [acc,cm,ind,per] = confusion(yt',clsCEnc');
        
        %acuracia(i) = (acc/size(xt,1));
        acuracia(i) = 1 - acc;
        meanCM = meanCM + cm;
        meanPer = meanPer + per;
    end

    meanPer = meanPer./nIt;
        
    result(contk,:) = [ k mean(acuracia) std(acuracia)];
    result2(contk,:) = acuracia;
end
result
% 
CM = bsxfun(@rdivide,meanCM,sum(meanCM,2)');

csvwrite([exportDir base '_KNN_acuracia.csv'],result);
csvwrite([exportDir base '_KNN_cmNorm.csv'],CM);
csvwrite([exportDir base '_KNN_cmAnalise.csv'],meanPer);

%boxplot(result2',kSearch);
plot(result(:,1),result(:,[2 3]));
title('Acur�cia em fun��o do valor de K');

%Plotando regi�es de decis�o variando o valor de K
if(length(p)==2)
    [tmp, clsT] = max(y,[],2); 
    showDecision(x,clsT,'global yl;cls=knn(x,yl,xy,1);',nClasses)
    title('K=1');
    path = sprintf('%sfigura/%s_%s_%d_%d.eps',exportDir,base,'KNN_RegDec_K1',p(1),p(2));
    saveas(gca, path,'epsc');
    
    showDecision(x,clsT,'global yl;cls=knn(x,yl,xy,10);',nClasses)
    title('K=10');
    path = sprintf('%sfigura/%s_%s_%d_%d.eps',exportDir,base,'KNN_RegDec_K10',p(1),p(2));
    saveas(gca, path,'epsc');
    
    showDecision(x,clsT,'global yl;cls=knn(x,yl,xy,50);',nClasses)
    title('K=50');
    path = sprintf('%sfigura/%s_%s_%d_%d.eps',exportDir,base,'KNN_RegDec_K50',p(1),p(2));
    saveas(gca, path,'epsc');
    
    showDecision(x,clsT,'global yl;cls=knn(x,yl,xy,75);',nClasses)
    title('K=75');
    path = sprintf('%sfigura/%s_%s_%d_%d.eps',exportDir,base,'KNN_RegDec_K75',p(1),p(2));
    saveas(gca, path,'epsc');    
end





 
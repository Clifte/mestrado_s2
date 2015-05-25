%%Gera curva A-R para as bases
addpath(genpath('../util/'))
clear all; clear;clc;close all;
warning('off','all')
exportDir = '../../../../Latex/ReconhecimentoDePadroes/trabalho3/matlab/';

rangeParzenSearch = linspace(10E-5,1,25);
global parametro1;

bases = {'vertebra','breastC','haber','diab'};
fnc = 'parzenGauss';
perspectiva = 1;

N = length(bases) * length(rangeParzenSearch);


try
    load('parzenSearch');
catch
end

if(~parzenSearchResult)
parzenSearchResult = zeros(length(bases),length(rangeParzenSearch),3);    
    
    for i=1:length(bases)
        base = cell2mat (bases(i)) ;


        [ x , y ,labels, features ] = carregaDatabase(base);

        y = [y(:,1) ~y(:,1)];
        %x = x(:,[1 2]);

        %Normalizando
        x = bsxfun(@minus,x,min(x));
        x = bsxfun(@rdivide,x,max(x));

        model = {};
        model.lambda=[];
        model.fnc = fnc;
        model.forcaEquip = 0;
        model.rejOpc = 0;
        model.exibirPontos = ~perspectiva;

        model.data = x;
        model.labels = y;

        for ph = 1:length(rangeParzenSearch)
             parametro1 = rangeParzenSearch(ph);  
             [acuracia meanCM meanPer] = executaTesteBayes(x,y,model,0.25,15);

             acc = mean(acuracia);
             dsv = std(acuracia);
             parzenSearchResult(i,ph,1) = parametro1;
             parzenSearchResult(i,ph,2) = acc;
             parzenSearchResult(i,ph,3) = dsv;          
             fprintf('(%.2f)Base:%s l: %.2f Acc:%.2f dsv:%.2f\n',(ph + (i-1)*length(rangeParzenSearch))/N,base,parametro1,acc,dsv);

        end
    end
    
    save('parzenSearch','parzenSearchResult','bases');
end

%Gerando gráficos dos resultados
for i=1:length(bases)
        base = cell2mat (bases(i)) ;
        
        figure;
        plot(parzenSearchResult(i,:,[1])',parzenSearchResult(i,:,[2]) + parzenSearchResult(i,:,[3]),'r');hold on;
        plot(parzenSearchResult(i,:,[1])',parzenSearchResult(i,:,[2]),'b' );
        plot(parzenSearchResult(i,:,[1])',parzenSearchResult(i,:,[2])-parzenSearchResult(i,:,[3]),'r' );

        
        [v id] =  max(parzenSearchResult(i,:,[2]));
        fprintf('base:%s Melhor janela: %.2f\n',base,parzenSearchResult(i, id,1));
end

%valores ótimos 5 e 1
parametro1 = 0.005;
close all;
%Gerando Região de decisão
for i=1:length(bases)
        base = cell2mat (bases(i)) ;
        
      
  

        [ x , y ,labels, features ] = carregaDatabase(base);

        y = [y(:,1) ~y(:,1)];
        x = x(:,[1 2]);

        %Normalizando
        x = bsxfun(@minus,x,min(x));
        x = bsxfun(@rdivide,x,max(x));

        model = {};
        model.lambda=[];
        model.fnc = fnc;
        model.forcaEquip = 0;
        model.rejOpc = 0;
        model.exibirPontos = ~perspectiva;

        model.data = x;
        model.labels = y;      
        
        close all;
        bayesDecision(model);
        
        pathBase = sprintf('%s/%s/%s/decReg/',exportDir,fnc,base); mkdir(pathBase);
        if(perspectiva)
                path = sprintf('%sdecRegion_%.3f_A.eps',pathBase,parametro1);
                saveSubplot(gca,path,1)
        else
                view([0 90]);
                path = sprintf('%sdecRegion_%.3f_B.eps',pathBase,parametro1);
                saveSubplot(gca,path,1)
        end
            
                   
     
end







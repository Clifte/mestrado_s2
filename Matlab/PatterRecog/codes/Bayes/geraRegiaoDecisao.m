%%Gera curva A-R para as bases
addpath(genpath('../util/'))
clear all; clear;clc;close all;
warning('off','all')
exportDir = '../../../../Latex/ReconhecimentoDePadroes/trabalho3/matlab/';



global randSeedPreparaDados;
randSeedPreparaDados = 1;

global parametro1;
%parametro1 = 0.002;
parametro1 = 3;

combinacao = [1 2;
              1 2;
              1 2;
              5 6]


perspectiva = 0;
fnc = 'gmm';


    bases = {'vertebra','breastC','haber','diab'};

    threshs = linspace(0.5,1,10);

    N = length(bases) * length(threshs);
    
    for i=1:length(bases)
        base = cell2mat (bases(i)) ;


        [ x , y ,labels, features ] = carregaDatabase(base);

        y = [y(:,1) ~y(:,1)];
        x = x(:,combinacao(i,:));
        
        %Normalizando
        x = bsxfun(@minus,x,min(x));
        x = bsxfun(@rdivide,x,max(x));

        model = {};
        model.lambda=[];
        model.fnc = fnc;
        model.forcaEquip = 1;

        pathBase = sprintf('%s/%s/%s/RejOpt/decReg/',exportDir,fnc,base); mkdir(pathBase);
        for t=1:length(threshs);
            thresh = threshs(t);
            model.rejOpc = thresh;

            if(perspectiva)
                model.exibirPontos = 0;
                model.lim = [-2 2];
                [acuracia meanCM meanPer] = executaTesteBayes(x,y,model,0.25,1);
                path = sprintf('%sdecRegion_%.3f_A.eps',pathBase,thresh);
                saveSubplot(gca,path,1);
                
            else
                model.exibirPontos = 1;
                model.lim = [-0.25 1.25];
                
                [acuracia meanCM meanPer] = executaTesteBayes(x,y,model,0.25,1);
                view([0 90]);
                path = sprintf('%sdecRegion_%.3f_B.eps',pathBase,thresh);
                saveSubplot(gca,path,1);
                
            end
            
            
            fprintf('(%.2f)Base:%s Fnc:%s Thersh: %.2f Acc: %.2f\n',(t + (i-1)*length(threshs))/N,base,fnc,thresh,acuracia);
            close all;
         end
    end



%%Gera curva A-R para as bases
addpath(genpath('../util/'))
clear all; clear;clc;close all;
warning('off','all')
exportDir = '../../../../Latex/ReconhecimentoDePadroes/trabalho3/matlab/';



global randSeedPreparaDados;
randSeedPreparaDados = 0;

global parametro1
parametro1 = 0.002;

fnc = 'gmm';
try
    load(fnc)
catch
    fprintf('Arquivo não encontrado. Gerando base');
end

if(~exist('resultsACC'))
    %bases = {'vertebra','breastC','haber','diab'};
    %bases = {'iris'};


    threshs = linspace(0,1,200);


    resultsACC = zeros(length(threshs),length(bases));
    resultsRej = zeros(length(threshs),length(bases));


    N = length(bases) * length(threshs);
    
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
        

        for t=1:length(threshs);
            thresh = threshs(t);

            model.rejOpc = thresh;

            [acuracia meanCM meanPer] = executaTesteBayes(x,y,model,0.25,25); 

            tmpMeanCM = meanCM(1:end-1,1:end-1);

            %txAcc = (trace(tmpMeanCM) + 10E-10) / (sum(sum(tmpMeanCM)) + 10E-10);
            txRej = sum(meanCM(:,end))/sum(sum(meanCM));
            txError = (sum(sum(tmpMeanCM)) - trace(tmpMeanCM)) / sum(sum(meanCM));
            
            
            resultsACC(t,i) = txError;
            resultsRej(t,i) = txRej;
            
            fprintf('(%.2f)Base:%s Fnc:%s Thersh: %.2f TxE:%.2f TxR:%.2f\n',(t + (i-1)*length(threshs))/N,base,fnc,thresh,txError,txRej);
        end
    end
  
    save(fnc,'resultsACC','resultsRej','bases','threshs');
end


wrs = linspace(0,1,50);

for i=1:length(bases)
        base = cell2mat (bases(i)) ;
    
        E = resultsACC(:,i);
        R = resultsRej(:,i);
            
        V = [R E];
        V2 = [wrs' ones(length(wrs),1)];
       
        Re = V2 * V';
        [v ReMinimo] = min(Re');
        
        
%         
         [ath awr ] = unique(ReMinimo);
         Re = Re(awr,:);
         ReMinimo=ath;
         v = v(awr);
        
        Eo = E(ReMinimo);
        Ro = R(ReMinimo);
        
        %-----------------------------------------------------------
        figure('name',base);
        h = subplot(2,2,1);
        hold on;
        plot(threshs,E,'r');
        plot(threshs,R,'g');
        
        legend('Erro','Rejeicao');
        title('Taxa de erro e Rejeicao por limiar');
        pathBase = sprintf('%s/%s/%s/RejOpt/',exportDir,fnc,base); mkdir(pathBase);
        path = sprintf('%sTaxaErroRejeicao.eps',pathBase);
        saveSubplot(h,path)

        %-----------------------------------------------------------
        subplot(2,2,2);
        plot(R,E);
        title('Taxa de rejeição vs Taxa de Erro');



        h = subplot(2,2,3);
        plot(threshs,Re); hold on;
        scatter(threshs(ath),v,'k','filled');
        %scatter(threshs(ReMinimo),v);
        
        
        %legend(num2str(wrs','wr=%0.2f'))
        title('Erro empirico');
        path = sprintf('%sErroEmpirico.eps',pathBase);
        saveSubplot(h,path)
         %-----------------------------------------------------------
        
        
        h = subplot(2,2,4);
        scatter(Ro,1-Eo,'filled');hold on;
        plot(Ro,1-Eo)
        title('Taxa de rejeicao vc Acuracia');        
        path = sprintf('%sRejeicaoAcuracia.eps',pathBase);
        saveSubplot(h,path)
        
    
        info = [wrs(awr)' threshs(ath)' 1-Eo Ro];
        path = sprintf('%sWrsAccRej.csv',pathBase);
        %csvwrite(path,info);
        dlmwrite(path,info, 'precision', 3);
end



addpath(genpath('./util/'))
addpath(genpath('./Bayes/'))
addpath(genpath('./lssvm/'))
clear all; clear;clc;close all;
warning('off','all')


%Configurações
opc = {'bayes','vertebra','SVM','breastC'};
tecnicas = {'bayes','Vertebra','SVM','Cancer de mama'};
[tecnica,v] = listdlg('PromptString','Selecione uma função:','SelectionMode','single','ListString',opc)
if(~v) return;end;



opc = {'database/breastCancer/bc.txt', ...
       'database/dermat/dermatology.data', ...
       'database/diabetes/dia.txt', ...
       'database/haberman/hab.txt', ...
       'database/iris/bezdekIris.data', ...
       'database/verte/column_3C.dat'};
   
bases = {'Cancêr de Mama','D. Dermatologica','Diabetes','Haberman','Íris','D. Coluna'};
[s,v] = listdlg('PromptString','Selecione uma base:','SelectionMode','single','ListString',bases)
if(~v) return; end;
base = opc(s);

if(tecnica==1) %Bayes
    opc = {'Gerar curva AR'};

    [s,v] = listdlg('PromptString','O que fazer?','SelectionMode','single','ListString',opc)
    if(~v) return;end;

    
    
    if(s==1)
       geraCurvaAR;
    end 
end

if(tecnica==3) %SVM

    opc = {'LSSVM - Linear',...
        'LSSVM - RBF',...
        'LSSVM - Linear - Região de Decisão',...
        'LSSVM - RBF - Região de Decisão'...
        };

    [s,v] = listdlg('PromptString','O que fazer?','SelectionMode','single','ListString',opc)
    if(~v) return;end;
    base = cell2mat(base);
    
    if(s==1)
        params.kernelFNC = 'linear';
        lssvm_run;
    end
    
    if(s==2)
        params.kernelFNC = 'RBF';
        lssvm_run;
    end
    
    
    if(s==3)
        params.kernelFNC = 'linear';
        atributos = [1 3];
        lssvm_run;
    end    
    if(s==4)
        params.kernelFNC = 'RBF';
        atributos = [1 3];
        lssvm_run;
    end        
end


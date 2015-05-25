fprintf([base '_BAYES_' fnc sprintf('_%d',p) '\n']);


 [acuracia meanCM meanPer] = executaTesteBayes(x, y,fnc, pTeste , nIt);    


    
CM = bsxfun(@rdivide,meanCM,sum(meanCM,2)');

%%%%%%%%%%%%%%%%%%%%%%%%%
%Matriz confusão
path = sprintf('%sCM/%s/%s_BAYES_cmNorm.csv',exportDir, base,fnc);
mkdir(path);

s = rmdir(path);
fileID = fopen(path,'a');

for i=1:length(labels(:,1))
     fprintf(fileID,';%s',labels(i,:));
end
fprintf(fileID,'\n');
for i=1:length(labels(:,1))
     fprintf(fileID,'%s',labels(i,:));
     fprintf(fileID,';%f',CM(i,:));
     fprintf(fileID,'\n');
end

fclose(fileID);


%%%%%%%%%%%%%%%%%%%%%%%%%


csvwrite([exportDir base '_BAYES_cmNorm.csv'],CM);
csvwrite([exportDir base '_BAYES_cmAnalise.csv'],meanPer);

acc = mean(acuracia);
dsv = std(acuracia);
maxacc = max(acuracia);
minacc = min(acuracia);

fprintf('Acurácia : %.4f\n',acc);
fprintf('Desvio padrão : %.4f\n',dsv);

TEX = sprintf('%s & %f & %f & %f & %f',baseSelecionada,acc,dsv,maxacc,minacc);
fileID = fopen([exportDir 'acuracias/' base '_BAYES_' fnc sprintf('_%d',p) '.tex'],'w');
fprintf(fileID,'%s',TEX);
    
    
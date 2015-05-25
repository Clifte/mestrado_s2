function [acuracia meanCM meanPer] = executaTesteBayes(x, y,model, pTeste , nIt)

[m nClasses] = size(y);

[m n ] = size(x);

%aplica teste comum com cálculo da acurácia
acuracia = zeros(1,nIt);
meanCM = zeros(nClasses+1,nClasses+1);
meanPer = zeros(nClasses+1,4);

    
for i=1:nIt
    [ xd yd xt yt ] = preparaDados( x , y, pTeste);

    model.data = xd;
    model.labels = yd;
    
    clsC = bayes(xt,model);

    clsCEnc = encode1ofk(clsC',nClasses + 1);
    yt = [yt zeros(length(yt(:,1)),1)];
    [acc,cm,ind,per] = confusion(yt',clsCEnc');

    meanCM = meanCM + cm;
    meanPer = meanPer + per;
    acuracia(i) = 1-acc;
    
    if n==2
        bayesDecision(model);
        drawnow;
    end
    
end

end

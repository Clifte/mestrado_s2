for ph = 1:length(rangeParzenSearch)
    parzenh = rangeParzenSearch(ph);
    
    bayes_test_repete;
    parzenSearchResult(ph,1) = parzenh;
    parzenSearchResult(ph,2) = acc;
    parzenSearchResult(ph,3) = dsv;
    
    fileID = fopen([exportDir 'acuracias/' base '_BAYES_SigmaSearch_' fnc sprintf('_%d',p) '.tex'],'a');
    fprintf(fileID,'%s & %f\n',TEX,parzenh);
    fclose(fileID);
end

figure; hold on
plot(parzenSearchResult(:,[1])',parzenSearchResult(:,[2]) + parzenSearchResult(:,[3]),'r');
plot(parzenSearchResult(:,[1])',parzenSearchResult(:,[2]),'b' );
plot(parzenSearchResult(:,[1])',parzenSearchResult(:,[2])-parzenSearchResult(:,[3]),'r' );

path = sprintf('%sfigura/%s_%s.eps',exportDir,base,'_BAYES_SigmaSearch_');
saveas(gca, path,'epsc');

[v l ] = max(parzenSearchResult);
parzenh = parzenSearchResult(l(2),1);
bayes_test_repete

fprintf('*Valor de Sigma : %.4f\n',parzenSearchResult(l(2),1));

%Labels codificadas em 1ofk
function [cls p]= bayes(amostra,data,labels,fnc)

    [m n] = size(data);
    [m nClasses] = size(labels);
    
    

    labelsL = decode1ofk(labels);

    for i=1:nClasses
        idx = find(labelsL==i);
        p(i,:) = conditionalProbability(amostra,data(idx,:),fnc);
    end

    [v cls] = max(p);
        
end
    
    
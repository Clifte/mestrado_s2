%Labels codificadas em 1ofk
function [cls p]= bayes(amostra,data,labels,lambda,fnc)

    %[m n] = size(data);
    [m nClasses] = size(labels);
    N = length(amostra);
    
    labelsL = decode1ofk(labels);

    p = zeros(nClasses,length(amostra));
    for i=1:nClasses
        idx = find(labelsL==i);
        prior = length(idx)/length(labelsL);
        p(i,:) = conditionalProbability(amostra,data(idx,:),fnc) * prior;
    end

    
    
    
    if(lambda~=0)
        P = repmat(permute(p,[3 1 2]),[nClasses,1,1]);
        L = repmat(lambda,[1,1,N]);
        Risk = P.*L;

        [v cls2] = min(sum(Risk,2));
        cls2 = permute(cls2,[3 1 2]);
        cls = cls2;
    else
        [v cls] = max(p);
    end
        
end
    
    
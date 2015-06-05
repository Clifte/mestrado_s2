%Labels codificadas em 1ofk
function [cls p post]= bayes(amostra,model)
    
    data      = model.data;
    labels    = model.labels;
    lambda    = model.lambda;
    fnc       = model.fnc;
    thresh    = model.rejOpc;
    
    
    %[m n] = size(data);
    [m nClasses] = size(labels);
    N = length(amostra);
    
    labelsL = decode1ofk(labels);

    p = zeros(nClasses,length(amostra));
    for i=1:nClasses
        idx = find(labelsL==i);
        if(length(idx)==0) 
            continue;
        end
        prior = length(idx)/length(labelsL);
        
        if(model.forcaEquip)
            prior = 1 / nClasses;
        end
        
        p(i,:) = conditionalProbability(amostra,data(idx,:),fnc) * prior;
    end

    
    post = bsxfun(@rdivide,p,sum(p));
    

    if(lambda~=0)
        P = repmat(permute(p,[3 1 2]),[nClasses,1,1]);
        L = repmat(lambda,[1,1,N]);
        Risk = P.*L;

        [v cls2] = min(sum(Risk,2));
        cls2 = permute(cls2,[3 1 2]);
        cls = cls2;
    else
        [v cls] = max(post);
        cls(find(v<=thresh)) = nClasses + 1;
    end
        
end
    
    
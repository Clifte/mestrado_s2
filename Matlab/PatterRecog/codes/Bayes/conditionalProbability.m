function p = conditionalProbability(amostra,data,fnc)
    cv = cov(data);
    [m, n] = size(cv);
    
    if(cond(cv)>1000)
        fprintf('Condition number to height!!!\n');
        cv = cv + eye(n,n)*0.01;
    end
    
    if(strcmp(fnc, 'gauss'))        
        mu = mean(data);
        p = mvnpdf(amostra,mu,cv);

        %Normalizando
        mx = mvnpdf(mu,mu,cv);
        p = p / mx;
        return;
    end
    
    if(strcmp(fnc, 'same'))
        cv = eye(m,m) * 0.1;
        mu = mean(data);
        p = mvnpdf(amostra,mu,cv);

        %Normalizando
        mx = mvnpdf(mu,mu,cv);
        p = p / mx;
        return;
    end
    
    idx = 1:m+1:m*m;
    
    if(strcmp(fnc, 'ndiag'))  
        cv(idx) = 0;
        mu = mean(data);
        p = mvnpdf(amostra,mu,cv);

        %Normalizando
        mx = mvnpdf(mu,mu,cv);
        p = p / mx;
        return;
    end
    
    if(strcmp(fnc, 'diag'))
        idx = etdiff(1:m*m,idx);
        cv(idx) = 0;
        mu = mean(data);
        p = mvnpdf(amostra,mu,cv);

        %Normalizando
        mx = mvnpdf(mu,mu,cv);
        p = p / mx;
        return;
    end    
    

    
    if(strcmp(fnc, 'parzenGauss'))
        [m n] = size(data);
        
        cv = eye(n,n) * 0.00005;
        for i=1:m
            mi = data(i,:);
            P(i,:) = mvnpdf(amostra,mi,cv);
        end
        
        p = sum(P) / m;
        
        return;
    end            
    
end
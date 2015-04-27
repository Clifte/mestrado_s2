function p = conditionalProbability(amostra,data,fnc)
    global parzenh;

    cv = cov(data);
    [m, n] = size(data);
   
    if(m==0)
        p = 0; 
        return;
    end
    
    incV = linspace(0,1,50);
    if(cond(cv)>1000)
        for inc = incV
            cv = cv + eye(n,n) * inc;
            if(cond(cv)<1000)
                break;
            end
        end
    end
    
    if( m==1)
        %fprintf('Condition number to height!!!\n');
        cv = cv + eye(n,n) * 0.01;
    end

    if(strcmp(fnc, 'gauss'))        
        if(m==1)
            mu = data;
        else
            mu = mean(data);
        end
        
        p = mvnpdf(amostra,mu,cv);

        %Normalizando
        mx = mvnpdf(mu,mu,cv);
        p = p / mx;
        return;
    end
    
    if(strcmp(fnc, 'same'))
        cv = eye(n,n) * parzenh;
        mu = mean(data,1);
        p = mvnpdf(amostra,mu,cv);

        %Normalizando
        mx = mvnpdf(mu,mu,cv);
        p = p / mx;
        return;
    end
    
    idx = 1:n+1:n*n;
    
    if(strcmp(fnc, 'ndiag'))  
        cv(idx) = 1;
        mu = mean(data,1);
        p = mvnpdf(amostra,mu,cv);

        %Normalizando
        mx = mvnpdf(mu,mu,cv);%encontrando maximo
        p = p / mx;
        return;
    end
    
    if(strcmp(fnc, 'diag'))
        idx = setdiff(1:n*n,idx);
        cv(idx) = 0;
        mu = mean(data,1);
        p = mvnpdf(amostra,mu,cv);

        %Normalizando
        mx = mvnpdf(mu,mu,cv);
        p = p / mx;
        return;
    end    
     if(strcmp(fnc, 'euclid'))
        mu = mean(data,1);
        
        p = bsxfun(@minus,amostra,mu);
        p = sum(sqrt(p.^2),2);
        p = 1000 - p;
        
        return;
    end      

    
    if(strcmp(fnc, 'parzenGauss'))
        h = parzenh;
        [m n] = size(data);
        [mm nn] = size(amostra);
        
        cv = eye(n,n) * h;
        P = zeros(m,mm);
        
        for i=1:m
            mi = data(i,:);
            P(i,:) = mvnpdf(amostra,mi,cv);
        end
        
        p = sum(P,1) / m;
        
        return;
    end            
    
end
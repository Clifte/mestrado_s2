function p = conditionalProbability(amostra,data,fnc)
    if(fnc=='gauss')
        cv = cov(data);
        mu = mean(data);
        p = mvnpdf(amostra,mu,cv);
    end
end
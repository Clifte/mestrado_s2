function clsC = DMC(C,amostra)
    [m, n] = size(amostra);
    
    if(m==1)
        %calculando distancia euclidiana
        diff = bsxfun(@minus,amostra,C);
        dist = sum(diff.*diff,2);

        %verificando vizinhos
        [value, index] = min(dist);

        %identificando classe
        %[tmp clsC] = max(labels(index,:),1);
        clsC = index;
    else
        clsC = zeros(m,1);        

        for i=1:m
          clsC(i) = DMC(C,amostra(i,:));
        end
    end
end
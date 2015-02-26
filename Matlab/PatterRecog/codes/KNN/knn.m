%%
%aplica o KNN
% dados : Matriz de dados onde cada linha é um ponto
%labels : matriz no formato 1ofk

function clsC = knn(dados, labels,amostra,k)

    if(length(dados(:,1)) < k)
        fprintf('K %d is bigger than memory data. Setting k to length of data %d.\n',k,length(dados(:,1)))
        k = length(dados(:,1)); 
    end

    [m n] = size(amostra);
    
    if( m==1 )
        %calculando distancia euclidiana
        diff = bsxfun(@minus,amostra,dados);
        dist = sum(diff.*diff,2);

        %verificando vizinhos
        [value index] = sort(dist);
        nei = index(1:k);

        %identificando classe
        [tmp clsC] = max(sum(labels(nei,:),1));
    else
        clsC = zeros(m,1);
        for i=1:m
            clsC(i) = knn(dados,labels,amostra(i,:),k);
        end
    end
        
end
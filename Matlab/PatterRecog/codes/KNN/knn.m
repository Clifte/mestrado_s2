function clsC = knn(dados, labels,amostra,k)
    %calculando distancia euclidiana
    diff = bsxfun(@minus,amostra,dados);
    dist = sum(diff.*diff,2);

    %verificando vizinhos
    [value index] = sort(dist);
    nei = index(1:k);

    %identificando classe
    [tmp clsC] = max(sum(labels(nei,:),1));

end
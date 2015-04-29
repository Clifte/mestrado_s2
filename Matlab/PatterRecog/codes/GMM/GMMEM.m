function [modelo]= GMMEM(x, K, modelo)
[m p] = size(x);



if(~exist('modelo','var'))
    %Estimar Gaussianas
    W = ones(1,K);      %Pesos
    par1 = rand(K,p);   %Parametros Média e variancia
    par2 = repmat(0.05*eye(p,p),[ 1 1 K]);
else
    par1 = modelo.medias;
    par2 = modelo.covariancias;
    W = modelo.pesos;
end
    

priori = zeros(K,m);

for i=1:K
    priori(i,:)= W(i) .* mvnpdf(x,par1(i,:),par2(:,:,i));
end

evidencia = sum(priori);
responsability = priori ./ repmat(evidencia,[K 1]);

Nk = sum(responsability,2);

for i=1:K
    par1(i,:)= sum(repmat(responsability(i,:),[p 1]).* x',2)/Nk(i);
    diff = bsxfun(@minus,x,par1(i,:));

    par2(:,:,i) = zeros(p,p);
    for j=1:m
        par2(:,:,i) = par2(:,:,i) + responsability(i,j) .* (diff(j,:)' * diff(j,:));
    end   

    W(i) = Nk(i)/m;
    par2(:,:,i) = par2(:,:,i) /Nk(i); 
end

modelo = {};
modelo.medias = par1;
modelo.covariancias = par2;
modelo.pesos = W;

end


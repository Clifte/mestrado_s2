function [modelo]= GMMEM(x, K)

[m p] = size(x);

%Estimar Gaussianas
W = ones(1,K);    %Pesos
par1 = rand(K,p);  %Parametros Média e variancia
par2 = repmat(eye(p,p),[ 1 1 K]);

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
    par2(:,:,k) = par2(:,:,i) /Nk(i); 
end


end
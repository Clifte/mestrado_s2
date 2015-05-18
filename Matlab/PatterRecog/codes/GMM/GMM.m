function [Px]= GMM(modelo,x)
par1 = modelo.medias;
par2 = modelo.covariancias;
W = modelo.pesos;

[k p] = size(par1);
[m p] = size(x);

Px = zeros(m,1);

for i=1:k
    Px = Px + W(i) * mvnpdf(x,par1(i,:),par2(:,:,i));
end

end
function [Px]= GMM(modelo,x)
par1 = modelo.medias;
par2 = modelo.covariancias;
W = modelo.pesos;

[k p] = size(par1);
[m p] = size(x);

Px = zeros(k+1,m);

for i=1:k
    Px(i,:) = W(i) * mvnpdf(x,par1(i,:),par2(:,:,i));
    Px(k+1,:) = Px(k+1,:) + Px(i,:); 
end

end
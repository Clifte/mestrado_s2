function C = DMC_centroids(base,labels)
    [m n] = size(labels);
    [m p] = size(base);
    [v l] = max(labels,[],2);
    C = zeros(n,p);
    
    for i=1:n
        I = find(l==i);
        C(i,:) = sum(base(I,:))/length(I);
    end
end
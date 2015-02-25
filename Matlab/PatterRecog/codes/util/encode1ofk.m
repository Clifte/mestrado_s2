function R = encode1ofk(value,L)
	m = length(value);
    R = zeros(m,L);
    R(sub2ind(size(R),1:m,value')) = 1;
end
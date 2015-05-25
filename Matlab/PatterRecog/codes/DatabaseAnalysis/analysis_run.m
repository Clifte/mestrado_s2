addpath(genpath('../util/'))
clear all; clear;clc;close all;
warning('off','all')


%%
%Configurações
base = 'diab';

%Inicialização
[ x , y ,labels, features ] = carregaDatabase(base);
%Normalizando
x = bsxfun(@minus,x,min(x));
x = bsxfun(@rdivide,x,max(x));

[m n] = size(x);
[m nCls] = size(y);
[v yl] = max(y,[],2);

cmap2 = lines(nCls);
[h ax bigax] = gplotmatrix(x,x,yl,cmap2)

%Plotando histograma na diagonal principal
for i=1:n
    cla(ax(i,i));
    xlabel(ax(n,i),features(i,:))
    ylabel(ax(i,1),features(i,:))
    
    lim = xlim(ax(i,i));
    for j=1:nCls
        index = find(yl==j);
        data = x(index,i);
        
        [yy xx] = hist(data,linspace(lim(1),lim(2),20));

        yy = normalize_ar(yy,lim);
        
        hold(ax(i,i),'on');
        plot(ax(i,i),xx,yy,'color',cmap2(j,:));
        
    end
end
h = findobj(gcf,'Type','axes','Tag','legend');
legend(h,labels)

[autoVer scor autoVal] = princomp(x);
autoVal = autoVal/sum(autoVal);


% set methodology up

realizations = 5;
train_percs = 80;
nPart = 3;
nGamas = 10;
nSigmas = 10;


if(strcmp(params.kernelFNC,'RBF')==0)
    nSigmas = 1;
end

if (~exist('base'))
	base = 'data.txt';
end

% set params up
params.gamma = 0.04;

% data loading
ds = DataSet(base);
ds.normalize();
ds.labels(ds.labels~=2)=-1;
ds.labels(ds.labels==2)= 1;


if (exist('atributos'))
	ds.features = ds.features(:,atributos);
    [ds.features b c] = unique(ds.features,'rows');
    ds.labels = ds.labels(b);
end



hit_rate = zeros(realizations,1);
sv_rate = zeros(realizations,1);

gamas = linspace(1,50,nGamas);
gamaSearch = zeros(2,nGamas);

sigmas = linspace(1,0.3,nSigmas)
sigmaGamaSearch = zeros(nSigmas,nGamas);

for s=1:nSigmas
    sigma = sigmas(s)
    fprintf('Sigma:%.3f\n',sigma);
    params.sigma = sigma;
    
    
    for g=1:length(gamas)
        params.gamma = gamas(g);
        fprintf('gama:%.3f\n',1/gamas(g));


        accRealizacao = zeros(1,realizations);
        for i = 1 : realizations
           % fprintf('Realizacao:%.d   ',i);
            [train_f train_l test_f test_l] = ds.shuffle(train_percs);

            P = length(train_l) / nPart;
            accXValidation = zeros(1,nPart);
            svXValidation = zeros(1,nPart);

            %Cross Validation
            for p=1:nPart 
                idx = int32(   (P * (p-1) + 1) : (p * P) );
                train_features = train_f;
                train_labels   = train_l;

                train_features(idx,:) = [];
                train_labels(idx,:) = [];

                test_features = train_f(idx,:);
                test_labels   = train_l(idx,:);


                my = MyLSSVM(train_features, train_labels, params);
                my.train();

                %make decision function
                output_labels = my.classify(test_features);
                accXValidation(p) = length(find((output_labels - test_labels) == 0))/size(test_features,1);
                svXValidation(p) = length(my.alphas);
            end


            accRealizacao(i) = mean(accXValidation);
           % fprintf('Acuracia:%.3f\n',accRealizacao(i));
        end

        gamaSearch(1,g) = mean(accRealizacao);
        gamaSearch(2,g) = std(accRealizacao);
        fprintf('Acuracia Media:%.3f\n',gamaSearch(1,g));
        sigmaGamaSearch(s,g) = gamaSearch(1,g);
    end
    figure('name','Gama Search'); hold on;
    plot(gamas,gamaSearch(1,:),'b');
    plot(gamas,gamaSearch(1,:) + gamaSearch(2,:),'r');
    plot(gamas,gamaSearch(1,:) - gamaSearch(2,:),'r');
    xlabel('Gama');
    ylabel('Acuracia');
    
    
end


if (~exist('atributos'))
    return;
end



figure;
imagesc(sigmaGamaSearch);
title('Grid Search');
xlabel('Gama');
ylabel('Sigma');

[max_num idx]=max(sigmaGamaSearch(:));
[s g]=ind2sub(size(sigmaGamaSearch),idx);
fprintf('Best Sigma/Gama : %.3f / %.3f\n',sigmas(s),gamas(g));

%Treinando com parametros ótimos
params.gama = gamas(g);
params.sigma = sigmas(s);


my = MyLSSVM(train_features, train_labels, params);
my.train();

%Gerando região de decisão
nAmostra = 100;
range = linspace(-2,2,nAmostra);
xy = generatePairs(range,range);
yc = my.classify(xy);
yc = reshape(yc,[nAmostra nAmostra]);
figure;
imagesc(range,range,yc); hold on;
positivos = train_features(find(train_labels==1),:);
negativos = train_features(find(train_labels==-1),:);
scatter(positivos(:,1),positivos(:,2),'g','filled');
scatter(negativos(:,1),negativos(:,2),'k','filled');





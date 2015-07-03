% set methodology up

realizations = 5;
train_percs = 80;
nPart = 10;
nGamas = 25;

if (~exist('base'))
	base = 'data.txt';
end

% set params up
params.gamma = 0.04;

% data loading
ds = DataSet(base);
ds.normalize();
ds.labels(ds.labels~=2)=-1;



hit_rate = zeros(realizations,1);
sv_rate = zeros(realizations,1);

gamas = linspace(0.001,2,nGamas);
gamaSearch = zeros(2,nGamas);

for g=1:length(gamas)
    params.gamma = gamas(g);
    fprintf('gama:%.3f\n',gamas(g));
    
    
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
end
figure('name','Gama Search'); hold on;
plot(gamas,gamaSearch(1,:),'b');
plot(gamas,gamaSearch(1,:) + gamaSearch(2,:),'r');
plot(gamas,gamaSearch(1,:) - gamaSearch(2,:),'r');
xlabel('Gama');
ylabel('Acuracia');



% hit_mean_rate = sum(hit_rate)/length(hit_rate);
% hit_mean_rate
% 
% hit_sv = (sum(sv_rate)/length(sv_rate));
% hit_sv
% hit_sv_rate =  (sum(sv_rate)/length(sv_rate))/size(train_features,1);
% hit_sv_rate






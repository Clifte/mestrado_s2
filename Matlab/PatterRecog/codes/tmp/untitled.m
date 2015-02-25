clear all;
clc;

% Step 1
irisdata = load ('../database/iris/bezdekIris.data');
k = input('Enter the number of nearest neighbors:  ');

%Step 2: Randomizing and dividing data into 1:1 ratio for training and
%testing

split = 0;
count = 0;
acuracia = 0;

while(count~=1)
    numofobs = length(irisdata);
    rearrangement = randperm(numofobs);
    newirisdata = irisdata(rearrangement,:);
    %newirislabel = newirisdata(rearrangement);
    split = ceil(numofobs/5);
    count = count + 1;
end

% Separate data
dataTe = newirisdata(1:split,:);
dataTr = newirisdata(split+1:end,:);

% Separate and normalize Training of Test
xTe = dataTe(:,1:end-1);
dTe = dataTe(:,end);

xTr = dataTr(:,1:end-1);
dTr = dataTr(:,end);

numoftestdata = size(xTe,1);
numoftrainingdata = size(xTr,1);

for sample = 1:numoftestdata
    
    %Step 3: Computing euclidean distance for each testdata
    euclideandistance = sum((repmat(xTe(sample,:),numoftrainingdata,1)- xTr).^2,2);
        
    %Step 4: compute k nearest neighbors and store them in an array
    [dist position] = sort(euclideandistance,'ascend');
    
    ndTr = dTr(position);
    
    nC = mode(ndTr(1:k,:));
    
    if(nC == dTe(sample)) 
        acuracia = acuracia + 1;
    end
    
    
end

acuracia = acuracia/numoftestdata;
clear;
close all;

mu1 = [2,3];
sigma1 = [1,1.5;1.5,3];

mu2 = [6,5];
sigma2 = [2,1.5;1.5,3];

r1 = mvnrnd(mu1,sigma1,100);
r2 = mvnrnd(mu2,sigma2,100);


figure;

scatter(r1(:,1),r1(:,2),'r');
hold on;
scatter(r2(:,1),r2(:,2),'b');

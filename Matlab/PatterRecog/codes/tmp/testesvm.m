close all;clear all;
N = 500;

x = [rand(N/2,2) + 1;
     rand(N/2,2) + 3];
 
y = [ -1*ones(N/2,1);
      ones(N/2,1)
    ]

cores = [1 0 0
         0 1 0
         0 0 1] 


scatter(x(:,1),x(:,2),25,cores(y+2),'filled');hold on;

W = [x ones(N,1)]\y

yh = sign([x ones(N,1)] * W);
yh = yh*2 -1;
acc = sum(yh == y)/N;

pts = [
        [0 [0 4 1] * W] 
        [[4 0 1] * W 4]
      ];

  
  
plot(pts(:,1),pts(1,:))


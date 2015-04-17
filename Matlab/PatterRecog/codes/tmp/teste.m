m1 = rand(2,1);
m2 = rand(2,1);

scatter(m1(1,:),m1(2,:),'b');
hold on;
scatter(m2(1,:),m2(2,:),'b');

x = (m1'*m1 + m2'*m2) .\ (2*(m2-m1)');

scatter(x(:,1),x(:,2),'r');



clear all

% p = [m1 ks1 ki1 m2 ks2 ki2 alfa c1 c2 k1 k2 k3 k6 k7] 
p = [0.42912 13.065 0 2.6493 571.27 0 1 0 0 0.31204 0.062776 3.1473 278.62 0];
xi = [221.7400 31.2896 0.8082 5.4421]';
xk = [210 35 1 5]';
%xk=xi;
h=1/3;
N=1200;

u=@(t) [1/40; 70+20*sin(2*pi*t/20); 50+20*cos(pi*t/10)];

f1=@(x,t) bio_f(x,t,p,u);
g1=@(x,t) bio_g(x,p);

[y1,q1,t1]=solver_runge_4(f1,g1,0,xi,h,N);

for i=1:50
v=randn(1,N)*10;

q1=q1+v;

[fd,gd]=discretiza_euler(f1,g1,h);

%imprecis�o do modelo
Q=eye(4)/100;
%R=v^2
R=100;
%incerteza das condi��es iniciais
P=1*eye(4);

[Ad] = @(x,i) bio_discreto_A (x,i,p,u,h);

[Cd] = @(x,i) bio_discreto_C (x,p,h);

[XC]=kalman_estendido(Ad,Cd,xk,Q,R,P,q1,fd,gd);

e=(y1(3)-XC(3));

erro=e'*e;

E(i)=erro;

end

Erro=mean(E)


%Altera��es para compara��o
%P

pn = [0.42912 13.065 0 2.6493 571.27 0 1 0 0 0.31204 0.062776 3.1473 278.62 0];
xin = [221.7400 31.2896 0.8082 5.4421]';
xkn = [210 35 1 5]';
h=1/3;
N=1200;

un=@(t) [1/40; 70+20*sin(2*pi*t/20); 50+20*cos(pi*t/10)];

f1n=@(x,t) bio_f(x,t,pn,un);
g1n=@(x,t) bio_g(x,pn);

[y1n,q1n,t1]=solver_runge_4(f1n,g1n,0,xin,h,N);

for i=1:50
vn=randn(1,N)*10;

q1n=q1n+vn;

[fdn,gdn]=discretiza_euler(f1n,g1n,h);

Qn=eye(4)/100;
Rn=100;
%
Pn=10*eye(4);
%

[Adn] = @(x,i) bio_discreto_A (x,i,pn,un,h);

[Cdn] = @(x,i) bio_discreto_C (x,pn,h);

[XCn]=kalman_estendido(Adn,Cdn,xkn,Qn,Rn,Pn,q1n,fdn,gdn);

en=(y1n(3)-XCn(3));

erron=en'*en;

En(i)=erron;

end

Erron=mean(En)

close all
figure(1)
subplot(2,1,1)
plot(t1,y1,'r')
hold on
plot (t1,XC','b')
hold off
subplot(2,1,2)
plot(t1,y1n,'r')
hold on
plot (t1,XCn','b')
hold off

figure(2)
subplot(2,1,1)
plot(t1,q1)
hold on
subplot(2,1,2)
plot(t1,q1n)
hold off

figure(3)
subplot(2,1,1)
plot(t1,y1(3,1:N),'r')
hold on
plot(t1,XC(3,1:N)','b')
hold off
subplot(2,1,2)
plot(t1,y1n(3,1:N),'r')
hold on
plot(t1,XCn(3,1:N)','b')
hold off
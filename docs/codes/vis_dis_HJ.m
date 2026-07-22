%  For viscous discount HJ equation
clear;
clc;

% Parameters
n         = 20;   % 
lambdaset = logspace(-4, -0.5, n);  % discount parameter
alpha     = 0.2;
epsset    = lambdaset.^(1+alpha);     % viscous parameter
diff      = zeros(n,1);
N         = 20000;        % number of intervals
h         = pi/N;
x         = linspace(0,pi,N+1)';  % grid

for  i = 1:n
    lambda = lambdaset(i);
    eps = epsset(i);
%% --------- Solve with eps > 0 ---------
% --------- Newton Iteration ----------
U = zeros(N+1,1);
maxit = 30; tol = 1e-8;

% analytic Jacobian method
for it = 1:maxit
    F = zeros(N+1,1);
    J = spalloc(N+1,N+1,3*(N+1));

    % left boundary
    F(1) = lambda*U(1) + cos(x(1)) - 1 - eps*(2*(U(2)-U(1)))/h^2;
    J(1,1) = lambda + 2*eps/h^2;
    J(1,2) = -2*eps/h^2;

    % interior
    for j=2:N
        up  = (U(j+1)-U(j-1))/(2*h);
        upp = (U(j+1)-2*U(j)+U(j-1))/h^2;
        F(j) = lambda*U(j) + 0.5*up^2 + cos(x(j)) - 1 - eps*upp;

        J(j,j-1) = -up/(2*h) - eps/h^2;
        J(j,j)   = lambda + 2*eps/h^2;
        J(j,j+1) =  up/(2*h) - eps/h^2;
    end

    % right boundary
    F(N+1) = lambda*U(N+1) + cos(x(N+1)) - 1 ...
           - eps*(2*(U(N)-U(N+1)))/h^2;
    J(N+1,N+1) = lambda + 2*eps/h^2;
    J(N+1,N)   = -2*eps/h^2;

    res = norm(F,inf);
    fprintf('iter %d: ||F||_inf = %.3e\n',it,res);
    if res < tol, 
        break;
    end
    dU = -J\F;
    U = U + dU;
end

% derivative
Up = zeros(N+1,1);
for j=2:N
    Up(j) = (U(j+1)-U(j-1))/(2*h);
end
Up(1)=0; Up(N+1)=0;

%% --------- Solve with eps = 0 ---------

    U0 = 0;         % initial condition u(0)=0
    
    % Solve ODE (positive branch)
    [x,u] = ode45(@(x,u) rhs(x,u,lambda), x, U0);


% derivative
Up0 = zeros(N+1,1);
for j=2:N
    Up0(j) = (u(j+1)-u(j-1))/(2*h);
end
Up0(1)=0; Up0(N+1)=0;

%% ---------Comparsion eps>0 with eps=0--------
udiff = U-u;
diff(i) = norm(udiff,inf);

%% --------- Plot results ---------
% figure;
% plot(x,U,'b-','LineWidth',1.5); hold on;
%     plot(x,u,'LineWidth',2);
% %    xlabel('x'); ylabel('u(x)');
% %    title(['Solution of \\lambda u + |u''|^2/2 + cos(x) - 1 = 0, \lambda=',num2str(lambda)]);
% %    grid on;
% %plot(x,U0,'r--','LineWidth',1.5);
% grid on;
% xlabel('x'); ylabel('u(x)');
% legend('eps>0','eps=0');
% title(sprintf('Solution u(x), \\lambda=%.2f, eps=%.2f vs 0',lambda,eps));
% 
% figure;
% plot(x,Up,'b-','LineWidth',1.5); hold on;
% plot(x,Up0,'r--','LineWidth',1.5);
% grid on;
% xlabel('x'); ylabel('u''(x)');
% legend('eps>0','eps=0');
% title('Derivative u''(x)');

end
%% --------- Plot convergence rate----------
figure;
loglog(lambdaset,diff,'o-', 'LineWidth',1.5)
hold on
loglog(lambdaset,lambdaset.^alpha+abs(epsset.*log(epsset)),'k--')
loglog(lambdaset,lambdaset.^alpha,'r--')
fig1_legend=legend(['||u_\lambda^\epsilon(x)-u_\lambda(x)||, N=',num2str(N)],'\epsilon/\lambda+\epsilon|log\epsilon|','\epsilon/\lambda')
set(fig1_legend, 'Position', [0.2, 0.75, 0.2, 0.15], 'FontSize', 12)
xlabel('\lambda');
%title(['\alpha=',num2str(alpha),', \epsilon=\lambda^{1+\alpha}'])

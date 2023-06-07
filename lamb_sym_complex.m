function erro = lamb_sym_complex(kd,wd,CL,CT,h)
%% 材料属性
nu = 0.33; % 铝

%% 结构参数
k = 2.0288;

%% 频散方程
F = @(x,y) tan(sqrt(x^2-y^2))/tan(sqrt(x^2/k^2-y^2)) + 4*y^2*sqrt(x^2/k^2-y^2)*sqrt(x^2-y^2)/(x^2-2*y^2)^2;
erro = F(wd,kd);
end
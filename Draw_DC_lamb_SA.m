clear;close all
addpath(".\wave_function")
addpath(".\get_wavenumber")
%% 材料参数
%%% 铝材
lambda = 51e9;
mu = 26e9;
density = 2700;

%%% 波速
CL = sqrt((lambda+2*mu)/density);
CT = sqrt(mu/density);
%% 几何参数
h = 0.5e-3; % 半板厚
%% 扫频范围
f = [0, 10e6];
num_dw = 2000; % 扫频点数
w = 2*pi*f;
dw = diff(w)/num_dw; % 扫频步长
w_sca = w(1):dw:w(2) ;
%% 求解波数
Ta = tic; % 计时开始[Ta]
wd_sca = w_sca*h/CT; % 无量纲化

%%% 对称模态
F1 = @lamb_sym;
[Kd_sym,Wd_sym,nmode_sym] = get_wavenumber(wd_sca,lambda,mu,density,h,F1);
% 量纲还原
K_sym = Kd_sym/h;
W_sym = Wd_sym*CT/h;
F_sym = W_sym/2/pi;

Cp_sym = W_sym./K_sym;
Cg_sym = Cp_sym + K_sym.*[nan(1,size(K_sym,2));diff(Cp_sym)./diff(K_sym)];


%%% 反对称模态
F2 = @lamb_asy;
[Kd_asy,Wd_asy,nmode_asy] = get_wavenumber(wd_sca,lambda,mu,density,h,F2);
% 量纲还原
K_asy = Kd_asy/h;
W_asy = Wd_asy*CT/h;
F_asy = W_asy/2/pi;

Cp_asy = W_asy./K_asy;
Cg_asy = Cp_asy + K_asy.*[nan(1,size(K_asy,2));diff(Cp_asy)./diff(K_asy)];

T = toc(Ta); % 计时结束[Ta]
%% 绘图
%%% 频散曲线
fig(1) = figure(1);
plot(F_sym(:),K_sym(:),'.',color="#0072BD"); % 对称模态频散曲线
hold on
plot(F_asy(:),K_asy(:),'.',color="#D95319"); % 反对称模态频散曲线
hold off
xlabel("频率f [Hz]")
ylabel("波数k [m^{-1}]")
legend("Symmetric","Asymmetric",'location','northwest')
title("频散曲线")

%%% 相速度
fig(2) = figure(2);
plot(F_sym(:),Cp_sym(:),'.',color="#0072BD"); % 对称模态
hold on
plot(F_asy(:),Cp_asy(:),'.',color="#D95319"); % 反对称模态
hold off
xlabel("频率f [Hz]")
ylabel("相速度C_p [m/s]")
legend('Symmetric','Asymmetric','location','northwest')
title("相速度")
ylim([0 12e3])


%%% 群速度
fig(3) = figure(3);
plot(F_sym(:),Cg_sym(:),'.',color="#0072BD"); % 对称模态
hold on
plot(F_asy(:),Cg_asy(:),'.',color="#D95319"); % 反对称模态
hold off
xlabel("频率f [Hz]")
ylabel("群速度C_g [m/s]")
legend("Symmetric","Asymmetric",'location','northwest')
title("群速度")
ylim([0 8e3])


%%% 保存绘图
mkdir output % 创建文件夹output，如果文件夹已存在，会有警告，但不影响运行
date = datetime("now","Format","uuuu-MM-dd HH.mm.ss");
name_fig = ['./output/Lamb_DC_lamb_SA [', char(date), '].fig'] % 绘图文件名
savefig(fig,name_fig)

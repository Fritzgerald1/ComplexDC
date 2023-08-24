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

%%% 对称模态@lamb_sym 或 反对称模态@lamb_asy
F1 = @lamb_sym; 
[Kr,Ki,Wd,mode_s] = get_wavenumber_complex(wd_sca,lambda,mu,density,h,F1);
% 量纲还原
Krs = Kr/h;
Kis = Ki/h;
W = Wd*CT/h;
F = W/2/pi;

T = toc(Ta); % 计时结束[Ta]
%% 绘图
fig = figure();
idr = (Ki == 0);
s1 = scatter3(Ki(idr),Kr(idr),F(idr),3,'red','filled'); % 实部
hold on
idi = (Kr == 0);
s2 = scatter3(Ki(idi),Kr(idi),F(idi),3,'black','filled'); % 虚部

idc = (~(idi)) & (~(idr));
s3 = scatter3(Ki(idc),Kr(idc),F(idc),3,'blue','filled'); % 复数部

hold off
view([135 15])
legend('real','image','complex')
char1 = char(F1);
title(char1);

mkdir output % 创建文件夹output，如果文件夹已存在，会有警告，但不影响运行
date = datetime("now","Format","uuuu-MM-dd HH.mm.ss");
name_fig = ['./output/', char1, '[', char(date), '].fig'] % 绘图文件名
savefig(fig,name_fig)

%{
%% 绘图
fig = figure();
hold on
MyDraw(Ks*h,Ws*h*2/(pi*CT),mode_s,fig);

hold off
title(['time=', num2str(T)]);legend('Symmetric','Asymmetric')
%}

%% 运行完成后的提示音效
% load train
% sound(y,Fs)
%------------------------------------------------------------
% end
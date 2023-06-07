% function fig = My_Lamb
%% 材料参数
CL = 6.35;
CT = 3.13;
h=0.5;

%% 频率范围 MHZ
lw = 1e-3/2*pi;
rw = 6/2*pi;
dw = (rw-lw)/1000;
w_sca = lw:dw:rw;

%% 求解波数
Ta = tic;
F1 = @lamb_sym_real2;
[Krsym,Kisym,Wsym,mode_s] = get_wavenumber_complex(w_sca,F1);
% 量纲还原
Krs = Krsym/h;
Kis = Kisym/h;
Ws = Wsym*CT/h;

T = toc(Ta);

%% 绘图
fig = figure();
idr = (Kisym == 0);
scatter3(Kisym(idr),Krsym(idr),Wsym(idr),1.5,'red')
hold on
idi = (Krsym == 0);
scatter3(Kisym(idi),Krsym(idi),Wsym(idi),1.5,'red')

idc = (~(idi)) & (~(idr));
scatter3(Kisym(idc),Krsym(idc),Wsym(idc),1.5,'blue')

hold off
view([135 15])
title("Symmetric");

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
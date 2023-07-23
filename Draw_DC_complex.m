% function fig = My_Lamb
%% 材料参数
CL = 6.35;
CT = 3.13;
h=0.5;

%% 频率范围 MHZ
lw = 1e-3/2*pi;
rw = 6/2*pi;
dw = (rw-lw)/2000;
w_sca = lw:dw:rw;

%% 求解波数
Ta = tic;
F1 = @lamb_sym;
[Krsym,Kisym,Wsym,mode_s] = get_wavenumber_complex(w_sca,F1);
% 量纲还原
Krs = Krsym/h;
Kis = Kisym/h;
Ws = Wsym*CT/h;

T = toc(Ta);

%% 绘图
fig = figure();
idr = (Kisym == 0);
s1 = scatter3(Kisym(idr),Krsym(idr),Wsym(idr),3,'red','filled');
hold on
idi = (Krsym == 0);
s2 = scatter3(Kisym(idi),Krsym(idi),Wsym(idi),3,'black','filled');

idc = (~(idi)) & (~(idr));
s3 = scatter3(Kisym(idc),Krsym(idc),Wsym(idc),3,'blue','filled');

hold off
view([135 15])
title("Symmetric");	legend('real','image','complex')

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
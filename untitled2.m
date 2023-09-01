
Cg_sym = Cp_sym + K_sym.*[nan(1,size(K_sym,2));diff(Cp_sym)./diff(K_sym)];

Cg_asy = Cp_asy + K_asy.*[nan(1,size(K_asy,2));diff(Cp_asy)./diff(K_asy)];


%%

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

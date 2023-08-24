function [RealK,Omega,modes] = get_wavenumber(wd_sca,lambda,mu,density,h,Fun)
%%
% 输入量：
%	wd_sca为无量纲数
%		wd_sca = w*h/CT
% 输出量：
%	RealK也是无量纲数
%		RealK = k*h
%	t是模态数量
%	Omega是t个wd_sca

%% 变量初始化
max_nmodes = 30;% 最大模态数
RealK = zeros(numel(wd_sca),max_nmodes);
Omega = zeros(numel(wd_sca),max_nmodes);
modes = zeros(size(wd_sca)); % 模态数

%% 搜索波数解的范围
Ay = 1e-3;
By = 10;
dy = 1e-3;

%% 搜索波数解
for ii = 1:numel(wd_sca) % 扫描频率的区间
	aw = wd_sca(ii);
	for  ay = Ay:5*dy:By % 搜索波数解实部的范围
		s1=inf;
		sw1=0;
		sy1=0;
		by = ay+6*dy; % 搜索范围的右边界
		%% 在小网格里，找到极小值解(syr1,siy1,sw1)
		for y1 = ay:dy:by
			h1 = Fun(y1,aw,lambda,mu,density,h); % 频散方程行列式
			hh1 = abs(h1);
			if hh1 < s1
				s1 = hh1;
				sw1 = aw;
				sy1 = y1;
			end
		end

		if (abs(sy1-ay)>0.1*dy) && (abs(sy1-by)>0.1*dy) % 不在外边界上
			%% 当极小值不在边界时，判断该点是否是零点
			[true_sy,zero_flag]=Determine_zero_point(sy1,sw1,dy,lambda,mu,density,h,Fun); % 判断零点，ssy1为每次迭代的解
			if zero_flag == 1 % 该点是零点
                modes(ii) = modes(ii)+1;
                RealK(ii,modes(ii)) = true_sy;
                Omega(ii,modes(ii)) = sw1;
				% Omega=[Omega sw1];
				% RealK=[RealK true_sy];
				
			end
		end
    end
    RealK(ii,1:modes(ii)) = RealK(ii,modes(ii):-1:1);
    Omega(ii,1:modes(ii)) = Omega(ii,modes(ii):-1:1);
end
end
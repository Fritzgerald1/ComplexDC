function  [zpr,zpi,zero_flag]=Determine_zero_point_complex(yr,yi,w,dry,diy,lambda,mu,density,h,Fun)
%% Determine_zero_point
% 判断(yr+1i*yi,w)是否为零点
% 输出：
%	ssry1,ssiy1:末项为零点y的精确解；
%	DetF:每次迭代的行列式，当DetF(1)/DetF(end) > 1e7时
%	zero_flag:为1时，该点为零点；为0时，该点不是零点。

zpr = [];
zpi = [];
zero_flag = 0;
Detmin=inf;
sry = 0;
siy = 0;
iter = 10;% 迭代次数
step = 2;% 将子区间[yy-ty,yy+ty]划分为2*{step}份
DetF=zeros(1,iter);
ssry1=zeros(1,iter);
ssiy1=zeros(1,iter);

%% 搜索区间为[y-ty,y+ty]，步长(ty/step)
ary = yr-dry;
bry = yr+dry;
dry = dry/step;

aiy = yi-diy;
biy = yi+diy;
diy = diy/step;

for k = 1:iter
	for yr1 = ary:dry:bry
		for yi1 = aiy:diy:biy
			y1 = yr1+1i*yi1;
			[h1,flag] = Fun(y1,w,lambda,mu,density,h);
			hh1 = abs(h1);
			if hh1 < Detmin
				Detmin = hh1;
				sry = yr1;
				siy = yi1;
			end
		end
	end
	DetF(k) = Detmin; % 存储每个迭代的行列式
	ssry1(k) = sry; % 存储每个迭代的解的实部
	ssiy1(k) = siy; % 存储每个迭代的解的虚部
	%% 缩小搜索区间
	ary = sry-dry;	bry = sry+dry;	dry = dry/step;
	aiy = siy-diy;	biy = siy+diy;	diy = diy/step;
end

if DetF(1)/DetF(end) > 1e2 % 为零点
	if flag
	zero_flag = 1;
	zpr = ssry1(end);
	zpi = ssiy1(end);
	end
end
end
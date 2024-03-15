function [fitness] = fun(X,I)
[r,c,color] = size(I);%获取图像尺寸
if(color == 3)
    I = rgb2gray(I);
end

I = double((I- min(I(:)))./(max(I(:)) - min(I(:))));%图像归一化;
I = I(:);%把图像变为1维向量;
alpha = X(1);
beta = X(2);
Iout = betainc(I,alpha,beta); %非完全beta
fitness = sum(Iout.^2)/(r*c)  - (sum(Iout)/(r*c))^2; %图像方差
fitness = -fitness;%转换为寻找最小值。
end
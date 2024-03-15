function [fitness] = fun(X,I)
[r,c,color] = size(I);%��ȡͼ��ߴ�
if(color == 3)
    I = rgb2gray(I);
end

I = double((I- min(I(:)))./(max(I(:)) - min(I(:))));%ͼ���һ��;
I = I(:);%��ͼ���Ϊ1ά����;
alpha = X(1);
beta = X(2);
Iout = betainc(I,alpha,beta); %����ȫbeta
fitness = sum(Iout.^2)/(r*c)  - (sum(Iout)/(r*c))^2; %ͼ�񷽲�
fitness = -fitness;%ת��ΪѰ����Сֵ��
end
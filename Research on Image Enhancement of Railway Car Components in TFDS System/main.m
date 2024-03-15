%_________________________________________________________________________%
% 基于麻雀搜索算法与非完全beta函数的自适应图像增强算法            %
%__________________________________________________________________________%







clear all ;clear;
clc
rng('default')
%读取图像
B = imread('11.jpg'); %加载图像
[r,c,color] = size(B);%获取图像尺寸
if(color == 3)
    Igray = rgb2gray(B);
    Igray = double(Igray);
    B = double(B);
else
    Igray = B;
    Igray = double(Igray);
    B = double(B);
end

SearchAgents_no=20; % Number of search agents 种群数量
Max_iteration=20; % Maximum numbef of iterations 设定最大迭代次数
lb = 0.1; %下边界
ub = 5;  %上边界
dim = 2; %维度为2，即alpha，beta
fobj = @(X) fun(X,Igray);%适应度函数
[Best_pos,Best_score,SSA_curve]=SSA(SearchAgents_no,Max_iteration,lb,ub,dim,fobj); %开始优化
figure
plot(SSA_curve,'Color','r','linewidth',2)
hold on
title('收敛曲线')
xlabel('迭代次数');
ylabel('最优适应度值');

axis tight
grid on
box on
legend('SSA')
display(['alpah,beta的值为:',num2str(Best_pos)]);
%输出增强结果
if(color == 1)%灰度图
    It = ((B- min(B(:)))./(max(B(:)) - min(B(:))));%图像归一化;;%图像归一化;
    It = It(:);%把图像变为1维向量;
    alpha = Best_pos(1);
    beta = Best_pos(2);
    Iout = betainc(It,alpha,beta);
    Iout = double(max(B(:)) - min(B(:))).*Iout + min(B(:));    %反归一化
    Iout = uint8(Iout);
    Iout = reshape(Iout,[r,c]);
    figure
     imshow([uint8(B),uint8(Iout)],[]);
    title('增强前后对比图')
else%彩色图
   Iout = zeros(r,c,3);
   for i = 1:3     
    Itemp = B(:,:,i);
    It = ((Itemp- min(B(:)))./(max(B(:)) - min(B(:))));%图像归一化;
    It = It(:);%把图像变为1维向量;
    alpha = Best_pos(1);
    beta = Best_pos(2);
    IoutT = betainc(It,alpha,beta);
    IoutT = (max(B(:)) - min(B(:))).*IoutT + min(B(:));     %反归一化
    IoutT = uint8(IoutT);
    IoutT = reshape(IoutT,[r,c]);
    Iout(:,:,i) = IoutT;
   end
   figure
   imshow([uint8(B),uint8(Iout)],[]);
   title('增强前后对比图')
end
    

    



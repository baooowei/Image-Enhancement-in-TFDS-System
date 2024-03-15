clear
clc

orimg=imread('D:\About BJTU\大创\题目算法\原图像\21.png');
orimg=rgb2gray(orimg);
[ori_row,ori_col]=size(orimg);

sigma = 0.7;%sigma赋值
N = 7;%大小是（2N+1）×（2N+1）
N_row = 2*N+1;
 
H = [];%求高斯模板H
for i=1:N_row
    for j=1:N_row
        fenzi=double((i-N-1)^2+(j-N-1)^2);
        H(i,j)=exp(-fenzi/(2*sigma*sigma))/(2*pi*sigma);
    end
end
H=H/sum(H(:));%归一化
 
h=zeros(ori_row,ori_col);%滤波后图像
midimg=zeros(ori_row+2*N,ori_col+2*N);%中间图像
for i=1:ori_row %原图像赋值给中间图像，四周边缘设置为0
    for j=1:ori_col
        midimg(i+N,j+N)=orimg(i,j);
    end
end
temp=[];
for ai=N+1:ori_row+N
    for aj=N+1:ori_col+N
        temp_row=ai-N;
        temp_col=aj-N;
        temp=0;
        for bi=1:N_row
            for bj=1:N_row
                temp= temp+(midimg(temp_row+bi-1,temp_col+bj-1)*H(bi,bj));
            end
        end
        h(temp_row,temp_col)=temp;
    end
end
h=uint8(h);
% imshow(h);

%拉普拉斯算子锐化图像
I=im2double(h);
[m,n,c]=size(I);
A=zeros(m,n,c);
for i=2:m-1
    for j=2:n-1
        A(i,j,1)=I(i+1,j,1)+I(i-1,j,1)+I(i,j+1,1)+I(i,j-1,1)-4*I(i,j,1);
    end
end %以上为拉普拉斯边缘检测
B=I-A; %整体图像边缘增强
imwrite(B,'edg_inhance.png','png')
% figure
% imshow(B);
%title('边缘增强图像')

%自适应整体增强
rng('default')
B = imread('edg_inhance.png','png');
[r,c,color] = size(B);%获取图像尺寸
Igray = B;
Igray = double(Igray);
B = double(B);

SearchAgents_no=20; % Number of search agents 种群数量
Max_iteration=20; % Maximum numbef of iterations 设定最大迭代次数
lb = 0.5; %下边界
ub = 6;  %上边界
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
It = ((B- min(B(:)))./(max(B(:)) - min(B(:))));%图像归一化;
It = It(:);%把图像变为1维向量;
alpha = Best_pos(1);
beta = Best_pos(2);
Iout = betainc(It,alpha,beta);
Iout = double(max(B(:)) - min(B(:))).*Iout + min(B(:)); %反归一化
Iout = uint8(Iout);
Iout = reshape(Iout,[r,c]);
figure
imshow([uint8(B),uint8(Iout)],[]);
title('增强前后对比图')
imwrite(Iout,'Final_inhance.png','png')


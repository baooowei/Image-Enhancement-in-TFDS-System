clear
clc

orimg=imread('D:\About BJTU\��\��Ŀ�㷨\ԭͼ��\21.png');
orimg=rgb2gray(orimg);
[ori_row,ori_col]=size(orimg);

sigma = 0.7;%sigma��ֵ
N = 7;%��С�ǣ�2N+1������2N+1��
N_row = 2*N+1;
 
H = [];%���˹ģ��H
for i=1:N_row
    for j=1:N_row
        fenzi=double((i-N-1)^2+(j-N-1)^2);
        H(i,j)=exp(-fenzi/(2*sigma*sigma))/(2*pi*sigma);
    end
end
H=H/sum(H(:));%��һ��
 
h=zeros(ori_row,ori_col);%�˲���ͼ��
midimg=zeros(ori_row+2*N,ori_col+2*N);%�м�ͼ��
for i=1:ori_row %ԭͼ��ֵ���м�ͼ�����ܱ�Ե����Ϊ0
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

%������˹������ͼ��
I=im2double(h);
[m,n,c]=size(I);
A=zeros(m,n,c);
for i=2:m-1
    for j=2:n-1
        A(i,j,1)=I(i+1,j,1)+I(i-1,j,1)+I(i,j+1,1)+I(i,j-1,1)-4*I(i,j,1);
    end
end %����Ϊ������˹��Ե���
B=I-A; %����ͼ���Ե��ǿ
imwrite(B,'edg_inhance.png','png')
% figure
% imshow(B);
%title('��Ե��ǿͼ��')

%����Ӧ������ǿ
rng('default')
B = imread('edg_inhance.png','png');
[r,c,color] = size(B);%��ȡͼ��ߴ�
Igray = B;
Igray = double(Igray);
B = double(B);

SearchAgents_no=20; % Number of search agents ��Ⱥ����
Max_iteration=20; % Maximum numbef of iterations �趨����������
lb = 0.5; %�±߽�
ub = 6;  %�ϱ߽�
dim = 2; %ά��Ϊ2����alpha��beta
fobj = @(X) fun(X,Igray);%��Ӧ�Ⱥ���
[Best_pos,Best_score,SSA_curve]=SSA(SearchAgents_no,Max_iteration,lb,ub,dim,fobj); %��ʼ�Ż�
figure
plot(SSA_curve,'Color','r','linewidth',2)
hold on
title('��������')
xlabel('��������');
ylabel('������Ӧ��ֵ');

axis tight
grid on
box on
legend('SSA')
display(['alpah,beta��ֵΪ:',num2str(Best_pos)]);

%�����ǿ���
It = ((B- min(B(:)))./(max(B(:)) - min(B(:))));%ͼ���һ��;
It = It(:);%��ͼ���Ϊ1ά����;
alpha = Best_pos(1);
beta = Best_pos(2);
Iout = betainc(It,alpha,beta);
Iout = double(max(B(:)) - min(B(:))).*Iout + min(B(:)); %����һ��
Iout = uint8(Iout);
Iout = reshape(Iout,[r,c]);
figure
imshow([uint8(B),uint8(Iout)],[]);
title('��ǿǰ��Ա�ͼ')
imwrite(Iout,'Final_inhance.png','png')


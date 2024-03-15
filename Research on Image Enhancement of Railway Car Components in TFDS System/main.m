%_________________________________________________________________________%
% ������ȸ�����㷨�����ȫbeta����������Ӧͼ����ǿ�㷨            %
%__________________________________________________________________________%







clear all ;clear;
clc
rng('default')
%��ȡͼ��
B = imread('11.jpg'); %����ͼ��
[r,c,color] = size(B);%��ȡͼ��ߴ�
if(color == 3)
    Igray = rgb2gray(B);
    Igray = double(Igray);
    B = double(B);
else
    Igray = B;
    Igray = double(Igray);
    B = double(B);
end

SearchAgents_no=20; % Number of search agents ��Ⱥ����
Max_iteration=20; % Maximum numbef of iterations �趨����������
lb = 0.1; %�±߽�
ub = 5;  %�ϱ߽�
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
if(color == 1)%�Ҷ�ͼ
    It = ((B- min(B(:)))./(max(B(:)) - min(B(:))));%ͼ���һ��;;%ͼ���һ��;
    It = It(:);%��ͼ���Ϊ1ά����;
    alpha = Best_pos(1);
    beta = Best_pos(2);
    Iout = betainc(It,alpha,beta);
    Iout = double(max(B(:)) - min(B(:))).*Iout + min(B(:));    %����һ��
    Iout = uint8(Iout);
    Iout = reshape(Iout,[r,c]);
    figure
     imshow([uint8(B),uint8(Iout)],[]);
    title('��ǿǰ��Ա�ͼ')
else%��ɫͼ
   Iout = zeros(r,c,3);
   for i = 1:3     
    Itemp = B(:,:,i);
    It = ((Itemp- min(B(:)))./(max(B(:)) - min(B(:))));%ͼ���һ��;
    It = It(:);%��ͼ���Ϊ1ά����;
    alpha = Best_pos(1);
    beta = Best_pos(2);
    IoutT = betainc(It,alpha,beta);
    IoutT = (max(B(:)) - min(B(:))).*IoutT + min(B(:));     %����һ��
    IoutT = uint8(IoutT);
    IoutT = reshape(IoutT,[r,c]);
    Iout(:,:,i) = IoutT;
   end
   figure
   imshow([uint8(B),uint8(Iout)],[]);
   title('��ǿǰ��Ա�ͼ')
end
    

    



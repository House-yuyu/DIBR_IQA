function [QR] = MDWT(Ref,Dist)

   Ref = rgb2gray(Ref);
   Dist = rgb2gray(Dist);
   
%    
[H_tform_matrix]=shift_Compasation(Ref,Dist);

if H_tform_matrix.T(1,1)>=1.007
    recovered = imwarp(im2single(Ref),H_tform_matrix, 'OutputView',imref2d(size(Ref)));
    Ref = recovered * 255;
end
    
   




%=============================================================================================================================


%=======================================���ж�߶�С���任======================================================================
%�ο�ͼ���ά�༶С���任
[C_ref,S_ref] = wavedec2(Ref, 2, 'sym7');%ʹ��db20С����������ͼ��X����2��С���ֽ�


cA2_ref = appcoef2(C_ref,S_ref,'sym7',2); %��ȡ2����Ƶ�ɷ�
cH2_ref = detcoef2('h',C_ref,S_ref,2); %��ȡ2����Ƶ�ɷ֣�h��v��d�ֱ����ˮƽ����ֱ���Խ���
cV2_ref = detcoef2('v',C_ref,S_ref,2);
cD2_ref = detcoef2('d',C_ref,S_ref,2);
% wfilters

cA1_ref = appcoef2(C_ref,S_ref,'sym7',1); %��ȡ1����Ƶ�ɷ�
cH1_ref = detcoef2('h',C_ref,S_ref,1);%��ȡ1����Ƶ�ɷ�
cV1_ref = detcoef2('v',C_ref,S_ref,1);
cD1_ref = detcoef2('d',C_ref,S_ref,1);

%ʧ��ͼ���ά�༶С���任
[C_syn,S_syn] = wavedec2(Dist, 2, 'sym7');%ʹ��sym7С����������ͼ��X����2��С���ֽ�



cA2_syn = appcoef2(C_syn,S_syn,'sym7',2); %��ȡ2����Ƶ�ɷ�
cH2_syn = detcoef2('h',C_syn,S_syn,2); %��ȡ2����Ƶ�ɷ֣�h��v��d�ֱ����ˮƽ����ֱ���Խ���
cV2_syn = detcoef2('v',C_syn,S_syn,2);
cD2_syn = detcoef2('d',C_syn,S_syn,2); 

cA1_syn = appcoef2(C_syn,S_syn,'sym7',1); %��ȡ1����Ƶ�ɷ�
cH1_syn = detcoef2('h',C_syn,S_syn,1);%��ȡ1����Ƶ�ɷ֣�h��v��d�ֱ����ˮƽ����ֱ���Խ���
cV1_syn = detcoef2('v',C_syn,S_syn,1);
cD1_syn = detcoef2('d',C_syn,S_syn,1);


%===========================================================================================================================


%===================================================��С���Ӵ��м���ʧ��===================================================
%��Ƶ
%�߶�1��Ƶ
[sim_1] = gra_sim(cA1_ref,cA1_syn);
sim_1 = 1 - sim_1;

%�߶�2��Ƶ
[sim_2] = gra_sim(cA2_ref,cA2_syn);
sim_2 = 1 - sim_2;

%��Ƶ
%�߶�1��Ƶ
[sim_3] = gra_sim(cD1_ref,cD1_syn); 
sim_3 = 1 - sim_3;


%�߶�2��Ƶ
[sim_4] = gra_sim(cD2_ref,cD2_syn);
sim_4 = 1 - sim_4;



% % % %�߶�1��̬ѧ����
          C = strel('square',2);%Ĭ��3           
          sim_1 = imopen(sim_1,C);
          sim_3 = imopen(sim_3,C);
% 
% % % % �߶�2��̬ѧ����
          C = strel('square',1);%Ĭ��3           
          sim_2 = imopen(sim_2,C);
          sim_4 = imopen(sim_4,C);


% % %�߶�1��ֵ�˲�
sim_1 = medfilt2(sim_1,[4 4]);
sim_3 = medfilt2(sim_3,[4 4]);

% % % % %�߶�2��ֵ�˲�
sim_2 = medfilt2(sim_2,[3 3]);
sim_4 = medfilt2(sim_4,[3 3]);



%��Ƶ=======================================================================================
%�߶�1��Ƶ
score_1 = std2(sim_1);
%�߶�2��Ƶ
score_2 = std2(sim_2);

%��Ƶ=======================================================================================
%�߶�1��Ƶ
score_3 = std2(sim_3);
%�߶�2��Ƶ
score_4 = std2(sim_4);



     a = 0.55;
     b = 0.95;
     
     QR = ( (1-a) * (b * score_1 + (1 - b) * score_2) + a * (b * score_3 + (1 - b) * score_4) );


end
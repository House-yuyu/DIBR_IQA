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


%=======================================进行多尺度小波变换======================================================================
%参考图像二维多级小波变换
[C_ref,S_ref] = wavedec2(Ref, 2, 'sym7');%使用db20小波基函数对图像X进行2级小波分解


cA2_ref = appcoef2(C_ref,S_ref,'sym7',2); %提取2级低频成分
cH2_ref = detcoef2('h',C_ref,S_ref,2); %提取2级高频成分，h，v，d分别代表水平、垂直、对角线
cV2_ref = detcoef2('v',C_ref,S_ref,2);
cD2_ref = detcoef2('d',C_ref,S_ref,2);
% wfilters

cA1_ref = appcoef2(C_ref,S_ref,'sym7',1); %提取1级低频成分
cH1_ref = detcoef2('h',C_ref,S_ref,1);%提取1级高频成分
cV1_ref = detcoef2('v',C_ref,S_ref,1);
cD1_ref = detcoef2('d',C_ref,S_ref,1);

%失真图像二维多级小波变换
[C_syn,S_syn] = wavedec2(Dist, 2, 'sym7');%使用sym7小波基函数对图像X进行2级小波分解



cA2_syn = appcoef2(C_syn,S_syn,'sym7',2); %提取2级低频成分
cH2_syn = detcoef2('h',C_syn,S_syn,2); %提取2级高频成分，h，v，d分别代表水平、垂直、对角线
cV2_syn = detcoef2('v',C_syn,S_syn,2);
cD2_syn = detcoef2('d',C_syn,S_syn,2); 

cA1_syn = appcoef2(C_syn,S_syn,'sym7',1); %提取1级低频成分
cH1_syn = detcoef2('h',C_syn,S_syn,1);%提取1级高频成分，h，v，d分别代表水平、垂直、对角线
cV1_syn = detcoef2('v',C_syn,S_syn,1);
cD1_syn = detcoef2('d',C_syn,S_syn,1);


%===========================================================================================================================


%===================================================从小波子带中检测出失真===================================================
%低频
%尺度1低频
[sim_1] = gra_sim(cA1_ref,cA1_syn);
sim_1 = 1 - sim_1;

%尺度2低频
[sim_2] = gra_sim(cA2_ref,cA2_syn);
sim_2 = 1 - sim_2;

%高频
%尺度1高频
[sim_3] = gra_sim(cD1_ref,cD1_syn); 
sim_3 = 1 - sim_3;


%尺度2高频
[sim_4] = gra_sim(cD2_ref,cD2_syn);
sim_4 = 1 - sim_4;



% % % %尺度1形态学运算
          C = strel('square',2);%默认3           
          sim_1 = imopen(sim_1,C);
          sim_3 = imopen(sim_3,C);
% 
% % % % 尺度2形态学运算
          C = strel('square',1);%默认3           
          sim_2 = imopen(sim_2,C);
          sim_4 = imopen(sim_4,C);


% % %尺度1中值滤波
sim_1 = medfilt2(sim_1,[4 4]);
sim_3 = medfilt2(sim_3,[4 4]);

% % % % %尺度2中值滤波
sim_2 = medfilt2(sim_2,[3 3]);
sim_4 = medfilt2(sim_4,[3 3]);



%低频=======================================================================================
%尺度1低频
score_1 = std2(sim_1);
%尺度2低频
score_2 = std2(sim_2);

%高频=======================================================================================
%尺度1高频
score_3 = std2(sim_3);
%尺度2高频
score_4 = std2(sim_4);



     a = 0.55;
     b = 0.95;
     
     QR = ( (1-a) * (b * score_1 + (1 - b) * score_2) + a * (b * score_3 + (1 - b) * score_4) );


end
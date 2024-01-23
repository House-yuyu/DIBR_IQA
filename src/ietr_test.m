clc;
clear all;
%读取照片分数xlsx文件，IETR，读取照片名和相应的DMOS
[Dmos, Ima_Name] = xlsread('D:\Study\DIBR-IQA\IETR_DIBR_Database\IETR_DIBR_Database\DMOS_variance.xlsx',1,'A2:B141');
cnt = 0;
num = 140;
DIBR_mdwt = zeros(num,1);
score_final = {};
ietr_path = 'D:\Study\DIBR-IQA\IETR_DIBR_Database\IETR_DIBR_Database\IETR_DIBR_database_PNG\';

%全参考IETR代码读取参考图和失真图
for cnt = 1:num
    cnt
    if(cnt < 15)
        Dist = imread([ietr_path,Ima_Name{cnt}]);
        Ref = imread([ietr_path,'BookArrival_cam09_58_original.png']);
    end
    if(cnt >= 15 && cnt < 29)
         Dist = imread([ietr_path,Ima_Name{cnt}]);
        Ref = imread([ietr_path,'Dancer_cam05_66_original.png']);
    end
    if(cnt >= 29 && cnt < 43)
         Dist = imread([ietr_path,Ima_Name{cnt}]);
        Ref = imread([ietr_path,'GT_Fly_cam05_150_original.png']);
    end
    if(cnt >= 43 && cnt < 57)
         Dist = imread([ietr_path,Ima_Name{cnt}]);
        Ref = imread([ietr_path,'Lovebird1_cam06_80_original.png']);
    end
    if(cnt >= 57 && cnt < 71)
         Dist = imread([ietr_path,Ima_Name{cnt}]);
        Ref = imread([ietr_path,'Newspaper_cam04_56_original.png']);
    end
    if(cnt >= 71 && cnt < 85)
        Dist = imread([ietr_path,Ima_Name{cnt}]);
        Ref = imread([ietr_path,'PoznanHall2_cam06_150_original.png']);
    end
        if(cnt >= 85 && cnt < 99)
        Dist = imread([ietr_path,Ima_Name{cnt}]);
        Ref = imread([ietr_path,'Poznan_Street_cam04_26_original.png']);
        end
     if(cnt >= 99 && cnt < 113)
        Dist = imread([ietr_path,Ima_Name{cnt}]);
        Ref = imread([ietr_path,'Shark_cam05_220_original.png']);
     end
     if(cnt >= 113 && cnt < 127)
         Dist = imread([ietr_path,Ima_Name{cnt}]);
        Ref = imread([ietr_path,'balloons_cam03_6_original.png']);
     end
      if(cnt >= 127 && cnt <= 140)
         Dist = imread([ietr_path,Ima_Name{cnt}]);
        Ref = imread([ietr_path,'kendo_cam03_10_original.png']);
      end
      
% K. Gu, G. Zhai, W. Lin, X. Yang and W. Zhang, "Visual Saliency Detection With Free Energy Theory," in IEEE Signal Processing Letters, vol. 22, no. 10, pp. 1552-1555, Oct. 2015, doi: 10.1109/LSP.2015.2413944.
% [SaliencyMap] = FES(Dist);
      

%============================================得出质量分数====================================================      
        DIBR_mdwt(cnt) = MDWT(Ref,Dist);
%   DIBR_mdwt(cnt) = getLeftRightRegions_test(Dist);


end    
DIBR_mdwt = DIBR_mdwt(:);
%============================================得出相关分数====================================================
cc = abs(corr(DIBR_mdwt,Dmos,'type','spearman'));
[delta,beta,x,y,diff] = findrmse2(DIBR_mdwt,Dmos);
[corr(x,y),corr(x,y,'type','spearman'),corr(x,y,'type','kendall'),mean(abs(diff)),(mean(diff.^2))^0.5]
clc;
clear all;
load('ivc_dmos.mat')
%文件路径
 file_path = 'D:\Study\DIBR-IQA\IVC\';
 

cnt = 1;
num = 84;
DIBR_mdwt = zeros(cnt,1);
tic
%IVC全参考读取照片
for cnt = 1:84
    cnt%显示运行位置
    dist_name = strcat(num2str(cnt),'.png');
    if(cnt < 8)
         Dist = imread([file_path,dist_name]);
         Ref = imread([file_path,'85.png']);
    end
    if(cnt >= 8 && cnt < 15)
         Dist = imread([file_path,dist_name]);
         Ref = imread([file_path,'86.png']);
    end
    if(cnt >= 15 && cnt < 22)
         Dist = imread([file_path,dist_name]);
         Ref = imread([file_path,'87.png']);
    end
    if(cnt >= 22 && cnt < 29)
         Dist = imread([file_path,dist_name]);
         Ref = imread([file_path,'88.png']);
    end
    if(cnt >= 29 && cnt < 36)
         Dist = imread([file_path,dist_name]);
         Ref = imread([file_path,'89.png']);
    end
    if(cnt >= 36 && cnt < 43)
         Dist = imread([file_path,dist_name]);
         Ref = imread([file_path,'90.png']);
    end
    if(cnt >= 43 && cnt < 50)
         Dist = imread([file_path,dist_name]);
         Ref = imread([file_path,'91.png']);
    end
    if(cnt >= 50 && cnt < 57)
         Dist = imread([file_path,dist_name]);
         Ref = imread([file_path,'92.png']);
    end
    if(cnt >= 57 && cnt < 64)
         Dist = imread([file_path,dist_name]);
         Ref = imread([file_path,'93.png']);
    end
    if(cnt >= 64 && cnt < 71)
         Dist = imread([file_path,dist_name]);
         Ref = imread([file_path,'94.png']);
    end
    if(cnt >= 71 && cnt < 78)
         Dist = imread([file_path,dist_name]);
         Ref = imread([file_path,'95.png']);
    end
    if(cnt >= 78 && cnt < 85)
         Dist = imread([file_path,dist_name]);
         Ref = imread([file_path,'96.png']);
    end
    
 % K. Gu, G. Zhai, W. Lin, X. Yang and W. Zhang, "Visual Saliency Detection With Free Energy Theory," in IEEE Signal Processing Letters, vol. 22, no. 10, pp. 1552-1555, Oct. 2015, doi: 10.1109/LSP.2015.2413944.
% [SaliencyMap] = FES(Dist);
    
%============================================得出质量分数====================================================      
          DIBR_mdwt(cnt) = MDWT(Ref,Dist);
%     DIBR_mdwt(cnt) = getLeftRightRegions_test(Dist);


end      
DIBR_mdwt = DIBR_mdwt(:);
%============================================得出相关分数====================================================
cc = abs(corr(DIBR_mdwt,DIBR_dmos,'type','spearman'));
[delta,beta,x,y,diff] = findrmse2(DIBR_mdwt,DIBR_dmos);
[corr(x,y),corr(x,y,'type','spearman'),corr(x,y,'type','kendall'),mean(abs(diff)),(mean(diff.^2))^0.5]
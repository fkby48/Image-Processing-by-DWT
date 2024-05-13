%用于图像隐藏。计算PSNR（峰值信噪比），值越大表示越接近原图
function dPSNR = PSNR(ImageA,ImageB)
if (size(ImageA,1) ~= size(ImageB,1)) || (size(ImageA,2) ~= size(ImageB,2))
    dPSNR=0;
    errordlg('图片尺寸不一致，无法计算。','计算PSNR时出错');
    return;
end
try
    ImageA=double(ImageA);
    ImageB=double(ImageB);
    M = size(ImageA,1);
    N = size(ImageA,2);
    d = 0;
    for i = 1:M
        for j = 1:N
            d = d + (ImageA(i,j) - ImageB(i,j)).^2;
        end
    end
    dPSNR = 10*log10((M*N*max(max(ImageA.^2)))/d);
catch ex
    errordlg(['请检查错误信息，然后重试。',char(10),'错误信息：',ex.message],'计算PSNR时出错');
end
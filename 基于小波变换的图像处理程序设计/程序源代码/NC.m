%用于图像隐藏。计算NC（归一化相关系数），越接近1表示与原图越像
function dNC = NC(ImageA,ImageB)
if (size(ImageA,1) ~= size(ImageB,1)) || (size(ImageA,2) ~= size(ImageB,2))
    dNC = 0;
    errordlg('图片尺寸不一致，无法计算。','计算NC时出错');
    return;
end
try
    ImageA=double(ImageA);
    ImageB=double(ImageB);
    M = size(ImageA,1);
    N = size(ImageA,2);
    d1=0;
    d2=0;
    d3=0;
    for i = 1:M
        for j = 1:N
            d1=d1+ImageA(i,j)*ImageB(i,j);
            d2=d2+ImageA(i,j)*ImageA(i,j);
            d3=d3+ImageB(i,j)*ImageB(i,j);
        end
    end
    dNC=d1/(sqrt(d2)*sqrt(d3));
catch ex
    errordlg(['请检查错误信息，然后重试。',char(10),'错误信息：',ex.message],'计算NC时出错');
end
%����ͼ�����ء�����PSNR����ֵ����ȣ���ֵԽ���ʾԽ�ӽ�ԭͼ
function dPSNR = PSNR(ImageA,ImageB)
if (size(ImageA,1) ~= size(ImageB,1)) || (size(ImageA,2) ~= size(ImageB,2))
    dPSNR=0;
    errordlg('ͼƬ�ߴ粻һ�£��޷����㡣','����PSNRʱ����');
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
    errordlg(['���������Ϣ��Ȼ�����ԡ�',char(10),'������Ϣ��',ex.message],'����PSNRʱ����');
end
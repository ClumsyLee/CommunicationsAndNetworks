fs=10000;
T=1;
B=300;miu=255;
quantization_bits=4;
esp=1e-10;
source_power_dB=-25;

Amax=1;
step_size=(2*Amax/(2^quantization_bits));

t=0:1/fs:T;
rs=randn(1,length(t));
frs=fft(rs);
mask=zeros(1,length(t));
endF=round((length(t)-1)/fs*B);
mask(1:endF+1)=mask(1:endF+1)+1;
mask(end-endF+1:end)=mask(end-endF+1:end)+1;
ffrs=frs.*mask;
s=ifft(ffrs)*sqrt(fs/2/B);
s=s*sqrt((10^(source_power_dB/10)));  %改变信源的功率

ls=sign(s).*log(1+miu*abs(s))/log(1+miu);

%限幅
limit_ls=(ls-(ls-(Amax-esp)).*floor(sign(ls-(Amax-esp))/2+0.7)+(-Amax-ls).*floor(sign(-Amax-ls)/2+0.7));

sq=limit_ls/step_size;
dsq=(floor(sq)+0.5)*step_size;
dsq=sign(dsq).*(exp(abs(dsq)*log(1+miu))-1)/miu;
esq=dsq-s;
%10*log10([mean(s.*s) mean(esq.*esq)])
figure;plot(t,s,'.');hold on; plot(t,dsq,'r.');
title('非线性量化的效果');xlabel('t (s)');ylabel('采样幅度');legend('原始采样','非线性量化后');
figure;
plot((0:length(s)-1)/length(s)*fs,20*log10(abs(fft(s)/sqrt(length(s))/sqrt(T))));hold on;
plot((0:length(s)-1)/length(s)*fs,20*log10(abs(fft(dsq)/sqrt(length(s))/sqrt(T))),'r');
title('原始采样、非线性量化后的功率谱');xlabel('频率（Hz）');ylabel('功率谱 (dB)');legend('原始采样','非线性量化后');

recover_sq=ifft(fft(dsq).*mask);
recover_esq=recover_sq-s;
10*log10([mean(s.*s) mean(esq.*esq) mean(recover_esq.*recover_esq)])


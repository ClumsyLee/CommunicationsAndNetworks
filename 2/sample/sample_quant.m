fs=10000;
T=1;
B=300;
source_power=1;
t=0:1/fs:T;
rs=randn(1,length(t));
frs=fft(rs);
mask=zeros(1,length(t));
endF=round((length(t)-1)/fs*B);
mask(1:endF+1)=mask(1:endF+1)+1;
mask(end-endF+1:end)=mask(end-endF+1:end)+1;
ffrs=frs.*mask;
s=ifft(ffrs)*sqrt(fs/2/B);

s=s*sqrt(source_power);  %改变信源的功率

s10=s*10;   %台阶为0.1
s100=s*100;   %台阶为0.01
% ds10=round(s10)/10;
% ds100=round(s100)/100;
ds10=(floor(s10)+0.5)/10;
ds100=(floor(s100)+0.5)/100;
es10=ds10-s;
es100=ds100-s;
10*log10([mean(s.*s) mean(es10.*es10) mean(es100.*es100)])
%分别显示：信号功率、直接重构的台阶0.1及0.01的噪声功率，单位为dB
%可以观察到，采样率的变化不影响量化噪声功率
figure;plot(t,s,'.');hold on; plot(t,ds10,'r.');plot(t,ds100,'g.');
title('原始采样及量化后的采样');xlabel('时间t  (s)');ylabel('x(t)');legend('原始采样','台阶0.1','台阶0.01');
figure;
plot((0:length(s)-1)/length(s)*fs,20*log10(abs(fft(s)/sqrt(length(s))/sqrt(T))));hold on;
plot((0:length(s)-1)/length(s)*fs,20*log10(abs(fft(ds10)/sqrt(length(s))/sqrt(T))),'r');
plot((0:length(s)-1)/length(s)*fs,20*log10(abs(fft(ds100)/sqrt(length(s))/sqrt(T))),'g');
title('原始采样及量化后的采样的功率谱');xlabel('频率f (Hz)');ylabel('功率谱 (dB)');legend('原始采样','台阶0.1','台阶0.01');
%观察量化前后的频谱，可以看到量化噪声的能量平均到了所有的频谱上，采样率变高，量化噪声功率谱密度就降低
%因此，带内噪声功率也会限着采样率的增加而降低，这个降低量就是过采样率
%过采样率 = 采样率 / 2倍信号带宽。

recover_s10=ifft(fft(ds10).*mask);
recover_s100=ifft(fft(ds100).*mask);
recover_es10=recover_s10-s;
recover_es100=recover_s100-s;
10*log10([mean(s.*s) mean(es10.*es10) mean(es100.*es100) mean(recover_es10.*recover_es10) mean(recover_es100.*recover_es100)])
%分别显示：信号功率、直接重构的台阶0.1及0.01的噪声功率、滤波重构的台阶0.1及0.01的重构噪声功率，单位为dB
figure;hist(es10,100);title('直接重构的台阶0.1的噪声电平分布');
xlabel('噪声电平取值');ylabel('相应噪声电平的统计数');
figure;hist(recover_es10,100);title('滤波重构的台阶0.1的噪声电平分布');
xlabel('噪声电平取值');ylabel('相应噪声电平的统计数');
%观察直接量化噪声的分布，是均匀分布；而该均匀分布的噪声，通过低通滤波以后，不仅功率变小了，而且分布呈现高斯分布
%其原理，滤波器输出就是前后若干个样点的加权和，而量化噪声之间呈现独立性，也就是说，多个独立分布的随机变量和，哪怕不是完全同分布的，从整体上看，有高斯化的趋势。

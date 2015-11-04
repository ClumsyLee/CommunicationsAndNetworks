close all

f_origin=50000;
T=1;

fl1 = 10e3;
fh1 = 11e3;
fl2 = 12e3;
fh2 = 15e3;

power1 = 1;
power2 = 1e-6;

t = 0:1/f_origin:T;
f_index = @(f, fs) round(T * mod(f, fs)) + 1;

rs = randn(1,length(t));
frs = fft(rs);

mask1 = zeros(1,length(t));
mask2 = mask1;

mask1(f_index(fl1, f_origin):f_index(fh1, f_origin)) = 1;
mask2(f_index(fl2, f_origin):f_index(fh2, f_origin)) = 1;

mask1(ceil((length(t) / 2) + 1):end) = flip(mask1(2:floor((length(t) / 2) + 1)));
mask2(ceil((length(t) / 2) + 1):end) = flip(mask2(2:floor((length(t) / 2) + 1)));

s1 = ifft(frs .* mask1) * sqrt(f_origin / sum(mask1) * power1);
s2 = ifft(frs .* mask2) * sqrt(f_origin / sum(mask2) * power2);


figure
subplot 211
plot(t, s1);
title s1
subplot 212
plot(t, s2);
title s2

s = s1 + s2;
% Sample.
f_sample = 10000;
t_sample = 0:1/f_sample:T;
s_sample = s(int32(round(t_sample * f_origin)) + 1);
fft_sample = fft(s_sample);

hold on

figure
subplot 211
plot(t, s, t_sample, s_sample);
legend Origin Sampled
title Signal

subplot 212
plot(fftshift(0:1/length(s):(1-1/length(s))) * f_origin - f_origin / 2, abs(fft(s)) / length(s), ...
     fftshift(0:1/length(s_sample):(1-1/length(s_sample))) * f_sample - f_sample / 2, abs(fft(s_sample)) / length(s_sample));
legend Origin Sampled
title 'Freq Domain'


% Rebuild.
f_rebuild = zeros(1, length(t));
f_rebuild(f_index(fl1, f_origin):f_index(fh1, f_origin)) = fft_sample(f_index(fl1, f_sample):f_index(fh1, f_sample)) * length(s) / length(s_sample);
f_rebuild(f_index(fl2, f_origin):f_index(fh2, f_origin)) = fft_sample(f_index(fl2, f_sample):f_index(fh2, f_sample)) * length(s) / length(s_sample);
f_rebuild(ceil((length(t) / 2) + 1):end) = conj(flip(f_rebuild(2:floor((length(t) / 2) + 1))));

s_rebuild = ifft(f_rebuild);

figure
subplot 211
plot(t, s, t, s_rebuild);
legend Origin Rebuilt
title Signal
subplot 212
plot(fftshift(0:1/length(s):(1-1/length(s))) * f_origin - f_origin / 2, abs(fft(s)), ...
     fftshift(0:1/length(s):(1-1/length(s))) * f_origin - f_origin / 2, abs(f_rebuild));
title 'Freq Domain'
legend Origin Rebuilt

delta = 0.11;
s_q1 = (floor(s_sample / delta) + 0.5) * delta;
fft_s_q1 = fft(s_q1);
s_q2 = (floor(s_sample / delta2) + 0.5) * delta2;
fft_s_q2 = fft(s_q2);

f_rebuild_q1 = zeros(1, length(t));
f_rebuild_q1(f_index(fl1, f_origin):f_index(fh1, f_origin)) = fft_s_q1(f_index(fl1, f_sample):f_index(fh1, f_sample)) * length(s) / length(s_sample);
f_rebuild_q1(ceil((length(t) / 2) + 1):end) = conj(flip(f_rebuild_q1(2:floor((length(t) / 2) + 1))));
s_q1_1 = ifft(f_rebuild_q1);

f_rebuild_q2 = zeros(1, length(t));
f_rebuild_q2(f_index(fl2, f_origin):f_index(fh2, f_origin)) = fft_s_q1(f_index(fl2, f_sample):f_index(fh2, f_sample)) * length(s) / length(s_sample);
f_rebuild_q2(ceil((length(t) / 2) + 1):end) = conj(flip(f_rebuild_q2(2:floor((length(t) / 2) + 1))));
s_q1_2 = ifft(f_rebuild_q2);

figure
subplot 211
plot(t, s_q1_1);
title s1
subplot 212
plot(t, s_q1_2);
title s2

figure
subplot 211
plot(t, s_q1_1 + s_q1_2);
title s
subplot 212
plot(fftshift(0:1/length(s):(1-1/length(s))) * f_origin - f_origin / 2, abs(fft(s_q1_1 + s_q1_2)));
title 'Freq Domain'

figure
subplot 211
plot(t, s_q1_1 + s_q1_2 - s_rebuild);
subplot 212
plot(fftshift(0:1/length(s):(1-1/length(s))) * f_origin - f_origin / 2, abs(fft(s_q1_1 + s_q1_2 - s_rebuild)));
title 'Freq Domain'

delta = 1.1e-4;
s_q1 = (floor(s_sample / delta) + 0.5) * delta;
fft_s_q1 = fft(s_q1);
s_q2 = (floor(s_sample / delta2) + 0.5) * delta2;
fft_s_q2 = fft(s_q2);

f_rebuild_q1 = zeros(1, length(t));
f_rebuild_q1(f_index(fl1, f_origin):f_index(fh1, f_origin)) = fft_s_q1(f_index(fl1, f_sample):f_index(fh1, f_sample)) * length(s) / length(s_sample);
f_rebuild_q1(ceil((length(t) / 2) + 1):end) = conj(flip(f_rebuild_q1(2:floor((length(t) / 2) + 1))));
s_q1_1 = ifft(f_rebuild_q1);

f_rebuild_q2 = zeros(1, length(t));
f_rebuild_q2(f_index(fl2, f_origin):f_index(fh2, f_origin)) = fft_s_q1(f_index(fl2, f_sample):f_index(fh2, f_sample)) * length(s) / length(s_sample);
f_rebuild_q2(ceil((length(t) / 2) + 1):end) = conj(flip(f_rebuild_q2(2:floor((length(t) / 2) + 1))));
s_q1_2 = ifft(f_rebuild_q2);

figure
subplot 211
plot(t, s_q1_1);
title s1
subplot 212
plot(t, s_q1_2);
title s2

figure
subplot 211
plot(t, s_q1_1 + s_q1_2);
title s
subplot 212
plot(fftshift(0:1/length(s):(1-1/length(s))) * f_origin - f_origin / 2, abs(fft(s_q1_1 + s_q1_2)));
title 'Freq Domain'

figure
subplot 211
plot(t, s_q1_1 + s_q1_2 - s_rebuild);
subplot 212
plot(fftshift(0:1/length(s):(1-1/length(s))) * f_origin - f_origin / 2, abs(fft(s_q1_1 + s_q1_2 - s_rebuild)));
title 'Freq Domain'

disp(['需要' int2str(ceil(log2(2 * max(abs(s)) / 0.11))) '位量化'])
disp(['需要' int2str(ceil(log2(2 * max(abs(s)) / 1.1e-4))) '位量化'])

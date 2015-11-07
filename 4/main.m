close all

LEN = 100;
ITERS = 10;

ebn0 = 0:0.5:10;
error_bit_rate = zeros(length(ebn0), 1);

for k = 1:length(ebn0)
    snr = 10 * log10(8) + ebn0(k);

    for iter = 1:ITERS
        symbols = logical([1; randi([0 1], LEN - 1, 1)]);
        signals = qam_send(symbols, 4, 4, 'real');
        signals = awgn(signals, snr);
        received = qam_receive(signals, 4, 4, 'real');

        error_bit_rate(k) = error_bit_rate(k) + sum(xor(symbols, received)) / LEN;
    end
    error_bit_rate(k) = error_bit_rate(k) / ITERS;
end

figure
subplot 211
plot(ebn0, error_bit_rate)
subplot 212
plot(ebn0, 3/2*(1 - normcdf(sqrt(4/5*10.^(ebn0 / 10)))) / 2);

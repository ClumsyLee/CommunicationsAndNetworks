close all

LEN = 1000;
ITERS = 100;
ebn0 = 0:0.2:10;

error_bit_rate_real = zeros(length(ebn0), 1);
error_bit_rate_complex = zeros(length(ebn0), 1);

parfor k = 1:length(ebn0)
    disp(['Eb/N0 = ' num2str(ebn0(k))]);
    snr_real = 10 * log10(8) + ebn0(k);
    snr_complex = 10 * log10(4) + ebn0(k);

    for iter = 1:ITERS
        symbols = logical([1; randi([0 1], LEN - 1, 1)]);

        % Real.
        signals = qam_send(symbols, 4, 20, 'real');
        signals = awgn(signals, snr_real);
        received = qam_receive(signals, 4, 20, 'real');

        error_bit_rate_real(k) = error_bit_rate_real(k) + ...
                                 sum(xor(symbols, received)) / LEN;

        % Complex.
        signals = qam_send(symbols, 4, 4, 'complex');
        signals = awgn(signals, snr_complex);
        received = qam_receive(signals, 4, 4, 'complex');

        error_bit_rate_complex(k) = error_bit_rate_complex(k) + ...
                                    sum(xor(symbols, received)) / LEN;
    end
    error_bit_rate_real(k) = error_bit_rate_real(k) / ITERS;
    error_bit_rate_complex(k) = error_bit_rate_complex(k) / ITERS;
end

% Draw figures.
figure

subplot 211
semilogy(ebn0, 3/2*(1 - normcdf(sqrt(2 * 4/5*10.^(ebn0 / 10)))) / 2, ...
         ebn0, error_bit_rate_real, 'LineWidth', 2);
legend Theoretical Actural
title Real

subplot 212
semilogy(ebn0, 3/2*(1 - normcdf(sqrt(4/5*10.^(ebn0 / 10)))) / 2, ...
         ebn0, error_bit_rate_complex, 'LineWidth', 2);
title Complex
legend Theoretical Actural

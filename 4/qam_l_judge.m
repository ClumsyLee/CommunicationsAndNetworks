function symbols = qam_l_judge(signals)
    signals = sqrt(10) * signals;
    signals(signals >= 2) = 2;
    signals(signals >= 0 & signals < 2) = 3;
    signals(signals >= -2 & signals < 0) = 1;
    signals(signals < -2) = 0;

    [signal_len, cols] = size(signals);
    signals = signals(:);

    len = 2 * signal_len;
    symbols = zeros(len, cols);

    for k = 1:len
        symbols(2 * k - 1) = floor(signals(k) / 2);
        symbols(2 * k) = mod(signals(k), 2);
    end
end

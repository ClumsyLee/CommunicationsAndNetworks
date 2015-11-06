function signals = qam_2l_convert(symbols, sample_rate)
    [len, cols] = size(symbols);
    if mod(len, 2)
        error 'qam_2l_convert: mod(size(symbols, 1), 2) ~= 0'
    end

    signal_len = len / 2 * cols;
    symbols = symbols(:);
    signals = zeros(signal_len, 1);

    for k = 1:signal_len
        signals(k) = 2 * symbols(2 * k - 1) + symbols(2 * k);
    end

    signals(signals == 0) = -3;
    signals(signals == 1) = -1;
    signals(signals == 3) = 1;
    signals(signals == 2) = 3;

    signals = sqrt(10) / 40 * signals;  % Make sure averge power = 1 in QAM.
    signals = repmat(signals', [sample_rate, 1]);  % Repeat sample_rate times.

    signals = reshape(signals, len / 2 * sample_rate, cols);
end

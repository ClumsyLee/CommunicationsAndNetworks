function signals = qam_2l_convert(symbols)
    [len, cols] = size(symbols);
    if mod(len, 2)
        error 'qam_2l_convert: mod(size(symbols, 1), 2) ~= 0'
    end

    symbols = symbols(:);
    signals = zeros(len / 2, cols);

    for k = 1:len
        signals(k) = 2 * symbols(2 * k - 1) + symbols(2 * k);
    end

    signals(signals == 0) = -3;
    signals(signals == 1) = -1;
    signals(signals == 3) = 1;
    signals(signals == 2) = 3;

    signals = signals / sqrt(10);  % Make sure averge power = 1 in QAM.
end

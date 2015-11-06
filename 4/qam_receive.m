% 16QAM.
function symbols = qam_receive(signals, f_carrier, oversample_rate, method)
    signal_len = length(signals);
    sample_rate = 8 * f_carrier * oversample_rate;

    % Recover.
    switch method
    case 'real'
        carrier = [cos(pi / oversample_rate * (1:signal_len))
                   cos(pi / oversample_rate * (1:signal_len) + pi / 2)]';
    case 'complex'
        carrier = [exp(-j * pi / oversample_rate * (1:signal_len))
                   exp(-j * (pi / oversample_rate * (1:signal_len) + pi / 2))]';
    end
    signals = real([signals signals] .* carrier);

    % LPF
    lpf = rcosdesign(0.5, 6, sample_rate);
    signals = 2 * upfirdn(signals, lpf, 1, sample_rate);
    signals = signals(7:end-6, :);  % Caused by filter delay.

    % Judge & merge.
    symbols = qam_l_judge(signals)';
    symbols = symbols(:);

    symbols = symbols(find(symbols, 1):end);  % Remove paddings.
end

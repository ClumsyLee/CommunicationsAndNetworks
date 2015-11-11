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
    % figure
    % plot(signals(1:sample_rate*100, :));

    % LPF
    lpf = rcosdesign(0.5, 40, sample_rate);
    % eyediagram(filter(lpf, 1, signals), sample_rate, 1);
    signals = upfirdn(signals, lpf, 1, sample_rate);
    signals = signals(41:end-40, :);  % Caused by filter delay.

    % Judge & merge.
    symbols = qam_l_judge(signals)';
    symbols = symbols(:);
end

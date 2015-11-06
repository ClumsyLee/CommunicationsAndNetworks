% 16QAM.
function symbols = qam_receive(signals, f_carrier, oversample_rate)
    signal_len = length(signals);
    sample_rate = 8 * f_carrier * oversample_rate;

    % Recover.
    carrier = [cos(pi / oversample_rate * (1:signal_len))
               cos(pi / oversample_rate * (1:signal_len) + pi / 2)]';
    signals = [signals signals] .* carrier;
    figure
    plot(signals);
    title 'Got off carrier'

    % LPF
    lpf = rcosdesign(0.5, 6, sample_rate);
    signals = 2 * upfirdn(signals, lpf, 1, sample_rate);
    signals = signals(7:end-6, :);  % Caused by filter delay.
    figure
    stem(signals);
    title 'After LPF of receiver'

    % Judge & merge.
    symbols = qam_l_judge(signals)';
    symbols = symbols(:);

    symbols = symbols(find(symbols, 1):end);  % Remove paddings.

    figure
    stem(symbols);
    title 'Output'
end

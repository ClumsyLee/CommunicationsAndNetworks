% 16QAM.
% Average power = 1.
function signals = qam_send(symbols, f_carrier, oversample_rate)
    len = length(symbols);
    pad = mod(len, 4);
    if pad
        if symbols(1) == 0
            warning 'Symbols(1) == 0, but a zero will be added in front of it.';
        end
        symbols = [zeros(pad, 1); symbols];
    end

    % Serial => parallel.
    signals = qam_2l_convert(symbols, 2 * f_carrier * oversample_rate);
    signal_len = size(signals, 1);

    carrier = [cos(pi / oversample_rate * 1:signal_len)
               cos(pi / oversample_rate * 1:signal_len + pi / 2)]';
    signals = signals .* carrier;

    signals = signals(:, 1) .* signals(:, 2);
end

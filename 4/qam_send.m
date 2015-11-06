% 16QAM.
% Average power = 1.
function signals = qam_send(symbols, f_carrier, oversample_rate)
    len = length(symbols);
    left = mod(len, 4);
    if left
        if symbols(1) == 0
            warning 'Symbols(1) == 0, but a zero will be added in front of it.';
        end
        symbols = [zeros(4 - left, 1); symbols];
        len = length(symbols);
    end

    % Serial => parallel.
    symbols = reshape(symbols, 2, len / 2)';

    % 2 -> L
    signals = qam_2l_convert(symbols, 4 * f_carrier * oversample_rate);
    signal_len = size(signals, 1);

    % Get on carrier.
    carrier = [cos(pi / oversample_rate * (1:signal_len))
               cos(pi / oversample_rate * (1:signal_len) + pi / 2)]';
    signals = signals .* carrier;

    % Merge.
    signals = signals(:, 1) + signals(:, 2);
end

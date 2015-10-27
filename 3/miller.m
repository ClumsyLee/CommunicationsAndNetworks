function code = miller(signal, fs)
    s = zeros(length(signal) * 2, 1);

    last_signal = 0;
    last_s = 0;
    for n = 1:length(signal)
        if signal(n) == 1
            delta = [0 1];
        elseif last_signal == 1
            delta = [0 0];
        else
            delta = [1 1];
        end

        s(2*n-1:2*n) = mod(delta + last_s, 2);
        last_signal = signal(n);
        last_s = s(2 * n);
    end

    code = repmat(s', round(fs / 2), 1);
    code = code(:);
end

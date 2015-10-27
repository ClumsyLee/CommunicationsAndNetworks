function code = ami(signal, fs, width)
    signal(signal == 1) = (-1).^(0:sum(signal)-1);
    code = zeros(length(signal) * fs, 1);

    pad = round(fs / 2 * (1 - width));

    for n = 1:length(code)
        index = ceil(n / fs);
        pos = mod(n - 1, fs);

        if pos >= pad && pos < fs - pad
            code(n) = signal(index);
        else
            code(n) = 0;
        end
    end
end

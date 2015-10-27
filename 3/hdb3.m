function code = hdb3(signal, fs, width)
    s = zeros(length(signal), 1);

    last_sign = -1;
    zero_count = 0;
    b_count = 0;
    for n = 1:length(signal)
        if signal(n) ~= 0  % B.
            last_sign = -last_sign;
            s(n) = last_sign;
            zero_count = 0;
            b_count = b_count + 1;
        else
            zero_count = zero_count + 1;
            if zero_count == 4
                if mod(b_count, 2) == 0
                    last_sign = -last_sign;
                    s(n - 3) = last_sign;  % Add a B.
                end
                s(n) = last_sign;  % Add a V.
                zero_count = 0;
                b_count = 0;
            end
        end
    end

    code = zeros(length(s) * fs, 1);
    pad = round(fs / 2 * (1 - width));

    for n = 1:length(code)
        index = ceil(n / fs);
        pos = mod(n - 1, fs);

        if pos >= pad && pos < fs - pad
            code(n) = s(index);
        else
            code(n) = 0;
        end
    end
end

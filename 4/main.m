close all

symbols = randi([0 1], 100, 1);

signals = qam_send(symbols, 4, 20, 'real');
qam_receive(signals, 4, 20, 'real');

signals = qam_send(symbols, 4, 4, 'complex');
qam_receive(signals, 4, 4, 'complex');

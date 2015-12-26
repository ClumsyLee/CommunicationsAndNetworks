NODES = 30;
EDGES = 100;
SAMPLES = 500;
ITERS = 100;

samples = zeros(SAMPLES, 2);

for k = 1:SAMPLES
    disp(['Sample #' int2str(k)]);
    adj = gen_rand_net(NODES, EDGES);

    tic
    for iter = 1:ITERS
        bellman_ford(adj, 1);
    end
    samples(k, 1) = toc / ITERS;

    tic
    for iter = 1:ITERS
        dijkstra(adj, 1);
    end
    samples(k, 2) = toc / ITERS;
end

figure
hist(samples(:, 1))
title Bellman-Ford
xlabel time/s
ylabel count

figure
hist(samples(:, 2))
title Dijkstra
xlabel time/s
ylabel count

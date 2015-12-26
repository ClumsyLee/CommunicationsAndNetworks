function adj_mat = gen_rand_net(nodes, edges)
    % Decide which edges to take.
    max_edges = (nodes - 1) * nodes / 2;
    edges = min(edges, max_edges);
    pick = zeros(max_edges, 1);
    pick(randsample(max_edges, edges)) = 1;

    adj_mat = zeros(nodes);

    k = 1;
    for row = 1:nodes
        for col = 1:row-1
            if pick(k)
                dis = rand();
            else
                dis = inf;
            end
            adj_mat(row, col) = dis;
            k = k + 1;
        end
    end
    adj_mat = adj_mat + adj_mat';

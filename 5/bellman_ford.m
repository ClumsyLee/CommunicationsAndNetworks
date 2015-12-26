function [dist, next] = bellman_ford(adj_mat, src)
    nodes = size(adj_mat, 1);

    dist = adj_mat;
    next = repmat(1:nodes, [nodes, 1]) .* ~isinf(adj_mat);

    new_dist = zeros(nodes);
    while true
        for node = 1:nodes
            routes = repmat(adj_mat(:, node), [1, nodes]) + dist;
            [new_dist(node, :), index] = min(routes);
            updates = index ~= node;
            next(node, updates) = index(updates);
        end

        if all(all(new_dist == dist))
            break
        end

        dist = new_dist;
    end

    % Remove unaccessable entries in next.
    next(isinf(dist)) = 0;

    % Return only the data for src.
    dist = dist(src, :)';
    next = next(src, :)';

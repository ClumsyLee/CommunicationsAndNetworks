function [dist, next] = dijkstra(adj_mat, src)
    nodes = size(adj_mat, 1);
    done = false(nodes, 1);

    dist = inf(nodes, 1);
    next = zeros(nodes, 1);

    current = src;
    done(src) = 1;
    dist(src) = 0;
    next(src) = src;

    while true
        dist_from_current = dist(current) + adj_mat(current, :)';
        dist_from_current(done) = inf;  % Remove done (including self).

        % Update neighbors.
        updates = dist_from_current < dist;
        dist(updates) = dist_from_current(updates);
        if current == src
            next(updates) = find(updates);
        else
            next(updates) = next(current);
        end

        dist_now = dist;
        dist_now(done) = inf;
        [value, index] = min(dist_now);
        if isinf(value)
            break;
        else
            done(index) = 1;
            current = index;
        end
    end

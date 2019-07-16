using LinearAlgebra
using Flux

a = [1, 2, 3, 5, 5, 5, 6]
b = [1, 1, 2, 2, 3, 5]

a = rand(10)
b = rand(10)

# a = param(a)
# b = param(b)
# Make first row and column very large numbers

dist = (x,y) -> norm(x-y)


function DTW(a, b)
    table = zeros(Float64, size(a)[1], size(b)[1])
    table[1, 1] = 0
    for i in 1:size(a)[1]
        for j in 1:size(b)[1]
            table[i, j] = abs(a[i] - b[j])  # Calculate distance of current signal indices

            # Indices we can move from (DTW must be monotonically increasing)
            indexes = [(i-1, j),   # Left --> pos
                       (i-1, j-1), # Up Left --> pos
                       (i, j-1)]   # Up --> pos

            current_distances = []
            for idx in indexes
                try
                    push!(current_distances,table[idx...])
                catch BoundsError  # Handle out of bounds case
                    push!(current_distances, Inf)
                end
            end
            if all(isinf.(current_distances))  # Handle if everything was out of bounds
                push!(current_distances, 0.)
            end
            table[i, j] += min(current_distances...)  # Add the previous minimum distance to current distance
        end
    end
    return table
end

function minimum_warp_path(table)
    current_pos = size(table) |> collect
    keep_going = true
    shortest_path = []
    push!(shortest_path, copy(current_pos))  # We start at the end and work back

    while keep_going == true
        current_value = table[current_pos...]
        # We search the direct left, left and up, and upward directions
        # for the smallest distance.
        indexes = ((current_pos[1] - 1, current_pos[2]),      # Left
                   (current_pos[1] - 1, current_pos[2] - 1),  # Up and Left
                   (current_pos[1], current_pos[2] - 1))      # Up

        # For each of our possible cells to check
        values = []
        for idx in indexes
            try
                push!(values, table[idx...])
            catch BoundsError  # We make sure we handle if we go out of bounds
                push!(values, Inf)
            end
        end

        min_arg = argmin(values)  # Get direction had the smallest distance

        if min_arg == 1         # Left
            current_pos[1] -= 1
        elseif min_arg == 2     # Up and Left
            current_pos[1] -= 1
            current_pos[2] -= 1
        else                    # Up
            current_pos[2] -= 1
        end

        # Stop once you're at the beginning
        if current_pos == [1, 1]
            keep_going = false
        end
        pushfirst!(shortest_path, copy(current_pos))
    end
    shortest_path = vcat(shortest_path'...)  # reshape
    return shortest_path
end


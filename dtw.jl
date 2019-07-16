using LinearAlgebra
using Flux

a = [1, 2, 3, 5, 5, 5, 6]
b = [1, 1, 2, 2, 3, 5]

function DTW(a, b)
    table = fill(Inf, size(a)[1]+1, size(b)[1]+1)
    table[1, 1] = 0
    for i in 2:size(table, 1)
        for j in 2:size(table, 2)
            table[i, j] = abs(a[i-1] - b[j-1])  # Calculate distance of current signal indices
            table[i, j] += min(Inf, table[i-1, j], table[i-1, j-1], table[i, j-1])
        end
    end
    return table
end

t = DTW(a, b)

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


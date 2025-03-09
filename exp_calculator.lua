local exp_history = {}
local total_exp = 0
local last_exp = 0

function update_exp_history(current_exp, needed_exp, level)
    local current_time = os.time()

    if current_exp < last_exp then
        total_exp = total_exp + needed_exp
    end
    total_exp = total_exp + (current_exp - last_exp)
    last_exp = current_exp 

    table.insert(exp_history, {time = current_time, total_exp = total_exp})

    local cutoff_10min = current_time - 600
    local cutoff_1min = current_time - 60

    while #exp_history > 0 and exp_history[1].time < cutoff_10min do
        table.remove(exp_history, 1)
    end

    local function calculate_rate(cutoff)
        local start_exp = nil
        local start_time = nil
        for _, record in ipairs(exp_history) do
            if record.time >= cutoff then
                start_exp = record.total_exp
                start_time = record.time
                break
            end
        end

        if start_exp and start_time then
            local exp_gained = total_exp - start_exp
            local time_elapsed = current_time - start_time
            if time_elapsed > 0 then
                local exp_per_sec = exp_gained / time_elapsed
                local exp_per_min = math.floor((exp_per_sec * 60) + 0.5)
                local exp_per_hour = math.floor((exp_per_sec * 3600) + 0.5)
                return exp_per_min, exp_per_hour
            end
        end

        return 0, 0
    end

    local exp_per_min_1m, exp_per_hour_1m = calculate_rate(cutoff_1min)
    local exp_per_min_10m, exp_per_hour_10m = calculate_rate(cutoff_10min)

    return exp_per_min_1m, exp_per_hour_1m, exp_per_min_10m, exp_per_hour_10m
end

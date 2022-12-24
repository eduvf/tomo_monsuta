function map_gen()
    for x = 0, 15 do
        for y = 0, 15 do
            mset(x, y, 2)
        end
    end
    gen_rooms()
    maze_worm()
    place_flags()
    carve_doors()
    carve_cuts()
    fill_ends()
end

function gen_rooms()
    local faliure_max, room_max = 5, 4
    local mw, mh = 6, 6

    repeat
        local r = rnd_room(mw, mh)
        if place_room(r) then
            room_max -= 1
        else
            faliure_max -= 1
            
            if r.w > r.h then
                mw = max(mw - 1, 3)
            else
                mh = max(mh - 1, 3)
            end
        end
    until faliure_max <= 0 or room_max <= 0
    
    -- dbg[1] = "fails: "..faliure_max
    -- dbg[2] = "rooms: "..room_max
end

function rnd_room(mw, mh)
    local _w = 3 + flr(rnd(mw - 2))
    local _h = 3 + flr(rnd(mh - 2))
    mh = max(35 / _w, 3)
    return {
        x = 0, y = 0,
        w = _w, h = _h
    }
end

function place_room(r)
    local cand, c = {}
    for _x = 0, 16 - r.w do
        for _y = 0, 16 - r.h do
            if does_room_fit(r, _x, _y) then
                add(cand, {x = _x, y = _y})
            end
        end
    end

    if #cand == 0 then return false end

    c = get_rnd(cand)
    r.x = c.x
    r.y = c.y

    for _x = 0, r.w - 1 do
        for _y = 0, r.h - 1 do
            mset(_x+r.x,_y+r.y,1)
        end
    end
    return true
end

function does_room_fit(r,x,y)
    for _x = -1, r.w do
        for _y = -1, r.h do
            if is_walkable(_x + x, _y + y) then
                return false
            end
        end
    end
    return true
end

function maze_worm()
    repeat
        local cand = {}
        for _x = 0, 15 do
            for _y = 0, 15 do
                if not is_walkable(_x, _y) and get_signature(_x, _y) == 255 then
                    add(cand, {x = _x, y = _y})
                end
            end
        end

        if #cand > 0 then
            local c = get_rnd(cand)
            dig_worm(c.x, c.y)
        end
    until #cand <= 1
end

function dig_worm(x, y)
    local dir, step = 1 + flr(rnd(4)), 0

    repeat
        mset(x, y, 1)
        if not can_carve(x + dir_x[dir], y + dir_y[dir], false) or (rnd() < 0.5 and step > 2) then
            step = 0
            local cand = {}
            for i = 1, 4 do
                if can_carve(x + dir_x[i], y + dir_y[i], false) then
                    add(cand, i)
                end
            end
            if #cand == 0 then
                dir = 8
            else
                dir = get_rnd(cand)
            end
        end
        x += dir_x[dir]
        y += dir_y[dir]
        step += 1
    until dir == 8
end

function can_carve(x, y, walk)
    if in_bounds(x, y) and is_walkable(x, y) == walk then
        local sig = get_signature(x, y)
        for i = 1, #carve_sig do
            if bit_comp(sig, carve_sig[i], carve_msk[i]) then
                return true
            end
        end
    end
    return false
end

function bit_comp(sig, match, mask)
    local mask = mask and mask or 0
    return bor(sig, mask) == bor(match, mask)
end

function get_signature(x, y)
    local sig, digit = 0
    for i = 1, 8 do
        local dx, dy = x + dir_x[i], y + dir_y[i]
        if is_walkable(dx, dy) then
            digit = 0
        else
            digit = 1
        end
        sig = bor(sig, shl(digit, 8 - i))
    end
    return sig
end

-- doorways

function place_flags()
    local curr_flag = 1
    flags = blank_map(0)

    for _x = 0, 15 do
        for _y = 0, 15 do
            if is_walkable(_x, _y) and flags[_x][_y] == 0 then
                grow_flag(_x, _y, curr_flag)
                curr_flag += 1
            end
        end
    end
end

function grow_flag(_x, _y, f)
    local cand, cand_new = {{x = _x, y = _y}}
    flags[_x][_y] = f

    repeat
        cand_new = {}
        for c in all(cand) do
            for d = 1, 4 do
                local dx, dy = c.x + dir_x[d], c.y + dir_y[d]
                if is_walkable(dx, dy) and flags[dx][dy] != f then
                    flags[dx][dy] = f
                    add(cand_new, {x = dx, y = dy})
                end
            end
        end
        cand = cand_new
    until #cand == 0
end

function carve_doors()
    local x1, y1, x2, y2, found, _f1, _f2, doors = 1, 1, 1, 1
    repeat
        doors = {}
        for _x = 0, 15 do
            for _y = 0, 15 do
                if not is_walkable(_x, _y) then
                    local sig = get_signature(_x, _y)
                    found = false

                    if bit_comp(sig, 0b11000000, 0b00001111) then
                        x1, y1, x2, y2, found = _x, _y - 1, _x, _y + 1, true
                    elseif bit_comp(sig, 0b00110000, 0b00001111) then
                        x1, y1, x2, y2, found = _x + 1, _y, _x - 1, _y, true
                    end

                    _f1 = flags[x1][y1]
                    _f2 = flags[x2][y2]
                    if found and _f1 != _f2 then
                        add(doors, {x = _x, y = _y, f1 = _f1, f2 = _f2})
                    end
                end
            end
        end

        if #doors > 0 then
            local d = get_rnd(doors)
            mset(d.x, d.y, 1)
            grow_flag(d.x, d.y, d.f1)
        end
    until #doors == 0
end

function carve_cuts()
    local x1, y1, x2, y2, cut, found, doors = 1, 1, 1, 1, 0
    repeat
        doors = {}
        for _x = 0, 15 do
            for _y = 0, 15 do
                if not is_walkable(_x, _y) then
                    local sig = get_signature(_x, _y)
                    found = false

                    if bit_comp(sig, 0b11000000, 0b00001111) then
                        x1, y1, x2, y2, found = _x, _y - 1, _x, _y + 1, true
                    elseif bit_comp(sig, 0b00110000, 0b00001111) then
                        x1, y1, x2, y2, found = _x + 1, _y, _x - 1, _y, true
                    end

                    if found then
                        calc_dist(x1, y1)
                        if dist_map[x2][y2] > 20 then
                            add(doors, {x = _x, y = _y})
                        end
                    end
                end
            end
        end

        if #doors > 0 then
            local d = get_rnd(doors)
            mset(d.x, d.y, 1)
            cut += 1
        end
    until #doors == 0 or cut >= 3
end

function fill_ends()
    local cand
    repeat
        cand = {}
        for _x = 0, 15 do
            for _y = 0, 15 do
                if can_carve(_x, _y, true) then
                    add(cand, {x = _x, y = _y})
                end
            end
        end

        for c in all(cand) do
            mset(c.x, c.y, 2)
        end
    until #cand == 0
end
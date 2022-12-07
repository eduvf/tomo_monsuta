function map_gen()
    for x = 0, 15 do
        for y = 0, 15 do
            mset(x, y, 2)
        end
    end
    gen_rooms()
end

function gen_rooms()
    local faliure_max, room_max = 5, 5
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
    
    dbg[1] = "fails: "..faliure_max
    dbg[2] = "rooms: "..room_max
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
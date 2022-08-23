function move_player(dx, dy)
	local dest_x = p_mob.x + dx
	local dest_y = p_mob.y + dy
	local tile = mget(dest_x, dest_y)

	if dx < 0 then
		p_mob.fx = true
	elseif dx > 0 then
		p_mob.fx = false
	end

	if is_walkable(dest_x, dest_y, 'check mobs') then
		-- move
		sfx(63)

		p_mob.x += dx
		p_mob.y += dy
		p_mob.sx = dx * -8
		p_mob.sy = dy * -8
		p_mob.ox, p_mob.oy = p_mob.sx, p_mob.sy
		p_t = 0
		_upd = update_p_turn

		p_mob.move = move_walk
	else
		-- don't move
		p_mob.sx = dx * 8
		p_mob.sy = dy * 8
		p_mob.ox, p_mob.oy = 0, 0
		p_t = 0
		_upd = update_p_turn

		p_mob.move = move_bump

		local mob = get_mob(dest_x, dest_y)
		if not mob then
			-- trigger interaction
			if fget(tile, 1) then
				trig_bump(tile, dest_x, dest_y)
			end
		else
			hit_mob(p_mob, mob)
		end
	end
end

function trig_bump(tile, dest_x, dest_y)
	if tile == 7 or tile == 8 then
		-- vase
		sfx(59)
		mset(dest_x, dest_y, 1)
	elseif tile == 10 or tile == 12 then
		-- chest
		sfx(61)
		mset(dest_x, dest_y, tile - 1)
	elseif tile == 13 then
		-- door
		sfx(62)
		mset(dest_x, dest_y, 1)
	elseif tile == 6 then
		-- stone tablet
		-- show_msg('toki! o pona!', 60)
		show_dlg({'o toki!','','o sewi e tomo','monsuta. o kama','jo e poki pi','kiwen jelo.'})
	end
end

function get_mob(x, y)
	for m in all(mob) do
		if m.x == x and m.y == y then
			return m
		end
	end
	return false
end

function is_walkable(x, y, mode)
	if mode == nil then mode = '' end
	if in_bounds(x, y) then
		if not fget(mget(x, y), 0) then
			if mode == 'check mobs' then
				return not get_mob(x, y)
			end
			return true
		end
	end
	return false
end

function in_bounds(x, y)
	return 0 <= x and x <= 15 and 0 <= y and y <= 15
end

function hit_mob(atk_m, def_m)
end
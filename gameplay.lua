function move_player(dx, dy)
	local dest_x = p_mob.x + dx
	local dest_y = p_mob.y + dy
	local tile = mget(dest_x, dest_y)

	if is_walkable(dest_x, dest_y, 'check mobs') then
		-- move
		sfx(63)
		mob_walk(p_mob, dx, dy)
		p_t = 0
		_upd = update_p_turn
	else
		-- don't move
		mob_bump(p_mob, dx, dy)
		p_t = 0
		_upd = update_p_turn

		local mob = get_mob(dest_x, dest_y)
		if not mob then
			-- trigger interaction
			if fget(tile, 1) then
				trig_bump(tile, dest_x, dest_y)
			end
		else
			sfx(58)
			hit_mob(p_mob, mob)
		end
	end

	unfog()
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
	local dmg = atk_m.atk
	def_m.hp -= dmg
	def_m.flash = 4

	add_float('-'..dmg, def_m.x * 8, def_m.y * 8, 9)

	if def_m.hp <= 0 then
		-- if def_m is player
		add(die_mob, def_m) -- ???
		del(mob, def_m)
		def_m.dur = 8
	end
end

function check_end()
	if p_mob.hp <= 0 then
		boxes = {}
		_upd = update_gameover
		_drw = draw_gameover
		fade_out()
		-- reload the map
		reload(0x2000, 0x2000, 0x1000)
		return false
	end
	return true
end

-- line of sight
function los(x1, y1, x2, y2)
	local first, sx, sy, dx, dy = true

	if dist(x1, y1, x2, y2) == 1 then
		return true
	end

	if x1 < x2 then
		sx = 1
		dx = x2 - x1
	else
		sx = -1
		dx = x1 - x2
	end
	if y1 < y2 then
		sy = 1
		dy = y2 - y1
	else
		sy = -1
		dy = y1 - y2
	end
	local err, e2 = dx - dy, nil

	while not (x1 == x2 and y1 == y2) do
		if not first and is_walkable(x1, y1, 'sight') == false then
			return false
		end
		first = false
		e2 = err + err
		if e2 > -dy then
			err -= dy
			x1 += sx
		end
		if e2 < dx then
			err += dx
			y1 += sy
		end
	end
	return true
end

function unfog()
	for x = 0, 15 do
		for y = 0, 15 do
			if los(p_mob.x, p_mob.y, x, y) then
				fog[x][y] = 0
			end
		end
	end
end
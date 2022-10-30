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
	mode = mode or ''
	if in_bounds(x, y) then
		local tile = mget(x, y)
		if mode == 'sight' then
			return not fget(tile, 2)
		else
			if not fget(tile, 0) then
				if mode == 'check mobs' then
					return not get_mob(x, y)
				end
				return true
			end
		end
	end
	return false
end

function in_bounds(x, y)
	return 0 <= x and x <= 15 and 0 <= y and y <= 15
end

function hit_mob(atk_m, def_m)
	local dmg = atk_m.atk
	local def = def_m.defmin + flr(rnd(def_m.defmax - def_m.defmin + 1))
	dmg -= min(def, dmg)

	def_m.hp -= dmg
	def_m.flash = 4

	add_float('-'..dmg, def_m.x * 8, def_m.y * 8, 9)

	if def_m.hp <= 0 then
		-- if def_m is player
		add(die_mob, def_m)
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
		sx, dx = 1, x2 - x1
	else
		sx, dx = -1, x1 - x2
	end
	if y1 < y2 then
		sy, dy = 1, y2 - y1
	else
		sy, dy = -1, y1 - y2
	end
	local err, e2 = dx - dy

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
	local px, py = p_mob.x, p_mob.y
	for x = 0, 15 do
		for y = 0, 15 do
			if fog[x][y] == 1 and dist(px, py, x, y) <= p_mob.los and los(px, py, x, y) then
				unfog_tile(x, y)
			end
		end
	end
end

function unfog_tile(x, y)
	fog[x][y] = 0
	if is_walkable(x, y, 'sight') then
		for i = 1, 4 do
			local tx, ty = x + dir_x[i], y + dir_y[i]
			if in_bounds(tx, ty) and not is_walkable(tx, ty, 'sight') then
				fog[tx][ty] = 0
			end
		end
	end
end

function calc_dist(tx, ty)
	local cand, step = {}, 0
	dist_map = blank_map(-1)
	dist_map[tx][ty] = 0
	add(cand, {x = tx, y = ty})

	repeat
		step += 1
		new_cand = {}
		for c in all(cand) do
			for d = 1, 4 do
				local dx = c.x + dir_x[d]
				local dy = c.y + dir_y[d]
				if in_bounds(dx, dy) and dist_map[dx][dy] == -1 then
					dist_map[dx][dy] = step
					if is_walkable(dx, dy) then
						add(new_cand, {x = dx, y = dy})
					end
				end
			end
		end
		cand = new_cand
	until #cand == 0
end

function update_stats()
	local atk, d_min, d_max = 1, 0, 0

	if eqp[1] then
		atk += itm_stat1[eqp[1]]
	end
	if eqp[2] then
		d_min += itm_stat1[eqp[2]]
		d_max += itm_stat2[eqp[2]]
	end

	p_mob.atk = atk
	p_mob.defmin = d_min
	p_mob.defmax = d_max
end
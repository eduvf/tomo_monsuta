function move_player(dx, dy)
	local dest_x = p_mob.x + dx
	local dest_y = p_mob.y + dy
	local tile = mget(dest_x, dest_y)

	if is_walkable(dest_x, dest_y, 'checkmobs') then
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
		if mob then
			sfx(58)
			hit_mob(p_mob, mob)
		else
			-- trigger interaction
			if fget(tile, 1) then
				trig_bump(tile, dest_x, dest_y)
			else
				skip_ai = true
				mset(dest_x, dest_y, 1)
			end
		end
	end

	unfog()
end

function trig_bump(tile, dest_x, dest_y)
	if tile == 7 or tile == 8 then
		-- vase
		sfx(59)
		mset(dest_x, dest_y, 1)
		if rnd(4) < 1 then
			local item = flr(rnd(#itm_name)) + 1
			take_item(item)
			show_msg(itm_name[item], 60)
		end
	elseif tile == 10 or tile == 12 then
		-- chest
		sfx(61)
		mset(dest_x, dest_y, tile - 1)
		local item = flr(rnd(#itm_name)) + 1
		take_item(item)
		show_msg(itm_name[item], 60)
	elseif tile == 13 then
		-- door
		sfx(62)
		mset(dest_x, dest_y, 1)
	elseif tile == 6 then
		-- stone tablet
		if floor == 0 then
			show_talk({'o toki!','','o sewi e tomo','monsuta. o kama','jo e poki pi','kiwen jelo!'})
		elseif floor == win_floor then
			win = true
		end
	end
end

function trig_step()
	local tile = mget(p_mob.x, p_mob.y)

	if tile == 14 then
		fade_out()
		gen_floor(floor + 1)
		floor_msg()
		return true
	end
	return false
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
	local mode = mode or 'test'

	if in_bounds(x, y) then
		local tile = mget(x, y)
		if mode == 'sight' then
			return not fget(tile, 2)
		else
			if not fget(tile, 0) then
				if mode == 'checkmobs' then
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

function hit_mob(atk_m, def_m, raw_dmg)
	local dmg = atk_m and atk_m.atk or raw_dmg
	local def = def_m.def_min + flr(rnd(def_m.def_max - def_m.def_min + 1))
	dmg -= min(def, dmg)

	def_m.hp -= dmg
	def_m.flash = 10

	add_float('-'..dmg, def_m.x * 8, def_m.y * 8, 9)

	if def_m.hp <= 0 then
		-- if def_m is player
		add(die_mob, def_m)
		del(mob, def_m)
		def_m.dur = 10
	end
end

function heal_mob(m, hp)
	hp = min(m.hp_max - m.hp, hp)
	m.hp += hp
	m.flash = 10

	add_float('+'..hp, m.x * 8, m.y * 8, 7)
end

function check_end()
	if win then
		windows = {}
		_upd = update_gameover
		_drw = draw_gamewin
		fade_out()
		return false
	elseif p_mob.hp <= 0 then
		windows = {}
		_upd = update_gameover
		_drw = draw_gameover
		fade_out()
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
	local cand, step, cand_new = {}, 0
	dist_map = blank_map(-1)
	add(cand, {x = tx, y = ty})
	dist_map[tx][ty] = 0

	repeat
		step += 1
		cand_new = {}
		for c in all(cand) do
			for d = 1, 4 do
				local dx = c.x + dir_x[d]
				local dy = c.y + dir_y[d]
				if in_bounds(dx, dy) and dist_map[dx][dy] == -1 then
					dist_map[dx][dy] = step
					if is_walkable(dx, dy) then
						add(cand_new, {x = dx, y = dy})
					end
				end
			end
		end
		cand = cand_new
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
	p_mob.def_min = d_min
	p_mob.def_max = d_max
end

function eat(item, m)
	local effect = itm_stat1[item]

	if effect == 1 then
		-- heal
		heal_mob(m, 1)
	end
end

function throw()
	local item, tx, ty = inv[throw_slt], throw_tile()

	if in_bounds(tx, ty) then
		local m = get_mob(tx, ty)
		if m then 
			if itm_type[item] == 'food' then
				eat(item, m)
			else
				hit_mob(nil, m, itm_stat1[item])
				sfx(58)
			end
		end
	end
	mob_bump(p_mob, throw_x, throw_y)

	inv[throw_slt] = nil
	p_t = 0
	_upd = update_p_turn
end

function throw_tile()
	local tx, ty = p_mob.x, p_mob.y
	repeat
		tx += throw_x
		ty += throw_y
	until not is_walkable(tx, ty, 'checkmobs')
	return tx, ty
end
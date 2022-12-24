function add_mob(typ, x, y)
	local m = {
		x = x, y = y,
		ox = 0, oy = 0,
		fx = false,
		anim = {},
		flash = 0,
		hp = mob_hp[typ],
		hp_max = mob_hp[typ],
		atk = mob_atk[typ],
		def_min = 0,
		def_max = 0,
		los = mob_los[typ],
		task = ai_wait
	}
	for i = 0, 3 do
		add(m.anim, mob_anim[typ] + i)
	end
	add(mob, m)
	return m
end

function mob_walk(m, dx, dy)
	m.x += dx
	m.y += dy

	mob_flip(m, dx)
	m.sx = dx * -8
	m.sy = dy * -8
	m.ox, m.oy = m.sx, m.sy
	m.move = move_walk
end

function mob_bump(m, dx, dy)
	mob_flip(m, dx)
	m.sx = dx * 8
	m.sy = dy * 8
	m.ox, m.oy = 0, 0
	m.move = move_bump
end

function mob_flip(m, dx)
	m.fx = dx == 0 and m.fx or dx < 0
end

function move_walk(self)
	self.ox = self.sx * (1 - p_t)
	self.oy = self.sy * (1 - p_t)
end

function move_bump(self)
	local time = p_t > 0.5 and 1 - p_t or p_t
	self.ox = self.sx * time
	self.oy = self.sy * time
end

function do_ai()
	local moving = false

	for m in all(mob) do
		if m != p_mob then
			m.move = nil
			moving = m.task(m) or moving
		end
	end

	if moving then
		_upd = update_ai_turn
		p_t = 0
	end
end

function ai_wait(m)
	if can_see(m, p_mob) then
		m.task = ai_attack
		m.tx, m.ty = p_mob.x, p_mob.y
		add_float('!', m.x * 8 + 2, m.y * 8, 10)
		return true
	end
	return false
end

function ai_attack(m)
	if dist(m.x, m.y, p_mob.x, p_mob.y) == 1 then
		-- attack
		local dx, dy = p_mob.x - m.x, p_mob.y - m.y
		mob_bump(m, dx, dy)
		hit_mob(m, p_mob)
		sfx(57)
		return true
	else
		-- follow
		if can_see(m, p_mob) then
			m.tx, m.ty = p_mob.x, p_mob.y
		end

		if m.x == m.tx and m.y == m.ty then
			m.task = ai_wait
			add_float('?', m.x * 8 + 2, m.y * 8, 10)
		else
			local best_d, cand = 999, {}
			calc_dist(m.tx, m.ty)
			for i = 1, 4 do
				local dx, dy = dir_x[i], dir_y[i]
				local tx, ty = m.x + dx, m.y + dy
				if is_walkable(tx, ty, 'check mobs') then
					local d = dist_map[tx][ty]
					if d < best_d then
						cand = {}
						best_d = d
					end
					if d == best_d then
						add(cand, i)
					end
				end
			end
			if #cand > 0 then
				local c = get_rnd(cand)
				mob_walk(m, dir_x[c], dir_y[c])
				return true
			end
		end
	end
	return false
end

function can_see(m1, m2)
	return dist(m1.x, m1.y, m2.x, m2.y) <= m1.los and los(m1.x, m1.y, m2.x, m2.y)
end

------------------------------

function take_item(item)
	local i = free_inv_slot()
	if i == 0 then return false end
	inv[i] = item
	return true
end

function free_inv_slot()
	for i = 1, 6 do
		if not inv[i] then
			return i
		end
	end
	return 0
end
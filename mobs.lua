function add_mob(type, x, y)
	local m = {
		x = x, y = y,
		ox = 0, oy = 0,
		sx = 0, sy = 0,
		fx = false,
		move = nil,
		anim = {},
		flash = 0,
		hp = mob_hp[type],
		hp_max = mob_hp[type],
		atk = mob_atk[type]
	}
	for i = 0, 3 do
		add(m.anim, mob_anim[type] + i)
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
	if dx < 0 then
		m.fx = true
	elseif dx > 0 then
		m.fx = false
	end
end

function move_walk(m, anim_t)
	m.ox = m.sx * (1 - anim_t)
	m.oy = m.sy * (1 - anim_t)
end

function move_bump(m, anim_t)
	local time = anim_t
	if anim_t > 0.5 then
		time = 1 - time
	end

	m.ox = m.sx * time
	m.oy = m.sy * time
end
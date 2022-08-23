function add_mob(type, x, y)
	local m = {
		x = x, y = y,
		ox = 0, oy = 0,
		sx = 0, sy = 0,
		fx = false,
		move = nil,
		anim = {}
	}
	for i = 0, 3 do
		add(m.anim, mob_anim[type] + i)
	end
	add(mob, m)
	return m
end
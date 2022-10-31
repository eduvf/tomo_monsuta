function draw_game()
	cls(0)
	map()
	for m in all(die_mob) do
		draw_mob(m)
		m.dur -= 1
		
		if m.dur <= 0 then
			del(die_mob, m)
		end
	end

	for i = #mob, 1, -1 do
		draw_mob(mob[i])
	end

	if _upd == update_throw then
		line(p_mob.x * 8 + 4, p_mob.y * 8 + 4, p_mob.x * 8 + throw_x * 16 + 4, p_mob.y * 8 + throw_y * 16 + 4, 7)
	end

	for x = 0, 15 do
		for y = 0, 15 do
			if fog[x][y] == 1 then
				rectf(x * 8, y * 8, 8, 8, 0)
			end
		end
	end

	for f in all(float) do
		oprint8(f.text, f.x, f.y, f.c, 0)
	end
end

function draw_mob(m)
	local c = false
	if (m.flash > 0) and (t % 2) == 0 then
		m.flash -= 1
		c = 7
	end
	sprite(get_frame(m.anim), m.x * 8 + m.ox, m.y * 8 + m.oy, m.fx, c)
end

function draw_gameover()
	cls(2)
	print('u ded', 50, 50)
end
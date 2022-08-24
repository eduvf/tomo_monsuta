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

	for m in all(mob) do
		if m != p_mob then
			draw_mob(m)
		end
	end

	draw_mob(p_mob)

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
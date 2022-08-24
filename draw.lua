function draw_game()
	cls(0)
	map()
	for m in all(mob) do
		local c = false
		if (m.flash > 0) and (t % 2) == 0 then
			m.flash -= 1
			c = 7
		end
		sprite(get_frame(m.anim), m.x * 8 + m.ox, m.y * 8 + m.oy, m.fx, c)
	end

	for f in all(float) do
		oprint8(f.text, f.x, f.y, f.c, 0)
	end
end

function draw_gameover()

end
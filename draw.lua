function draw_game()
	cls(0)
	map()
	for m in all(mob) do
		sprite(get_frame(m.anim), m.x * 8 + m.ox, m.y * 8 + m.oy, m.fx)
	end
end

function draw_gameover()

end
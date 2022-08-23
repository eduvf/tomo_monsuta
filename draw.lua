function draw_game()
	cls(0)
	map()

	sprite(get_frame(p_walk_anim), p_x * 8 + p_ox, p_y * 8 + p_oy, p_flip)
	for m in all(mob) do
		sprite(get_frame(m.anim), m.x * 8, m.y * 8, false)
	end
end

function draw_gameover()

end
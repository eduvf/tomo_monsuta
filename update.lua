function update_game()
	for i = 0, 3 do
		if btnp(i) then
			move_player(dir_x[i+1], dir_y[i+1])
			return
		end
	end
end

function update_p_turn()
	p_t = min(p_t + 0.2, 1)

	p_anim()

	if p_t == 1 then
		_upd = update_game
	end
end

function update_gameover()

end

function anim_walk()
	p_ox = p_sx * (1 - p_t)
	p_oy = p_sy * (1 - p_t)
end

function anim_bump()
	local time = p_t
	if p_t > 0.5 then
		time = 1 - time
	end

	p_ox = p_sx * time
	p_oy = p_sy * time
end
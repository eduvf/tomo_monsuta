function update_game()
	for i = 0, 3 do
		if btnp(i) then
			local _dx, _dy = dir_x[i+1], dir_y[i+1]
			p_x += _dx
			p_y += _dy
			p_sx = _dx * -8
			p_sy = _dy * -8
			p_ox, p_oy = p_sx, p_sy
			p_t = 0
			_upd = update_p_turn
			return
		end
	end
end

function update_p_turn()
	p_t = min(p_t + 0.2, 1)

	p_ox = p_sx * (1 - p_t)
	p_oy = p_sy * (1 - p_t)

	if p_t == 1 then
		_upd = update_game
	end
end

function update_gameover()

end
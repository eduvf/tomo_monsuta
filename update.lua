function update_game()
	if btnp(⬅️) then
		p_x -= 1
		p_ox = 8
		_upd = update_p_turn
	end
	if btnp(➡️) then
		p_x += 1
		p_ox = -8
		_upd = update_p_turn
	end
	if btnp(⬆️) then
		p_y -= 1
		p_oy = 8
		_upd = update_p_turn
	end
	if btnp(⬇️) then
		p_y += 1
		p_oy = -8
		_upd = update_p_turn
	end
end

function update_p_turn()
	if p_ox > 0 then
		p_ox -= 2
	end
	if p_ox < 0 then
		p_ox += 2
	end
	if p_oy > 0 then
		p_oy -= 2
	end
	if p_oy < 0 then
		p_oy += 2
	end
	if p_ox == 0 and p_oy == 0 then
		_upd = update_game
	end
end

function update_gameover()

end
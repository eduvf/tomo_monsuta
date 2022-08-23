function update_game()
	buff_btn()
	act_btn(btn_buff)
	btn_buff = -1
end

function update_p_turn()
	buff_btn()
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

function get_btn()
	for i = 0, 5 do
		if btnp(i) then
			return i
		end
	end
	return -1
end

function buff_btn()
	if btn_buff == -1 then
		btn_buff = get_btn()
	end
end

function act_btn(btn)
	if btn < 0 then
		return
	elseif btn < 4 then
		move_player(dir_x[btn+1], dir_y[btn+1])
		return
	end
end
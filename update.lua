function update_game()
	if opened_box then
		if get_btn() == 5 then
			opened_box.dur = 0
			opened_box = nil
		end
	else
		buff_btn()
		act_btn(btn_buff)
		btn_buff = -1
	end
end

function update_inv()
	move_menu(inv_box)
	if btnp(4) then
		_upd = update_game
		inv_box.dur = 0
		stats_box.dur = 0
	end
end

function move_menu(box)
	if btnp(2) then
		box.cursor_pos = max(1, box.cursor_pos - 1)
	elseif btnp(3) then
		box.cursor_pos = min(#box.text, box.cursor_pos + 1)
	end
end

function update_p_turn()
	buff_btn()
	p_t = min(p_t + 0.2, 1)

	p_mob:move()

	if p_t == 1 then
		_upd = update_game
		if check_end() then
			follow_ai()
		end
	end
end

function update_ai_turn()
	buff_btn()
	p_t = min(p_t + 0.2, 1)

	for m in all(mob) do
		if m != p_mob and m.move then
			m:move()
		end
	end

	if p_t == 1 then
		_upd = update_game
		check_end()
	end
end

function update_gameover()
	if btnp(❎) then
		fade_out()
		start_game()
	end
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
	elseif btn == 5 then
		show_inv()
	end
end
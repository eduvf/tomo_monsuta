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
	move_menu(active_box)
	if btnp(4) then
		if active_box == inv_box then
			_upd = update_game
			inv_box.dur = 0
			stats_box.dur = 0
		elseif active_box == use_box then
			use_box.dur = 0
			active_box = inv_box
		end
	elseif btnp(5) then
		if active_box == inv_box and inv_box.cursor != 3 then
			show_use()
		elseif active_box == use_box then
			-- confirm
			trig_use()
		end
	end
end

function update_throw()
	local btn = get_btn()
	if btn >= 0 and btn <= 3 then
		throw_dir = btn
	end
	throw_x = dir_x[throw_dir + 1]
	throw_y = dir_y[throw_dir + 1]
	if btn == 4 then
		_upd = update_game
	elseif btn == 5 then
		throw()
	end
end

function move_menu(box)
	if btnp(2) then
		box.cursor -= 1
	elseif btnp(3) then
		box.cursor += 1
	end
	box.cursor = ((box.cursor - 1) % #box.text) + 1
end

function update_p_turn()
	buff_btn()
	p_t = min(p_t + 0.2, 1)

	if p_mob.move then
		p_mob:move()
	end

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

function buff_btn()
	if btn_buff == -1 then
		btn_buff = get_btn()
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

function act_btn(btn)
	if btn < 0 then
		return
	elseif btn < 4 then
		move_player(dir_x[btn+1], dir_y[btn+1])
	elseif btn == 5 then
		show_inv()
	end
end
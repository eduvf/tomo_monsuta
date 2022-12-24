function update_game()
	if talk_wind then
		if get_btn() == 5 then
			talk_wind.dur = 0
			talk_wind = nil
		end
	else
		do_btn_buff()
		do_btn(btn_buff)
		btn_buff = -1
	end
end

function update_inv()
	move_menu(curr_wind)
	if btnp(4) then
		if curr_wind == inv_wind then
			_upd = update_game
			inv_wind.dur = 0
			stat_wind.dur = 0
		elseif curr_wind == use_wind then
			use_wind.dur = 0
			curr_wind = inv_wind
		end
	elseif btnp(5) then
		if curr_wind == inv_wind and inv_wind.cursor != 3 then
			show_use()
		elseif curr_wind == use_wind then
			-- confirm
			trig_use()
		end
	end
end

function update_throw()
	local b = get_btn()
	if b >= 0 and b <= 3 then
		throw_x = dir_x[b + 1]
		throw_y = dir_y[b + 1]
	end
	if b == 4 then
		_upd = update_game
	elseif b == 5 then
		throw()
	end
end

function move_menu(w)
	if btnp(2) then
		w.cursor -= 1
	elseif btnp(3) then
		w.cursor += 1
	end
	w.cursor = ((w.cursor - 1) % #w.text) + 1
end

function update_p_turn()
	do_btn_buff()
	p_t = min(p_t + 0.2, 1)

	if p_mob.move then
		p_mob:move()
	end

	if p_t == 1 then
		_upd = update_game
		if trig_step() then
			return
		end
		if check_end() and not skip_ai then
			do_ai()
		end
		skip_ai = false
	end
end

function update_ai_turn()
	do_btn_buff()
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

function do_btn_buff()
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

function do_btn(b)
	if b < 0 then
		return
	elseif b < 4 then
		move_player(dir_x[b+1], dir_y[b+1])
	elseif b == 5 then
		show_inv()
	elseif b == 4 then
		map_gen()
	end
end
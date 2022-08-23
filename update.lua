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

function update_p_turn()
	buff_btn()
	p_t = min(p_t + 0.2, 1)

	p_mob.move(p_mob, p_t)

	if p_t == 1 then
		_upd = update_game
	end
end

function update_gameover()

end

function move_walk(mob, anim_t)
	mob.ox = mob.sx * (1 - anim_t)
	mob.oy = mob.sy * (1 - anim_t)
end

function move_bump(mob, anim_t)
	local time = anim_t
	if anim_t > 0.5 then
		time = 1 - time
	end

	mob.ox = mob.sx * time
	mob.oy = mob.sy * time
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
	end
end
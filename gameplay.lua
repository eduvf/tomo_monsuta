function move_player(_dx, _dy)
	local dest_x = p_x + _dx
	local dest_y = p_y + _dy
	local tile = mget(dest_x, dest_y)

	if _dx < 0 then
		p_flip = true
	elseif _dx > 0 then
		p_flip = false
	end

	if fget(tile, 0) then
		-- wall
		p_sx = _dx * 8
		p_sy = _dy * 8
		p_ox, p_oy = 0, 0
		p_t = 0
		_upd = update_p_turn

		p_anim = anim_bump
	else
		p_x += _dx
		p_y += _dy
		p_sx = _dx * -8
		p_sy = _dy * -8
		p_ox, p_oy = p_sx, p_sy
		p_t = 0
		_upd = update_p_turn

		p_anim = anim_walk
	end
end
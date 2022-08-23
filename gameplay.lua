function move_player(dx, dy)
	local dest_x = p_x + dx
	local dest_y = p_y + dy
	local tile = mget(dest_x, dest_y)

	if dx < 0 then
		p_flip = true
	elseif dx > 0 then
		p_flip = false
	end

	if fget(tile, 0) then
		-- wall
		p_sx = dx * 8
		p_sy = dy * 8
		p_ox, p_oy = 0, 0
		p_t = 0
		_upd = update_p_turn

		p_anim = anim_bump

		-- trigger interaction
		if fget(tile, 1) then
			trig_bump(tile, dest_x, dest_y)
		end
	else
		-- move
		sfx(63)

		p_x += dx
		p_y += dy
		p_sx = dx * -8
		p_sy = dy * -8
		p_ox, p_oy = p_sx, p_sy
		p_t = 0
		_upd = update_p_turn

		p_anim = anim_walk
	end
end

function trig_bump(tile, dest_x, dest_y)
	if tile == 7 or tile == 8 then
		-- vase
		sfx(59)
		mset(dest_x, dest_y, 1)
	elseif tile == 10 or tile == 12 then
		-- chest
		sfx(61)
		mset(dest_x, dest_y, tile - 1)
	elseif tile == 13 then
		-- door
		sfx(62)
		mset(dest_x, dest_y, 1)
	end
end
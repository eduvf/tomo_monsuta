function draw_game()
	cls(0)
	if fadeperc == 1 then return end
	map()
	for m in all(die_mob) do
		if sin(time() * 8) > 0 then
			draw_mob(m)
		end
		m.dur -= 1
		
		if m.dur <= 0 then
			del(die_mob, m)
		end
	end

	for i = #mob, 1, -1 do
		draw_mob(mob[i])
	end

	if _upd == update_throw then
		local tx, ty = throw_tile()
		local lx1, ly1 = p_mob.x * 8 + 3 + throw_x * 4, p_mob.y * 8 + 3 + throw_y * 4
		local lx2, ly2 = mid(0, tx * 8 + 3, 127), mid(0, ty * 8 + 3, 127)
		rectfill(lx1 + throw_y, ly1 + throw_x, lx2 - throw_y, ly2 - throw_x, 0)
		
		local thorw_anim, m = flr(t/7) % 2 == 0, get_mob(tx, ty)
		if thorw_anim then
			fillp(0b1010010110100101)
		else
			fillp(0b0101101001011010)
		end
		line(lx1, ly1, lx2, ly2, 7)
		fillp()
		oprint8('+', lx2 - 1, ly2 - 2, 7, 0)
		
		if m and thorw_anim then
			m.flash=1
		end 
	end

	for x = 0, 15 do
		for y = 0, 15 do
			if fog[x][y] == 1 then
				rectf(x * 8, y * 8, 8, 8, 0)
			end
		end
	end

	for f in all(float) do
		oprint8(f.text, f.x, f.y, f.c, 0)
	end
end

function draw_mob(m)
	local c = 10
	if m.flash > 0 then
		m.flash -= 1
		c = 7
	end
	draw_spr(get_frame(m.anim), m.x * 8 + m.ox, m.y * 8 + m.oy, c, m.fx)
end

function draw_gameover()
	cls(2)
	print('sina moli!', 50, 50, 7)
end

function draw_gamewin()
	cls(2)
	print('sina kama jo!', 50, 50, 7)
end
function get_frame(anim)
	return anim[flr(t/8) % #anim + 1]
end

function sprite(id, x, y, flip)
	palt(0, false)
	spr(get_frame(id), x, y, 1, 1, flip)
end

function rectf(x, y, w, h, c)
	rectfill(x, y, x + max(w - 1, 0), y + max(h - 1, 0), c)
end

function oprint8(t, x, y, c1, c2)
	for i = 1, 8 do
		print(t, x + dir8_x[i], y + dir8_y[i], c2)
	end
	print(t, x, y, c1)
end
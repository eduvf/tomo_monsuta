function get_frame(anim)
	return anim[flr(t/8) % #anim + 1]
end

function sprite(id, x, y, fx, c)
	palt(0, false)
	if c then
		pal(8, 7)
	end
	spr(id, x, y, 1, 1, fx)
	pal()
end

function rectf(x, y, w, h, c)
	rectfill(x, y, x + max(w - 1, 0), y + max(h - 1, 0), c)
end

function oprint8(t, x, y, c1, c2)
	for i = 1, 8 do
		print(t, x + dir_x[i], y + dir_y[i], c2)
	end
	print(t, x, y, c1)
end

function dist(x1, y1, x2, y2)
	local dx, dy = x1 - x2, y1 - y2
	return sqrt(dx * dx + dy * dy)
end
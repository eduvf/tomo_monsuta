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

function fade()
	local pix, kmax, col, k = flr(mid(0, fadeperc, 1) * 100)
	for j = 1, 15 do
		col = j
		kmax = flr((pix + (j * 1.46)) / 22)
		for k = 1, kmax do
			col = dpal[col]
		end
		pal(j, col, 1)
	end
end

function check_fade()
	if fadeperc > 0 then
		fadeperc = max(fadeperc - 0.04, 0)
		fade()
	end
end

function wait(_wait)
	repeat
		_wait -= 1
		flip()
	until _wait < 0
end

function fade_out()
	local s = 0.04
	repeat
		fadeperc = min(fadeperc + s, 1)
		fade()
		flip()
	until fadeperc == 1
end
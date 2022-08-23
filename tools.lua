function get_frame(anim)
	return anim[flr(t/8) % #anim + 1]
end

function sprite(id, x, y, flip)
	palt(0, false)
	spr(get_frame(id), x, y, 1, 1, flip)
end

function rectf(x, y, w, h, c)
	rectfill(x, y, x + w - 1, y + h - 1, c)
end
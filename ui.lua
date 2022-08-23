function add_box(x, y, w, h, text)
	local b = {
		x = x, y = y,
		w = w, h = h,
		text = text
	}
	add(boxes, b)
	return b
end

function draw_boxes()
	for b in all(boxes) do
		local x, y, w, h = b.x, b.y, b.w, b.h
		rectf(x, y, w, h, 1)
		rect(x + 1, y + 1, x + w -1, y + h -2, 6)

		x += 4
		y += 4
		clip(x, y, w - 8, h - 8)
		for i = 1, #b.text do
			local t = b.text[i]
			print(t, x, y, 6)
			y += 6
		end
		clip()

		

		if b.dur != nil then
			b.dur -= 1
			if b.dur <= 0 then
				b.y += h / 2 / 2
				b.h -= h / 2
				if b.h < 3 then
					del(boxes, b)
				end
			end
		else
			if b.btn then
				oprint8(
					'❎',
					x + w - 15,
					y - 1 + get_frame({0,0,1,1}),
					6, 1
				)
			end
		end
	end
end

function show_msg(text, dur)
	local w = (#text + 2) * 4 + 6
	local b = add_box(63 - w / 2, 50, w, 13, {' '..text})
	b.dur = dur
end

function show_dlg(text)
	opened_box = add_box(16, 50, 94, #text * 6 + 7, text)
	opened_box.btn = true
end
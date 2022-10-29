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
		rect(x + 1, y + 1, x + w -2, y + h -2, 6)

		x += 4
		y += 4
		clip(x, y, w - 7, h - 7)
		if b.cursor then
			x += 6
		end
		for i = 1, #b.text do
			local t, c = b.text[i], 6
			if b.color and b.color[i] then
				c = b.color[i]
			end
			print(t, x, y, c)
			if i == b.cursor_pos then
				spr(255, x - 5 + sin(time()), y)
			end
			y += 6
		end
		clip()

		

		if b.dur then
			b.dur -= 1
			if b.dur <= 0 then
				b.y += h / 4
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

function add_float(text, x, y, c)
	add(float, {
		text = text,
		x = x, y = y, c = c,
		ty = y - 10, t = 0})
end

function anim_float()
	for f in all(float) do
		f.y += (f.ty - f.y) / 10
		f.t += 1
		if f.t > 30 then
			del(float, f)
		end
	end
end

function update_hp_box()
	hp_box.text[1] = p_mob.hp .. '♥'
	local hp_y = 5
	if p_mob.y < 8 then
		hp_y = 110
	end
	hp_box.y += (hp_y - hp_box.y) / 5
end

function show_inv()
	local text, color = {}, {}
	for i = 1, 2 do
		local item, eqt = eqp[i]
		if item then
			eqt = itm_name[item]
			add(color, 6)
		else
			if i == 1 then
				eqt = '[pakala]'
			else
				eqt = '[selo]'
			end
			add(color, 5)
		end
		add(text, eqt)
	end
	add(text, '--------------')
	add(color, 6)
	for i = 1, 6 do
		local item = inv[i]
		if item then
			add(text, itm_name[item])
			add(color, 6)
		else
			add(text, '...')
			add(color, 5)
		end
	end
	
	_upd = update_inv
	inv_box = add_box(5, 17, 84, 62, text)
	inv_box.cursor = true
	inv_box.cursor_pos = 1
	inv_box.color = color

	stats_box = add_box(5, 5, 84, 13, {'ambcacmb'})
end
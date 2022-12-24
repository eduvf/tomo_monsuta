function add_wind(x, y, w, h, text)
	local w = {
		x = x, y = y,
		w = w, h = h,
		text = text
	}
	add(windows, w)
	return w
end

function draw_windows()
	for wind in all(windows) do
		local x, y, w, h = wind.x, wind.y, wind.w, wind.h
		rectf(x, y, w, h, 1)
		rect(x + 1, y + 1, x + w -2, y + h -2, 6)
		x += 4
		y += 4
		clip(x, y, w - 7, h - 7)
		if wind.cursor then
			x += 6
		end
		for i = 1, #wind.text do
			local t, c = wind.text[i], 6
			if wind.color and wind.color[i] then
				c = wind.color[i]
			end
			print(t, x, y, c)
			if i == wind.cursor then
				spr(255, x - 5 + sin(time()), y)
			end
			y += 6
		end
		clip()

		if wind.dur then
			wind.dur -= 1
			if wind.dur <= 0 then
				wind.y += h / 4
				wind.h -= h / 2
				if wind.h < 3 then
					del(windows, wind)
				end
			end
		else
			if wind.btn then
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
	local wind = add_wind(63 - w / 2, 50, w, 13, {' '..text})
	wind.dur = dur
end

function show_talk(text)
	talk_wind = add_wind(16, 50, 94, #text * 6 + 7, text)
	talk_wind.btn = true
end

function add_float(text, x, y, c)
	add(float, {
		text = text,
		x = x, y = y, c = c,
		ty = y - 10, t = 0})
end

function do_floats()
	for f in all(float) do
		f.y += (f.ty - f.y) / 10
		f.t += 1
		if f.t > 30 then
			del(float, f)
		end
	end
end

function do_hp_wind()
	hp_wind.text[1] = p_mob.hp .. '/' .. p_mob.hp_max .. '♥'
	local hp_y = 5
	if p_mob.y < 8 then
		hp_y = 110
	end
	hp_wind.y += (hp_y - hp_wind.y) / 5
end

function show_inv()
	local text, color, item, eqt = {}, {}
	_upd = update_inv
	for i = 1, 2 do
		item = eqp[i]
		if item then
			eqt = itm_name[item]
			add(color, 6)
		else
			eqt = i == 1 and '[pakala]' or '[selo]'
			add(color, 5)
		end
		add(text, eqt)
	end
	add(text, '--------------')
	add(color, 6)
	for i = 1, 6 do
		item = inv[i]
		if item then
			add(text, itm_name[item])
			add(color, 6)
		else
			add(text, '...')
			add(color, 5)
		end
	end
	
	inv_wind = add_wind(5, 17, 84, 62, text)
	inv_wind.cursor = 1
	inv_wind.color = color

	stat_wind = add_wind(5, 5, 84, 13, {'wawa: '..p_mob.atk..' | len: '..p_mob.def_min..'-'..p_mob.def_max})

	curr_wind = inv_wind
end

function show_use()
	local item = inv_wind.cursor < 3 and eqp[inv_wind.cursor] or inv[inv_wind.cursor - 3]
	if item == nil then
		return
	end
	local typ, text = itm_type[item], {}

	if typ == 'weapon' or typ == 'armor' then
		add(text, 'o kpkn')
	end
	if typ == 'food' then
		add(text, 'o moku')
	end
	if typ == 'throw' or typ == 'food' then
		add(text, 'o pana')
	end
	add(text, 'o weka')

	use_wind = add_wind(84, inv_wind.cursor * 6 + 11, 36, 7 + #text * 6, text)
	use_wind.cursor = 1
	curr_wind = use_wind
end

function trig_use()
	local verb, i, back = use_wind.text[use_wind.cursor], inv_wind.cursor, true
	local item = i < 3 and eqp[i] or inv[i - 3]

	if verb == 'o weka' then
		if i < 3 then
			eqp[i] = nil
		else
			inv[i - 3] = nil
		end
	elseif verb == 'o kpkn' then
		local slot = 2
		if itm_type[item] == 'weapon' then
			slot = 1
		end
		inv[i - 3] = eqp[slot]
		eqp[slot] = item
	elseif verb == 'o moku' then
		eat(item, p_mob)
		_upd = update_p_turn
		inv[i - 3] = nil
		p_mob.move = nil
		p_t = 0
		back = false
	elseif verb == 'o pana' then
		_upd = update_throw
		throw_slt = i - 3
		back = false
	end

	update_stats()
	use_wind.dur = 0

	if back then
		del(windows, inv_wind)
		del(windows, stat_wind)
		show_inv()
		inv_wind.cursor = i
	else
		inv_wind.dur = 0
		stat_wind.dur = 0
	end
end

function floor_msg()
	show_msg("tomo nanpa " .. floor, 120)
end
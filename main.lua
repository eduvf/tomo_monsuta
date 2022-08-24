function _init()
	t = 0

	dir_x = {-1, 1, 0, 0, 1, 1,-1,-1}
	dir_y = { 0, 0,-1, 1,-1, 1, 1,-1}

	mob_anim = {240, 192}
	mob_atk = {1, 1}
	mob_hp = {5, 2}

	dbg = {}
	start_game()
end

function _update()
	t += 1

	_upd()
	anim_float()
end

function _draw()
	_drw()
	draw_boxes()
	cursor(4, 4)
	color(8)
	for text in all(dbg) do
		print(text)
	end
	color()
end

function start_game()
	btn_buff = -1

	mob = {}
	die_mob = {}
	p_mob = add_mob(1, 1, 1 )

	for x = 0, 15 do
		for y = 0, 15 do
			if mget(x, y) == 3 then
				add_mob(2, x, y)
			end
		end
	end

	p_t = 0

	boxes = {}
	opened_box = nil
	float = {}

	_upd = update_game
	_drw = draw_game
end
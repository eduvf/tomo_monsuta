function _init()
	t = 0

	dpal = {0,1,1,2,1,13,6,4,4,9,3,13,1,13,14}

	dir_x = {-1, 1, 0, 0, 1, 1,-1,-1}
	dir_y = { 0, 0,-1, 1,-1, 1, 1,-1}

	mob_anim = {240, 192}
	mob_atk = {1, 1}
	mob_hp = {5, 2}
	mob_los = {4, 4}

	dbg = {}
	start_game()
end

function _update()
	t += 1

	_upd()
	anim_float()
	update_hp_box()
end

function _draw()
	_drw()
	draw_boxes()
	check_fade()

	cursor(4, 4)
	color(8)
	for text in all(dbg) do
		print(text)
	end
	color()
end

function start_game()
	fadeperc = 1 -- fade
	btn_buff = -1

	mob = {}
	die_mob = {}
	p_mob = add_mob(1, 1, 1 )

	for x = 0, 15 do
		for y = 0, 15 do
			if mget(x, y) == 192 then
				add_mob(2, x, y)
				mset(x, y, 1)
			end
		end
	end

	p_t = 0

	boxes = {}
	opened_box = nil
	float = {}

	-- set to blank_map(0) to disable fog
	fog = blank_map(0)

	hp_box = add_box(5, 5, 18, 13, {})

	_upd = update_game
	_drw = draw_game

	unfog()
end
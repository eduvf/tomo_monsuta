function _init()
	t = 0

	dir_x = {-1, 1, 0, 0, 1, 1,-1,-1}
	dir_y = { 0, 0,-1, 1,-1, 1, 1,-1}

	mob_anim = {240, 192}
	mob_atk = {1, 1}
	mob_hp = {5, 2}

	_upd = update_game
	_drw = draw_game
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
end

function start_game()
	btn_buff = -1

	mob = {}
	p_mob = add_mob(1, 1, 1 )
	add_mob(2, 2, 2)

	p_t = 0

	boxes = {}
	opened_box = nil
	float = {}
end
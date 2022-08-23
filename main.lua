function _init()
	t = 0
	p_walk_anim = {240,241,242,243}

	dir_x = {-1, 1, 0, 0}
	dir_y = { 0, 0,-1, 1}

	_upd = update_game
	_drw = draw_game
	start_game()
end

function _update()
	t += 1

	_upd()
end

function _draw()
	_drw()
	draw_boxes()
end

function start_game()
	btn_buff = -1

	p_x, p_y = 4, 3
	p_ox, p_oy = 0, 0
	p_sx, p_sy = 0, 0
	p_flip = false
	p_anim = nil

	p_t = 0

	boxes = {}

	add_box(32, 64, 64, 32, {"hello world", "line 2"})
end
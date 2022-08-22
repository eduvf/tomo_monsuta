function _init()
	t = 0
	p_anim = {240,241,242,243}

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
end

function start_game()
	p_x, p_y = 4, 3
	p_ox, p_oy = 0, 0
end
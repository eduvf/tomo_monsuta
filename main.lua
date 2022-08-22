function _init()
	_upd = update_game
	_drw = draw_game
	start_game()
end

function _update()
	_upd()
end

function _draw()
	_drw()
end

function start_game()
	p_x = 4
	p_y = 3
end
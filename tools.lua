function get_frame(_anim)
    return _anim[flr(t/8) % #_anim + 1]
end

function sprite(_spr, _x, _y)
    palt(0, false)
	spr(get_frame(_spr), _x, _y)
end
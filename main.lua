function _init()
	t = 0

	dpal = {0,1,1,2,1,13,6,4,4,9,3,13,1,13,14}

	dir_x = {-1, 1, 0, 0, 1, 1,-1,-1}
	dir_y = { 0, 0,-1, 1,-1, 1, 1,-1}

	mob_anim = {240, 192}
	mob_atk = {1, 1}
	mob_hp = {5, 1}
	mob_los = {4, 4}

	itm_name = {'ilo utl suli', 'len soweli', 'telo loje', 'sike kipisi', 'ilo utl pkl'}
	itm_type = {'weapon', 'armor', 'food', 'throw', 'weapon'}
	itm_stat1 = {2, 0, 1, 1, 1}
	itm_stat2 = {0, 2, 0, 0, 0}

	carve_sig = {0b11111111, 0b11010110, 0b01111100, 0b10110011, 0b11101001}
	carve_msk = {0,          0b00001001, 0b00000011, 0b00001100, 0b00000110}

	dbg = {}
	start_game()
end

function _update()
	t += 1

	_upd()
	do_floats()
	do_hp_wind()
end

function _draw()
	_drw()
	draw_windows()
	check_fade()

	cursor(4, 4)
	color(8)
	for text in all(dbg) do
		print(text)
	end
end

function start_game()
	fadeperc = 1 -- fade
	btn_buff = -1

	skip_ai = false

	mob = {}
	die_mob = {}
	p_mob = add_mob(1, 1, 1)

	p_t = 0

	inv, eqp = {}, {}

	windows = {}
	float = {}
	fog = blank_map(0)
	talk_wind = nil

	hp_wind = add_wind(5, 5, 28, 13, {})

	throw_x, throw_y = 0, -1

	_upd = update_game
	_drw = draw_game
	unfog()

	map_gen()
end
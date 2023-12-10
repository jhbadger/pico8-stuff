pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
function _init()
	game_over=false
	win=false
	g=0.025 --gravity
	make_player()
	make_ground()
end

function _update()
	if (not game_over) then
		move_player()
		check_land()
	else
		if (btnp(5)) _init()
	end
end

function _draw()
	cls()
	draw_stars()
	draw_player()
	draw_ground()
	if (game_over) then
		if (win) then
			print("the eagle has landed!",25,48,11)
		else
			print("the turkey has crashed!",25,48,11)
		end
		print("press ❎ to play again",25,70,5)
	end
end

function check_land()
	l_x=flr(p.x)
	r_x=flr(p.x+7)
	b_y=flr(p.y+7)
	
	over_pad=l_x>=pad.x and r_x<=pad.x+pad.width
	on_pad=b_y>=pad.y-1
	slow=p.dy<1
	
	if (over_pad and on_pad and slow) then
		end_game(true)
	elseif (over_pad and on_pad) then
		end_game(false)
	else
		for i=l_x,r_x do
			if (gnd[i]<=b_y) end_game(false)
		end
	end
end
 
 
function end_game(won)
	game_over=true
	win=won
	if (win) then
		sfx(1)
	else
		sfx(2)
	end
end

function thrust()
	if (btn(0)) p.dx-=p.thrust
	if (btn(1)) p.dx+=p.thrust
	if (btn(2)) p.dy-=p.thrust	
	if (btn(0) or btn(1) or btn(2)) sfx(0)
end

function stay_on_screen()
	if (p.x<0) then
		p.x=0
		p.dx=0
	end
	if (p.x>119) then
		p.x=119
		p.dx=0
	end
	if (p.y<0) then
		p.y=0
		p.dy=0
	end
end

function move_player()
	p.dy+=g
	thrust()
	p.x+=p.dx
	p.y+=p.dy
	stay_on_screen()
end

function make_player()
	p={}
	p.x=60
	p.y=8
	p.dx=0
	p.dy=0
	p.sprite=1
	p.alive=true
	p.thrust=0.075
end

function draw_player()
	spr(p.sprite,p.x,p.y)
	if (game_over and win) then
		spr(4,p.x,p.y-8)
	elseif (game_over) then
		spr(5,p.x,p.y)
	end
end

function draw_ground()
	for i=0,127 do
		line(i,gnd[i],i,127,5)
	end
	spr(pad.sprite,pad.x,pad.y,2,1)
end


function rndb(low,high)
	return flr(rnd(high-low+1)+low)
end

function draw_stars()
	srand(1)
	for i=1,50 do
		pset(rndb(0,127),rndb(0,127),rndb(5,7))
	end
	srand(time)
end
	
function make_ground()
	gnd={}
	local top=96
	local btm=120
	pad={}
	pad.width=15
	pad.x=rndb(0,126-pad.width)
	pad.y=rndb(top,btm)
	pad.sprite=2
	for i=pad.x,pad.x+pad.width do
		gnd[i]=pad.y
	end
	for i=pad.x+pad.width+1, 127 do
		local h=rndb(gnd[i-1]-3,gnd[i-1]+3)
		gnd[i]=mid(top,h,btm)
	end
	for i=pad.x-1,0,-1 do
		local h=rndb(gnd[i+1]-3,gnd[i+1]+3)
		gnd[i]=mid(top,h,btm)
	end
end

__gfx__
00000000000000002222222222222222000000000090080000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000dddd000000000000000000000000009009000800000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000dd77dd00000000000000000000000000988099000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000dd7557dd0000000000000000000d80008908800000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000dd5555dd0000000000000000000d88000080899800000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000dddddd00000000000000000000d88809890808000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000070770700000000000000000000d00000080089000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000660660660000000000000000000d00000909080000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000600000065000700007000070000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000a00001d0501d0501a0501a05015050150501d0501d050000001b0501d0501d0500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0004000025050220501e0501b0501905016050130500f0500c0500a05007050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

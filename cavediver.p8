pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
cartdata("cavediver_scores")

function _init()
	game_over=false
	make_cave()
	make_player()
end

function _update()
	if (not game_over) then
		update_cave()
		move_player()
		check_hit()
		player.score += player.speed
		else if (btnp(5)) then
			_init()
		end
	end
end

function _draw()
	cls()
	draw_cave()
	draw_player()
	print(player.score,2,0,0)
	print(player.hiscore,110,0,0)
end

function check_hit()
	for i=player.x,player.x+7 do
		if (cave[i+1].top>player.y
			or cave[i+1].btm<player.y+7) then
				game_over=true
				sfx(1)
		end	
	end
end

function make_cave()
	cave = {{["top"]=5, ["btm"]=119}}
	top = 45
	btm = 85
end

function update_cave()
	if (#cave>player.speed) then
		for i=1,player.speed do
			del(cave, cave[1])
		end
	end
	while(#cave<128) do
		local col={}
		local up=flr(rnd(7)-3)
		local dwn=flr(rnd(7)-3)
		col.top=mid(3,cave[#cave].top+up,top)
		col.btm=mid(btm,cave[#cave].btm+dwn,124)
		add(cave,col)
	end
end

function draw_cave()
	top_color=5
	btm_color=5
	for i=1,#cave do
		line(i-1,0,i-1,cave[i].top,top_color)
		line(i-1,127,i-1,cave[i].btm,btm_color)
	end
end
		

function make_player()
	player={}
	player.x = 24
	player.y = 60
	player.dy = 0
	player.rise=1
	player.fall=2
	player.dead=3
	player.speed=2
	player.score=0
	player.hiscore = dget(1)
end

function draw_player()
	if (game_over) then
		spr(player.dead, player.x, player.y)
		if (player.score > player.hiscore) then
			dset(1, player.score)
		end
	elseif (player.dy<0) then
		spr(player.rise, player.x, player.y)
	else
		spr(player.fall, player.x, player.y)
	end
end			

function move_player()
	gravity=0.2 -- bigger more gravity
	player.dy+=gravity	
	if (btnp(2)) then
		player.dy-=3
		sfx(0)
	end
	player.y+=player.dy
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000aaaa0000aaaa0000aaaa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000a0aa0a00a0aa0a00a0aa0a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000aaaaaa00aaaaaa00aaaaaa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000a0000a00aa00aa00aa00aa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000aa00aa00aa00aa00a0aa0a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000aaaa0000aaaa0000aaaa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000400000003000030000300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000a00002d050250501e0501805010050030500305003050030500305003050030500305003050030500000000000000000000000000000000000000000000000000000000000000000000000000000000000000

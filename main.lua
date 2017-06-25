require "global"
require "tiled"
require "anim"
require "ninja"
require "obake"
require "coin"
require "porc"

function lutro.conf(t)
	t.width  = SCREEN_WIDTH
	t.height = SCREEN_HEIGHT
end

local add_entity_from_map = function(object)
	if object.type == "ground" then
		table.insert(entities, object)
	elseif object.type == "coin" then
		table.insert(entities, newCoin(object))
	elseif object.type == "porc" then
		table.insert(entities, newPorc(object))
	end
end

function lutro.load()
	camera_x = 0
	camera_y = 0
	gold = 0
	hp = 3
	lutro.graphics.setBackgroundColor(0, 0, 0)
	bg1 = lutro.graphics.newImage("assets/forestbackground.png")
	bg2 = lutro.graphics.newImage("assets/foresttrees.png")
	font = lutro.graphics.newImageFont("assets/font.png",
		" abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,!?-+/")
	lutro.graphics.setFont(font)
	map = tiled_load("assets/pagode.json")
	tiled_load_objects(map, add_entity_from_map)

	sfx_coin = lutro.audio.newSource("assets/coin.wav")
	sfx_jump = lutro.audio.newSource("assets/jump.wav")
	sfx_step = lutro.audio.newSource("assets/step.wav")
	sfx_hit = lutro.audio.newSource("assets/hit.wav")

	ninja = newNinja()
	table.insert(entities, ninja)
	table.insert(entities, newObake())
end

function lutro.update(dt)
	for i=1, #entities do
		if entities[i].update then
			entities[i]:update(dt)
		end
	end

	detect_collisions()

	-- camera
	camera_x = - ninja.x + SCREEN_WIDTH/2 - ninja.width/2;
	if camera_x > 0 then
		camera_x = 0
	end
	if camera_x < -(map.width * map.tilewidth) + SCREEN_WIDTH then
		camera_x = -(map.width * map.tilewidth) + SCREEN_WIDTH
	end
end

function lutro.draw()
	lutro.graphics.clear()

	for i=0, 4 do
		lutro.graphics.draw(bg1, i*bg1:getWidth() + camera_x / 6, 0)
		--lutro.graphics.draw(bg2, i*bg2:getWidth() + camera_x / 3, 0)
	end

	lutro.graphics.push()

	lutro.graphics.translate(camera_x, camera_y)

	tiled_draw_layer(map.layers[1])
	for i=1, #entities do
		if entities[i].draw then
			entities[i]:draw(dt)
		end
	end
	tiled_draw_layer(map.layers[2])

	lutro.graphics.pop()

	lutro.graphics.print("HP " .. hp .. "  GOLD " .. gold, 3, 1)
end

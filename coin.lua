require "collisions"

local coin = {}
coin.__index = coin

function newCoin(object)
	local n = object
	n.collect = 0

	n.anim = newAnimation(lutro.graphics.newImage(
				"assets/coin.png"), 16, 16, 1, 10)
	return setmetatable(n, coin)
end

function coin:update(dt)
	if self.collect > 0 then
		self.collect = self.collect - 1
		self.x = self.x + (320 - camera_x - self.x - self.width)/10
		self.y = self.y + (  0 - camera_y - self.y)/10
	end
	if self.collect == 1 then
		entities_remove(self)
	end

	self.anim:update(dt)
end

function coin:draw()
	self.anim:draw(self.x, self.y)
end

function coin:on_collide(e1, e2, dx, dy)
	if e2.type == "ninja" then
		lutro.audio.play(sfx_coin)
		--entities_remove(self)
		self.collect = 30
		self.on_collide = nil
		gold = gold + 1
	end
end

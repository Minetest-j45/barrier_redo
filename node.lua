local range = 5

minetest.register_node("barrier:barrier", {
	description = "Barrier",
	tiles = {
		"barrier.png",
		"barrier.png",
		"barrier.png",
		"barrier.png",
		"barrier.png",
		"barrier.png"
	},
	inventory_image = "barrier_inv.png",
	drawtype = "nodebox",
	paramtype = "light",
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
		}
	}
})

minetest.register_node("barrier:visible_barrier", {
	description = "Visible Barrier",
	tiles = {
		"barrier_inv.png",
		"barrier_inv.png",
		"barrier_inv.png",
		"barrier_inv.png",
		"barrier_inv.png",
		"barrier_inv.png"
	},
	inventory_image = "barrier_inv.png",
	drawtype = "nodebox",
	paramtype = "light",
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2,not_in_creative_inventory=1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
		}
	}
})

local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime;
	if timer >= 0.5 then
		for _,player in pairs(minetest.get_connected_players()) do
			if player:get_wielded_item():get_name() == "barrier:barrier" then
				local pos = player:get_pos()
				for x=-range, range do
					for y=-range, range do
						for z=-range, range do
							if x*x+y*y+z*z <= range * range then
								local nodepos = {x=pos.x+x, y=pos.y+y, z=pos.z+z}
								local node = minetest.get_node(nodepos)
								if node.name == "barrier:barrier" then
									minetest.set_node(nodepos, {name="barrier:visible_barrier"})
								end
							end
						end
					end
				end
			end
		end
		timer = 0
	end
end)

minetest.register_abm({
	nodenames = {"barrier:visible_barrier"},
	interval = 0.5,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local all_objects = minetest.get_objects_inside_radius(pos, range)
		local players = {}
		local _,obj
		if #all_objects == 0 then
			minetest.set_node(pos, {name="barrier:barrier"})
		else
			for _,obj in ipairs(all_objects) do
				if obj:is_player() then
					if not obj:get_wielded_item():get_name() == "barrier:barrier" then
						minetest.set_node(pos, {name="barrier:barrier"})	
					end
				end
			end
		end
	end
})
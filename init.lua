
lib_doors = {}

local _lib_doors = {}
lib_doors.registered_doors = {}

function lib_doors.get(pos)
	local node_name = minetest.get_node(pos).name
	if lib_doors.registered_doors[node_name] then
		-- A normal upright door
		return {
			pos = pos,
			open = function(self, player)
				if self:state() then
					return false
				end
				return lib_doors.door_toggle(self.pos, nil, player)
			end,
			close = function(self, player)
				if not self:state() then
					return false
				end
				return lib_doors.door_toggle(self.pos, nil, player)
			end,
			toggle = function(self, player)
				return lib_doors.door_toggle(self.pos, nil, player)
			end,
			state = function(self)
				return minetest.get_node(self.pos).name:sub(-5) == "_open"
			end
		}
	else
		return nil
	end
end
function lib_doors.door_toggle(pos, node, clicker)
	node = node or minetest.get_node(pos)
	if clicker and not minetest.check_player_privs(clicker, "protection_bypass") then
		-- is player wielding the right key?
		local item = clicker:get_wielded_item()
		local meta = minetest.get_meta(pos)
		local owner = meta:get_string("doors_owner")
		if item:get_name() == "default:key" then
			local key_meta = minetest.parse_json(item:get_metadata())
			local secret = meta:get_string("key_lock_secret")
			if secret ~= key_meta.secret then
				return false
			end

		elseif owner ~= "" then
			if clicker:get_player_name() ~= owner then
				return false
			end
		end
	end

	local def = minetest.registered_nodes[node.name]

	if string.sub(node.name, -5) == "_open" then
		minetest.sound_play(def.sound_close,
			{pos = pos, gain = 0.3, max_hear_distance = 10})
		minetest.swap_node(pos, {name = string.sub(node.name, 1,
			string.len(node.name) - 5), param1 = node.param1, param2 = node.param2})
	else
		minetest.sound_play(def.sound_open,
			{pos = pos, gain = 0.3, max_hear_distance = 10})
		minetest.swap_node(pos, {name = node.name .. "_open",
			param1 = node.param1, param2 = node.param2})
	end
end
local function can_dig_door(pos, digger)
	local digger_name = digger and digger:get_player_name()
	if digger_name and minetest.get_player_privs(digger_name).protection_bypass then
		return true
	end
	return minetest.get_meta(pos):get_string("doors_owner") == digger_name
end
local function on_place_node(place_to, newnode,
	placer, oldnode, itemstack, pointed_thing)
	-- Run script hook
	for _, callback in ipairs(minetest.registered_on_placenodes) do
		-- Deepcopy pos, node and pointed_thing because callback can modify them
		local place_to_copy = {x = place_to.x, y = place_to.y, z = place_to.z}
		local newnode_copy =
			{name = newnode.name, param1 = newnode.param1, param2 = newnode.param2}
		local oldnode_copy =
			{name = oldnode.name, param1 = oldnode.param1, param2 = oldnode.param2}
		local pointed_thing_copy = {
			type  = pointed_thing.type,
			above = vector.new(pointed_thing.above),
			under = vector.new(pointed_thing.under),
			ref   = pointed_thing.ref,
		}
		callback(place_to_copy, newnode_copy, placer,
			oldnode_copy, itemstack, pointed_thing_copy)
	end
end


function lib_doors.register_nodes(node_name, node_desc, node_texture, node_craft_mat, node_sounds)

--DOORS
	lib_doors.register_door_centered(node_name .. "_door_centered", node_desc .. "Door_centered", node_texture, node_craft_mat, node_sounds)
	lib_doors.register_door_centered_right(node_name .. "_door_centered_right", node_desc .. "Door_centered_right", node_texture, node_craft_mat, node_sounds)

	lib_doors.register_door_centered_with_window(node_name .. "_door_centered_with_window", node_desc .. "Door_centered_with_window", node_texture, node_craft_mat, node_sounds)
	lib_doors.register_door_centered_with_window_right(node_name .. "_door_centered_with_window_right", node_desc .. "Door_centered_with_window_right", node_texture, node_craft_mat, node_sounds)

	lib_doors.register_door_centered_sliding(node_name .. "_door_centered_sliding", node_desc .. "Door_centered_sliding", node_texture, node_craft_mat, node_sounds)
	lib_doors.register_door_centered_sliding_right(node_name .. "_door_centered_sliding_right", node_desc .. "Door_centered_sliding_right", node_texture, node_craft_mat, node_sounds)

	lib_doors.register_door_centered_400_height_250_width(node_name .. "_door_centered_400_height_250_width", node_desc .. "Door_centered_400_height_250_width", node_texture, node_craft_mat, node_sounds)
	lib_doors.register_door_centered_400_height_250_width_right(node_name .. "_door_centered_400_height_250_width_right", node_desc .. "Door_centered_400_height_250_width_right", node_texture, node_craft_mat, node_sounds)

	lib_doors.register_door_centered_400_height_200_width(node_name .. "_door_centered_400_height_200_width", node_desc .. "Door_centered_400_height_200_width", node_texture, node_craft_mat, node_sounds)
	lib_doors.register_door_centered_400_height_200_width_right(node_name .. "_door_centered_400_height_200_width_right", node_desc .. "Door_centered_400_height_200_width_right", node_texture, node_craft_mat, node_sounds)

	lib_doors.register_door_centered_300_height_150_width(node_name .. "_door_centered_300_height_150_width", node_desc .. "Door_centered_300_height_150_width", node_texture, node_craft_mat, node_sounds)
	lib_doors.register_door_centered_300_height_150_width_right(node_name .. "_door_centered_300_height_150_width_right", node_desc .. "Door_centered_300_height_150_width_right", node_texture, node_craft_mat, node_sounds)

--GATES
	lib_doors.register_fencegate_centered(node_name .. "_gate_centered", node_desc .. "Gate_centered", node_texture, node_craft_mat, node_sounds)
	lib_doors.register_fencegate_centered_right(node_name .. "_gate_centered_right", node_desc .. "Gate_centered_right", node_texture, node_craft_mat, node_sounds)

	lib_doors.register_fencegate_centered_solid(node_name .. "_gate_centered_solid", node_desc .. "Gate_centered_solid", node_texture, node_craft_mat, node_sounds)
	lib_doors.register_fencegate_centered_solid_right(node_name .. "_gate_centered_solid_right", node_desc .. "Gate_centered_solid_right", node_texture, node_craft_mat, node_sounds)

end

lib_doors.register_door_centered_right = function(wall_name, wall_desc, wall_texture, wall_mat, wall_sounds)

	local name = ""

	if not wall_name:find(":") then
		name = "lib_doors:" .. wall_name
	end

	local name_closed = name
	local name_opened = name.."_open"
	local skel_key = false


	local def = {
		description = wall_desc,
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		sounds = wall_sounds,
		sound_open = "doors_door_open",
		sound_close = "doors_door_close",
		protected = false,
		groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, fence = 1, wall = 1, stone = 1, wood = 1, glass = 1, lib_doors = 1},
		tiles = {wall_texture},

		on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
			lib_doors.door_toggle(pos, node, clicker)
			return itemstack
		end,
	}
	if skel_key then
		def.can_dig = can_dig_door
		def.after_place_node = function(pos, placer, itemstack, pointed_thing)
			local pn = placer:get_player_name()
			local meta = minetest.get_meta(pos)
			meta:set_string("doors_owner", pn)
			meta:set_string("infotext", "Owned by "..pn)

			return minetest.setting_getbool("creative_mode")
		end

		def.on_blast = function() end
		def.on_key_use = function(pos, player)
			local door = lib_doors.get(pos)
			lib_doors:toggle(player)
		end
		def.on_skeleton_key_use = function(pos, player, newsecret)
			local meta = minetest.get_meta(pos)
			local owner = meta:get_string("doors_owner")
			local pname = player:get_player_name()

			-- verify placer is owner of lockable door
			if owner ~= pname then
				minetest.record_protection_violation(pos, pname)
				minetest.chat_send_player(pname, "You do not own this trapdoor.")
				return nil
			end

			local secret = meta:get_string("key_lock_secret")
			if secret == "" then
				secret = newsecret
				meta:set_string("key_lock_secret", secret)
			end

			return secret, "a locked trapdoor", owner
		end
	else
		def.on_blast = function(pos, intensity)
			minetest.remove_node(pos)
			return {name}
		end
	end


	local def_opened = table.copy(def)
	local def_closed = table.copy(def)

	def_closed.node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.0625, 0.5, 1.5, 0.0625}
	}
	def_closed.selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.0625, 0.5, 1.5, 0.0625}
	}

	def_opened.node_box = {
		type = "fixed",
		fixed = {0.375, -0.5, 0, 0.5, 1.5, 1.0}
	}
	def_opened.selection_box = {
		type = "fixed",
		fixed = {0.375, -0.5, 0, 0.5, 1.5, 1.0}
	}

	def_opened.drop = name_closed
	def_opened.groups.not_in_creative_inventory = 1

	minetest.register_node(name_opened, def_opened)
	minetest.register_node(name_closed, def_closed)

	lib_doors.registered_doors[name_opened] = true
	lib_doors.registered_doors[name_closed] = true

	-- crafting recipe
	minetest.register_craft({
		output = "lib_doors:" .. wall_name .. " 99",
		recipe = {
			{ '', '', '' },
			{ '', "lib_shapes:shape_door_centered_right", ''},
			{ '', wall_mat, ''},
		}
	})
end
lib_doors.register_door_centered = function(wall_name, wall_desc, wall_texture, wall_mat, wall_sounds)

	local name = ""

	if not wall_name:find(":") then
		name = "lib_doors:" .. wall_name
	end

	local name_closed = name
	local name_opened = name.."_open"
	local skel_key = false


	local def = {
		description = wall_desc,
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		sounds = wall_sounds,
		sound_open = "doors_door_open",
		sound_close = "doors_door_close",
		protected = false,
		groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, fence = 1, wall = 1, stone = 1, wood = 1, glass = 1, lib_doors = 1},
		tiles = {wall_texture},

		on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
			lib_doors.door_toggle(pos, node, clicker)
			return itemstack
		end,
	}
	if skel_key then
		def.can_dig = can_dig_door
		def.after_place_node = function(pos, placer, itemstack, pointed_thing)
			local pn = placer:get_player_name()
			local meta = minetest.get_meta(pos)
			meta:set_string("doors_owner", pn)
			meta:set_string("infotext", "Owned by "..pn)

			return minetest.setting_getbool("creative_mode")
		end

		def.on_blast = function() end
		def.on_key_use = function(pos, player)
			local door = lib_doors.get(pos)
			lib_doors:toggle(player)
		end
		def.on_skeleton_key_use = function(pos, player, newsecret)
			local meta = minetest.get_meta(pos)
			local owner = meta:get_string("doors_owner")
			local pname = player:get_player_name()

			-- verify placer is owner of lockable door
			if owner ~= pname then
				minetest.record_protection_violation(pos, pname)
				minetest.chat_send_player(pname, "You do not own this trapdoor.")
				return nil
			end

			local secret = meta:get_string("key_lock_secret")
			if secret == "" then
				secret = newsecret
				meta:set_string("key_lock_secret", secret)
			end

			return secret, "a locked trapdoor", owner
		end
	else
		def.on_blast = function(pos, intensity)
			minetest.remove_node(pos)
			return {name}
		end
	end


	local def_opened = table.copy(def)
	local def_closed = table.copy(def)

	def_closed.node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.0625, 0.5, 1.5, 0.0625}
	}
	def_closed.selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.0625, 0.5, 1.5, 0.0625}
	}

	def_opened.node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, 0, -0.375, 1.5, 1.0}
	}
	def_opened.selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, 0, -0.375, 1.5, 1.0}
	}

	def_opened.drop = name_closed
	def_opened.groups.not_in_creative_inventory = 1

	minetest.register_node(name_opened, def_opened)
	minetest.register_node(name_closed, def_closed)

	lib_doors.registered_doors[name_opened] = true
	lib_doors.registered_doors[name_closed] = true

	-- crafting recipe
	minetest.register_craft({
		output = "lib_doors:" .. wall_name .. " 99",
		recipe = {
			{ '', '', '' },
			{ '', "lib_shapes:shape_door_centered", ''},
			{ '', wall_mat, ''},
		}
	})
end

lib_doors.register_door_centered_with_window_right = function(wall_name, wall_desc, wall_texture, wall_mat, wall_sounds)

	local name = ""

	if not wall_name:find(":") then
		name = "lib_doors:" .. wall_name
	end

	local name_closed = name
	local name_opened = name.."_open"
	local skel_key = false


	local def = {
		description = wall_desc,
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		sounds = wall_sounds,
		sound_open = "doors_door_open",
		sound_close = "doors_door_close",
		protected = false,
		groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, fence = 1, wall = 1, stone = 1, wood = 1, glass = 1, lib_doors = 1},
		tiles = {wall_texture},

		on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
			lib_doors.door_toggle(pos, node, clicker)
			return itemstack
		end,
	}
	if skel_key then
		def.can_dig = can_dig_door
		def.after_place_node = function(pos, placer, itemstack, pointed_thing)
			local pn = placer:get_player_name()
			local meta = minetest.get_meta(pos)
			meta:set_string("doors_owner", pn)
			meta:set_string("infotext", "Owned by "..pn)

			return minetest.setting_getbool("creative_mode")
		end

		def.on_blast = function() end
		def.on_key_use = function(pos, player)
			local door = lib_doors.get(pos)
			lib_doors:toggle(player)
		end
		def.on_skeleton_key_use = function(pos, player, newsecret)
			local meta = minetest.get_meta(pos)
			local owner = meta:get_string("doors_owner")
			local pname = player:get_player_name()

			-- verify placer is owner of lockable door
			if owner ~= pname then
				minetest.record_protection_violation(pos, pname)
				minetest.chat_send_player(pname, "You do not own this trapdoor.")
				return nil
			end

			local secret = meta:get_string("key_lock_secret")
			if secret == "" then
				secret = newsecret
				meta:set_string("key_lock_secret", secret)
			end

			return secret, "a locked trapdoor", owner
		end
	else
		def.on_blast = function(pos, intensity)
			minetest.remove_node(pos)
			return {name}
		end
	end


	local def_opened = table.copy(def)
	local def_closed = table.copy(def)

	def_closed.node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.0625, 0.5, 0.5, 0.0625}, --Base
			{-0.5, 0.5, -0.0625, 0.5, 0.625, 0.0625}, -- Bottom_x
			{-0.5, 1.375, -0.0625, 0.5, 1.5, 0.0625}, -- Top_x
			{0.375, 0.625, -0.0625, 0.5, 1.375, 0.0625}, -- Right_y
			{-0.5, 0.625, -0.0625, -0.375, 1.375, 0.0625}, -- Left_y
			{-0.375, 0.9375, -0.0625, 0.375, 1.0625, 0.0625}, -- Center_x
			{-0.0625, 0.625, -0.0625, 0.0625, 1.375, 0.0625}, -- Center_y
		}
	}
	def_closed.selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.0625, 0.5, 1.5, 0.0625}, --Base
		}
--[[
			{-0.5, 0.5, -0.0625, 0.5, 0.625, 0.0625}, -- Bottom_x
			{-0.5, 1.375, -0.0625, 0.5, 1.5, 0.0625}, -- Top_x
			{0.375, 0.875, -0.0625, 0.5, 1.375, 0.0625}, -- Right_y
			{-0.5, 0.875, -0.0625, -0.375, 1.375, 0.0625}, -- Left_y
			{-0.375, 0.9375, -0.0625, 0.375, 1.0625, 0.0625}, -- Center_x
			{-0.0625, 0.875, -0.0625, 0.0625, 1.375, 0.0625}, -- Center_y
		}
]]
	}

	def_opened.node_box = {
		type = "fixed",
		fixed = {
			{0.375, -0.5, 0, 0.5, 0.5, 1.0}, --Base
			{0.375, 0.5, 0, 0.5, 0.625, 1.0}, -- Bottom_x
			{0.375, 1.375, 0, 0.5, 1.5, 1.0}, -- Top_x
			{0.375, 0.625, 0, 0.5, 1.375, 0.125}, -- Right_y
			{0.375, 0.625, 0.875, 0.5, 1.375, 1.0}, -- Left_y
			{0.375, 0.9375, 0.0625, 0.5, 1.0625, 0.9375}, -- Center_x
			{0.375, 0.625, 0.4375, 0.5, 1.375, 0.5625}, -- Center_y
		}
	}
	def_opened.selection_box = {
		type = "fixed",
		fixed = {0.375, -0.5, 0, 0.5, 1.5, 1.0}
	}

	def_opened.drop = name_closed
	def_opened.groups.not_in_creative_inventory = 1

	minetest.register_node(name_opened, def_opened)
	minetest.register_node(name_closed, def_closed)

	lib_doors.registered_doors[name_opened] = true
	lib_doors.registered_doors[name_closed] = true

	-- crafting recipe
	minetest.register_craft({
		output = "lib_doors:" .. wall_name .. " 99",
		recipe = {
			{ '', '', '' },
			{ '', "lib_shapes:shape_door_centered_with_window_right", ''},
			{ '', wall_mat, ''},
		}
	})
end
lib_doors.register_door_centered_with_window = function(wall_name, wall_desc, wall_texture, wall_mat, wall_sounds)

	local name = ""

	if not wall_name:find(":") then
		name = "lib_doors:" .. wall_name
	end

	local name_closed = name
	local name_opened = name.."_open"
	local skel_key = false


	local def = {
		description = wall_desc,
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		sounds = wall_sounds,
		sound_open = "doors_door_open",
		sound_close = "doors_door_close",
		protected = false,
		groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, fence = 1, wall = 1, stone = 1, wood = 1, glass = 1, lib_doors = 1},
		tiles = {wall_texture},

		on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
			lib_doors.door_toggle(pos, node, clicker)
			return itemstack
		end,
	}
	if skel_key then
		def.can_dig = can_dig_door
		def.after_place_node = function(pos, placer, itemstack, pointed_thing)
			local pn = placer:get_player_name()
			local meta = minetest.get_meta(pos)
			meta:set_string("doors_owner", pn)
			meta:set_string("infotext", "Owned by "..pn)

			return minetest.setting_getbool("creative_mode")
		end

		def.on_blast = function() end
		def.on_key_use = function(pos, player)
			local door = lib_doors.get(pos)
			lib_doors:toggle(player)
		end
		def.on_skeleton_key_use = function(pos, player, newsecret)
			local meta = minetest.get_meta(pos)
			local owner = meta:get_string("doors_owner")
			local pname = player:get_player_name()

			-- verify placer is owner of lockable door
			if owner ~= pname then
				minetest.record_protection_violation(pos, pname)
				minetest.chat_send_player(pname, "You do not own this trapdoor.")
				return nil
			end

			local secret = meta:get_string("key_lock_secret")
			if secret == "" then
				secret = newsecret
				meta:set_string("key_lock_secret", secret)
			end

			return secret, "a locked trapdoor", owner
		end
	else
		def.on_blast = function(pos, intensity)
			minetest.remove_node(pos)
			return {name}
		end
	end


	local def_opened = table.copy(def)
	local def_closed = table.copy(def)

	def_closed.node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.0625, 0.5, 0.5, 0.0625}, --Base
			{-0.5, 0.5, -0.0625, 0.5, 0.625, 0.0625}, -- Bottom_x
			{-0.5, 1.375, -0.0625, 0.5, 1.5, 0.0625}, -- Top_x
			{0.375, 0.625, -0.0625, 0.5, 1.375, 0.0625}, -- Right_y
			{-0.5, 0.625, -0.0625, -0.375, 1.375, 0.0625}, -- Left_y
			{-0.375, 0.9375, -0.0625, 0.375, 1.0625, 0.0625}, -- Center_x
			{-0.0625, 0.625, -0.0625, 0.0625, 1.375, 0.0625}, -- Center_y
		}
	}
	def_closed.selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.0625, 0.5, 1.5, 0.0625}, --Base
		}
--[[
			{-0.5, 0.5, -0.0625, 0.5, 0.625, 0.0625}, -- Bottom_x
			{-0.5, 1.375, -0.0625, 0.5, 1.5, 0.0625}, -- Top_x
			{0.375, 0.625, -0.0625, 0.5, 1.375, 0.0625}, -- Right_y
			{-0.5, 0.625, -0.0625, -0.375, 1.375, 0.0625}, -- Left_y
			{-0.375, 0.9375, -0.0625, 0.375, 1.0625, 0.0625}, -- Center_x
			{-0.0625, 0.625, -0.0625, 0.0625, 1.375, 0.0625}, -- Center_y
		}
]]
	}

	def_opened.node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0, -0.375, 0.5, 1.0}, --Base
			{-0.5, 0.5, 0, -0.375, 0.625, 1.0}, -- Bottom_x
			{-0.5, 1.375, 0, -0.375, 1.5, 1.0}, -- Top_x
			{-0.5, 0.625, 0.875, -0.375, 1.375, 1.0}, -- Right_y
			{-0.5, 0.625, 0, -0.375, 1.375, 0.125}, -- Left_y
			{-0.5, 0.9375, 0.125, -0.375, 1.0625, 0.9375}, -- Center_x
			{-0.5, 0.625, 0.4375, -0.375, 1.375, 0.5625}, -- Center_y
		}
	}
	def_opened.selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0, -0.375, 1.5, 1.0}, --Base
		}
--[[
			{-0.5, 0.5, 0, -0.375, 0.625, 1.0}, -- Bottom_x
			{-0.5, 1.375, 0, -0.375, 1.5, 1.0}, -- Top_x
			{-0.5, 0.625, 0.875, -0.375, 1.375, 1.0}, -- Right_y
			{-0.5, 0.625, 0, -0.375, 1.375, 0.125}, -- Left_y
			{-0.5, 0.9375, 0.125, -0.375, 1.0625, 0.9375}, -- Center_x
			{-0.5, 0.625, 0.4375, -0.375, 1.375, 0.5625}, -- Center_y
		}
]]
	}

	def_opened.drop = name_closed
	def_opened.groups.not_in_creative_inventory = 1

	minetest.register_node(name_opened, def_opened)
	minetest.register_node(name_closed, def_closed)

	lib_doors.registered_doors[name_opened] = true
	lib_doors.registered_doors[name_closed] = true

	-- crafting recipe
	minetest.register_craft({
		output = "lib_doors:" .. wall_name .. " 99",
		recipe = {
			{ '', '', '' },
			{ '', "lib_shapes:shape_door_centered_with_window", ''},
			{ '', wall_mat, ''},
		}
	})
end

lib_doors.register_door_centered_sliding_right = function(wall_name, wall_desc, wall_texture, wall_mat, wall_sounds)

	local name = ""

	if not wall_name:find(":") then
		name = "lib_doors:" .. wall_name
	end

	local name_closed = name
	local name_opened = name.."_open"
	local skel_key = false


	local def = {
		description = wall_desc,
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		sounds = wall_sounds,
		sound_open = "doors_door_open",
		sound_close = "doors_door_close",
		protected = false,
		groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, fence = 1, wall = 1, stone = 1, wood = 1, glass = 1, lib_doors = 1},
		tiles = {wall_texture},

		on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
			lib_doors.door_toggle(pos, node, clicker)
			return itemstack
		end,
	}
	if skel_key then
		def.can_dig = can_dig_door
		def.after_place_node = function(pos, placer, itemstack, pointed_thing)
			local pn = placer:get_player_name()
			local meta = minetest.get_meta(pos)
			meta:set_string("doors_owner", pn)
			meta:set_string("infotext", "Owned by "..pn)

			return minetest.setting_getbool("creative_mode")
		end

		def.on_blast = function() end
		def.on_key_use = function(pos, player)
			local door = lib_doors.get(pos)
			lib_doors:toggle(player)
		end
		def.on_skeleton_key_use = function(pos, player, newsecret)
			local meta = minetest.get_meta(pos)
			local owner = meta:get_string("doors_owner")
			local pname = player:get_player_name()

			-- verify placer is owner of lockable door
			if owner ~= pname then
				minetest.record_protection_violation(pos, pname)
				minetest.chat_send_player(pname, "You do not own this trapdoor.")
				return nil
			end

			local secret = meta:get_string("key_lock_secret")
			if secret == "" then
				secret = newsecret
				meta:set_string("key_lock_secret", secret)
			end

			return secret, "a locked trapdoor", owner
		end
	else
		def.on_blast = function(pos, intensity)
			minetest.remove_node(pos)
			return {name}
		end
	end


	local def_opened = table.copy(def)
	local def_closed = table.copy(def)

	def_closed.node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.0625, 0.5, 1.5, 0.0625}
	}
	def_closed.selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.0625, 0.5, 1.5, 0.0625}
	}

	def_opened.node_box = {
		type = "fixed",
		fixed = {0.375, -0.5, -0.0625, 0.5, 1.5, 0.0625}
	}
	def_opened.selection_box = {
		type = "fixed",
		fixed = {0.375, -0.5, -0.0625, 0.5, 1.5, 0.0625}
	}

	def_opened.drop = name_closed
	def_opened.groups.not_in_creative_inventory = 1

	minetest.register_node(name_opened, def_opened)
	minetest.register_node(name_closed, def_closed)

	lib_doors.registered_doors[name_opened] = true
	lib_doors.registered_doors[name_closed] = true

	-- crafting recipe
	minetest.register_craft({
		output = "lib_doors:" .. wall_name .. " 99",
		recipe = {
			{ '', '', '' },
			{ '', "lib_shapes:shape_door_centered_sliding_right", ''},
			{ '', wall_mat, ''},
		}
	})
end
lib_doors.register_door_centered_sliding = function(wall_name, wall_desc, wall_texture, wall_mat, wall_sounds)

	local name = ""

	if not wall_name:find(":") then
		name = "lib_doors:" .. wall_name
	end

	local name_closed = name
	local name_opened = name.."_open"
	local skel_key = false


	local def = {
		description = wall_desc,
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		sounds = wall_sounds,
		sound_open = "doors_door_open",
		sound_close = "doors_door_close",
		protected = false,
		groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, fence = 1, wall = 1, stone = 1, wood = 1, glass = 1, lib_doors = 1},
		tiles = {wall_texture},

		on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
			lib_doors.door_toggle(pos, node, clicker)
			return itemstack
		end,
	}
	if skel_key then
		def.can_dig = can_dig_door
		def.after_place_node = function(pos, placer, itemstack, pointed_thing)
			local pn = placer:get_player_name()
			local meta = minetest.get_meta(pos)
			meta:set_string("doors_owner", pn)
			meta:set_string("infotext", "Owned by "..pn)

			return minetest.setting_getbool("creative_mode")
		end

		def.on_blast = function() end
		def.on_key_use = function(pos, player)
			local door = lib_doors.get(pos)
			lib_doors:toggle(player)
		end
		def.on_skeleton_key_use = function(pos, player, newsecret)
			local meta = minetest.get_meta(pos)
			local owner = meta:get_string("doors_owner")
			local pname = player:get_player_name()

			-- verify placer is owner of lockable door
			if owner ~= pname then
				minetest.record_protection_violation(pos, pname)
				minetest.chat_send_player(pname, "You do not own this trapdoor.")
				return nil
			end

			local secret = meta:get_string("key_lock_secret")
			if secret == "" then
				secret = newsecret
				meta:set_string("key_lock_secret", secret)
			end

			return secret, "a locked trapdoor", owner
		end
	else
		def.on_blast = function(pos, intensity)
			minetest.remove_node(pos)
			return {name}
		end
	end


	local def_opened = table.copy(def)
	local def_closed = table.copy(def)

	def_closed.node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.0625, 0.5, 1.5, 0.0625}
	}
	def_closed.selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.0625, 0.5, 1.5, 0.0625}
	}

	def_opened.node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.0625, -0.375, 1.5, 0.0625}
	}
	def_opened.selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.0625, -0.375, 1.5, 0.0625}
	}

	def_opened.drop = name_closed
	def_opened.groups.not_in_creative_inventory = 1

	minetest.register_node(name_opened, def_opened)
	minetest.register_node(name_closed, def_closed)

	lib_doors.registered_doors[name_opened] = true
	lib_doors.registered_doors[name_closed] = true

	-- crafting recipe
	minetest.register_craft({
		output = "lib_doors:" .. wall_name .. " 99",
		recipe = {
			{ '', '', '' },
			{ '', "lib_shapes:shape_door_centered_sliding", ''},
			{ '', wall_mat, ''},
		}
	})
end

lib_doors.register_door_centered_400_height_250_width_right = function(wall_name, wall_desc, wall_texture, wall_mat, wall_sounds)

	local name = ""

	if not wall_name:find(":") then
		name = "lib_doors:" .. wall_name
	end

	local name_closed = name
	local name_opened = name.."_open"
	local skel_key = false


	local def = {
		description = wall_desc,
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		sounds = wall_sounds,
		sound_open = "doors_door_open",
		sound_close = "doors_door_close",
		protected = false,
		groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, fence = 1, wall = 1, stone = 1, wood = 1, glass = 1, lib_doors = 1},
		tiles = {wall_texture},

		on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
			lib_doors.door_toggle(pos, node, clicker)
			return itemstack
		end,
	}
	if skel_key then
		def.can_dig = can_dig_door
		def.after_place_node = function(pos, placer, itemstack, pointed_thing)
			local pn = placer:get_player_name()
			local meta = minetest.get_meta(pos)
			meta:set_string("doors_owner", pn)
			meta:set_string("infotext", "Owned by "..pn)

			return minetest.setting_getbool("creative_mode")
		end

		def.on_blast = function() end
		def.on_key_use = function(pos, player)
			local door = lib_doors.get(pos)
			lib_doors:toggle(player)
		end
		def.on_skeleton_key_use = function(pos, player, newsecret)
			local meta = minetest.get_meta(pos)
			local owner = meta:get_string("doors_owner")
			local pname = player:get_player_name()

			-- verify placer is owner of lockable door
			if owner ~= pname then
				minetest.record_protection_violation(pos, pname)
				minetest.chat_send_player(pname, "You do not own this trapdoor.")
				return nil
			end

			local secret = meta:get_string("key_lock_secret")
			if secret == "" then
				secret = newsecret
				meta:set_string("key_lock_secret", secret)
			end

			return secret, "a locked trapdoor", owner
		end
	else
		def.on_blast = function(pos, intensity)
			minetest.remove_node(pos)
			return {name}
		end
	end


	local def_opened = table.copy(def)
	local def_closed = table.copy(def)

	def_closed.node_box = {
		type = "fixed",
		fixed = {-2.0, -0.5, -0.0625, 0.5, 3.5, 0.0625}
	}
	def_closed.selection_box = {
		type = "fixed",
		fixed = {-2.0, -0.5, -0.0625, 0.5, 3.5, 0.0625}
	}

	def_opened.node_box = {
		type = "fixed",
		fixed = {0.375, -0.5, 0, 0.5, 3.5, 2.5}
	}
	def_opened.selection_box = {
		type = "fixed",
		fixed = {0.375, -0.5, 0, 0.5, 3.5, 2.5}
	}

	def_opened.drop = name_closed
	def_opened.groups.not_in_creative_inventory = 1

	minetest.register_node(name_opened, def_opened)
	minetest.register_node(name_closed, def_closed)

	lib_doors.registered_doors[name_opened] = true
	lib_doors.registered_doors[name_closed] = true

	-- crafting recipe
	minetest.register_craft({
		output = "lib_doors:" .. wall_name .. " 99",
		recipe = {
			{ '', '', '' },
			{ '', "lib_shapes:shape_door_centered_400_height_250_width_right", ''},
			{ '', wall_mat, ''},
		}
	})
end
lib_doors.register_door_centered_400_height_250_width = function(wall_name, wall_desc, wall_texture, wall_mat, wall_sounds)

	local name = ""

	if not wall_name:find(":") then
		name = "lib_doors:" .. wall_name
	end

	local name_closed = name
	local name_opened = name.."_open"
	local skel_key = false


	local def = {
		description = wall_desc,
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		sounds = wall_sounds,
		sound_open = "doors_door_open",
		sound_close = "doors_door_close",
		protected = false,
		groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, fence = 1, wall = 1, stone = 1, wood = 1, glass = 1, lib_doors = 1},
		tiles = {wall_texture},

		on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
			lib_doors.door_toggle(pos, node, clicker)
			return itemstack
		end,
	}
	if skel_key then
		def.can_dig = can_dig_door
		def.after_place_node = function(pos, placer, itemstack, pointed_thing)
			local pn = placer:get_player_name()
			local meta = minetest.get_meta(pos)
			meta:set_string("doors_owner", pn)
			meta:set_string("infotext", "Owned by "..pn)

			return minetest.setting_getbool("creative_mode")
		end

		def.on_blast = function() end
		def.on_key_use = function(pos, player)
			local door = lib_doors.get(pos)
			lib_doors:toggle(player)
		end
		def.on_skeleton_key_use = function(pos, player, newsecret)
			local meta = minetest.get_meta(pos)
			local owner = meta:get_string("doors_owner")
			local pname = player:get_player_name()

			-- verify placer is owner of lockable door
			if owner ~= pname then
				minetest.record_protection_violation(pos, pname)
				minetest.chat_send_player(pname, "You do not own this trapdoor.")
				return nil
			end

			local secret = meta:get_string("key_lock_secret")
			if secret == "" then
				secret = newsecret
				meta:set_string("key_lock_secret", secret)
			end

			return secret, "a locked trapdoor", owner
		end
	else
		def.on_blast = function(pos, intensity)
			minetest.remove_node(pos)
			return {name}
		end
	end


	local def_opened = table.copy(def)
	local def_closed = table.copy(def)

	def_closed.node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.0625, 2.0, 3.5, 0.0625}
	}
	def_closed.selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.0625, 2.0, 3.5, 0.0625}
	}

	def_opened.node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, 0, -0.375, 3.5, 2.5}
	}
	def_opened.selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, 0, -0.375, 3.5, 2.5}
	}

	def_opened.drop = name_closed
	def_opened.groups.not_in_creative_inventory = 1

	minetest.register_node(name_opened, def_opened)
	minetest.register_node(name_closed, def_closed)

	lib_doors.registered_doors[name_opened] = true
	lib_doors.registered_doors[name_closed] = true

	-- crafting recipe
	minetest.register_craft({
		output = "lib_doors:" .. wall_name .. " 99",
		recipe = {
			{ '', '', '' },
			{ '', "lib_shapes:shape_door_centered_400_height_250_width", ''},
			{ '', wall_mat, ''},
		}
	})
end

lib_doors.register_door_centered_400_height_200_width_right = function(wall_name, wall_desc, wall_texture, wall_mat, wall_sounds)

	local name = ""

	if not wall_name:find(":") then
		name = "lib_doors:" .. wall_name
	end

	local name_closed = name
	local name_opened = name.."_open"
	local skel_key = false


	local def = {
		description = wall_desc,
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		sounds = wall_sounds,
		sound_open = "doors_door_open",
		sound_close = "doors_door_close",
		protected = false,
		groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, fence = 1, wall = 1, stone = 1, wood = 1, glass = 1, lib_doors = 1},
		tiles = {wall_texture},

		on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
			lib_doors.door_toggle(pos, node, clicker)
			return itemstack
		end,
	}
	if skel_key then
		def.can_dig = can_dig_door
		def.after_place_node = function(pos, placer, itemstack, pointed_thing)
			local pn = placer:get_player_name()
			local meta = minetest.get_meta(pos)
			meta:set_string("doors_owner", pn)
			meta:set_string("infotext", "Owned by "..pn)

			return minetest.setting_getbool("creative_mode")
		end

		def.on_blast = function() end
		def.on_key_use = function(pos, player)
			local door = lib_doors.get(pos)
			lib_doors:toggle(player)
		end
		def.on_skeleton_key_use = function(pos, player, newsecret)
			local meta = minetest.get_meta(pos)
			local owner = meta:get_string("doors_owner")
			local pname = player:get_player_name()

			-- verify placer is owner of lockable door
			if owner ~= pname then
				minetest.record_protection_violation(pos, pname)
				minetest.chat_send_player(pname, "You do not own this trapdoor.")
				return nil
			end

			local secret = meta:get_string("key_lock_secret")
			if secret == "" then
				secret = newsecret
				meta:set_string("key_lock_secret", secret)
			end

			return secret, "a locked trapdoor", owner
		end
	else
		def.on_blast = function(pos, intensity)
			minetest.remove_node(pos)
			return {name}
		end
	end


	local def_opened = table.copy(def)
	local def_closed = table.copy(def)

	def_closed.node_box = {
		type = "fixed",
		fixed = {-1.5, -0.5, -0.0625, 0.5, 3.5, 0.0625}
	}
	def_closed.selection_box = {
		type = "fixed",
		fixed = {-1.5, -0.5, -0.0625, 0.5, 3.5, 0.0625}
	}

	def_opened.node_box = {
		type = "fixed",
		fixed = {0.375, -0.5, 0, 0.5, 3.5, 2.0}
	}
	def_opened.selection_box = {
		type = "fixed",
		fixed = {0.375, -0.5, 0, 0.5, 3.5, 2.0}
	}

	def_opened.drop = name_closed
	def_opened.groups.not_in_creative_inventory = 1

	minetest.register_node(name_opened, def_opened)
	minetest.register_node(name_closed, def_closed)

	lib_doors.registered_doors[name_opened] = true
	lib_doors.registered_doors[name_closed] = true

	-- crafting recipe
	minetest.register_craft({
		output = "lib_doors:" .. wall_name .. " 99",
		recipe = {
			{ '', '', '' },
			{ '', "lib_shapes:shape_door_centered_400_height_200_width_right", ''},
			{ '', wall_mat, ''},
		}
	})
end
lib_doors.register_door_centered_400_height_200_width = function(wall_name, wall_desc, wall_texture, wall_mat, wall_sounds)

	local name = ""

	if not wall_name:find(":") then
		name = "lib_doors:" .. wall_name
	end

	local name_closed = name
	local name_opened = name.."_open"
	local skel_key = false


	local def = {
		description = wall_desc,
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		sounds = wall_sounds,
		sound_open = "doors_door_open",
		sound_close = "doors_door_close",
		protected = false,
		groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, fence = 1, wall = 1, stone = 1, wood = 1, glass = 1, lib_doors = 1},
		tiles = {wall_texture},

		on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
			lib_doors.door_toggle(pos, node, clicker)
			return itemstack
		end,
	}
	if skel_key then
		def.can_dig = can_dig_door
		def.after_place_node = function(pos, placer, itemstack, pointed_thing)
			local pn = placer:get_player_name()
			local meta = minetest.get_meta(pos)
			meta:set_string("doors_owner", pn)
			meta:set_string("infotext", "Owned by "..pn)

			return minetest.setting_getbool("creative_mode")
		end

		def.on_blast = function() end
		def.on_key_use = function(pos, player)
			local door = lib_doors.get(pos)
			lib_doors:toggle(player)
		end
		def.on_skeleton_key_use = function(pos, player, newsecret)
			local meta = minetest.get_meta(pos)
			local owner = meta:get_string("doors_owner")
			local pname = player:get_player_name()

			-- verify placer is owner of lockable door
			if owner ~= pname then
				minetest.record_protection_violation(pos, pname)
				minetest.chat_send_player(pname, "You do not own this trapdoor.")
				return nil
			end

			local secret = meta:get_string("key_lock_secret")
			if secret == "" then
				secret = newsecret
				meta:set_string("key_lock_secret", secret)
			end

			return secret, "a locked trapdoor", owner
		end
	else
		def.on_blast = function(pos, intensity)
			minetest.remove_node(pos)
			return {name}
		end
	end


	local def_opened = table.copy(def)
	local def_closed = table.copy(def)

	def_closed.node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.0625, 1.5, 3.5, 0.0625}
	}
	def_closed.selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.0625, 1.5, 3.5, 0.0625}
	}

	def_opened.node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, 0, -0.375, 3.5, 2.0}
	}
	def_opened.selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, 0, -0.375, 3.5, 2.0}
	}

	def_opened.drop = name_closed
	def_opened.groups.not_in_creative_inventory = 1

	minetest.register_node(name_opened, def_opened)
	minetest.register_node(name_closed, def_closed)

	lib_doors.registered_doors[name_opened] = true
	lib_doors.registered_doors[name_closed] = true

	-- crafting recipe
	minetest.register_craft({
		output = "lib_doors:" .. wall_name .. " 99",
		recipe = {
			{ '', '', '' },
			{ '', "lib_shapes:shape_door_centered_400_height_200_width", ''},
			{ '', wall_mat, ''},
		}
	})
end

lib_doors.register_door_centered_300_height_150_width_right = function(wall_name, wall_desc, wall_texture, wall_mat, wall_sounds)

	local name = ""

	if not wall_name:find(":") then
		name = "lib_doors:" .. wall_name
	end

	local name_closed = name
	local name_opened = name.."_open"
	local skel_key = false


	local def = {
		description = wall_desc,
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		sounds = wall_sounds,
		sound_open = "doors_door_open",
		sound_close = "doors_door_close",
		protected = false,
		groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, fence = 1, wall = 1, stone = 1, wood = 1, glass = 1, lib_doors = 1},
		tiles = {wall_texture},

		on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
			lib_doors.door_toggle(pos, node, clicker)
			return itemstack
		end,
	}
	if skel_key then
		def.can_dig = can_dig_door
		def.after_place_node = function(pos, placer, itemstack, pointed_thing)
			local pn = placer:get_player_name()
			local meta = minetest.get_meta(pos)
			meta:set_string("doors_owner", pn)
			meta:set_string("infotext", "Owned by "..pn)

			return minetest.setting_getbool("creative_mode")
		end

		def.on_blast = function() end
		def.on_key_use = function(pos, player)
			local door = lib_doors.get(pos)
			lib_doors:toggle(player)
		end
		def.on_skeleton_key_use = function(pos, player, newsecret)
			local meta = minetest.get_meta(pos)
			local owner = meta:get_string("doors_owner")
			local pname = player:get_player_name()

			-- verify placer is owner of lockable door
			if owner ~= pname then
				minetest.record_protection_violation(pos, pname)
				minetest.chat_send_player(pname, "You do not own this trapdoor.")
				return nil
			end

			local secret = meta:get_string("key_lock_secret")
			if secret == "" then
				secret = newsecret
				meta:set_string("key_lock_secret", secret)
			end

			return secret, "a locked trapdoor", owner
		end
	else
		def.on_blast = function(pos, intensity)
			minetest.remove_node(pos)
			return {name}
		end
	end


	local def_opened = table.copy(def)
	local def_closed = table.copy(def)

	def_closed.node_box = {
		type = "fixed",
		fixed = {-1.0, -0.5, -0.0625, 0.5, 2.5, 0.0625}
	}
	def_closed.selection_box = {
		type = "fixed",
		fixed = {-1.0, -0.5, -0.0625, 0.5, 2.5, 0.0625}
	}

	def_opened.node_box = {
		type = "fixed",
		fixed = {0.375, -0.5, 0, 0.5, 2.5, 1.5}
	}
	def_opened.selection_box = {
		type = "fixed",
		fixed = {0.375, -0.5, 0, 0.5, 2.5, 1.5}
	}

	def_opened.drop = name_closed
	def_opened.groups.not_in_creative_inventory = 1

	minetest.register_node(name_opened, def_opened)
	minetest.register_node(name_closed, def_closed)

	lib_doors.registered_doors[name_opened] = true
	lib_doors.registered_doors[name_closed] = true

	-- crafting recipe
	minetest.register_craft({
		output = "lib_doors:" .. wall_name .. " 99",
		recipe = {
			{ '', '', '' },
			{ '', "lib_shapes:shape_door_centered_300_height_150_width_right", ''},
			{ '', wall_mat, ''},
		}
	})
end
lib_doors.register_door_centered_300_height_150_width = function(wall_name, wall_desc, wall_texture, wall_mat, wall_sounds)

	local name = ""

	if not wall_name:find(":") then
		name = "lib_doors:" .. wall_name
	end

	local name_closed = name
	local name_opened = name.."_open"
	local skel_key = false


	local def = {
		description = wall_desc,
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		sounds = wall_sounds,
		sound_open = "doors_door_open",
		sound_close = "doors_door_close",
		protected = false,
		groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, fence = 1, wall = 1, stone = 1, wood = 1, glass = 1, lib_doors = 1},
		tiles = {wall_texture},

		on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
			lib_doors.door_toggle(pos, node, clicker)
			return itemstack
		end,
	}
	if skel_key then
		def.can_dig = can_dig_door
		def.after_place_node = function(pos, placer, itemstack, pointed_thing)
			local pn = placer:get_player_name()
			local meta = minetest.get_meta(pos)
			meta:set_string("doors_owner", pn)
			meta:set_string("infotext", "Owned by "..pn)

			return minetest.setting_getbool("creative_mode")
		end

		def.on_blast = function() end
		def.on_key_use = function(pos, player)
			local door = lib_doors.get(pos)
			lib_doors:toggle(player)
		end
		def.on_skeleton_key_use = function(pos, player, newsecret)
			local meta = minetest.get_meta(pos)
			local owner = meta:get_string("doors_owner")
			local pname = player:get_player_name()

			-- verify placer is owner of lockable door
			if owner ~= pname then
				minetest.record_protection_violation(pos, pname)
				minetest.chat_send_player(pname, "You do not own this trapdoor.")
				return nil
			end

			local secret = meta:get_string("key_lock_secret")
			if secret == "" then
				secret = newsecret
				meta:set_string("key_lock_secret", secret)
			end

			return secret, "a locked trapdoor", owner
		end
	else
		def.on_blast = function(pos, intensity)
			minetest.remove_node(pos)
			return {name}
		end
	end


	local def_opened = table.copy(def)
	local def_closed = table.copy(def)

	def_closed.node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.0625, 1.0, 2.5, 0.0625}
	}
	def_closed.selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.0625, 1.0, 2.5, 0.0625}
	}

	def_opened.node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, 0, -0.375, 2.5, 1.5}
	}
	def_opened.selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, 0, -0.375, 2.5, 1.5}
	}

	def_opened.drop = name_closed
	def_opened.groups.not_in_creative_inventory = 1

	minetest.register_node(name_opened, def_opened)
	minetest.register_node(name_closed, def_closed)

	lib_doors.registered_doors[name_opened] = true
	lib_doors.registered_doors[name_closed] = true

	-- crafting recipe
	minetest.register_craft({
		output = "lib_doors:" .. wall_name .. " 99",
		recipe = {
			{ '', '', '' },
			{ '', "lib_shapes:shape_door_centered_300_height_150_width", ''},
			{ '', wall_mat, ''},
		}
	})
end



lib_doors.register_fencegate_centered_solid_right = function(wall_name, wall_desc, wall_texture, wall_mat, wall_sounds)

	local name = ""

	if not wall_name:find(":") then
		name = "lib_doors:" .. wall_name
	end

	local name_closed = name
	local name_opened = name.."_open"
	local skel_key = false


	local def = {
		-- Common door configuration
		description = wall_desc,
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		sounds = wall_sounds,
		sound_open = "doors_door_open",
		sound_close = "doors_door_close",
		protected = false,
		groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, fence = 1, wall = 1, stone = 1, wood = 1, glass = 1, lib_doors = 1},
		--groups = minetest.registered_nodes[wall_mat].groups,
		tiles = {wall_texture},

		on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
			lib_doors.door_toggle(pos, node, clicker)
			return itemstack
		end,

	}
	if skel_key then
		def.can_dig = can_dig_door
		def.after_place_node = function(pos, placer, itemstack, pointed_thing)
			local pn = placer:get_player_name()
			local meta = minetest.get_meta(pos)
			meta:set_string("doors_owner", pn)
			meta:set_string("infotext", "Owned by "..pn)

			return minetest.setting_getbool("creative_mode")
		end

		def.on_blast = function() end
		def.on_key_use = function(pos, player)
			local door = lib_doors.get(pos)
			lib_doors:toggle(player)
		end
		def.on_skeleton_key_use = function(pos, player, newsecret)
			local meta = minetest.get_meta(pos)
			local owner = meta:get_string("doors_owner")
			local pname = player:get_player_name()

			-- verify placer is owner of lockable door
			if owner ~= pname then
				minetest.record_protection_violation(pos, pname)
				minetest.chat_send_player(pname, "You do not own this trapdoor.")
				return nil
			end

			local secret = meta:get_string("key_lock_secret")
			if secret == "" then
				secret = newsecret
				meta:set_string("key_lock_secret", secret)
			end

			return secret, "a locked trapdoor", owner
		end
	else
		def.on_blast = function(pos, intensity)
			minetest.remove_node(pos)
			return {name}
		end
	end


	local def_opened = table.copy(def)
	local def_closed = table.copy(def)

	def_closed.node_box = {
		type = "fixed",
		fixed = {
			{0.375, -0.5, -0.125, 0.5, 0.5, 0.125}, -- Post_y
			{-0.5, -0.375, -0.0625, 0.375, 0.4375, 0.0625},
		}
	}
	def_closed.selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.125, 0.5, 0.5, 0.125}, -- Post_y
		}
	}

	def_opened.node_box = {
		type = "fixed",
		fixed = {
			{0.375, -0.5, -0.125, 0.5, 0.5, 0.125}, -- Post_y
			{0.3125, -0.5, 0, 0.4375, 0.5, 0.875},
		}
	}
	def_opened.selection_box = {
		type = "fixed",
		fixed = {0.3125, -0.5, -0.125, 0.5, 0.5, 0.875}
	}

	def_opened.drop = name_closed
	def_opened.groups.not_in_creative_inventory = 1

	minetest.register_node(name_opened, def_opened)
	minetest.register_node(name_closed, def_closed)

	lib_doors.registered_doors[name_opened] = true
	lib_doors.registered_doors[name_closed] = true

	-- crafting recipe
	minetest.register_craft({
		output = "lib_doors:" .. wall_name .. " 99",
		recipe = {
			{ '', '', '' },
			{ '', "lib_shapes:shape_fencegate_centered_solid_right", ''},
			{ '', wall_mat, ''},
		}
	})
end
lib_doors.register_fencegate_centered_solid = function(wall_name, wall_desc, wall_texture, wall_mat, wall_sounds)

	local name = ""

	if not wall_name:find(":") then
		name = "lib_doors:" .. wall_name
	end

	local name_closed = name
	local name_opened = name.."_open"
	local skel_key = false


	local def = {
		-- Common door configuration
		description = wall_desc,
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		sounds = wall_sounds,
		sound_open = "doors_door_open",
		sound_close = "doors_door_close",
		protected = false,
		groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, fence = 1, wall = 1, stone = 1, wood = 1, glass = 1, lib_doors = 1},
		--groups = minetest.registered_nodes[wall_mat].groups,
		tiles = {wall_texture},

		on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
			lib_doors.door_toggle(pos, node, clicker)
			return itemstack
		end,

	}
	if skel_key then
		def.can_dig = can_dig_door
		def.after_place_node = function(pos, placer, itemstack, pointed_thing)
			local pn = placer:get_player_name()
			local meta = minetest.get_meta(pos)
			meta:set_string("doors_owner", pn)
			meta:set_string("infotext", "Owned by "..pn)

			return minetest.setting_getbool("creative_mode")
		end

		def.on_blast = function() end
		def.on_key_use = function(pos, player)
			local door = lib_doors.get(pos)
			lib_doors:toggle(player)
		end
		def.on_skeleton_key_use = function(pos, player, newsecret)
			local meta = minetest.get_meta(pos)
			local owner = meta:get_string("doors_owner")
			local pname = player:get_player_name()

			-- verify placer is owner of lockable door
			if owner ~= pname then
				minetest.record_protection_violation(pos, pname)
				minetest.chat_send_player(pname, "You do not own this trapdoor.")
				return nil
			end

			local secret = meta:get_string("key_lock_secret")
			if secret == "" then
				secret = newsecret
				meta:set_string("key_lock_secret", secret)
			end

			return secret, "a locked trapdoor", owner
		end
	else
		def.on_blast = function(pos, intensity)
			minetest.remove_node(pos)
			return {name}
		end
	end


	local def_opened = table.copy(def)
	local def_closed = table.copy(def)

	def_closed.node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.125, -0.375, 0.5, 0.125}, -- Post_y
			{-0.375, -0.375, -0.0625, 0.5, 0.4375, 0.0625},
		}
	}
	def_closed.selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.125, 0.5, 0.5, 0.125}, -- Post_y
		}
	}

	def_opened.node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.125, -0.375, 0.5, 0.125}, -- Post_y
			{-0.4375, -0.375, 0, -0.3125, 0.4375, 0.875},
		}
	}
	def_opened.selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.125, -0.3125, 0.5, 0.875}, -- Post_y
		}
	}

	def_opened.drop = name_closed
	def_opened.groups.not_in_creative_inventory = 1

	minetest.register_node(name_opened, def_opened)
	minetest.register_node(name_closed, def_closed)

	lib_doors.registered_doors[name_opened] = true
	lib_doors.registered_doors[name_closed] = true

	-- crafting recipe
	minetest.register_craft({
		output = "lib_doors:" .. wall_name .. " 99",
		recipe = {
			{ '', '', '' },
			{ '', "lib_shapes:shape_fencegate_centered_solid", ''},
			{ '', wall_mat, ''},
		}
	})
end

lib_doors.register_fencegate_centered_right = function(wall_name, wall_desc, wall_texture, wall_mat, wall_sounds)

	local name = ""

	if not wall_name:find(":") then
		name = "lib_doors:" .. wall_name
	end

	local name_closed = name
	local name_opened = name.."_open"
	local skel_key = false


	local def = {
		-- Common door configuration
		description = wall_desc,
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		sounds = wall_sounds,
		sound_open = "doors_door_open",
		sound_close = "doors_door_close",
		protected = false,
		groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, fence = 1, wall = 1, stone = 1, wood = 1, glass = 1, lib_doors = 1},
		--groups = minetest.registered_nodes[wall_mat].groups,
		tiles = {wall_texture},

		on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
			lib_doors.door_toggle(pos, node, clicker)
			return itemstack
		end,

	}
	if skel_key then
		def.can_dig = can_dig_door
		def.after_place_node = function(pos, placer, itemstack, pointed_thing)
			local pn = placer:get_player_name()
			local meta = minetest.get_meta(pos)
			meta:set_string("doors_owner", pn)
			meta:set_string("infotext", "Owned by "..pn)

			return minetest.setting_getbool("creative_mode")
		end

		def.on_blast = function() end
		def.on_key_use = function(pos, player)
			local door = lib_doors.get(pos)
			lib_doors:toggle(player)
		end
		def.on_skeleton_key_use = function(pos, player, newsecret)
			local meta = minetest.get_meta(pos)
			local owner = meta:get_string("doors_owner")
			local pname = player:get_player_name()

			-- verify placer is owner of lockable door
			if owner ~= pname then
				minetest.record_protection_violation(pos, pname)
				minetest.chat_send_player(pname, "You do not own this trapdoor.")
				return nil
			end

			local secret = meta:get_string("key_lock_secret")
			if secret == "" then
				secret = newsecret
				meta:set_string("key_lock_secret", secret)
			end

			return secret, "a locked trapdoor", owner
		end
	else
		def.on_blast = function(pos, intensity)
			minetest.remove_node(pos)
			return {name}
		end
	end


	local def_opened = table.copy(def)
	local def_closed = table.copy(def)

	def_closed.node_box = {
		type = "fixed",
		fixed = {
			{0.375, -0.5, -0.125, 0.5, 0.5, 0.125}, -- Post_y
			{-0.375, 0.375, -0.0625, 0.4375, 0.5, 0.0625}, -- TopRail_x
			{-0.375, -0.375, -0.0625, 0.4375, -0.25, 0.0625}, -- BottomRail_x
			{-0.5, -0.375, -0.0625, -0.375, 0.5, 0.0625}, -- OuterSupport_y
			{-0.375, 0, -0.0625, 0.25, 0.125, 0.0625}, -- InnerRail_x
			{0.25, -0.25, -0.0625, 0.375, 0.375, 0.0625}, -- HingeSupport_y
		}
	}
	def_closed.selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.125, 0.5, 0.5, 0.125}, -- Post_y
		}
--[[
			{-0.375, 0.375, -0.0625, 0.4375, 0.5, 0.0625}, -- TopRail_x
			{-0.375, -0.375, -0.0625, 0.4375, -0.25, 0.0625}, -- BottomRail_x
			{-0.5, -0.375, -0.0625, -0.375, 0.5, 0.0625}, -- OuterSupport_y
			{-0.375, 0, -0.0625, 0.25, 0.125, 0.0625}, -- InnerRail_x
			{0.25, -0.25, -0.0625, 0.375, 0.375, 0.0625}, -- HingeSupport_y
		}
]]
	}

	def_opened.node_box = {
		type = "fixed",
		fixed = {
			{0.375, -0.5, -0.125, 0.5, 0.5, 0.125}, -- Post_y
			{0.3125, 0.375, 0, 0.4375, 0.5, 0.875}, -- TopRail_x
			{0.3125, -0.375, 0, 0.4375, -0.25, 0.875}, -- BottomRail_x
			{0.3125, -0.375, 0.875, 0.4375, 0.5, 1.0}, -- OuterSupport_y
			{0.3125, 0, 0.0625, 0.4375, 0.125, 0.875}, -- InnerRail_x
			{0.3125, -0.25, 0, 0.4375, 0.375, 0.125}, -- HingeSupport_y
		}
	}
	def_opened.selection_box = {
		type = "fixed",
		fixed = {
			{0.3125, -0.5, -0.125, 0.5, 0.5, 1.0}, -- Post_y
		}
--[[
			{0.3125, 0.375, 0, 0.4375, 0.5, 0.875}, -- TopRail_x
			{0.3125, -0.375, 0, 0.4375, -0.25, 0.875}, -- BottomRail_x
			{0.3125, -0.375, 0.875, 0.4375, 0.5, 1.0}, -- OuterSupport_y
			{0.3125, 0, 0.0625, 0.4375, 0.125, 0.875}, -- InnerRail_x
			{0.3125, -0.25, 0, 0.4375, 0.375, 0.125}, -- HingeSupport_y
		}
]]
	}

	def_opened.drop = name_closed
	def_opened.groups.not_in_creative_inventory = 1

	minetest.register_node(name_opened, def_opened)
	minetest.register_node(name_closed, def_closed)

	lib_doors.registered_doors[name_opened] = true
	lib_doors.registered_doors[name_closed] = true

	-- crafting recipe
	minetest.register_craft({
		output = "lib_doors:" .. wall_name .. " 99",
		recipe = {
			{ '', '', '' },
			{ '', "lib_shapes:shape_fencegate_centered_right", ''},
			{ '', wall_mat, ''},
		}
	})
end
lib_doors.register_fencegate_centered = function(wall_name, wall_desc, wall_texture, wall_mat, wall_sounds)

	local name = ""

	if not wall_name:find(":") then
		name = "lib_doors:" .. wall_name
	end

	local name_closed = name
	local name_opened = name.."_open"
	local skel_key = false


	local def = {
		-- Common door configuration
		description = wall_desc,
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		sounds = wall_sounds,
		sound_open = "doors_door_open",
		sound_close = "doors_door_close",
		protected = false,
		groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, fence = 1, wall = 1, stone = 1, wood = 1, glass = 1, lib_doors = 1},
		--groups = minetest.registered_nodes[wall_mat].groups,
		tiles = {wall_texture},

		on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
			lib_doors.door_toggle(pos, node, clicker)
			return itemstack
		end,

	}
	if skel_key then
		def.can_dig = can_dig_door
		def.after_place_node = function(pos, placer, itemstack, pointed_thing)
			local pn = placer:get_player_name()
			local meta = minetest.get_meta(pos)
			meta:set_string("doors_owner", pn)
			meta:set_string("infotext", "Owned by "..pn)

			return minetest.setting_getbool("creative_mode")
		end

		def.on_blast = function() end
		def.on_key_use = function(pos, player)
			local door = lib_doors.get(pos)
			lib_doors:toggle(player)
		end
		def.on_skeleton_key_use = function(pos, player, newsecret)
			local meta = minetest.get_meta(pos)
			local owner = meta:get_string("doors_owner")
			local pname = player:get_player_name()

			-- verify placer is owner of lockable door
			if owner ~= pname then
				minetest.record_protection_violation(pos, pname)
				minetest.chat_send_player(pname, "You do not own this trapdoor.")
				return nil
			end

			local secret = meta:get_string("key_lock_secret")
			if secret == "" then
				secret = newsecret
				meta:set_string("key_lock_secret", secret)
			end

			return secret, "a locked trapdoor", owner
		end
	else
		def.on_blast = function(pos, intensity)
			minetest.remove_node(pos)
			return {name}
		end
	end


	local def_opened = table.copy(def)
	local def_closed = table.copy(def)

	def_closed.node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.125, -0.375, 0.5, 0.125}, -- Post_y
			{-0.4375, 0.375, -0.0625, 0.375, 0.5, 0.0625}, -- TopRail_x
			{-0.4375, -0.375, -0.0625, 0.375, -0.25, 0.0625}, -- BottomRail_x
			{0.375, -0.375, -0.0625, 0.5, 0.5, 0.0625}, -- OuterSupport_y
			{-0.25, 0, -0.0625, 0.375, 0.125, 0.0625}, -- InnerRail_x
			{-0.375, -0.25, -0.0625, -0.25, 0.375, 0.0625}, -- HingeSupport_y
		},
	}
	def_closed.selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.125, 0.5, 0.5, 0.125},
--[[

			{-0.5, -0.5, -0.125, -0.375, 0.5, 0.125}, -- Post_y
			{-0.4375, 0.375, -0.0625, 0.375, 0.5, 0.0625}, -- TopRail_x
			{-0.4375, -0.375, -0.0625, 0.375, -0.25, 0.0625}, -- BottomRail_x
			{0.375, -0.375, -0.0625, 0.5, 0.5, 0.0625}, -- OuterSupport_y
			{-0.25, 0, -0.0625, 0.375, 0.125, 0.0625}, -- InnerRail_x
			{-0.375, -0.25, -0.0625, -0.25, 0.375, 0.0625}, -- HingeSupport_y
]]
		},
	}

	def_opened.node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.125, -0.375, 0.5, 0.125}, -- Post_y
			{-0.4375, 0.375, 0, -0.3125, 0.5, 0.875}, -- TopRail_x
			{-0.4375, -0.375, 0, -0.3125, -0.25, 0.875}, -- BottomRail_x
			{-0.4375, -0.375, 0.875, -0.3125, 0.5, 1.0}, -- OuterSupport_y
			{-0.4375, 0, 0.125, -0.3125, 0.125, 0.875}, -- InnerRail_x
			{-0.4375, -0.25, 0, -0.3125, 0.375, 0.125}, -- HingeSupport_y
		},
	}
	def_opened.selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.125, -0.3125, 0.5, 1.0},
--[[
			{-0.5, -0.5, -0.125, -0.375, 0.5, 0.125}, -- Post_y
			{-0.4375, 0.375, 0, -0.3125, 0.5, 0.875}, -- TopRail_x
			{-0.4375, -0.375, 0, -0.3125, -0.25, 0.875}, -- BottomRail_x
			{-0.4375, -0.375, 0.875, -0.3125, 0.5, 1.0}, -- OuterSupport_y
			{-0.4375, 0, 0.125, -0.3125, 0.125, 0.875}, -- InnerRail_x
			{-0.4375, -0.25, 0, -0.3125, 0.375, 0.125}, -- HingeSupport_y
]]
		},
	}

	def_opened.drop = name_closed
	def_opened.groups.not_in_creative_inventory = 1

	minetest.register_node(name_opened, def_opened)
	minetest.register_node(name_closed, def_closed)

	lib_doors.registered_doors[name_opened] = true
	lib_doors.registered_doors[name_closed] = true

	-- crafting recipe
	minetest.register_craft({
		output = "lib_doors:" .. wall_name .. " 99",
		recipe = {
			{ '', '', '' },
			{ '', "lib_shapes:shape_fencegate_centered", ''},
			{ '', wall_mat, ''},
		}
	})
end






--[[
lib_doors.register_nodes("cobble", "Cobblestone ", "default_cobble.png",
		"default:cobble", default.node_sound_stone_defaults())
lib_doors.register_nodes("mossycobble", "Mossy Cobblestone ", "default_mossycobble.png",
		"default:mossycobble", default.node_sound_stone_defaults())
lib_doors.register_nodes("desertcobble", "Desert Cobblestone ", "default_desert_cobble.png",
		"default:desert_cobble", default.node_sound_stone_defaults())
--]]

lib_doors.register_nodes("sandstone", "Sandstone ", "default_sandstone.png",
		"default:sandstone", default.node_sound_stone_defaults())
lib_doors.register_nodes("desert_stone", "Desert Stone ", "default_desert_stone.png",
		"default:desert_stone", default.node_sound_stone_defaults())
lib_doors.register_nodes("stone", "Stone ", "default_stone.png",
		"default:stone", default.node_sound_stone_defaults())
lib_doors.register_nodes("obsidian", "Obsidian ", "default_obsidian.png",
		"default:obsidian", default.node_sound_stone_defaults())

--[[
lib_doors.register_nodes("sandstone_block", "Sandstone Block ", "default_sandstone_block.png",
		"default:sandstone_block", default.node_sound_stone_defaults())
lib_doors.register_nodes("desert_stone_block", "Desert Stone Block ", "default_desert_stone_block.png",
		"default:desert_stone_block", default.node_sound_stone_defaults())
lib_doors.register_nodes("stone_block", "Stone Block ", "default_stone_block.png",
		"default:stone_block", default.node_sound_stone_defaults())
lib_doors.register_nodes("obsidian_block", "Obsidian Block ", "default_obsidian_block.png",
		"default:obsidian_block", default.node_sound_stone_defaults())
--]]
--[[
lib_doors.register_nodes("sandstone_brick", "Sandstone Brick ", "default_sandstone_brick.png",
		"default:sandstonebrick", default.node_sound_stone_defaults())
lib_doors.register_nodes("desertstone_brick", "Desert Stone Brick ", "default_desert_stone_brick.png",
		"default:desert_stonebrick", default.node_sound_stone_defaults())
lib_doors.register_nodes("stone_brick", "Stone Brick ", "default_stone_brick.png",
		"default:stonebrick", default.node_sound_stone_defaults())
lib_doors.register_nodes("obsidian_brick", "Obsidian Brick ", "default_obsidian_brick.png",
		"default:obsidianbrick", default.node_sound_stone_defaults())
--]]

--[[
lib_doors.register_nodes("glass", "Glass ", "default_glass.png",
		"default:glass", default.node_sound_stone_defaults())
--]]

lib_doors.register_nodes("tree", "Tree ", "default_tree.png",
		"default:tree", default.node_sound_wood_defaults())
lib_doors.register_nodes("wood", "Wood ", "default_wood.png",
		"default:wood", default.node_sound_wood_defaults())
lib_doors.register_nodes("jungletree", "Jungle Tree ", "default_jungletree.png",
		"default:jungletree", default.node_sound_wood_defaults())
lib_doors.register_nodes("junglewood", "Jungle Wood ", "default_junglewood.png",
		"default:junglewood", default.node_sound_wood_defaults())

lib_doors.register_nodes("acacia_tree", "Acacia Tree ", "default_acacia_tree.png",
		"default:acacia_tree", default.node_sound_wood_defaults())
lib_doors.register_nodes("acacia_wood", "Acacia Wood ", "default_acacia_wood.png",
		"default:acacia_wood", default.node_sound_wood_defaults())

lib_doors.register_nodes("aspen_tree", "Aspen Tree ", "default_aspen_tree.png",
		"default:aspen_tree", default.node_sound_wood_defaults())
lib_doors.register_nodes("aspen_wood", "Aspen Wood ", "default_aspen_wood.png",
		"default:aspen_wood", default.node_sound_wood_defaults())


lib_doors.register_nodes("steelblock", "Steel ", "default_steel_block.png",
		"default:steelblock", default.node_sound_metal_defaults())
lib_doors.register_nodes("copperblock", "Copper ", "default_copper_block.png",
		"default:copperblock", default.node_sound_metal_defaults())
lib_doors.register_nodes("tinblock", "Tin ", "default_tin_block.png",
		"default:tinblock", default.node_sound_metal_defaults())
lib_doors.register_nodes("bronzeblock", "Bronze ", "default_bronze_block.png",
		"default:bronzeblock", default.node_sound_metal_defaults())
lib_doors.register_nodes("goldblock", "Gold ", "default_gold_block.png",
		"default:goldblock", default.node_sound_metal_defaults())
lib_doors.register_nodes("diamondblock", "Diamond ", "default_diamond_block.png",
		"default:diamondblock", default.node_sound_glass_defaults())

lib_doors.register_nodes("glass", "Glass ", "default_glass.png",
		"default:glass", default.node_sound_glass_defaults())















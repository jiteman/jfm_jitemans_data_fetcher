--[[
function convertArray(arr)
    local itemArray = '['

    for _,item in pairs(arr) do
        if item ~= nil then
            itemArray = itemArray..'"'..item.name..'",'
        end
    end

    return itemArray..'null]'
end
]]--

local new_line = "\n"

function get_formatter( quantity )
	local formatter = ""

	for counter = 1, quantity do
		formatter = formatter .. "\t"
	end

	return formatter
end

function fetch_boolean( a_boolean )
    if a_boolean == true then
        return "true"
    elseif a_boolean == false then
        return "false"
    else
		return "not a boolean"
    end
end

function fetch_color( color, name, formatter )
	local red = 0.0
	local green = 0.0
	local blue = 0.0
	local alpha = 1.0

	if ( color.r ) then
		red = color.r
	end

	if ( color.g ) then
		green = color.g
	end

	if ( color.b ) then
		blue = color.b
	end

	if ( color.a ) then
		alpha = color.a
	end

	local color_json = get_formatter( formatter ) .. '"' .. name '"' .. ": " .. " {" .. new_line
	color_json = color_json .. get_formatter( formatter + 2 ) .. '"red"' .. ": " .. red .. "," .. new_line
	color_json = color_json .. get_formatter( formatter + 2 ) .. '"green"' .. ": " .. green .. "," .. new_line
	color_json = color_json .. get_formatter( formatter + 2 ) .. '"blue"' .. ": " .. blue .. "," .. new_line
	color_json = color_json .. get_formatter( formatter + 2 ) .. '"alpha"' .. ": " .. alpha .. "," .. new_line
	color_json = get_formatter( formatter + 1 ) .. "}"
	return color_json
end

function fetch_group_and_subgroup( element )
	local element_json = ""

	if ( element.group ) then
		element_json = element_json .. get_formatter( 2 ) .. '"group"' .. ": " .. "{" .. new_line
		element_json = element_json .. get_formatter( 3 ) .. '"type"' .. ": " .. '"' .. element.group.type .. '"' .. "," .. new_line
		element_json = element_json .. get_formatter( 3 ) .. '"name"' .. ": " .. '"' .. element.group.name .. '"' .. new_line
		element_json = element_json .. get_formatter( 2 ) .. "}" .. "," .. new_line

	end

	if ( element.subgroup ) then
		element_json = element_json .. get_formatter( 2 ) .. '"subgroup"' .. ": " .. "{" .. new_line
		element_json = element_json .. get_formatter( 3 ) .. '"type"' .. ": " .. '"' .. element.subgroup.type .. '"' .. "," .. new_line
		element_json = element_json .. get_formatter( 3 ) .. '"name"' .. ": " .. '"' .. element.subgroup.name .. '"' .. new_line
		element_json = element_json .. get_formatter( 2 ) .. "}" .. "," .. new_line
	end

	return element_json
end

function Fetch_entity( entity, entity_counter )
	local entity_json = new_line .. get_formatter( 1 ) .. "{" .. new_line
--	entity_json = entity_json .. get_formatter( 2 ) .. '"x"' .. ': "' .. entity.x .. '",' .. new_line
	entity_json = entity_json .. get_formatter( 2 ) .. '"type"' .. ': "' .. entity.type .. '",' .. new_line
	entity_json = entity_json .. get_formatter( 2 ) .. '"name"' .. ': "' .. entity.name .. '",' .. new_line

	if ( entity.items_to_place_this ) then
		entity_json = entity_json .. get_formatter( 2 ) .. '"items_to_place_this"' .. ": " .. "[" .. new_line

		local first_item_to_place = true

		for _, item in pairs( entity.items_to_place_this ) do
			if ( not first_item_to_place ) then
				entity_json = entity_json .. "," .. new_line
			else
				first_item_to_place = false
			end

			entity_json = entity_json .. get_formatter( 3 ) .. "{" .. new_line
			entity_json = entity_json .. get_formatter( 4 ) .. '"type"' .. ": " .. '"' .. item.type .. '"' .. "," .. new_line
			entity_json = entity_json .. get_formatter( 4 ) .. '"name"' .. ": " .. '"' .. item.name .. '"' .. new_line
			entity_json = entity_json .. get_formatter( 3 ) .. "}"

		end

		entity_json = entity_json .. new_line
		entity_json = entity_json .. get_formatter( 2 ) .. "]" .. "," .. new_line
	end

	entity_json = entity_json .. fetch_group_and_subgroup( entity )

	if ( entity.resource_category ) then
		entity_json = entity_json .. get_formatter( 2 ) .. '"resource_category"' .. ": " .. '"' .. entity.resource_category .. '"' .. "," .. new_line
	end

	if ( entity.mineable_properties ) then
		entity_json = entity_json .. get_formatter( 2 ) .. '"mineable_properties"' .. ": " .. "{" .. new_line
		entity_json = entity_json .. get_formatter( 3 ) .. '"is_minable"' .. ": " .. fetch_boolean( entity.mineable_properties.minable ) ..  "," .. new_line
		entity_json = entity_json .. get_formatter( 3 ) .. '"hardness"' .. ": " .. entity.mineable_properties.hardness .. "," .. new_line
		entity_json = entity_json .. get_formatter( 3 ) .. '"mining_time"' .. ": " .. entity.mineable_properties.mining_time .. "," .. new_line

		if ( entity.mineable_properties.products ) then
			entity_json = entity_json .. get_formatter( 3 ) .. '"products"' .. ": " .. "[" .. new_line

			local first_product_to_place = true

			for _, product in pairs( entity.mineable_properties.products ) do
				if ( not first_product_to_place ) then
					entity_json = entity_json .. "," .. new_line
				else
					first_product_to_place = false
				end

				entity_json = entity_json .. get_formatter( 4 ) .. "{" .. new_line

				entity_json = entity_json .. get_formatter( 5 ) .. '"type"' .. ": " .. '"' .. product.type .. '"' .. "," .. new_line
				entity_json = entity_json .. get_formatter( 5 ) .. '"name"' .. ": " .. '"' .. product.name .. '"'

				if ( product.amount ) then
					entity_json = entity_json .. "," .. new_line .. get_formatter( 5 ) .. '"amount"' .. ": " .. product.amount
				end

				if ( product.temperature ) then
					entity_json = entity_json .. "," .. new_line .. get_formatter( 5 ) .. '"temperature"' .. ": " .. product.temperature
				end

				if ( product.probability ) then
					entity_json = entity_json .. "," .. new_line .. get_formatter( 5 ) .. '"probability"' .. ": " .. product.probability
				end

				if ( product.amount_min ) then
					entity_json = entity_json .. "," .. new_line .. get_formatter( 5 ) .. '"amount_min"' .. ": " .. product.amount_min
				end

				if ( product.amount_max ) then
					entity_json = entity_json .. "," .. new_line .. get_formatter( 5 ) .. '"amount_max"' .. ": " .. product.amount_max
				end

				entity_json = entity_json .. new_line .. get_formatter( 4 ) .. "}" .. new_line
			end

			entity_json = entity_json .. new_line .. get_formatter( 3 ) .. "]" .. "," .. new_line
		end

		if ( entity.mineable_properties.required_fluid ) then
			entity_json = entity_json .. get_formatter( 3 ) .. '"required_fluid"' .. ": " .. '"' .. entity.mineable_properties.required_fluid .. '"' .. new_line
		end

		if ( entity.mineable_properties.fluid_amount ) then
			entity_json = entity_json .. "," .. new_line .. get_formatter( 3 ) .. '"fluid_amount"' .. ": " .. entity.mineable_properties.fluid_amount .. new_line
		end

		entity_json = entity_json .. get_formatter( 2 ) .. "}" .. new_line
	end

	-- mining drills
	if ( entity.mining_speed ) then
		entity_json = entity_json .. get_formatter( 2 ) .. '"mining_speed"' .. ": " .. entity.mining_speed .. "," .. new_line
	end

	if ( entity.mining_power ) then
		entity_json = entity_json .. get_formatter( 2 ) .. '"mining_power"' .. ": " .. entity.mining_power .. "," .. new_line
	end

	if ( entity.resource_categories ) then
		entity_json = entity_json .. get_formatter( 2 ) .. '"resource_categories"' .. ": " .. "{" .. new_line

		for category, is_category in pairs( entity.resource_categories ) do
			entity_json = entity_json .. get_formatter( 2 ) .. '"' .. category ..'"' .. ": " .. fetch_boolean( is_category ) .. "," .. new_line
		end

		entity_json = entity_json .. get_formatter( 2 ) .. "}" .. new_line
	end

	-- speed (belts and pumps)
	if ( entity.belt_speed ) then
		entity_json = entity_json .. get_formatter( 2 ) .. '"belt_speed"' .. ": " .. entity.belt_speed .. "," .. new_line
	end

	-- crafting machines
	if ( entity.ingredient_count ) then
		entity_json = entity_json .. get_formatter( 2 ) .. '"ingredient_count"' .. ": " .. entity.ingredient_count .. "," .. new_line
	end

	if ( entity.crafting_speed ) then
		entity_json = entity_json .. get_formatter( 2 ) .. '"crafting_speed"' .. ": " .. entity.crafting_speed .. "," .. new_line
	end

	if ( entity.crafting_categories ) then
		entity_json = entity_json .. get_formatter( 2 ) .. '"crafting_categories"' .. ": " .. "{" .. new_line

		for category, is_category in pairs( entity.crafting_categories ) do
			entity_json = entity_json .. get_formatter( 3 ) .. '"' .. category ..'"' .. ": " .. fetch_boolean( is_category ) .. "," .. new_line
		end

		entity_json = entity_json .. get_formatter( 2 ) .. "}" .. new_line
	end

	-- offshore pumps
	if ( entity.fluid ) then
		entity_json = entity_json .. get_formatter( 2 ) .. '"fluid"' .. ": " .. '"' .. entity.fluid.name .. '"' .. "," .. new_line
	end
	
	if ( entity.fluid_capacity ) then
		entity_json = entity_json .. get_formatter( 2 ) .. '"fluid_capacity"' .. ": " .. entity.fluid_capacity .. "," .. new_line
	end
	
	if ( entity.pumping_speed ) then
		entity_json = entity_json .. get_formatter( 2 ) .. '"pumping_speed"' .. ": " .. entity.pumping_speed .. "," .. new_line
	end

	if ( entity.fluid_usage_per_tick ) then
		entity_json = entity_json .. get_formatter( 2 ) .. '"fluid_usage_per_tick"' .. ": " .. entity.fluid_usage_per_tick .. "," .. new_line
	end
	
	if ( entity.maximum_temperature ) then
		entity_json = entity_json .. get_formatter( 2 ) .. '"maximum_temperature"' .. ": " .. entity.maximum_temperature .. "," .. new_line
	end
	
	if ( entity.target_temperature ) then
		entity_json = entity_json .. get_formatter( 2 ) .. '"target_temperature"' .. ": " .. entity.target_temperature .. "," .. new_line
	end
	
	-- energy
	if ( entity.production ) then
		entity_json = entity_json .. get_formatter( 2 ) .. '"energy_production"' .. ": " .. entity.production .. "," .. new_line
	end
	
	if ( entity.burner_prototype ) then
		entity_json = entity_json .. get_formatter( 2 ) .. '"burner_energy_source"' .. ": " .. "{" .. new_line

		entity_json = entity_json .. get_formatter( 4 ) .. '"effectivity"' .. ": " .. entity.burner_prototype.effectivity .. "," .. new_line
		
		entity_json = entity_json .. get_formatter( 4 ) .. '"fuel_categories"' .. ": " .. "{" .. new_line
		
		for fuel_category, is_category in pairs( entity.fuel_categories ) do
			entity_json = entity_json .. get_formatter( 6 ) .. '"' .. fuel_category ..'"' .. ": " .. fetch_boolean( is_category ) .. "," .. new_line
		end

		entity_json = entity_json .. get_formatter( 5 ) .. "}" .. "," .. new_line
		
		entity_json = entity_json .. get_formatter( 4 ) .. '"is_valid"' .. ": " .. fetch_boolean( entity.burner_prototype.valid ) .. "," .. new_line
		
		entity_json = entity_json .. get_formatter( 3 ) .. "}" .. "," .. new_line
	end
	
	if ( entity.electric_energy_source_prototype ) then
		entity_json = entity_json .. get_formatter( 2 ) .. '"electric_energy_source_prototype"' .. ": " .. "{" .. new_line

		entity_json = entity_json .. get_formatter( 4 ) .. '"buffer_capacity"' .. ": " .. entity.electric_energy_source_prototype.buffer_capacity .. "," .. new_line
		entity_json = entity_json .. get_formatter( 4 ) .. '"usage_priority"' .. ": " .. '"' .. entity.electric_energy_source_prototype.usage_priority .. '"' .. "," .. new_line
		entity_json = entity_json .. get_formatter( 4 ) .. '"input_flow_limit"' .. ": " .. entity.electric_energy_source_prototype.input_flow_limit .. "," .. new_line
		entity_json = entity_json .. get_formatter( 4 ) .. '"output_flow_limit"' .. ": " .. entity.electric_energy_source_prototype.output_flow_limit .. "," .. new_line
		entity_json = entity_json .. get_formatter( 4 ) .. '"drain"' .. ": " .. entity.electric_energy_source_prototype.drain .. "," .. new_line
		
		entity_json = entity_json .. get_formatter( 4 ) .. '"is_valid"' .. ": " .. fetch_boolean( entity.electric_energy_source_prototype.valid ) .. "," .. new_line		
		entity_json = entity_json .. get_formatter( 3 ) .. "}" .. "," .. new_line
	end
	
	if ( entity.color ) then
		entity_json = entity_json .. fetch_color( entity.color, "color", 2 ) .. "," .. new_line
	end

	entity_json = entity_json .. get_formatter( 2 ) .. '"is_valid"' .. ": " .. fetch_boolean( entity.valid ) .. "," .. new_line
	entity_json = entity_json .. get_formatter( 2 ) .. '"counter"' .. ": " .. entity_counter .. new_line
	entity_json = entity_json .. get_formatter( 1 ) .. "}"
	return entity_json
end

function Fetch_item( item, item_counter)
	local item_json = new_line .. get_formatter( 1 ) .. "{" .. new_line
	--	item_json = item_json .. get_formatter( 2 ) .. '"x"' .. ': "' .. item.x .. '"' .. "," .. new_line
	item_json = item_json .. get_formatter( 2 ) .. '"type"' .. ': "' .. item.type .. '"' .. "," .. new_line
	item_json = item_json .. get_formatter( 2 ) .. '"name"' .. ': "' .. item.name .. '"' .. "," .. new_line

	item_json = item_json .. fetch_group_and_subgroup( item )

	if ( item.place_result ) then
		item_json = item_json .. get_formatter( 2 ) .. '"place_result"' .. ": ".. "{" .. new_line
		item_json = item_json .. get_formatter( 3 ) .. '"name"' .. ': "' .. item.place_result.name .. '"' .. "," .. new_line
		item_json = item_json .. get_formatter( 3 ) .. '"type"' .. ': "' .. item.place_result.type .. new_line
		item_json = item_json .. get_formatter( 2 ) .. "}" .. "," new_line
	end

	if ( item.place_as_equipment_result ) then
		item_json = item_json .. get_formatter( 2 ) .. '"place_as_equipment_result"' .. ": ".. "{" .. new_line
		item_json = item_json .. get_formatter( 3 ) .. '"name"' .. ': "' .. item.place_as_equipment_result.name .. '"' .. "," .. new_line
		item_json = item_json .. get_formatter( 3 ) .. '"type"' .. ': "' .. item.place_as_equipment_result.type .. new_line
		item_json = item_json .. get_formatter( 2 ) .. "}" .. "," new_line
	end

	if ( item.fuel_category ) then
		item_json = item_json .. get_formatter( 2 ) .. '"fuel_category"' .. ': "' .. item.fuel_category .. '"' .. "," .. new_line
	end

	if ( item.burnt_result ) then
		item_json = item_json .. get_formatter( 2 ) .. '"burnt_result"' .. ": ".. "{" .. new_line
		item_json = item_json .. get_formatter( 3 ) .. '"name"' .. ': "' .. item.burnt_result.name .. '"' .. "," .. new_line
		item_json = item_json .. get_formatter( 3 ) .. '"type"' .. ': "' .. item.burnt_result.type .. '"' .. new_line
		item_json = item_json .. get_formatter( 2 ) .. "}" .. "," new_line
	end

	if ( item.speed ) then
		item_json = item_json .. get_formatter( 2 ) .. '"speed"' .. ': "' .. item.speed .. '",' .. new_line
	end

	if ( item.fuel_value ) then
		item_json = item_json .. get_formatter( 2 ) .. '"fuel_value"' .. ": " .. item.fuel_value .. "," .. new_line
	end

	if ( item.category ) then
		item_json = item_json .. get_formatter( 2 ) .. '"module_category"' .. ': "' .. item.category .. '",' .. new_line
	end

	if ( item.tier ) then
		item_json = item_json .. get_formatter( 2 ) .. '"module_tier"' .. ": " .. item.tier .. "," .. new_line
	end

	if ( item.module_effects ) then
		item_json = item_json .. get_formatter( 2 ) .. '"module_effects"' .. ": ".. "{" .. new_line

		local first_module_effect = true

		for effect, bonus in pairs( item.module_effects ) do
			if ( not first_module_effect ) then
				item_json = item_json .. "," .. new_line
			else
				first_module_effect = false
			end

			item_json = item_json .. get_formatter( 3 ) .. '"' .. effect .. '"' .. ": " .. bonus.bonus
		end

		item_json = item_json .. get_formatter( 2 ) .. "}" .. "," new_line
	end

	if ( item.limitations ) then
		item_json = item_json .. get_formatter( 2 ) .. '"limitations"' .. ": ".. "{" .. new_line

		local first_limitations = true

		for _, limitation in pairs( item.limitations ) do
			if ( not first_limitations ) then
				item_json = item_json .. "," .. new_line
			else
				first_limitations = false
			end

			item_json = item_json .. get_formatter( 3 ) .. '"recipe"' .. ": " .. '"' .. limitation .. '"'
		end

		item_json = item_json .. get_formatter( 2 ) .. "}" .. "," new_line
	end

	if ( item.straight_rail ) then
		item_json = item_json .. get_formatter( 2 ) .. '"straight_rail"' .. ": ".. "{" .. new_line
		item_json = item_json .. get_formatter( 3 ) .. '"name"' .. ': "' .. item.straight_rail.name .. '"' .. "," .. new_line
		item_json = item_json .. get_formatter( 3 ) .. '"type"' .. ': "' .. item.straight_rail.type .. '"' .. new_line
		item_json = item_json .. get_formatter( 2 ) .. "}" .. "," new_line
	end

	if ( item.curved_rail ) then
		item_json = item_json .. get_formatter( 2 ) .. '"curved_rail"' .. ": ".. "{" .. new_line
		item_json = item_json .. get_formatter( 3 ) .. '"name"' .. ': "' .. item.curved_rail.name .. '"' .. "," .. new_line
		item_json = item_json .. get_formatter( 3 ) .. '"type"' .. ': "' .. item.curved_rail.type .. '"' .. new_line
		item_json = item_json .. get_formatter( 2 ) .. "}" .. "," new_line
	end

	item_json = item_json .. get_formatter( 2 ) .. '"is_valid"' .. ": " .. fetch_boolean( item.valid ) .. "," .. new_line
	item_json = item_json .. get_formatter( 2 ) .. '"counter"' .. ": " .. item_counter .. new_line
	item_json = item_json .. get_formatter( 1 ) .. "}"
	return item_json
end

function Fetch_fluid( fluid, fluid_counter )
	local fluid_json = new_line .. get_formatter( 1 ) .. "{" .. new_line
	--	fluid_json = fluid_json .. get_formatter( 2 ) .. '"x"' .. ': "' .. fluid.x .. '"' .. "," .. new_line
	--	fluid_json = fluid_json .. get_formatter( 2 ) .. '"x"' .. ": " .. fluid.x .. "," .. new_line

	fluid_json = fluid_json .. get_formatter( 2 ) .. '"name"' .. ': "' .. fluid.name .. '"' .. "," .. new_line

	fluid_json = fluid_json .. get_formatter( 2 ) .. '"default_temperature"' .. ": " .. fluid.default_temperature .. "," .. new_line
	fluid_json = fluid_json .. get_formatter( 2 ) .. '"max_temperature"' .. ": " .. fluid.max_temperature .. "," .. new_line
	fluid_json = fluid_json .. get_formatter( 2 ) .. '"heat_capacity"' .. ": " .. fluid.heat_capacity .. "," .. new_line
	fluid_json = fluid_json .. get_formatter( 2 ) .. '"pressure_to_speed_ratio"' .. ": " .. fluid.pressure_to_speed_ratio .. "," .. new_line
	fluid_json = fluid_json .. get_formatter( 2 ) .. '"flow_to_energy_ratio"' .. ": " .. fluid.flow_to_energy_ratio .. "," .. new_line
	fluid_json = fluid_json .. get_formatter( 2 ) .. '"max_push_amount"' .. ": " .. fluid.max_push_amount .. "," .. new_line
	fluid_json = fluid_json .. get_formatter( 2 ) .. '"ratio_to_push"' .. ": " .. fluid.ratio_to_push .. "," .. new_line

	fluid_json = fluid_json .. fetch_group_and_subgroup( fluid )
	
	fluid_json = fluid_json .. fetch_color( fluid.base_color, "base_color", 2 ) .. "," .. new_line
	fluid_json = fluid_json .. fetch_color( fluid.flow_color, "flow_color", 2 ) .. "," .. new_line
	
	fluid_json = fluid_json .. get_formatter( 2 ) .. '"gas_temperature"' .. ": " .. fluid.gas_temperature .. "," .. new_line
	fluid_json = fluid_json .. get_formatter( 2 ) .. '"fuel_value"' .. ": " .. fluid.fuel_value .. "," .. new_line

	fluid_json = fluid_json .. get_formatter( 2 ) .. '"is_valid"' .. ": " .. fetch_boolean( fluid.valid ) .. "," .. new_line
	fluid_json = fluid_json .. get_formatter( 2 ) .. '"counter"' .. ": " .. fluid_counter .. new_line
	fluid_json = fluid_json .. get_formatter( 1 ) .. "}"
	return fluid_json
end

function Fetch_equipment( equipment, equipment_counter )
	local equipment_json = new_line .. get_formatter( 1 ) .. "{" .. new_line
	--	equipment_json = equipment_json .. get_formatter( 2 ) .. '"x"' .. ': "' .. equipment.x .. '"' .. "," .. new_line
	--	equipment_json = equipment_json .. get_formatter( 2 ) .. '"x"' .. ": " .. equipment.x .. "," .. new_line

	equipment_json = equipment_json .. get_formatter( 2 ) .. '"name"' .. ': "' .. equipment.name .. '"' .. "," .. new_line
	equipment_json = equipment_json .. get_formatter( 2 ) .. '"type"' .. ': "' .. equipment.type .. '"' .. "," .. new_line
	
	if ( equipment.energy_production

	equipment_json = equipment_json .. get_formatter( 2 ) .. '"is_valid"' .. ": " .. fetch_boolean( equipment.valid ) .. "," .. new_line
	equipment_json = equipment_json .. get_formatter( 2 ) .. '"counter"' .. ": " .. equipment_counter .. new_line
	equipment_json = equipment_json .. get_formatter( 1 ) .. "}"
	return equipment_json
end

function Fetch_recipe( recipe, recipe_counter )
	local recipe_json = new_line .. get_formatter( 1 ) .. "{" .. new_line
	--	recipe_json = recipe_json .. get_formatter( 2 ) .. '"x"' .. ': "' .. recipe.x .. '",' .. new_line
	--	recipe_json = recipe_json .. get_formatter( 2 ) .. '"x"' .. ": " .. recipe.x .. "," .. new_line

	recipe_json = recipe_json .. get_formatter( 2 ) .. '"name"' .. ': "' .. recipe.name .. '",' .. new_line

	recipe_json = recipe_json .. get_formatter( 2 ) .. '"is_valid"' .. ": " .. fetch_boolean( recipe.valid ) .. "," .. new_line
	recipe_json = recipe_json .. get_formatter( 2 ) .. '"counter"' .. ": " .. recipe_counter .. new_line
	recipe_json = recipe_json .. get_formatter( 1 ) .. "}"
	return recipe_json
end

function Fetch_technology( technology, technology_counter )
	local technology_json = new_line .. get_formatter( 1 ) .. "{" .. new_line
	--	technology_json = technology_json .. get_formatter( 2 ) .. '"x"' .. ': "' .. technology.x .. '",' .. new_line
	--	technology_json = technology_json .. get_formatter( 2 ) .. '"x"' .. ": " .. technology.x .. "," .. new_line

	technology_json = technology_json .. get_formatter( 2 ) .. '"name"' .. ': "' .. technology.name .. '",' .. new_line

	technology_json = technology_json .. get_formatter( 2 ) .. '"is_valid"' .. ": " .. fetch_boolean( technology.valid ) .. "," .. new_line
	technology_json = technology_json .. get_formatter( 2 ) .. '"counter"' .. ": " .. technology_counter .. new_line
	technology_json = technology_json .. get_formatter( 1 ) .. "}"
	return technology_json
end

function Fetch_database_name( database_name )
	local json_database = new_line
	json_database = json_database .. get_formatter( 1 ) .. "{" .. new_line
	json_database = json_database .. get_formatter( 2 ) .. '"type"' .. ": " .. '"factorio"' .. "," .. new_line
	json_database = json_database .. get_formatter( 2 ) .. '"name"' .. ": " .. '"' .. database_name .. '"' .. new_line
	json_database = json_database .. get_formatter( 1 ) .. "},"
	return json_database
end

function Fetch_elements( element_prototypes, element_name, element_fetcher )
	local element_counter = 0
	local element_json = "["

	element_json = element_json .. Fetch_database_name( element_name )

	first_element = true

	for _, element in pairs( element_prototypes ) do
		if ( not first_element ) then
			element_json = element_json .. ","
		else
			first_element = false
		end

		element_counter = element_counter + 1

		element_json = element_json .. element_fetcher( element, element_counter )
	end

	element_json = element_json .. new_line .. "]"
	return element_json
end

function Fetch_everything()
	game.write_file( "fetched_entities.json", Fetch_elements( game.entity_prototypes, "entities", Fetch_entity ) )
	game.write_file( "fetched_items.json", Fetch_elements( game.item_prototypes, "items", Fetch_item ) )
	game.write_file( "fetched_fluids.json", Fetch_elements( game.fluid_prototypes, "fluids", Fetch_fluid ) )
	game.write_file( "fetched_equipment.json", Fetch_elements( game.equipment_prototypes, "equipment", Fetch_equipment ) )
	game.write_file( "fetched_recipes.json", Fetch_elements( game.recipe_prototypes, "recipes", Fetch_recipe ) )
	game.write_file( "fetched_technologies.json", Fetch_elements( game.technology_prototypes, "technologies", Fetch_technology ) )
end

script.on_init( Fetch_everything )

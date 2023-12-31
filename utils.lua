local utils = {}

function utils.open_file(path)
	io.input(path)
	return io.read("*all")
end

function utils.open_file_lines(path)
	io.input(path)
	local file = io.read("*all")
	return utils.split_lines(file)
end

function utils.open_file_chars(path)
	io.input(path)
	local file = io.read("*all")
	return utils.split_chars(file)
end

function utils.split_lines(str)
	local lines = {}
	for s in str:gmatch("[^\r\n]+") do
		table.insert(lines, s)
	end
	return lines
end

function utils.split_chars(str)
	local lines = utils.split_lines(str)
	local characters = {}
	for i,line in ipairs(lines) do
		for s in str:gmatch(".") do
			table.insert(characters, s)
		end
	end
	return characters
end

function utils.matrix_dimensions(schematic)
	lines = utils.split_lines(schematic)
	return #lines[1], #lines
end

---@param o1 any|table First object to compare
---@param o2 any|table Second object to compare
---@param ignore_mt boolean True to ignore metatables (a recursive function to tests tables inside tables)
---@copyright igv, edited by rboy, from [StackOverflow](https://stackoverflow.com/questions/20325332/how-to-check-if-two-tablesobjects-have-the-same-value-in-lua)
function utils.equals(o1, o2, ignore_mt)
    if o1 == o2 then return true end
    local o1Type = type(o1)
    local o2Type = type(o2)
    if o1Type ~= o2Type then return false end
    if o1Type ~= 'table' then return false end

    if not ignore_mt then
        local mt1 = getmetatable(o1)
        if mt1 and mt1.__eq then
            --compare using built in method
            return o1 == o2
        end
    end

    local keySet = {}

    for key1, value1 in pairs(o1) do
        local value2 = o2[key1]
        if value2 == nil or utils.equals(value1, value2, ignore_mt) == false then
            return false
        end
        keySet[key1] = true
    end

    for key2, _ in pairs(o2) do
        if not keySet[key2] then return false end
    end
    return true
end

return utils

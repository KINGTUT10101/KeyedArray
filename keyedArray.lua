-- Keyed arrays allow you to index items by their keys and positions in an array
-- The array starts at 1, just like normal Lua arrays
-- Keys are used to differentiate each item inside the keyed array
-- Possible key types are "array" and "table"
local KeyedArray = {}

--- Creates a new KeyedArray object.
-- @return (table) A KeyedArray object
function KeyedArray:new ()
    -- Create a table to store the array elements
    local obj = {
        array = {}, -- Holds values that are indexed by position
        table = {}, -- Holds values that are indexed with a key
    }
    
    -- Copies the method references into the object
    for k, v in self do
        if type(v) == "function" and k ~= "new" then
            obj[k] = v
        end
    end
    
    return obj
end

--- Inserts a new item into the keyed array.
-- It will fail if an item already exists at the given key
-- @param key (table key) The key of the new item
-- @param value (any) The value of the new item
-- @param position (int) The position of the item in the array. Defaults to the current size of the array + 1 and will fix values outside the array bounds
-- @return (bool) True if the operation was successful, otherwise false
function KeyedArray:insert (key, value, position)
    position = position or #self.array + 1
    position = math.min (math.max (position, 1), #self.array + 1)
    
    if self.table[key] == nil then
        local container = {key = key, position = position, value = value} -- Values are placed in a container to avoid duplication
        
        self.table[key] = container
        table.insert (self.array, key, container)
        return true
    else
        return false
    end
end

--- Removes an item from the keyed array.
-- @raise When the provided keyType is invalid
-- @param key (table key) The key or position of the item
-- @param keyType (string) The type of key being used
function KeyedArray:delete (key, keyType)
    if keyType == "array" then
        if self.array[key] ~= nil then
            local container = self.array[key]
            table.remove (self.array, container.position)
            self.table[container.key] = nil
        end
    elseif keyType == "table" then
        if self.table[key] ~= nil then
            local container = self.array[key]
            table.remove (self.array, container.position)
            self.table[container.key] = nil
        end
    else
        error ("KeyedArray: undefined key type")
    end
end

--- Gets the value of an item from the keyed array.
-- @raise When the provided keyType is invalid
-- @param key (table key) The key or position of the item
-- @param keyType (string) The type of key being used
function KeyedArray:get (key, keyType)
    if keyType == "array" then
        if self.array[key] == nil then
            return nil
        else
            return self.array[key].value
        end
    elseif keyType == "table" then
        if self.table[key] == nil then
            return nil
        else
            return self.table[key].value
        end
    else
        error ("KeyedArray: undefined key type")
    end
end

--- Gets the current number of items inside the object.
-- @return (int) The number of items inside the object
function KeyedArray:size ()
    return #self.array
end

--- An iterator function for the keyed array object.
-- @return (function) An iterator function
function KeyedArray:pairs ()
   local index = 0
	
   return function ()
      index = index + 1
		
      if index <= #self.array then
         return self.array[index].value
      end
   end
end
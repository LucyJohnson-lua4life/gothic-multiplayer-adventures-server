OPERATING_SYSTEM = 1;-- 2 Linux, 1 Windows!
--QUIET = 0; --1 => no message for big_require
--Trim for names
--local find = string.find
--local sub = string.sub
function trim(s)
  local i1,i2 = string.find(s,'^%s*')
  if i2 >= i1 then s = string.sub(s,i2+1) end
  local i1,i2 = string.find(s,'%s*$')
  if i2 >= i1 then s = string.sub(s,1,i1-1) end
  return s
end

function string:split(delimiter)
  local result = { }
  local from = 1
  local delim_from, delim_to = string.find( self, delimiter, from )
  while delim_from do
    table.insert( result, string.sub( self, from , delim_from-1 ) )
    from = delim_to + 1
    delim_from, delim_to = string.find( self, delimiter, from )
  end
  table.insert( result, string.sub( self, from ) )
  return result
end



function string.ends(String,End)
   return End=='' or string.sub(String,-string.len(End))==End
end

function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

function string.contains(String, containstr)
	return string.find(string.lower(String), string.lower(containstr)) ~= nil;
end

function table.contains(Table, object)
	for var = 0, #Table, 1 do
		if(Table[var] == object)then
			return true;
		end
	end
	return false;
end


function table.copy(t)
  local t2 = {}
  for k,v in pairs(t) do
    t2[k] = v
  end
  return t2
end

function table.merge(t, t2)
	if(t == nil or t2== nil)then
		return;
	end
	for k,v in ipairs(t2) do
		table.insert(t, t2);
	end
end

function table.reverse ( tab )
    local size = #tab
    local newTable = {}
 
    for i,v in ipairs ( tab ) do
        newTable[size-i] = v
    end
 
    return newTable
end

function table.removeElement(tab, ele)
	for i,v in ipairs ( tab ) do
		if(ele == v)then
			tab[i] = nil;
			table.remove(tab, v);
			break;
		end
	end
end

function big_require(folder, file, recursive)
	local rec = false;
	if(recursive ~= nil and recursive == true)then
		rec = true;
	end
	local files = scandir(folder, rec);
	
	for var = 1, #files, 1 do
		if(string.ends(files[var], ".lua" ))then
			if(string.find(files[var], file) ~= nil)then
				if(QUIET == nil or QUIET == 0)then
					print("Loaded Lib: "..string.sub(files[var],0, -string.len(".lua")-1));
				end
				require(string.sub(files[var],0, -string.len(".lua")-1))
			end
		end
	end
end

function scandir(directory, recursive, dirStr, t)
	if(t == nil)then
		t = {};
	end
	
    local popen = io.popen;
	
	if(dirStr == nil)then
		dirStr = "";
	end
	
	if(OPERATING_SYSTEM == nil or OPERATING_SYSTEM == 1)then
		for filename in popen('dir "'..directory..'" /b /a-d'):lines() do
			if(recursive == true)then
				table.insert(t, directory..filename);
			else
				table.insert(t, directory.."/"..filename);
			end
		end
		if(recursive == true)then
			for dirname in popen('dir "'..directory..'" /b /ad'):lines() do
				scandir(directory.."/"..dirname.."/", true, dirStr..dirname.."/", t);
			end
		end
	elseif(OPERATING_SYSTEM == 2)then
		if(recursive == true)then
			os.execute('find "'..directory..'" -type f > temp_bigrequire.tempfile');
			local handle = io.open("temp_bigrequire.tempfile");

			for filename in handle:lines() do
				table.insert(t, filename);
			end
			handle:close();
			os.remove("temp_bigrequire.tempfile");
		else
			os.execute('find "'..directory..'" -maxdepth 1 -type f > temp_bigrequire.tempfile');
			local handle = io.open("temp_bigrequire.tempfile");
			for filename in handle:lines() do
				table.insert(t, filename);
			end
			handle:close();
			os.remove("temp_bigrequire.tempfile");
		end
	end
    return t
end

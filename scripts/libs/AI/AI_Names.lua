local AI_NAMES = {};

function GET_NEW_ID(name)
	if(AI_NAMES[name] == nil)then
		AI_NAMES[name] = 0;
		return 0;
	end
	AI_NAMES[name] = AI_NAMES[name]+1;
	return AI_NAMES[name];
end

function GetNewNPCName(name)	
	local id = GET_NEW_ID(name);
	
	if(id == 0)then
		return name;
	end
	return name.." ("..id..")";
end
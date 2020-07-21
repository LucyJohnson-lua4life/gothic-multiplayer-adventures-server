- Right now the codebase is relatively small and easy to reason about. However before adding any mayor features, I would prefer to add 
test cases for the core modules of this project. Since im heavily relying on the GMP-API I need some mocking framework to mock the GMP calls in my test cases
- Integration tests of the DAO's would be nice
- GMP Function calls that deal with G2 item names are relatively fragile. If for example the item name does not exist, the code stops further execution, therefore
results in very unexpected behaviour. A solution for that should be found. 
- the drop and respawn module currently just check if the npc name matches String X, but it would be better, to simple replace the id of the npc name
and than check for equality for string X   

use:
local function getNameWithoutId(name)
    print(string.gsub(name, "%s%((%d+)%)",""))
	return string.gsub(name, "%s%((%d+)%)","")
end
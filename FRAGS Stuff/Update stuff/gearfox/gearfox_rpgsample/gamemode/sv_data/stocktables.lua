local Meta = FindMetaTable("Player")

function Meta:SetStockTable(Str)
	if (!self.StockTable) then self.StockTable = {} end
	if (!self.StockTable[Str]) then self.StockTable[Str] = {} end
	
	return self.StockTable[Str] 
end

function Meta:GetStockTable(Str)
	if (!self.StockTable) then self.StockTable = {} end
	if (Str) then return self.StockTable[Str] end
	return self.StockTable
end





--SQL Translations which are usefull. I use it for saving tables in an SQL Server and the other way around.
--Propably only usefull if you have setup a MySQL using MySQLoo or TMysql and know how to use it.
function Meta:TranslateStockTableToSQL()
	if (!self.StockTable) then return "" end
	
	local Dat = ""
	
	for k,v in pairs(self.StockTable) do
		Dat = Dat..k.."ø"
		
		for a,b in pairs(v) do Dat = Dat..a.."æ"..b end
		
		Dat = Dat.."\n"
	end
	
	return Dat
end

function Meta:TranslateStockTableFromSQL(LongStr)
	if (!self.StockTable) then self.StockTable = {} end
	
	local Dat = string.Explode("\n",LongStr)
	local Tab = {}
	
	for k,v in pairs(Dat) do
	
		local Split  = string.Explode("ø",v)
		
		if (Split[2]) then
			local Values = string.Explode("æ",Split[2])
			
			Tab[Split[1]] = {}
			
			for a,b in pairs(Values) do table.insert(Tab[Split[1]],b) end
		end
	end
	
	self.StockTable = Tab
	return Tab
end
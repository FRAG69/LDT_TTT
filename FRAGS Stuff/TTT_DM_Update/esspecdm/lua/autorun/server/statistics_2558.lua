hook.Add('Initialize','CH_S_00c1c529d54c3d24fecf0a131c8c7fed', function()
	http.Post('http://coderhire.com/api/script-statistics/usage/1744/814/00c1c529d54c3d24fecf0a131c8c7fed', {
		port = GetConVarString('hostport'),
		hostname = GetHostName()
	})
end)
hook.Add('Initialize','CH_S_00c6e828b6de1c3afb78650c91ec1fd0', function()
	http.Post('http://coderhire.com/api/script-statistics/usage/1744/1068/00c6e828b6de1c3afb78650c91ec1fd0', {
		port = GetConVarString('hostport'),
		hostname = GetHostName()
	})
end)
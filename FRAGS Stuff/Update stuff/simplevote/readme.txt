--Simple Vote by JohnnyThunders(aka Loures)--

1. About

SimpleVote is a simple voting system I made for TTT, it features only what you need to vote, 
a simple menu with a list of the avaible maps. 
You only need to click on one of the names and you just wait for the other players to vote.

2. Instructions

Just extract the zip file to your server's addons folder and do a changelevel and it should load 

You might want to tweak some CVars for it, the CVars are:

simplevote_maxrounds   (def: 6)		--How many rounds you have to play before the voting starts
simplevote_maxvotetime (def: 60) 	--How much time the server waits before skipping to change the most voted map, even if not all the players have voted
simplevote_minplayers  (def: 3)		--How many players must be on the server to make the vote start

To add a prefix, just open the votesys.lua and look for "local prefix" (without the quotes) then in the parenteses, add the prefix for your map
EXAMPLE: local prefix = {"ttt_", "dm_", "zm_"} ttt_ is there by default

3. Changelog

08/09/2010 - 1.0.0 - Inital release
09/09/2010 - 1.0.5 - Added CVars, fixed some code stuff, added readme
09/09/2010 - 1.0.6 - Added multiple prefix check, fixed vote menu totally not appearing and vote not starting
14/09/2010 - 1.1.0 - Added logging, added real-time vote count for the menu, fixed alot of bugs and improved some workings of the votesystem
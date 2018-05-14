function Print( var )
	if( isFinalVar == false and IsLogging() == true ) then
		print( var )
	end
end

function LogStringLua( var )
	if( isFinalVar == false and IsLogging() == true  ) then
		Engine.LogString( var )
	end
end

function DetermineAvgRatingForTeam( teamId, numPlayers )
	teamId = Engine.StackRankTeamByOverall( teamId )	
	local totalOverall = 0
	for playerCount = 1, numPlayers do
		local currPlayer = Engine.GetPlayer( teamId, playerCount )
		totalOverall = totalOverall + Engine.GetPlayerOverall( currPlayer )
	end --for playerCount = 1, numPlayers do
	local average = totalOverall / numPlayers
	return average
end

function IsMeetingObjective( team )
	local objectiveStatus = Engine.GetTeamLeague_ActualVsExpectations_AsString( team )
	local isMeeting = ( objectiveStatus == "EXPECTATION_EXCEEDING" or objectiveStatus == "EXPECTATION_MEETING" )
	return isMeeting
end

function ModifyTeamMorale( teamId, change )
	local numPlayersOnTeam = Engine.GetNumPlayers( teamId )
	for playerCount = 1, numPlayersOnTeam do
		local currentPlayer = Engine.GetPlayer( teamId, playerCount )
		Engine.ModifyPlayerMorale( teamId, currentPlayer, change )
	end
end

function GetWinDrawLossPercentage( numWins, numDraws, numLosses )
	local numGames = numWins + numDraws + numLosses
	local winPerc = 0
	local drawPerc = 0
	local lossPerc = 0
	if( numGames > 0 ) then
		winPerc = ( numWins * 100 ) / numGames
		drawPerc = ( numDraws * 100 ) / numGames
		lossPerc = ( numLosses * 100 ) / numGames
	end
	return winPerc, drawPerc, lossPerc
end

function GetTeamNation( teamId )
	local leagueId = Engine.GetLeagueId( teamId )
	local leagueNationId = Engine.GetLeagueNationId( leagueId )
	return leagueNationId
end

function RollPercentageDice( chance, force )
	local returnVal = false
	if( force == true ) then
		returnVal = true
	else
		local randNo = Engine.GetRandomNumber( 1, 100 )
		if( randNo <= chance ) then
			returnVal = true
		end
	end --if( force == true ) then
	return returnVal
end

function MakeCPUOfferForPlayer( teamId, playerId, numOffers, startRandom )
	local inWindow = Engine.IsWithinTransferWindow()
	if( inWindow == true ) then
		local maxOffers = 5
		if( numOffers > maxOffers ) then
			numOffers = maxOffers
		end --if( numOffers > maxOffers ) then
		local offers = {}
		local offer1 = 0
		local offer2 = 0
		local offer3 = 0
		local offer4 = 0
		local offer5 = 0
		local actualOffers, offer1, offer2, offer3, offer4, offer5 = Engine.FindSuitableTeamsForPlayer( teamId, playerId, numOffers, false )
		offers[ 1 ] = offer1
		offers[ 2 ] = offer2
		offers[ 3 ] = offer3
		offers[ 4 ] = offer4
		offers[ 5 ] = offer5
		if( actualOffers < startRandom ) then
			startRandom = actualOffers
		end --if( actualOffers < startRandom ) then
		if( actualOffers < numOffers ) then
			numOffers = actualOffers
		end --if( actualOffers < numOffers ) then
		local teamChoice = Engine.GetRandomNumber( startRandom, numOffers )
		local isRival = Engine.AreTeamsRivals( teamId, offers[ teamChoice ] )
		if( isRival == false ) then
			Engine.CreateOfferForPlayer( teamId, playerId, offers[ teamChoice ] )
		end
	end --if( inWindow == true ) then
end

-- Player Upset With Club Functions
function GetReasonForPlayerUpset( teamId, playerId )
	local match = 0		
	if( IsUnderachieving( teamId, playerId ) == true ) then
		match = 1			
	elseif( IsTooBigForTeam( teamId, playerId ) == true ) then 
		match = 2
	elseif( IsUnhappyWithSalary( teamId, playerId ) == true ) then
		match = 3
	end 	
	return match
end

function IsUnderachieving( teamId, playerId )
	local underachieving = false
	local morale = Engine.GetPlayerMoraleLevel( teamId, playerId )
	if( morale == "VERY_LOW" or morale == "LOW" ) then
		underachieving = true
	end
	return underachieving
end

function IsTooBigForTeam( teamId, playerId )
	local tooBig = false
	teamId = Engine.StackRankTeamByOverall( teamId )
	local playerRank = Engine.GetPlayerIndexById( teamId, playerId )
	if( playerRank == 1 ) then -- top play
		local playerOverall = Engine.GetPlayerOverall( playerId )
		local secondBestPlayer = Engine.GetPlayer( teamId, 2 )
		local secondBestOverall = Engine.GetPlayerOverall( secondBestPlayer )
		local overallDiff = Tuning.MISC.ovrDiff_BestPlayer
		if( playerOverall >= secondBestOverall + overallDiff ) then
			tooBig = true
		end
	elseif( playerRank <= Tuning.MISC.topPlayerCount ) then -- top five player
		local potentialDiff = Tuning.MISC.potDiff_TopPlayers
		local playerOverall = Engine.GetPlayerOverall( playerId )
		local playerPotential = Engine.GetPlayerPotential( teamId, playerId )
		if( playerPotential >= playerOverall + potentialDiff ) then
			tooBig = true
		end
	end
	return tooBig
end

function IsUnhappyWithSalary( teamId, playerId )
	local unhappy = false
	teamId = Engine.StackRankTeamByOverall( teamId )
	local playerRank = Engine.GetPlayerIndexById( teamId, playerId )
	teamId = Engine.StackRankTeamByWage( teamId )
	local wageRank = Engine.GetPlayerIndexById( teamId, playerId )
	local rankDifference = Tuning.MISC.rankDifference
	local age = Engine.GetPlayerAge( teamId, playerId )
	if( age <= Tuning.MISC.maxAge ) then
		if( playerRank + rankDifference <= wageRank ) then
			unhappy = true
		end
	end
	return unhappy
end
-- Player Upset With Club Functions

-- function ForceSafeTransfer( teamId, playerId )
	-- local success = false
	-- local actualOffers, offer1, offer2, offer3, offer4, offer5 = Engine.FindSuitableTeamsForPlayer( teamId, playerId, 5, false )
	-- local validTeams = {}
	-- if( actualOffers > 0 ) then
		-- for offersCount = 1, actualOffers do
			-- local offer = offer1
			-- if( offersCount == 2 ) then
				-- offer = offer2
			-- elseif( offersCount == 3 ) then
				-- offer = offer3
			-- elseif( offersCount == 4 ) then
				-- offer = offer4
			-- elseif( offersCount == 5 ) then
				-- offer = offer5
			-- end
			-- local isRival = Engine.AreTeamsRivals( teamId, offer )
			-- if( isRival == false ) then
				-- table.insert( validTeams, offer )
			-- end
		-- end
		-- local numTeams = # validTeams
		-- local playerTeamId = Engine.GetTeamIdFromPlayerId( playerId )
		-- if( teamId == playerTeamId ) then
			-- local randNum = Engine.GetRandomNumber( 1, numTeams )
			-- if( randNum == 5 ) then
				-- Engine.ForceTransfer( teamId, playerId, offer5, false )
			-- elseif( randNum == 4 ) then
				-- Engine.ForceTransfer( teamId, playerId, offer4, false )
			-- elseif( randNum == 3 ) then
				-- Engine.ForceTransfer( teamId, playerId, offer3, false )
			-- elseif( randNum == 2 ) then
				-- Engine.ForceTransfer( teamId, playerId, offer2, false )
			-- else
				-- Engine.ForceTransfer( teamId, playerId, offer1, false )
			-- end
			-- Engine.AddGrudge( playerId, teamId )
			-- success = true
		-- end
	-- end --if( actualOffers > 1 ) then
	-- return success
-- end

function IsAbleToPlay( teamId, playerId )
	local ableToPlay = true
	if( Engine.IsInjured( teamId, playerId ) == true ) then
		if( Engine.IsRecoveringFromInjury( teamId, playerId ) == true ) then
			ableToPlay = true
		else
			ableToPlay = false
		end
	end
	if( ableToPlay == true and Engine.IsPlayerSuspendedForNextGame( teamId, playerId ) == true ) then
		ableToPlay = false
	end
	if( Engine.IsOnInternationalDuty( teamId, playerId ) == true ) then
		ableToPlay = false
	end
	return ableToPlay
end

function IsPlayerInvolvedInSaga( playerId )
	local lastMinuteTransferRequest = Engine.IsPlayerInvolvedInStoryCategory( playerId, "TRANSREQ" )
	local foreignPlayerUpset = Engine.IsPlayerInvolvedInStoryCategory( playerId, "REQTRANS" )
	local contractRebel = Engine.IsPlayerInvolvedInStoryCategory( playerId, "CONT_REB" )
	local retiringPlayer = Engine.IsPlayerInvolvedInStoryCategory( playerId, "RETIRE" )
	local playTimeMorale = Engine.IsPlayerInvolvedInStoryCategory( playerId, "UNHAPPY" )
	local isInvolved = ( lastMinuteTransferRequest == true or foreignPlayerUpset == true or contractRebel == true or retiringPlayer == true or playTimeMorale == true )
	return isInvolved
end

-- function OfferNewContract( currentStory, teamId, playerId, acceptId, rejectId, storyId )
	-- Engine.SetStoryContractOverride( currentStory, 6 )	-- 6 is negotiating
	-- local currentWage = Engine.GetPlayerWage( teamId, playerId )
	-- local offeredWage = Engine.GetPlayerOfferedWage( teamId, playerId )
	-- local perc = Tuning.MISC.contPerc
	-- local percOfCurrent = ( currentWage * perc ) / 100
	-- if( offeredWage > currentWage + percOfCurrent ) then
		-- Engine.AddDateEvent( acceptId, 2, storyId )
	-- else
		-- Engine.AddDateEvent( rejectId, 2, storyId )
	-- end
-- end

function WouldPlayerEvenLeaveClub( teamId, playerId )
	local monthsJoined = Engine.GetNumberOfMonthsSincePlayerJoined( teamId, playerId )
	local numYears = Engine.GetNumberOfYearsSincePlayerJoined( teamId, playerId ) 
	local playerAge = Engine.GetPlayerAge( teamId, playerId )
	local oneClubPlayer = Engine.HasPlayerTrait( teamId, playerId, "ONE_CLUB_PLAYER" )
	local isListed = Engine.IsPlayerOnTransferList( playerId )
	local loanListed = Engine.IsPlayerOnLoanList( playerId )
	local inOnLoan = Engine.IsPlayerInOnLoan( teamId, playerId )
	local isRetiring = Engine.IsRetiring( playerId )
	local isPap = ( playerId == Engine.GetPlayAsPlayerID() )
	local injuryDuration = Engine.GetInjuryDuration( teamId, playerId )
	local numDaysOfInjury = Tuning.MISC.numDaysInjured
	local playerFitEnough = ( injuryDuration < numDaysOfInjury )
	local hasSignedPreContract = Engine.HasSignedPreContract( playerId )
	local retireStory = Engine.IsPlayerInvolvedInStoryId( playerId, "POTRET" )
	local wouldLeave = ( ( numYears <= Tuning.MISC.numYearsOnTeam or playerAge <= Tuning.MISC.playerAge ) and ( oneClubPlayer == false ) and ( inOnLoan == false ) and ( isRetiring == false ) and ( monthsJoined >= Tuning.MISC.monthsJoined ) and ( isPap == false ) and ( playerFitEnough == true ) and ( isListed == false ) and ( loanListed == false ) and ( hasSignedPreContract == false ) and ( retireStory == false ) )
	return wouldLeave
end

function PlayerSagaInjuryEnding( teamId, playerId, severity, returnDate )
	local storyId = "NIL"
	local currDate = Engine.GetCurrentDate()
	local daysBetween = Engine.GetNumDaysBetween( currDate, returnDate )
	local canRun = false
	local category = "NIL"
	if( Engine.IsPlayerInvolvedInStoryCategory( playerId, "UNHAPPY" ) == true ) then
		local numCat = ( Engine.GetNumStoriesByCategory( "PLAYTIME" ) + 1 )
		if( Engine.MarkPlayerForStory( teamId, playerId, "PLAYTIME", "PLAYTIME" .. numCat ) == true ) then
			Engine.EndStoryCategory( "UNHAPPY" )
		end
	elseif( daysBetween >= Tuning.INJURY.injuryDurationNeeded ) then
		if( Engine.IsPlayerInvolvedInStoryCategory( playerId, "TRANSREQ" ) == true ) then
			local numDays = Engine.GetNumDaysUntilNextTransferWindow()
			local inWindow = Engine.IsWithinTransferWindow()
			if( inWindow == true or daysBetween > numDays ) then
				canRun = true
				category = "TRANSREQ"
			end
		elseif( Engine.IsPlayerInvolvedInStoryCategory( playerId, "REQTRANS" ) == true ) then
			local numDaysLeft = Engine.GetNumDaysRemainingInTransferWindow()
			if( daysBetween > numDaysLeft ) then
				canRun = true
				category = "REQTRANS"
			end
		elseif( Engine.IsPlayerInvolvedInStoryCategory( playerId, "CONT_REB" ) == true ) then
			local numDays = Engine.GetNumDaysUntilNextTransferWindow()
			local inWindow = Engine.IsWithinTransferWindow()
			if( inWindow == true or daysBetween > numDays ) then
				canRun = true
				category = "CONT_REB"
			end
		end
		if( canRun == true ) then
			local numStories = Engine.GetNumStoriesByCategory( category )
			for storyCount = numStories, 1, -1 do
				local currentStory = Engine.GetStoryByCategoryAndIndex( category, storyCount )
				storyId = Engine.GetStoryId( currentStory )
			end
		end
		if( storyId ~= "NIL" ) then
			Engine.AddDateEvent( "INJURED", 1, storyId )
		end
	end
end

function PlayerSagaReleasedEnding( teamId, playerId )
	local storyId = "NIL"
	local category = "NIL"
	local numStories = 0
	local canRun = false
	if( Engine.IsPlayerInvolvedInStoryCategory( playerId, "TRANSREQ" ) == true ) then
		canRun = true
		category = "TRANSREQ"
	elseif( Engine.IsPlayerInvolvedInStoryCategory( playerId, "REQTRANS" ) == true ) then
		canRun = true
		category = "REQTRANS"
	elseif( Engine.IsPlayerInvolvedInStoryCategory( playerId, "CONT_REB" ) == true ) then
		canRun = true
		category = "CONT_REB"
	elseif( Engine.IsPlayerInvolvedInStoryCategory( playerId, "RETIRE" ) == true ) then
		canRun = true
		category = "RETIRE"
	end
	if( canRun == true ) then
		local numStories = Engine.GetNumStoriesByCategory( category )
		for storyCount = numStories, 1, -1 do
			local currentStory = Engine.GetStoryByCategoryAndIndex( category, storyCount )
			storyId = Engine.GetStoryId( currentStory )
		end
	end
	if( storyId ~= "NIL" ) then
		Engine.AddDateEvent( "RELEASED", 1, storyId )
	end
end

function SagaEndingDynamicEvent( eventId, storyId )
	if( eventId == "INJURED" ) then
		InjuredSagaEnding( storyId )
	elseif( eventId == "RELEASED" ) then
		ReleasedSagaEnding( storyId )
	end
end

function InjuredSagaEnding( storyId )
	local currentStory = Engine.GetStoryById( storyId )
	local playerId = Engine.GetStoryPlayer( currentStory )
	local teamId = Engine.GetStoryTeam( currentStory )	
	Engine.SetStringTeam( teamId, 1 )
	Engine.SetStringPlayer( playerId, 1 )
	TriggerNews( "news_title_Saga_InjuryEnding_", 1, 1, "news_body_Saga_InjuryEnding_", 1, 1, currentStory )
	Engine.UpdateStoryActivityById( storyId )
	Engine.EndStoryId( storyId )
end

function ReleasedSagaEnding( storyId )
	local currentStory = Engine.GetStoryById( storyId )
	local playerId = Engine.GetStoryPlayer( currentStory )
	local teamId = Engine.GetStoryTeam( currentStory )	
	Engine.SetStringTeam( teamId, 1 )
	Engine.SetStringPlayer( playerId, 1 )
	TriggerNews( "news_title_Saga_ReleasedEnding_", 1, 1, "news_body_Saga_ReleasedEnding_", 1, 1, currentStory )
	Engine.UpdateStoryActivityById( storyId )
	Engine.EndAllStoriesForPlayer( playerId )
end

function GetTeamPlayerAvg( teamId, numPlayers )
	local totalAvg = 0
	teamId = Engine.StackRankTeamByOverall( teamId )
	local loopToPlayers = numPlayers
	local numPlayersOnTeam = Engine.GetNumPlayers( teamId )
	if( numPlayersOnTeam < loopToPlayers ) then
		loopToPlayers = numPlayersOnTeam
	end
	for playerCount = 1, loopToPlayers do
		local currPlayer = Engine.GetPlayer( teamId, playerCount )
		local playerOverall = Engine.GetPlayerOverall( currPlayer )
		totalAvg = totalAvg + playerOverall
	end
	totalAvg = totalAvg / numPlayers
	return totalAvg
end

function GetSuitableTeamsForPlayer( teamId, playerId, numOffers, ignoreBudget )
	local offer = { -1, -1, -1 }
	local actualOffers = 0
	if( numOffers <= 3 ) then
		local badOfferFound = false
		actualOffers, offer[ 1 ], offer[ 2 ], offer[ 3 ] = Engine.FindSuitableTeamsForPlayer( teamId, playerId, numOffers, false )
		for offerCount = 1, actualOffers do
			local isRival = Engine.AreTeamsRivals( teamId, offer[ offerCount ] )
			if( offer[ offerCount ] == -1 or isRival == true ) then
				badOfferFound = true
				break
			end
		end
		if( badOfferFound == true ) then
			offer[ 1 ], offer[ 2 ], offer[ 3 ] = FindSuitablePlayersSafety( playerId, numOffers )
		end
	else
		Engine.LuaAssert( "FindSuitablePlayers - Too many offers requested: " .. numOffers )
	end
	return actualOffers, offer[ 1 ], offer[ 2 ], offer[ 3 ]
end

function FindSuitablePlayersSafety( playerId, numOffers )
	local highTeam = Tuning.MISC.highTeamIds    
	local numHighTeams = table.getn( highTeam )
	local userTeam = Engine.GetUserTeam()
	if( numOffers == nil ) then
		numOffers = 3
	end
	for teamCount = 1, numHighTeams do
		local isRival = Engine.AreTeamsRivals( userTeam, highTeam[ teamCount ] )
		if( userTeam == highTeam[ teamCount ] or isRival == true ) then
			table.remove( highTeam, teamCount )
			numHighTeams = table.getn( highTeam )
			break
		end
	end
	randNum = Engine.GetRandomNumber( 1, numHighTeams - numOffers )
	return highTeam[ randNum ], highTeam[ randNum + 1 ], highTeam[ randNum + 2 ]
end

function DidPlayerScore( matchResult, player ) -- Also in misc functions
	local scored = false
	local numIncidents = Engine.GetNumberOfIncidents( matchResult )
	for incidentCount = 1, numIncidents do
		local type = Engine.GetIncidentTypeByIndex( matchResult, incidentCount )
		if( type == "GOAL" ) then
			local incident = Engine.GetMatchIncidentByIndex( matchResult, incidentCount )
			local teamId, playerId, incidentTime = Engine.GetIncidentTeamPlayerAndTime( matchResult, incident )
			if(  playerId == player ) then
				scored = true
				break
			end
		end
	end
	return scored
end

function GetUserImportance()
	local fixture = Engine.GetCurrentGameFixtureData()
	local team1, team2 = Engine.GetTeamsFromFixtureData( fixture )
	local teamMI1, teamMI2 = Engine.GetMatchImportance( fixture )
	local matchImp = 0
	if( team1 == Engine.GetUserTeam() ) then
		matchImp = teamMI1
	else
		matchImp = teamMI2
	end
	return matchImp
end

function GetUserCpuTeamFromIds( team1, team2 )
	local userTeam = team1
	local cpuTeam = team2
	if( team1 ~= Engine.GetUserTeam() ) then
		cpuTeam = team1
		userTeam = team2
	end	
	return userTeam, cpuTeam
end

function GetTeamsFromFixture( fixture )
	local team1, team2 = Engine.GetTeamsFromFixtureData( fixture )
	local userTeam, cpuTeam = GetUserCpuTeamFromIds( team1, team2 )
	return userTeam, cpuTeam
end

function GetAudioPositionId( teamId, playerId )
	local posId = 14			-- Defaults to the striker positions
	local position = Engine.GetPlayerPosition( teamId, playerId )
	if( position == "GK" ) then
		posId = 06
	elseif( position == "SW" ) then
		posId = 07
	elseif( position == "RWB" ) then
		posId = 08
	elseif( position == "RB" ) then
		posId = 08
	elseif( position == "RCB" ) then
		posId = 07
	elseif( position == "CB" ) then
		posId = 07
	elseif( position == "LCB" ) then
		posId = 07
	elseif( position == "LB" ) then
		posId = 09
	elseif( position == "LWB" ) then
		posId = 09
	elseif( position == "RDM" ) then
		posId = 10
	elseif( position == "CDM" ) then
		posId = 10
	elseif( position == "LDM" ) then
		posId = 10
	elseif( position == "RM" ) then
		posId = 11
	elseif( position == "RCM" ) then
		posId = 10		
	elseif( position == "CM" ) then
		posId = 10		
	elseif( position == "LCM" ) then
		posId = 10				
	elseif( position == "LM" ) then
		posId = 12
	elseif( position == "RAM" ) then
		posId = 13
	elseif( position == "CAM" ) then
		posId = 13
	elseif( position == "LAM" ) then
		posId = 13		
	elseif( position == "RW" ) then
		posId = 11
	elseif( position == "LW" ) then
		posId = 12
	end
	return posId
end
-------------------------------------------------------------------------------------------------------------------------------
-- LOGGING
-------------------------------------------------------------------------------------------------------------------------------
function IsLogging()
	logging = false
	return logging
end

-------------------------------------------------------------------------------------------------------------------------------
-- TUNING
-------------------------------------------------------------------------------------------------------------------------------
Tuning = (function()

-------------------------------------------------------------------------------------------------------------------------------
-- LAST MINUTE TRANSFER REQUEST
-------------------------------------------------------------------------------------------------------------------------------
	local LMTR = {
		minPlayers_CPU = 1, -- Min # of players that will hand in a request ( 1 )
		maxPlayers_CPU = 2, -- Max # of players that will hand in a request ( 2 )
		changeOfUserProblem = 20, -- % chance the users player will ask for a transfer. ( 20 )
		chanceOfLeaving_CPU = 50, -- % Chance the users player will leave. ( 50 )
		chanceOfLeaving_USER = 50, -- 50% Chance the CPU will Leave ( 50 )
		chanceNewsConfused_CPU = 25, -- 25% Chance the news will give a confused outcome when referring to a CPU story. ( 25 )
		chanceNewsConfused_USER = 25, --25% the news will publish a third article in their confusion. ( 25 )
		--Timing
		triggerStoryDate = 16, -- Days since the opening of the transfer window ( 15 )
		storyStartDelay_Low = 1, -- min Aug 16th ( days from the 15th ) *Range* ( 1 )
		storyStartDelay_High = 10, -- Max Aug 25th ( Careful: It takes 5 days for the story to resolve )*Range* ( 10 )
		minBoardTransferDelay_CPU = 1, -- Min amount of days before the board sells the player, max is always the end of the window. ( 1 )
		boardDecisionDelay_CPU = 2, -- days from initial news article the board will decide to keep or sell the player. ( 2 )
		newsDelay_USER = 1, -- Days Delay before request hits the news. ( 1 )
		boardDecisionDelay_USER = 3, -- Days after the request that the board responds ( 3 )
		newsClubsDelay_USER = 1, -- Days Delay from the first article that the second comes out. ( 1 )
		newsConfusedDelay_USER = 1, -- Days after second article the media may publish this article in their confusion. ( 1 )
		-- End of Values
		topNumPlayers = 5
	}

-------------------------------------------------------------------------------------------------------------------------------
-- HOMESICK PLAYER
-------------------------------------------------------------------------------------------------------------------------------
	local FOREIGN = {
		chanceOnePlayer = 0, -- % Chance the story will select a CPU player for the story ( 40 )
		chanceTwoPlayers = 0, -- % chance the story will then select 2 players ( 20 )
		chanceUserPlayer = 0, -- % chance the user player will ask to leave. ( 30 )
		wantsToLeave = 0, -- % Chance the player will decide to leave ( 50 )
		maxNumberOfOffers = 5, -- Maximium # of offers will be sent from other teams ( 3 )
		maxRandPlayers = 5,
		--Timing
		percentThroughSeason = 60, -- Story Requires the season to be less than X% complete ( 60 )
		numDays_Min = 90, -- Days min needed before transfer window for the story to resolve ( 3 Months ) ( 90 )
		numDays_Max = 100, -- Days max for story to end by the Transfer window ( 3 Months ) ( 100 )
		start_Delay = 8, -- Days into the month delay ( 9th ) ( 8 )
		stage1_Delay_Low = 2, -- days min wait after the 9th of October ( CPU Only )*Range* ( 2 )
		stage1_Delay_High = 3, -- days max wait after the 9th ( CPU Only )*Range* ( 3 )
		stage2_Delay_Low = 5, -- days min wait after stage 1 *Range* ( 5 )
		stage2_Delay_High = 6, -- days max wait after stage 1 *Range* ( 6 )
		stage3_Delay_Low = 7, -- days min wait after stage 2 *Range* ( 7 )
		stage3_Delay_High = 10, -- days max wait after stage 2 *Range* ( 10 )
		stage4_Delay_Low = 10, -- days min wait after stage 3 *Range* ( 10 )
		stage4_Delay_High = 13, -- days max wait after stage 3 *Range* ( 13 )
		stage5_Delay_Low = 7, -- days min wait after stage 4 *Range* ( 7 )
		stage5_Delay_High = 11, -- days max wait after stage 4 *Range* ( 11 )
		stage6_Delay_Low = 14, -- days min wait after stage 5 *Range* ( 14 )
		stage6_Delay_High = 17, -- days max wait after stage 5 *Range* ( 17 )
		stage7_Delay_Low = 14, -- days min wait after stage 6 *Range* ( 14 )
		stage7_Delay_High = 18, -- days max wait after stage 6 *Range* ( 18 )
		stage8_Delay_Low = 14, -- days min wait after stage 7 *Range* ( 14 )
		stage8_Delay_High = 17, -- days max wait after stage 7 *Range* ( 17 )
		stage9_Delay = 1, -- days wait after stage 8 ( 1 )
		stage10_Delay = 1, -- days wait after stage 9 ( 1 )
		stage11_Delay = 2, -- days wait after stage 10 ( 2 )
		stage12_Delay = 10 -- days wait after stage 11 ( 10 )
	}

-------------------------------------------------------------------------------------------------------------------------------
-- CONTRACT REBEL
-------------------------------------------------------------------------------------------------------------------------------
	local REBEL = {
		wagePercent = 25, -- % greater contract needed ( 24 )
		isGoingToLeave = 50, -- % chance the player will choose to leave ( 50 )
		percentThroughSeason = 85, -- Must be less than X% through the season ( 85 )
		willPlayerRebel = 65, -- % chance the player will enter the story ( 65 )
		willTeamBid = 20, -- % chance a team will bid during stage 3.5 and 4.5 ( 20 )
		willTwoTeamsBid = 10, -- % chance two teams will bid during stage 4.5 ( 10 )
		shouldMakeOffer = 70, -- % chance a team will bid on rebel. ( 3 different times: 5th, 10th, 15th during transfer window ) ( 70 )
		--storyCoolDown = 21, -- Number of days before the same story can be triggered. ( Not Applicable ) ( 21 )
		-- Timing
		start_Delay_Low = 2, -- Days min from contract offer *Range* ( 2 )
		start_Delay_High = 5, -- Days max after contract offer *Range* ( 5 )
		stage0_Delay_Low = 3, -- Days after the story starts *Range* ( 3 )
		stage0_Delay_High = 5, -- Days after the story starts *Range* ( 5 )
		stage1_Delay_Low = 2, -- Days after the last stage *Range* ( 2 )
		stage1_Delay_High = 2, -- Days after the last stage *Range* ( 2 )
		stage2_Delay_Low = 3, -- Days after the last stage *Range* ( 3 )
		stage2_Delay_High = 6, -- Days after the last stage *Range* ( 6 )
		stage3_Delay_Low = 7, -- Days after the last stage *Range* ( 7 )
		stage3_Delay_High = 14, -- Days after the last stage *Range* ( 14 )
		stage3half_Delay_Low = 5, -- Days after the last stage *Range* ( 5 )
		stage3half_Delay_High = 8, -- Days after the last stage *Range* ( 8 )
		stage4_Delay_Low = 4, -- Days after the last stage *Range* ( 4 )
		stage4_Delay_High = 6, -- Days after the last stage *Range* ( 6 )
		stage4half_Delay_Low = 5, -- Days after the last stage *Range* ( 5 )
		stage4half_Delay_High = 8, -- Days after the last stage *Range* ( 8 )
		stage4half_numOffers_willTeamBid = 2, -- number of offers at stage 4.5 if a team will bid
		stage4half_numOffers_willTwoTeamsBid = 5, -- number of offers at stage 4.5 if two teams will bid
		stage5_Delay_Low = 5, -- Days after the last stage *Range* ( 5 )
		stage5_Delay_High = 9, -- Days after the last stage *Range* ( 9 )
		stage6_Delay_Low = 14, -- Days after the last stage *Range* ( 14 )
		stage6_Delay_High = 21, -- Days after the last stage *Range* ( 21 )
		stage7_Delay_Low = 14, -- Days after the last stage *Range* ( 14 )
		stage7_Delay_High = 21, -- Days after the last stage *Range* ( 21 )
		stage8_Delay_Low = 14, -- Days after the last stage *Range* ( 14 )
		stage8_Delay_High = 21, -- Days after the last stage *Range* ( 21 )
		stage9_Delay_Low = 1, -- Days after the last stage *Range* ( 1 )
		stage9_Delay_High = 1, -- Days after the last stage *Range* ( 1 )
		stage10_Delay_Low = 1, -- Days after the last stage *Range* ( 1 )
		stage10_Delay_High = 1, -- Days after the last stage *Range* ( 1 )

		minNumPlayersOnTeam = 23, -- Minimum number of players on team
		chanceToStartPercent = 10, -- Chance to start contract rebel story (as a percent)
		CPUTransfer_numDays_High = 15,
		CPUTransfer_numDays_Med = 10,
		CPUTransfer_numDays_Low = 5,
		CPUTransfer_numDays_High_Chance = 25,
		CPUTransfer_numDays_Med_Chance = 50,
		CPUTransfer_numDays_Low_Chance = 100,
	}

-------------------------------------------------------------------------------------------------------------------------------
-- UNHAPPY WITH WAGE
-------------------------------------------------------------------------------------------------------------------------------
	local UWW = {
		numStoriesLimit = 5,
		playerTierLimit = 6,
		yearsRemainingLimit = 4,
		minDelay = 2,
		maxDelay = 7,
		Stage1_BaseDelay = 30,
		Stage1_DelayStep = 5,
	}

-------------------------------------------------------------------------------------------------------------------------------
-- PLAYTIME MORALE
-------------------------------------------------------------------------------------------------------------------------------
	local PTM = {
		percentageThrough_Low = 20, -- % throught the season required *Range* ( 20 )
		percentageThrough_High = 90, -- No Greater than this % throught the season *Range* ( 90 )
		chanceOfHappyStory = 50, -- % Chance a happy player will comment on his play time. ( 50 )
		limitUnhappyStory = 5, -- story max. in one season ( 5 )
		limitHappyStory = 5, -- story max. in one season ( 5 )
		chanceTransferRequest = 40, -- % Chance an unhappy player in stage 3 will rewuest to be transferred ( 40 )
		storyCoolDown = 50, -- Number of days before the same story can be triggered. ( 50 )
		--Timing
		stage1_Delay = 1, -- Day Delay After Morale Change ( 1 )
		stage1News_delay = 1, -- Delay after the player comments on his playtime before an article is seen in the news. ( 1 )
		stage2_Delay = 30, -- Delay before player re-evaluates his playtime morale. ( Asks for Transfer / Loan ) ( 30 )
		stage3_Delay_Min = 1, -- Minimium days wait after the transfer window opens the player will check his transfer status. *Range*  ( 1 )
		stage3_Delay_Max = 15, -- # of Days Max. after the transfer window opens the player will check his transfer status. *Range*  ( 15 )
		listedNews_Delay = 1, -- Day delay Before the news of the players listing arrives.  ( 1 )
		--Morale
		--unhappyPlayTimeMorale = 50, -- Players with "LOW" or "VERY_LOW" morale will trigger the story. ( Tunable in the Morale .ini file )  ( 50 )
		ignored_PTM_Morale = -30, -- morale penalty if you do nothing  ( -30 )
		wrongList_PTM_Morale = -30, -- morale penalty if you add the player to the wrong list ( Trans/Loan )  ( -30 )
		moraleOverride = 10
	}

-------------------------------------------------------------------------------------------------------------------------------
-- PLAYER NOT FULLY RECOVERED
-------------------------------------------------------------------------------------------------------------------------------
	local INJURY = {
		chanceOfPreseasonInjury = 15, -- Chance of Preseason Injury ( 35 )
		forcedInjuryDuration = 50, -- Number of days the forced injury will last ( 50 )
		storyCoolDown = 21, -- Number of days before the same story can be triggered.
		playerTier_TopPlayer = 2, -- the teir and below that a player must be to enter the story ( 2 )
		injuryDurationNeeded = 14, -- greater than injury Duration needed to trigger story ( 14 )
		matchRating_Good = 59, -- Match rating must be Greater than for the "Played Well" Outcome. ( 59 )
		numDaysBeforeMatch = 2, -- days before the match, the player will ask to be played ( 2 )
		newsWeight = 25,
		newsWeightCpu = 24
	}

-------------------------------------------------------------------------------------------------------------------------------
-- ONE FOR THE FUTURE
-------------------------------------------------------------------------------------------------------------------------------
	local OFTF = {
		secondArticle_Delay = 14, -- days from the 1st of the month the second article will Print ( 14 days ( 15th ) )
		chanceOfFinding_Great = 40, -- Chance of finding a player Ovr 99 - 81 ( 40 )
		chanceOfFinding_Good = 40, -- Chance of finding a player Ovr 80 - 71 ( 40 )
		--chanceOfFinding_Average = 20, -- Chance of finding a player Ovr 70 - 60 ( 20 ) *Set by what ever /100 is left after the two previous numbers are set
		greatRating_High = 99, -- Great Player Ovr Max *Range* ( 99 )
		greatRating_Low = 81, -- Great Player Ovr Min *Range* ( 81 )
		goodRating_High = 80, -- Good Player Ovr Max *Range* ( 80 )
		goodRating_Low = 71, -- Good Player Ovr Min *Range* ( 71 )
		averageRating_High = 70, -- Average Player Ovr Max *Range* ( 70 )
		averageRating_Low = 60, -- Average Player Ovr Min *Range* ( 60 )
		storyCooldown = 21
	}

-------------------------------------------------------------------------------------------------------------------------------
-- LOW ENERGY APPEAL
-------------------------------------------------------------------------------------------------------------------------------
	local FATIGUE = {
		numDays = 0, -- Days Before Next Match ( 0 )
		seasonPercent = 90, -- % through the season ( 90 )
		maxPlayersToCheck = 11, -- Maximium number of players to check organized in decending Overalls ( 11 )
		playerTier = 3, -- below teir ( 3 )
		playerEnergy = 70, -- energy less than or equal to ( 70 )
		matchImportance = 70, -- Match Importance equal to or less than ( 70 )
		storyCoolDown = 21, -- Number of days before the same story can be triggered.
		playerRating_Good = 75, -- MR less than for player to complain ( 75 )
		minPlayed_Short = 30, -- Short Play is Less than or Equal to this playtime ( 30 )
		minPlayed_Med_Low = 31, -- Medium Play is Greater or Equal to this playtime *Range* ( 31 )
		minPlayed_Med_High = 60, -- Medium Play is Less than or Equal to this playtime *Range* ( 60 )
		-- minPlayed_Long = 60, -- Long Play ( This will be anything greater than "minPlayed_Med_High" )
		--Morale
		injuredFatigued_Morale = -50, -- Player Injured ( -50 )
		startingFatigued_Selfish_Morale = -50, -- Selfish Player Started ( -50 )
		startingFatigued_Team_Morale = -25, -- Team Player started ( -25 )
		benchStart_Long_Selfish_Morale = -30, -- Selfish Played Long ( -30 )
		benchStart_Med_Selfish_Morale = -20, -- Selfish Player Med ( -20 )
		benchStart_Short_Selfish_Morale = -10, -- Selfish Player Short ( -10 )
		benchStart_Long_Team_Morale = -10, -- Team Player Long ( -10 )
		benchStart_Med_Team_Morale = 0, -- Team Player Med ( 0 )
		benchStart_Short_Team_Morale = 10, -- Team Player Short ( 10 )
		notPlayed_Morale = 20 -- Not Played ( 20 )
	}

-------------------------------------------------------------------------------------------------------------------------------
-- FOREIGN INVESTOR
-------------------------------------------------------------------------------------------------------------------------------
	local INVESTOR = {
		monthHigh = 6, -- Latest Month /12 that the story can trigger ( 6 )
		monthLow = 3, -- Earliest Month /12 that the story can trigger ( 3 )
		chanceOfHappening = 20, -- Chance a team will be purchsed ( 40 )
		alreadyRichBudget = 30000000, -- Budgets greater than this are not applicable for purchase ( 30000000 )
		cpuBudget = 100000000, -- Funds added to the purchased cpu team ( 100000000 )
		userBudget = 40000000,
		--Timing
		stage2_Delay_Low = 28, -- Min Number of days after speculation that the team can be purchased ( 28 )
		stage2_Delay_High = 40, -- Max number of days after speculation the team is purchased ( 40 )

		validLeagues = { 4, 10, 13, 14, 16, 17, 19, 20, 31, 32, 39, 50, 53, 54, 60, 61, 67, 68, 308 },
		chanceDefault = 10,
		chanceOneSeason = 10,
		chanceTwoSeasons = 10
	}

-------------------------------------------------------------------------------------------------------------------------------
-- PLAYER FORM
-------------------------------------------------------------------------------------------------------------------------------
	local FORM = {
		maxWayThroughSeason = 85, -- Percent through the season, any greater than this and stories will not show ( 85 )
		goodPlayerRating = 59, -- Above is considered a good rating ( 59 )
		numDaysBefore = 2, -- Number of days a player will ask to be played in the next match after a run of poor form ( 2 )
		storyCoolDown = 21 -- Number of days before the same story can be triggered. ( Applies only to the Form Changes storyline )
	}

-------------------------------------------------------------------------------------------------------------------------------
-- LOAN LISTED
-------------------------------------------------------------------------------------------------------------------------------
	local LOANLIST = {
		storyCoolDown = 5, -- Number of days before the same story can be triggered.
		-- Morale
		numPlayersToAvg = 18, -- Number of players used to average the team
		und20_AbvAvg_Unhappy_Morale = -40, -- under 20, above team average, low playtime morale ( -10 )
		und20_AbvAvg_Happy_Morale = -40, -- under 20, above team average, high playtime morale ( -20 )
		und20_BlwAvg_Unhappy_Morale = 10, -- under 20, below team average, low playtime morale ( 10 )
		und20_BlwAvg_Happy_Morale = 10, -- under 20, below team average, high playtime morale ( -10 )
		ovr20_AbvAvg_Unhappy_Morale = -30, -- over 20, above team average, low playtime morale ( -10 )
		ovr20_AbvAvg_Happy_Morale = -30,  -- over 20, above team average, High playtime morale ( -30 )
		ovr20_BlwAvg_Unhappy_Morale = 10, -- over 20, below team average, low playtime morale ( 15 )
		ovr20_BlwAvg_Happy_Morale = -10, -- over 20, below team average, High playtime morale ( -20 )
		ovr30_AbvAvg_Unhappy_Morale = -40, -- over 30, above team average, low playtime morale ( -20 )
		ovr30_AbvAvg_Happy_Morale = -40, -- over 30, above team average, high playtime morale ( -40 )
		ovr30_BlwAvg_Unhappy_Morale = 10, -- over 30, below team average, low playtime morale ( 15 )
		ovr30_BlwAvg_Happy_Morale = -20 -- over 30, below team average, high playtime morale ( -10 )
	}

-------------------------------------------------------------------------------------------------------------------------------
-- TOP PLAYER ON BENCH
-------------------------------------------------------------------------------------------------------------------------------
	local ONBENCH = {
		numDays = 0, -- Number of days before next match the player will ask to be played ( 0 )
		storyCoolDown = 60, -- Number of days before the same story can be triggered.
		streakContinues_Morale = 15, -- Morale if his streak continues ( 15 )
		notPlayed_Morale = -10 -- Morle drop if he is not allowed to play ( -10 )
	}

-------------------------------------------------------------------------------------------------------------------------------
-- RETIREMENT
-------------------------------------------------------------------------------------------------------------------------------
	local RETIRE = {
		--chanceOfPotentialRet = 0 ( Tunable in the retirement .ini file )
		stage1_Delay_Low = 20, -- Min Delay before he announces his retirement to the manager *Range* ( 20 )
		stage1_Delay_High = 27, -- Max Delay after the season starts player announces his retirement to the manager *Range* ( 27 )
		injuryDuration = 25, -- Injury durations greater than this will spur a player to retire early ( 25 )
		injuryDecisionDelay = 7, -- number of days after a severe injury a player will announce he will retire early ( 7 )
		chanceOfRetirementInjury = 75, -- Chance the player will choose to retire after a serious injury ( 75 )
		numDaysBeforeLastMatch = 3, -- number of days before the last match the player will announce his retirement ( 3 )
		chanceOfRetirementLastGame = 75, -- Chance the player will choose to retire after the last match of the season ( 75 )
		minPlayersOnTeamToStartStory = 26,
		maxPlayersToCheck = 3,
		storyPriority = 4
	}

-------------------------------------------------------------------------------------------------------------------------------
-- SEASON PREVIEW
-------------------------------------------------------------------------------------------------------------------------------
	local PREVIEW = {
		attributePercentage = 95,
		topPlayerLowestIndex = 12,
		maxYoungPlayerAge = 21
	}

-------------------------------------------------------------------------------------------------------------------------------
-- MATCH INCIDENTS
-------------------------------------------------------------------------------------------------------------------------------
	local MATCHINCIDENT = {
		redCardCount = 2, -- Needs this many or greater red cards in a game before the manager speaks out about a dirty game ( 2 )
		chanceOfDirtyGame = 15, -- Chance the news will publish a dirty game story after a CPU match has completed ( 15 )
		dirtyGameStoryCoolDown = 14, -- Days needed before dirty game story can be repeated ( 14 )
		chanceOfDodgyGoal = 15, -- Chance the news will publish a dodgy goal story after a CPU match has completed ( 15 )
		chanceOfHandballGoal = 30, -- Determines Type of Dodgy Goal: Handball now bad defending ( 30/100 )
		chanceOfFoulGoal = 25, -- Determines Type of Dodgy Goal: Foul Goal ( 25/100 )
		chanceOfOffsideGoal = 45, -- Determines Type of Dodgy Goal: Off Side Goal ( 45/100 )
		chanceOfTechnology = 0, -- Determines Type of Dodgy Goal: Technology fault ( 0/100 )
		chanceOfDodgyRedCard = 15, -- Chance a manager will complain of a doodgy red card ( 15 )
		winningGoalTime_Low = 85, -- Earliest a goal can be scored and counts as a potential game winner. ( 85 )
		storyCoolDown = 21 -- Number of days before the same match incident story can be triggered. Besides the Dirty Game Story ( 21 )
	}

-------------------------------------------------------------------------------------------------------------------------------
-- RIDICULOUS TRANSFER
-------------------------------------------------------------------------------------------------------------------------------
	local STUPID = {
		overallDiff = 15, -- Ovr Difference between rediculous player and user team avg ( 15 )
		numPlayersToAvg = 17, -- Number of players average ( 17 )
		boardConfidencePen_1st = -10, -- Penalty after the second stupid offer ( -10 )
		boardConfidencePen_2nd = -10 -- Penalty after the third stupid offer ( -10 )
	}

-------------------------------------------------------------------------------------------------------------------------------
-- TALK TO PRESS
-------------------------------------------------------------------------------------------------------------------------------
	local PRESS = {
		bottomPerc = 15, -- Considered the bottom team ( 15 )
		topPerc = 15, -- Considered top percent ( 15 )
		superStarOvr = 87, -- OVR required for a player to be considered a super star
		evenDiff = 4, -- max OVR difference to be considered equal ( 4 )
		better = 9, -- Max Differnce to be considered slightly better ( 9 )
		sigBetter = 109, -- max for a user to be consdered signifigantly better ( 109? )
		chanceToStartPerc = 25,
		optionChancePerc = 50,
		lateSeasonPerc = 60,
		chanceOfReversePerc = 50,
		choicePerc = 35,
		teamChoice1Perc = 30,
		teamChoice2Perc = 30,
		youngGkThreshold = 25,
		oldGkThreshold = 34,
		youngDefThreshold = 22,
		oldDefThreshold = 31,
		youngMidThreshold = 22,
		oldMidThreshold = 30,
		youngAttThreshold = 22,
		oldAttThreshold = 29,
		minGoalScoringAppearances = 6, -- Min number of appearances to account for Goal Scoring
		minDisciplineAppearances = 6, -- Min number of appearances to account for Discipline
		goodGoalScoringThreshold = 0.5, -- Min appearance/goals ratio to account for Good Goal Scoring
		badGoalScoringThreshold = 0.25, -- Max appearance/goals ratio to account for Bad Goal Scoring
		goodDisciplineThreshold = 0.2, -- Max appearances/disciplineScore ratio to account for Good Discipline
		badDisciplineThreshold = 0.75, -- Min appearances/disciplineScore ratio to account for Bad Discipline
		minBigScoreDifference = 3 -- Min score difference for a Big Win or Big Loss
	}

-------------------------------------------------------------------------------------------------------------------------------
-- TRANSFER LISTED
-------------------------------------------------------------------------------------------------------------------------------
	local LISTED = {
		numPlayersToAvg = 18, -- Numbver of players on the team to average, highest to lowest ( 18 )
		und20_AbvAvg_Morale = -30, -- Under 20, above average Morale Penalty ( -20 )
		und20_BlwAvg_Morale = -20, -- Under 20, below average Morale Penalty ( -10 )
		ovr20_AbvAvg_Morale = -30, -- Over 20, above average Morale Penalty ( -20 )
		ovr20_BlwAvg_Morale = -10, -- Over 20, below average Morale Penalty ( -10 )
		ovr30_AbvAvg_Morale = -30, -- Over 30, above average Morale Penalty ( -20 )
		ovr30_BlwAvg_Morale = -10, -- Over 30, below average Morale Penalty ( -10 )
		storyCoolDown = 5, -- Number of days before the same story can be triggered.
		storyPriority = 2,
		maxYoungPlayerAge = 21,
		minOldPlayerAge = 30
	}

-------------------------------------------------------------------------------------------------------------------------------
-- TRANSFERS
-------------------------------------------------------------------------------------------------------------------------------
	local TRANSFERS = {
		numStories = 5, -- Max number of new signing stories ( 5 )
		ovrDiff = 20, -- OVR difference needed to consider a player a massive signing ( 20 )
		storyCoolDown = 21, -- Number of days before the same story can be triggered.
		exceptionSellingTeamId = 111592
	}

-------------------------------------------------------------------------------------------------------------------------------
-- IMPORTANT MATCH PREVIEW / REVIEW
-------------------------------------------------------------------------------------------------------------------------------
	local IMP = {
		numDays = 0, -- Number of days before the match ( 0 )
		matchImp = 85, -- Required Match Importance ( 85 )
		-- League Positions
		bottom = 60, -- Any % below this is considered the bottom half of the league ( 60 )
		high = 25, -- Any % above this is considered the top of the league ( 25 )
		low = 75, -- Any % below this is considered the very bottom of the league ( 75 )
		midHigh = 66, -- Any % below this is considered middle of the league ( 66 )
		midLow = 33, -- Any % above this is considered middle of the league ( 33 )
		-- League Timing
		early = 25, -- Any % below this is considered the early in the season ( 25 )
		-- midH = 84, -- Not Needed *Range* ( Considerd anything other than Early or Late )
		-- midL = 26, -- Not Needed *Range* ( Considerd anything other than Early or Late )
		late = 85, -- Any % above this is considered the late in the season ( 25 )
		-- Cups
		equal = 4, -- Max difference in opponents OVR needed to be considered an equal match ( 4 )
		goodHigh = 8, -- Max difference in opponents OVR needed to be considered a Big Team *Range* ( 8 )
		goodLow = 5, -- Min difference in opponents OVR needed to be considered a Big Team *Range* ( 4 )
		averageHigh = 14, -- Max difference in opponents OVR needed to be considered an average team *Range* ( 14 )
		averageLow = 9, -- min difference in opponents OVR needed to be considered an average team *Range* ( 9 )
		small = 15, -- min difference in opponents OVR needed to be considered a poor challenge *Range* ( 15 )
		
		chanceFormStoryPerc = 50,
		chanceCpuPerc = 50,
		percThroughSeason_FormStories = 30,
		matchImportanceFixPerc = 25,
		importantMatchNewsWeight = 1000,
		-- morale
		moraleAffectWonDerby = 10,
		moraleAffectWonNonDerby = 5,
		moraleAffectLostDerby = -5,
		moraleAffectLostNonDerby = -2,
		--score
		scoreDiffTrashing = 7,
		scoreDiffEasily = 3,
		highScoreGoals = 3,
		thrillingGoals = 2,
		--news weights
		reverseFixturePreviewWeight = 900,
		reverseFixtureReviewWeight = 998,
		streakPreMatchNewsWeight = 650,
		streakPreMatchNewsWeightCpu = 600,
		streakPostMatchNewsWeight = 990,
		streakPostMatchNewsWeightCpu = 988,
		fiveGameFormNewsWeight = 550,
		fiveGameFormNewsWeightCpu = 500,
		topScorerNewsWeight = 300,
		startingElevenHomeNewsWeight = 15,
		startingElevenAwayNewsWeight = 5,
		
		earlySeasonThreshold = 25,
		earlyMidSeasonThreshold = 45,
		lateMidSeasonThreshold = 65,
		importanceOffsets = { 10, -10, 15, -15, 0 },
		fiveGamePointsLow = 5,
		fiveGamePointsGood = 11,
	}

-------------------------------------------------------------------------------------------------------------------------------
-- NEW SIGNING
-------------------------------------------------------------------------------------------------------------------------------
	local NEWSIGNING = {
		newSigningProgressDelay = 60, -- Number of days the follow up article appears after signing a new player. ( 60 )
		formRating = 59, -- Anything above this number is considered good form. (59)
		newSigningCooldown = 21, -- Min days before the story can be reactivated (21)
		minPlayerOvr = 50,
		percentageThroughSeason = 60,
		chancePercentage = 25,
		postMatchNewsWeight = 1000,
		progressNewsWeight = 100,
		formChangeNewsWeight = 100,
		goodFormRating = 70,
		poorFormRating = 50
	}

-------------------------------------------------------------------------------------------------------------------------------
-- LOST PLAYER & REPLACEMENT PLAYER
-------------------------------------------------------------------------------------------------------------------------------
	local LOSTPLAYER = {
		topTierPlayer = 2, -- Min level to be considered a top player (3)
		clubProgressDelay = 90, -- Day delay until the club's progress is reported on. (90)
		playerProgressDelay = 60, -- Day delay until the lost player's progress is reported on. (90)
		lostPlayerCoolDown = 21, -- Days before the story can be activated again. (21)
		summaryNewsPriority = 10,
		progressNewsPriority = 2,
		monthsJoinedThreshold = 4,
		teamMoraleModifier = -5,
		--Replacement Player Storyline
		minMonthsJoined = 6, -- Min amount of months a player must have been on the team before requesting to replace the lost player. (6)
		maxPlayerAge = 30, -- Maximum player age of a player that would make the request. (30)
		replacementMinDiff = 0, -- Minimum OVR difference between the player who could consider himself a worthy replacement (0)
		replacementMaxDiff = 15, -- Max OVR difference between the player who could consider himself a worthy replacement (15)
		chanceOfSecondBest = 50, -- Chnace the second best player will make the request instead of the next best. (50)
		replacementPlayerDelay = 2, -- Number of days after the player is lost the new player will make the request (2)
		replacementProgDelayLow = 60, -- Min delay until the players progress is reported(60)
		replacementProgDelayHigh = 90, -- Delay until the players progress is reported(90)
		replacementPlayerCoolDown = 21 -- Cool down before the player replaced story can be re-activated (21)
	}

-------------------------------------------------------------------------------------------------------------------------------
-- PLAYER FEELS REPLACED
-------------------------------------------------------------------------------------------------------------------------------
	local PFR = {
		chanceOfPfr = 100, -- Chance the story will begin after the pruchase of a new star (100)
		topNumPlayers = 15, -- Max number of players to check for a player that might feel replaced. (15)
		minMonthsOnTeam = 6, -- Minimum time a player must have been on the team for to be eligiable. (6)
		maxPlayerAge = 30, -- Max age a player would feel they could be replaced. (30)
		oldPlayerMinTier = 2, -- Only this tier and better will be selected for the story. (2)
		newUnderOldPlayerDiff = 3, -- Max differential between players if the old player has greater OVR than the new one. (5)
		newOverOldPlayerDiff = 10, -- Max differential between players if the old player has lesser OVR than the new one. (10)
		pfrCooldown = 21, -- Days needed before the story could trigger after ending. (21)
		pfrStartDelay = 2, -- Days after the new signing the first news article will appear. (2)
		minMatchImportanceStage2 = 85, -- Minimium match Importance for the player to consider himself left out of an important match. (85)
		newPlayerGoodRating = 60, -- Above this rating is considered a good match for the new signing which results in a news article. (60)
		pfrPlayerDecisionDelay = 30, -- Number of days after the player has said he is upset that you have to increase his morale before a transfer request. (30)
		minPercentageThroughSeason = 30,
		minPercentageThroughSeasonStage1 = 15,
		newsWeight = 100,
		moraleOverride = 12,
		happyMoraleModifier = 10,
		unhappyMoraleModifier = -10
	}

-------------------------------------------------------------------------------------------------------------------------------
-- RESERVE PLAYER REQUEST
-------------------------------------------------------------------------------------------------------------------------------
	local RESERVE = {
		numDaysBeforeStart = 0, -- Number od days before the match the player will ask to be played. (0)
		minMatchImportance = 70, -- Maximum match importance the player will request to be played in. (70)
		chanceToStart = 50, -- Chance the player will ask to be play. (100)
		minPlayerTier = 3, -- Only less than this tier is allowed to request to play. (3)
		reserveRequestCooldown = 21, -- Days until story can re-fire. (21)
		goodPlayerRating = 59, -- Player rating the story considers a good performance. (59)
		minPlayerPotential = 75, -- Min player potential required to announce the player has a high potential. (75)
		newsWeight = 1000,
		moraleModifierGoal = 5,
		moraleModifierArticle = 20
	}

-------------------------------------------------------------------------------------------------------------------------------
-- STAR IN POOR FORM
-------------------------------------------------------------------------------------------------------------------------------
	local POORFORM = {
		playersToCheck = 5, -- Max players to check on the team decending by OVR (5)
		minTier = 1, --Min tier required to enter story (1)
		poorRating = 50, -- anything below this is considered a poor match (70)
		minStreak = 5, -- minimum amount of poor games in a row before the story will begin to talk about the player. (5)
		minStreakForPlayerMorale = 10, -- minimum amount of poor games in a row before player morale is reduced
		storyPriority = 2,
		chancePressCoversPerc = 30,
		moraleOverride = 11,
		moraleModifier = 10,
		releasedNewsWeight = 1,
		loanListedNewsWeight = 1,
		transferListedNewsWeight = 1,
		postMatchReviewWeight = 999,
		newSigningReviewWeight = 2,
		noGoalPreMatchNewsWeight = 4,
		poorFormPreMatchNewsWeight = 3,
		newSigningNewsWeight = 2,
		preMatchNoGoalsNewsWeight = 1
	}

-------------------------------------------------------------------------------------------------------------------------------
-- COUNTER OFFER
-------------------------------------------------------------------------------------------------------------------------------
	local NEGOTIATE = {
		negotiateCooldown = 21, -- Number of days before the negotiation story can re-trigger.
		newsWeight = 1,
		maxCounterOfferPlayerTier = 3
	}

-------------------------------------------------------------------------------------------------------------------------------
-- PLAYER OBJECTIVES
-------------------------------------------------------------------------------------------------------------------------------
	local PAPOBJECTIVES = {
		startMonthsDelay = 2, -- Number of months after the season ends to display the story. (2)
		gamesBeforeEOS = 0 -- Number of games remaining when the news checks if you are meeting your objectives. (0)
	}

-------------------------------------------------------------------------------------------------------------------------------
-- WEAK SPOT
-------------------------------------------------------------------------------------------------------------------------------
	local WEAKSPOT = {
		numberOfDays = 40, -- Number of days before the transfer window the fans will begin to demand a weak spot be filled (40)
		chanceToStart = 50, -- Chance to begin the story (50)
		chanceToStartHigh = 100, -- Chance to begin the story if you are signifagantly underachieving(100)
		weakSpotCooldown = 21, -- Time before story can be reactivated (21)
		numPlayers = 20, -- Number of players the story searches through to find a weak spot. (20)
		daysBeforeWindow = 0, -- Number of days before the window the board demands a new player be purchased. (0)
		chanceBoardWantsPlayer = 50, -- Chance the board wants you to buy a player (30)
		chanceBoardWantsPlayerHigh = 50, -- Chance the board wants you to buy a player if you are signifagantly underachieving (30)
		daysbeforePurchase = 5, -- Days before end of window the board will purchase a player for you. (5)
		chanceBoardBuys = 5, -- Chance the board will buy the player for you (15)
		chanceBoardBuysHigh = 30, -- Chance the board will buy a player if you are signifagantly underachieving (30)
		teamPositionThreshold = 4, -- Team position should be higher than this to start story
		newsWeight = 999,
		storyPriority = 5,
		daysBetweenStage1Stage2 = 15,
		playerAgeThreshold = 31, -- Player age threshold for Stage 2
		maxTransferFundsBudgetRatio = 50,
		maxPlayersInSquad = 35,
		numOffersForReplacement = 3
	}

-------------------------------------------------------------------------------------------------------------------------------
-- OVERPRICED AND UNDERPRICED DEAL
-------------------------------------------------------------------------------------------------------------------------------
	local OVERPRICED = {
		differenceLesser = 60,  -- If offer is less than this percent of the players actual value the deal will be considered underpriced. (60)
		differenceGreater = 150, -- If an offer is greater than this percent of the players value it is considered overpriced (150)
		overpricedOldAge = 28, -- Any age older than this is considered old, and under young. (28)
		overPricedCooldown = 21, -- Number of days before this story can be triggered again after completion. (21)
		newsWeight = 999,
		minPercentageThroughSeason = 30
	}

-------------------------------------------------------------------------------------------------------------------------------
-- PLAYER CRITICIZES
-------------------------------------------------------------------------------------------------------------------------------
	local CRITICIZE = {
		maxNumDays = 0, -- Number of days before the next match the player will criticize the squad selection. (0)
		minMatchImportance = 85, --Min match importance required for the player to be upset (85)
		minPlayerTier = 2, -- Minimum quality of player allowed to enter the story (2)
		chanceOfStarting = 100, -- Chance the player will suggest to be played over another player (100)
		criticizeCooldown = 21,  -- days before story can begin again. (21)
		playerOvrDifference = 10, -- OVR difference required between a criticizing player and a weaker starting player. (10)
		chanceOfCriticize = 100, -- Chance the player will openly speak out to the press about you. (100)
		chanceToRequestTransfer = 100, -- Chance if the player continues to be upset he will demand a transfer. (100)
		minMonthsToCriticize = 4,
		moraleModifierWinner = 10,
		moraleModifierLoser = -10,
		moraleModifierStage2 = -20
	}

-------------------------------------------------------------------------------------------------------------------------------
-- FORM STORIES
-------------------------------------------------------------------------------------------------------------------------------
	local FORMSTORIES = {
		playerCountHigh = 11, -- Max number of players to look at for pre-match form stories. (11)
		newsWeight = 400,
		newsWeightStep = 50
	}

-------------------------------------------------------------------------------------------------------------------------------
-- PLAYER VS FORMER TEAM
-------------------------------------------------------------------------------------------------------------------------------
	local FORMERTEAM = {
		numDaysBefore = 0, -- Number of days before the next match the press covers the story,
		preMatchPreviewWeight = 450,
		preMatchDerbyPreviewWeight = 400,
		postMatchWeight = 100,
		postMatchResultWeight = 90,
		moraleModifierWinner = 5,
		moraleModifierLoser = -5
	}

-------------------------------------------------------------------------------------------------------------------------------
-- PLAYER REQUEST
-------------------------------------------------------------------------------------------------------------------------------
	local REQUEST = {
		topTier = 3, -- Above this is considered top tier.
		newsWeight = 2
	}

-------------------------------------------------------------------------------------------------------------------------------
-- FREAK INJURIES
-------------------------------------------------------------------------------------------------------------------------------
	local FREAKINJURY = {
		chanceOfInjury = 15, -- Chance per month that a freak injury will occur. (50)
		chanceOfUser = 10, -- Chance the injury will affect the user team. (15)
		storyStartDelayLow = 1, -- Min number of days after the 1st of the month the story can appear in the news. (1)
		storyStartDelayHigh = 28, -- Max number of days after the 1st of the month the story can appear in the news. (28)
		freakInjuryCooldown = 60 -- min days before the story can be triggered again (21)
	}

-------------------------------------------------------------------------------------------------------------------------------
-- JOB OFFERS
-------------------------------------------------------------------------------------------------------------------------------
	local JOBOFFERS = {
		--International Manager Rumours
		monthsToStart = 2, -- Number of months into the game rumours might appear with international job rumours. (2)
		chance = 100, -- Chance the story would begin rumouring. (100)
		teamOvrToPublish = 75,
		baseNewsWeight = 100,
		minManagerPopularity = 40
	}

-------------------------------------------------------------------------------------------------------------------------------
-- NEW JOB
-------------------------------------------------------------------------------------------------------------------------------
	local NEWJOB = {
		storyCooldown = 21,
		storyCooldownInt = 10000,
		percThroughSeason_News_OldTeam = 30,
		domPrestigeWeight = 0.75,
		prestigeThreshold = 8.75
	}

-------------------------------------------------------------------------------------------------------------------------------
-- NEWS
-------------------------------------------------------------------------------------------------------------------------------
	local NEWS = {
		playerTier = 3, -- Less than this teir will be considered a star for that team by the press ( 3 )
		teamOvr = 80, -- Required team Ovr to make the headlines, applies to players as well ( 80 )
		previewWeight = 17,
		reviewWeight = 1,
		maxPreviewBuildLength = 2600,
		maxReviewBuildLength = 2500
	}

-------------------------------------------------------------------------------------------------------------------------------
-- FOULLANGUAGE
-------------------------------------------------------------------------------------------------------------------------------
	local FOULLANGUAGE = {
		daysToEndStory = 60,
		daysToEmail = 2,
		PapSelectionOverride = -1000
	}

-------------------------------------------------------------------------------------------------------------------------------
-- SUSPENSIONS
-------------------------------------------------------------------------------------------------------------------------------
	local SUSPENSIONS = {
		topPlayerSuspensionNewsWeight = 50,
		suspensionCrisisNewsWeight = 20,
		maxNumSuspensionsToUpdateStory = 5
	}

-------------------------------------------------------------------------------------------------------------------------------
-- MISC FUNCTIONS
-------------------------------------------------------------------------------------------------------------------------------
	local MISC = {
		-- Too Big For Team
		ovrDiff_BestPlayer = 2, -- Min difference from the top player to the second best player to consider himself too big ( 2 )
		topPlayerCount = 5, -- Number of players organized in decending Overall ratings considered "Top Players"( Other than the 1st ranked player ) ( 5 )
		potDiff_TopPlayers = 5,  -- Min difference in potential from a top five player to the best player to consider himself too big ( 5 )
		-- UnderPaid
		rankDifference = 3,  -- Min difference from a top five player to the best player to consider himself underpaid ( 3 )
		maxAge = 30, -- Less than or equal to this will allow a player to feel underpaid ( 30 )
		--Offer Contract
		contPerc = 25, -- % Required wage Increase to resign after asking for a transfer ( 25 )
		-- Would Player Leave
		numDaysInjured = 14, -- any greater days left on his injury than this and he will not ask to leave ( 14 )
		numYearsOnTeam = 2, -- Must be on the team less than these many years to consider leaving ( 6 )
		playerAge = 34, -- Player must be younger or equal to this number to hand in a transfer request ( 34 )
		monthsJoined = 24, -- Min Months On Team Needed before handing in a transfer request ( 12 )
		
		highTeamIds = { 11, 10, 73, 243, 5, 241, 21, 45 },
	}

	-- exported tuning tables
	return {
		LMTR = LMTR,
		FOREIGN = FOREIGN,
		REBEL = REBEL,
		UWW = UWW,
		PTM = PTM,
		INJURY = INJURY,
		OFTF = OFTF,
		FATIGUE = FATIGUE,
		INVESTOR = INVESTOR,
		FORM = FORM,
		LOANLIST = LOANLIST,
		ONBENCH = ONBENCH,
		RETIRE = RETIRE,
		PREVIEW = PREVIEW,
		MATCHINCIDENT = MATCHINCIDENT,
		STUPID = STUPID,
		PRESS = PRESS,
		LISTED = LISTED,
		TRANSFERS = TRANSFERS,
		IMP = IMP,
		NEWSIGNING = NEWSIGNING,
		LOSTPLAYER = LOSTPLAYER,
		PFR = PFR,
		RESERVE = RESERVE,
		POORFORM = POORFORM,
		NEGOTIATE = NEGOTIATE,
		PAPOBJECTIVES = PAPOBJECTIVES,
		WEAKSPOT = WEAKSPOT,
		OVERPRICED = OVERPRICED,
		CRITICIZE = CRITICIZE,
		FORMSTORIES = FORMSTORIES,
		FORMERTEAM = FORMERTEAM,
		REQUEST = REQUEST,
		FREAKINJURY = FREAKINJURY,
		JOBOFFERS = JOBOFFERS,
		NEWJOB = NEWJOB,
		NEWS = NEWS,
		FOULLANGUAGE = FOULLANGUAGE,
		SUSPENSIONS = SUSPENSIONS,
		MISC = MISC
	}
end)()

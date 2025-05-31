-------------------------------- MODULE CPBL --------------------------------

(* B: CTBC Brothers     *)
(* L: Uni Lions         *)
(* G: Fubon Guardians   *)
(* R: Rakuten Monkeys   *)

EXTENDS Integers, Sequences

(* Teams        : Names of all teams in the league      *)
(* TotalGames   : Number of games in the half season    *)
(* Winner       : Winner of the first-half season       *)
(* Schedule     : List of upcoming games                *)

CONSTANT Teams, TotalGames, Winner, Schedule

(* SecondHalfStandings  : Standings of each team in the second-half season                              *)
(* AllStandings         : Standings of each team in the overall season                                  *)
(* SecondHalfHeadToHead : Head-to-head standings between each pair of teams in the second-half season   *)
(* AllHeadToHead        : Head-to-head standings between each pair of teams in the overall season       *)
(* GameIndex            : Index used to enumerate over the schedule                                     *)
VARIABLES SecondHalfStandings, AllStandings, SecondHalfHeadToHead, AllHeadToHead, GameIndex

(* FirstHalfStandings   : Standings of each team in the first-half season   *)
FirstHalfStandings ==
    [team \in Teams |->
        CASE team = "B" -> [win |-> 37, lose |-> 23, tie |-> 0]
          [] team = "L" -> [win |-> 26, lose |-> 34, tie |-> 0]
          [] team = "G" -> [win |-> 23, lose |-> 37, tie |-> 0]
          [] team = "R" -> [win |-> 34, lose |-> 26, tie |-> 0]
    ]

(* FirstHalfHeadToHead  : Head-to-head standings between each pair of teams in the first-half season    *)
FirstHalfHeadToHead ==
    [t1 \in Teams |->
        [t2 \in Teams |->
            CASE <<t1, t2>> = <<"B", "L">> -> [win |-> 16, lose |-> 4, tie |-> 0]
              [] <<t1, t2>> = <<"B", "G">> -> [win |-> 13, lose |-> 7, tie |-> 0]
              [] <<t1, t2>> = <<"B", "R">> -> [win |-> 8, lose |-> 12, tie |-> 0]
              [] <<t1, t2>> = <<"L", "B">> -> [win |-> 4, lose |-> 16, tie |-> 0]
              [] <<t1, t2>> = <<"L", "G">> -> [win |-> 11, lose |-> 9, tie |-> 0]
              [] <<t1, t2>> = <<"L", "R">> -> [win |-> 11, lose |-> 9, tie |-> 0]
              [] <<t1, t2>> = <<"G", "B">> -> [win |-> 7, lose |-> 13, tie |-> 0]
              [] <<t1, t2>> = <<"G", "L">> -> [win |-> 9, lose |-> 11, tie |-> 0]
              [] <<t1, t2>> = <<"G", "R">> -> [win |-> 7, lose |-> 13, tie |-> 0]
              [] <<t1, t2>> = <<"R", "B">> -> [win |-> 12, lose |-> 8, tie |-> 0]
              [] <<t1, t2>> = <<"R", "L">> -> [win |-> 9, lose |-> 11, tie |-> 0]
              [] <<t1, t2>> = <<"R", "G">> -> [win |-> 13, lose |-> 7, tie |-> 0]
              [] OTHER                     -> [win |-> 0, lose |-> 0, tie |-> 0]
        ]
    ]

Init ==
    /\ SecondHalfStandings = 
        [team \in Teams |-> 
            CASE team = "B" -> [win |-> 27, lose |-> 27, tie |-> 2]
              [] team = "L" -> [win |-> 30, lose |-> 26, tie |-> 1]
              [] team = "G" -> [win |-> 29, lose |-> 26, tie |-> 1]
              [] team = "R" -> [win |-> 25, lose |-> 32, tie |-> 0]
        ]
    /\ AllStandings = 
        [team \in Teams |-> [
            win  |-> FirstHalfStandings[team].win  + SecondHalfStandings[team].win,
            lose |-> FirstHalfStandings[team].lose + SecondHalfStandings[team].lose,
            tie  |-> FirstHalfStandings[team].tie  + SecondHalfStandings[team].tie]
        ]
    /\ SecondHalfHeadToHead = 
        [t1 \in Teams |->
            [t2 \in Teams |->
                CASE <<t1, t2>> = <<"B", "L">> -> [win |-> 6, lose |-> 12, tie |-> 1]
                  [] <<t1, t2>> = <<"B", "G">> -> [win |-> 9, lose |-> 9, tie |-> 1]
                  [] <<t1, t2>> = <<"B", "R">> -> [win |-> 12, lose |-> 6, tie |-> 0]
                  [] <<t1, t2>> = <<"L", "B">> -> [win |-> 12, lose |-> 6, tie |-> 1]
                  [] <<t1, t2>> = <<"L", "G">> -> [win |-> 8, lose |-> 10, tie |-> 0]
                  [] <<t1, t2>> = <<"L", "R">> -> [win |-> 10, lose |-> 10, tie |-> 0]
                  [] <<t1, t2>> = <<"G", "B">> -> [win |-> 9, lose |-> 9, tie |-> 1]
                  [] <<t1, t2>> = <<"G", "L">> -> [win |-> 10, lose |-> 8, tie |-> 0]
                  [] <<t1, t2>> = <<"G", "R">> -> [win |-> 10, lose |-> 9, tie |-> 0]
                  [] <<t1, t2>> = <<"R", "B">> -> [win |-> 6, lose |-> 12, tie |-> 0]
                  [] <<t1, t2>> = <<"R", "L">> -> [win |-> 10, lose |-> 10, tie |-> 0]
                  [] <<t1, t2>> = <<"R", "G">> -> [win |-> 9, lose |-> 10, tie |-> 0]
                  [] OTHER                     -> [win |-> 0, lose |-> 0, tie |-> 0]
            ]
        ]
    /\ AllHeadToHead = 
        [t1 \in Teams |->
            [t2 \in Teams |->[
                win  |-> FirstHalfHeadToHead[t1][t2].win  + SecondHalfHeadToHead[t1][t2].win,
                lose |-> FirstHalfHeadToHead[t1][t2].lose + SecondHalfHeadToHead[t1][t2].lose,
                tie  |-> FirstHalfHeadToHead[t1][t2].tie  + SecondHalfHeadToHead[t1][t2].tie]
            ]
        ]
    /\ GameIndex = 1

CurrentGame == IF GameIndex <= Len(Schedule) THEN Schedule[GameIndex] ELSE Schedule[1]

Team1 == CurrentGame[1]
Team2 == CurrentGame[2]
   
GameWin(X, Y) ==
    /\ SecondHalfStandings' = [SecondHalfStandings EXCEPT
        ![X].win  = @ + 1,
        ![Y].lose = @ + 1
       ]
    /\ AllStandings' = [AllStandings EXCEPT
        ![X].win  = @ + 1,
        ![Y].lose = @ + 1
       ]
    /\ SecondHalfHeadToHead' = [SecondHalfHeadToHead EXCEPT
        ![X][Y].win = @ + 1,
        ![Y][X].lose = @ + 1
       ]
    /\ AllHeadToHead' = [AllHeadToHead EXCEPT
        ![X][Y].win = @ + 1,
        ![Y][X].lose = @ + 1
       ]
           
GameLose(X, Y) == GameWin(Y, X)

GameTie(X, Y) ==
    /\ SecondHalfStandings' = [SecondHalfStandings EXCEPT
        ![X].tie = @ + 1,
        ![Y].tie = @ + 1
       ]
    /\ AllStandings' = [AllStandings EXCEPT
        ![X].tie = @ + 1,
        ![Y].tie = @ + 1
       ]
    /\ SecondHalfHeadToHead' = [SecondHalfHeadToHead EXCEPT
        ![X][Y].tie = @ + 1,
        ![Y][X].tie = @ + 1
       ]
    /\ AllHeadToHead' = [AllHeadToHead EXCEPT
        ![X][Y].tie = @ + 1,
        ![Y][X].tie = @ + 1
       ]

TerminationCondition == GameIndex > Len(Schedule)

\* Team X eliminates Team Y if:
\* Case 1: X's win rate is greater than Y's, or
\* Case 2: Their win rates are equal, but X has a better head-to-head record.
XEliminatesY(TG, X, Y, XWinY, YWinX) ==
    \/ X.win * (TG - Y.tie) > (TG - Y.lose - Y.tie) * (TG - X.tie)
    \/  /\ X.win * (TG - Y.tie) = (TG - Y.lose - Y.tie) * (TG - X.tie)
        /\ XWinY > YWinX

\* Assumption: A beats B
\* Check if Team X eliminates Team Y in the second-half season
SecondHalfEliminates(X, Y, A, B) == 
    LET
        XStandings == [SecondHalfStandings[X] EXCEPT
            !.win = IF A = X THEN SecondHalfStandings[X].win + 1 ELSE SecondHalfStandings[X].win,
            !.lose = IF B = X THEN SecondHalfStandings[X].lose + 1 ELSE SecondHalfStandings[X].lose
        ]
        YStandings == [SecondHalfStandings[Y] EXCEPT
            !.win = IF A = Y THEN SecondHalfStandings[Y].win + 1 ELSE SecondHalfStandings[Y].win,
            !.lose = IF B = Y THEN SecondHalfStandings[Y].lose + 1 ELSE SecondHalfStandings[Y].lose
        ]
        XWinY == IF A = X /\ B = X THEN SecondHalfHeadToHead[X][Y].win + 1 ELSE SecondHalfHeadToHead[X][Y].win
        YWinX == IF A = Y /\ B = Y THEN SecondHalfHeadToHead[Y][X].win + 1 ELSE SecondHalfHeadToHead[Y][X].win
    IN
        XEliminatesY(TotalGames, XStandings, YStandings, XWinY, YWinX)

\* Assumption: A ties with B
\* Check if Team X eliminates Team Y in the second-half season
SecondHalfEliminatesTie(X, Y, A, B) == 
    LET
        XStandings == [SecondHalfStandings[X] EXCEPT
            !.tie = IF (A = X \/ B = X) THEN SecondHalfStandings[X].tie + 1 ELSE SecondHalfStandings[X].tie
        ]
        YStandings == [SecondHalfStandings[Y] EXCEPT
            !.tie = IF (A = Y \/ B = Y) THEN SecondHalfStandings[Y].tie + 1 ELSE SecondHalfStandings[Y].tie
        ]
        XWinY == SecondHalfHeadToHead[X][Y].win
        YWinX == SecondHalfHeadToHead[Y][X].win
    IN
        XEliminatesY(TotalGames, XStandings, YStandings, XWinY, YWinX)

\* Assumption: A beats B
\* Check if Team X eliminates Team Y in the overall season
AllEliminates(X, Y, A, B) == 
    LET
        XStandings == [AllStandings[X] EXCEPT
            !.win = IF A = X THEN AllStandings[X].win + 1 ELSE AllStandings[X].win,
            !.lose = IF B = X THEN AllStandings[X].lose + 1 ELSE AllStandings[X].lose
        ]
        YStandings == [SecondHalfStandings[Y] EXCEPT
            !.win = IF A = Y THEN AllStandings[Y].win + 1 ELSE AllStandings[Y].win,
            !.lose = IF B = Y THEN AllStandings[Y].lose + 1 ELSE AllStandings[Y].lose
        ]
        XWinY == IF A = X /\ B = X THEN AllHeadToHead[X][Y].win + 1 ELSE AllHeadToHead[X][Y].win
        YWinX == IF A = Y /\ B = Y THEN AllHeadToHead[Y][X].win + 1 ELSE AllHeadToHead[Y][X].win
    IN
        XEliminatesY(TotalGames * 2, XStandings, YStandings, XWinY, YWinX)

\* Assumption: A ties with B
\* Check if Team X eliminates Team Y in the overall season
AllEliminatesTie(X, Y, A, B) == 
    LET
        XStandings == [SecondHalfStandings[X] EXCEPT
            !.tie = IF (A = X \/ B = X) THEN AllStandings[X].tie + 1 ELSE AllStandings[X].tie
        ]
        YStandings == [SecondHalfStandings[Y] EXCEPT
            !.tie = IF (A = Y \/ B = Y) THEN AllStandings[Y].tie + 1 ELSE AllStandings[Y].tie
        ]
        XWinY == AllHeadToHead[X][Y].win
        YWinX == AllHeadToHead[Y][X].win
    IN
        XEliminatesY(TotalGames * 2, XStandings, YStandings, XWinY, YWinX)

\* Assumption: A beats B
\* Team X is eliminated from the second half season if
\* there exists another opponent team that would definitely have a better win rate than X
SecondHalfEliminatedIfAWinB(X, A, B) ==
    \E oppo \in Teams:
        SecondHalfEliminates(oppo, X, A, B)
 
\* Assumption: A beats B
\* Team X is eliminated from the overall season if
AllEliminatedIfAWinB(X, A, B) ==
    \* The winner of the first-half season will not be eliminated in the overall season
    /\ X # Winner
        \* Case 1: If neither the winner team nor X can win the second half, and X can't have the best overall records, or
    /\  \/  /\ \E oppo1 \in Teams:
                    SecondHalfEliminates(oppo1, Winner, A, B)
            /\ \E oppo2 \in Teams:
                    SecondHalfEliminates(oppo2, X, A, B)
            /\ \E oppo3 \in Teams:
                    AllEliminates(oppo3, X, A, B)
        \* Case 2: If the first half winner team also wins the second half and X can't win the second or the third place in the whole season
        \/  /\ \A oppo4 \in Teams:
                    SecondHalfEliminates(Winner, oppo4, A, B)
            /\ \E oppo5 \in (Teams \ {Winner}):
                    \E oppo6 \in (Teams \ {Winner, oppo5}):
                        AllEliminates(oppo5, X, A, B) /\ AllEliminates(oppo6, X, A, B)

\* Assumption: A ties with B
\* Team X is eliminated from the second half season if
\* there exists another opponent team that would definitely have a better win rate than X
SecondHalfEliminatedIfATieB(X, A, B) ==
    \E oppo \in Teams:
        SecondHalfEliminatesTie(oppo, X, A, B)

\* Assumption: A ties with B
\* Team X is eliminated from the overall season if
AllEliminatedIfATieB(X, A, B) == 
    \* The winner of the first-half season will not be eliminated in the overall season
    /\ X # Winner
        \* Case 1: If neither the winner team nor X can win the second half, and X can't have the best overall records, or
    /\  \/  /\ \E oppo1 \in Teams:
                    SecondHalfEliminatesTie(oppo1, Winner, A, B)
            /\ \E oppo2 \in Teams:
                    SecondHalfEliminatesTie(oppo2, X, A, B)
            /\ \E oppo3 \in Teams:
                    AllEliminatesTie(oppo3, X, A, B)
        \* Case 2: If the first half winner team also wins the second half and X can't win the second or the third place in the whole season
        \/  /\ \A oppo4 \in Teams:
                    SecondHalfEliminatesTie(Winner, oppo4, A, B)
            /\ \E oppo5 \in (Teams \ {Winner}):
                    \E oppo6 \in (Teams \ {Winner, oppo5}):
                        AllEliminatesTie(oppo5, X, A, B) /\ AllEliminatesTie(oppo6, X, A, B)

\* Check if team X beats team Y, team X is eliminated in both the second half and overall season
WinButEliminated(X, Y) ==
    /\ SecondHalfEliminatedIfAWinB(X, X, Y)
    /\ AllEliminatedIfAWinB(X, X, Y)

\* Check if team X ties with or loses to team Y, team X is still not eliminated in either the second half or overall season
TieOrLoseButNotEliminated(X, Y) ==
    \/ ~SecondHalfEliminatedIfAWinB(X, Y, X)
    \/ ~AllEliminatedIfAWinB(X, Y, X)
    \/ ~SecondHalfEliminatedIfATieB(X, X, Y)
    \/ ~AllEliminatedIfATieB(X, X, Y)

\* It should not be the case that
\* team X will be eliminated from the playoffs if it beats team Y and
\* team X will still have a chance to advance if it ties with or loses to team Y
WantToWin(X, Y) ==
    ~(WinButEliminated(X, Y) /\ TieOrLoseButNotEliminated(X, Y))

Next == 
    /\ ~TerminationCondition
    /\  \/ GameWin(Team1, Team2)
        \/ GameLose(Team1, Team2)
        \/ GameTie(Team1, Team2)
    /\ GameIndex' = GameIndex + 1

Invariant1 == WantToWin(Team1, Team2)
Invariant2 == WantToWin(Team2, Team1)    
    
=============================================================================
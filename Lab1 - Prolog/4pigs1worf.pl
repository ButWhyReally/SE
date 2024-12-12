name(nif). 
name(nyf).
name(naf).
name(wolf).

item(sports).
item(fauna).
item(flora).
item(space).

position(0).
position(1).
position(2).
position(3).

likes(wolf, fauna).
should_collect_if_likes(Name, Item) :-
    name(Name), item(Item), 
    not(likes(Name, _));
    name(Name), item(Item),
    likes(Name, Item).

dislikes(nyf, sports).
shouldnt_collect_if_dislikes(Name, Item) :-
    not(dislikes(Name, Item)).


sitting_n_seets_away(Name, Neighbour, InBetween,
           Name0, Pos0, Name1,  Pos1, 
           Name2, Pos2, Name3, Pos3) :-
    position(NamePos), find_associative4(Name, NamePos, Pos0, Name0, Pos1, Name1, 
                                         Pos2, Name2, Pos3, Name3),
    position(NeighbourPos), find_associative4(Neighbour, NeighbourPos, Pos0, Name0, Pos1, Name1,
                                          Pos2, Name2, Pos3, Name3),
    TargetPos is (NamePos + InBetween) mod 4,
    NeighbourPos = TargetPos, !.


to_left(wolf, naf).
should_sit_to_the_left(Name, Name0, Pos0, Name1, 
                       Pos1, Name2, Pos2, Name3, Pos3) :-
    not(to_left(Name, _));
 	to_left(Name, Neighbour),
    sitting_n_seets_away(Name, Neighbour, -1, Name0, Pos0, Name1, 
                         Pos1, Name2, Pos2, Name3, Pos3), !.
   	
to_right(nif, space).
should_sit_to_the_right(Name, Name0, Pos0, Item0, 
                              Name1, Pos1, Item1,
                              Name2, Pos2, Item2,
                        	  Name3, Pos3, Item3) :-
   	not(to_right(Name, _)), !;
    to_right(Name, NeighbourItem),
   	name(Neighbour), find_associative4(NeighbourItem, Neighbour,
                                       Name0, Item0, Name1, Item1, Name2, Item2,
                                       Name3, Item3),
    sitting_n_seets_away(Name, Neighbour, 1, Name0, Pos0, Name1, Pos1,
                         Name2, Pos2, Name3, Pos3), !.
    
opposite(nyf, naf).
should_sit_on_opposite_side(Name, Name0, Pos0, Name1, Pos1,
                       Name2, Pos2, Name3, Pos3) :-
    not(opposite(Name, _)), !;
    opposite(Name, Neighbour),
    sitting_n_seets_away(Name, Neighbour, 2, Name0, Pos0, Name1, Pos1,
                         Name2, Pos2, Name3, Pos3), !.


n_positions_forward(Position, N, Next) :- 
	position(Position), position(Next), Target is (Position + N) mod 4, Next = Target, !.


pick_continue4(Result0, Result1, Result2, Result3, Level) :-
    Next is Level + 1,
    Next > 3;
    Next is Level + 1,
    Next < 4,
    pick_unique_impl4(Result1, Result2, Result3, Result0, Next).

pick_unique_impl4(Result0, Result1, Result2, Result3, Level) :-
    Result0 \= Result1, Result0 \= Result2, Result0 \= Result3,
    pick_continue4(Result0, Result1, Result2, Result3, Level).

pick_unique4(Result0, Result1, Result2, Result3) :- 
   	Level is 0,
    pick_unique_impl4(Result0, Result1, Result2, Result3, Level).


find_associative_continue4(Level, Target, Result, Elem0, Val0, Elem1, Val1, 
                           Elem2, Val2, Elem3, Val3) :-
    Next is Level + 1,
    Next < 4, 
    find_associative_impl4(Next, Target, Result, Elem1, Val1, Elem2, Val2,
                             Elem3, Val3, Elem0, Val0).
    
find_associative_impl4(Level, Target, Result, Elem0, Val0, Elem1, Val1, 
                       Elem2, Val2, Elem3, Val3) :-
    Val0 = Target, Result = Elem0, !; % <- do nothing if false
    find_associative_continue4(Level, Target, Result, Elem0, Val0, Elem1, Val1, 
                                 Elem2, Val2, Elem3, Val3).

find_associative4(Target, Result, Elem0, Val0, Elem1, Val1,
                  Elem2, Val2, Elem3, Val3) :-
	find_associative_impl4(0, Target, Result, Elem0, Val0, Elem1, Val1,
                             Elem2, Val2, Elem3, Val3).

solution(Name0, Pos0, Item0, 
         Name1, Pos1, Item1,
         Name2, Pos2, Item2,
         Name3, Pos3, Item3) :-
    should_sit_to_the_left(Name0, Name0, Pos0, Name1, Pos1, Name2, Pos2, Name3, Pos3),
    should_sit_to_the_left(Name1, Name0, Pos0, Name1, Pos1, Name2, Pos2, Name3, Pos3),
    should_sit_to_the_left(Name2, Name0, Pos0, Name1, Pos1, Name2, Pos2, Name3, Pos3),
    should_sit_to_the_left(Name3, Name0, Pos0, Name1, Pos1, Name2, Pos2, Name3, Pos3),
    
    
    should_sit_to_the_right(Name0, Name0, Pos0, Item0, 
                              Name1, Pos1, Item1,
                              Name2, Pos2, Item2,
                        	  Name3, Pos3, Item3),
    should_sit_to_the_right(Name1, Name0, Pos0, Item0, 
                              Name1, Pos1, Item1,
                              Name2, Pos2, Item2,
                        	  Name3, Pos3, Item3),
    should_sit_to_the_right(Name2, Name0, Pos0, Item0, 
                              Name1, Pos1, Item1,
                              Name2, Pos2, Item2,
                        	  Name3, Pos3, Item3),
    should_sit_to_the_right(Name3, Name0, Pos0, Item0, 
                              Name1, Pos1, Item1,
                              Name2, Pos2, Item2,
                        	  Name3, Pos3, Item3),
    
    should_sit_on_opposite_side(Name0, Name0, Pos0, Name1, Pos1, Name2, Pos2, Name3, Pos3),
    should_sit_on_opposite_side(Name1, Name0, Pos0, Name1, Pos1, Name2, Pos2, Name3, Pos3),
    should_sit_on_opposite_side(Name2, Name0, Pos0, Name1, Pos1, Name2, Pos2, Name3, Pos3),
    should_sit_on_opposite_side(Name3, Name0, Pos0, Name1, Pos1, Name2, Pos2, Name3, Pos3),
    
    should_collect_if_likes(Name0, Item0),
    should_collect_if_likes(Name1, Item1),
    should_collect_if_likes(Name2, Item2),
    should_collect_if_likes(Name3, Item3),

    shouldnt_collect_if_dislikes(Name0, Item0),
	shouldnt_collect_if_dislikes(Name1, Item1),
    shouldnt_collect_if_dislikes(Name2, Item2),
    shouldnt_collect_if_dislikes(Name3, Item3).
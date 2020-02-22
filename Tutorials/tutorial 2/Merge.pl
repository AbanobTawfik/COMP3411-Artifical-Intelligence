% Write a predicate merge(Sort1, Sort2, Sort) which takes two lists 
% Sort1 and Sort2 that are already sorted in increasing order, 
% and binds Sort to a new list which combines the elements from Sort1 and Sort2 , 
% and is sorted in increasing order.

merge([], [], []).
merge([H|T], [], [H|T]).
merge([], [H|T], [H|T]).

merge([H|T], [H1|T1], [H | Tail]) :-
    H =< H1,
    merge(T, [H1|T1], Tail).

merge([H|T], [H1|T1], [H1 | Tail]) :-
    H > H1,
    merge([H|T], T1, Tail).

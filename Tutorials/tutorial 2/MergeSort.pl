% Write a predicate mergesort(List, NewList) which has the same functionality
% as the isort/2 predicate from part 2 above, but uses the MergeSort algorithm. 
% Hint: you will need to use the split/3 and merge/3 predicates from parts 3 and 4 above.

mergesort([], []).
mergesort([H], [H]).
mergesort([H1, H2 |[]],[H1, H2 |[]]) :-
    H1 =< H2.
mergesort([H1, H2 |[]],[H2, H1 |[]]) :-
    H1 > H2.
mergesort(List, NewList) :-
    split(List, List1, List2),
    mergesort(List1, SortedList1),
    mergesort(List2, SortedList2),
    merge(SortedList1, SortedList2, NewList).

split([], [], []). 
split([H|[]], [H], []).

split([H, N|T], [H|New1], [N| New2]) :- 
    split(T, New1, New2).

merge([], [], []).
merge([H|T], [], [H|T]).
merge([], [H|T], [H|T]).

merge([H|T], [H1|T1], [H | Tail]) :-
    H =< H1,
    merge(T, [H1|T1], Tail).

merge([H|T], [H1|T1], [H1 | Tail]) :-
    H > H1,
    merge([H|T], T1, Tail).

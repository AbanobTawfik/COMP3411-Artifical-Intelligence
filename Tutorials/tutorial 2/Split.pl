% Write a predicate split(BigList, List1, List2) which takes 
% a list BigList and divides the items into two smaller lists 
% List1 and List2 , as evenly as possible 
% (i.e. so that the number of items in List1 and List2 differs by no more that 1). 
% Can it be done without measuring the length of the list?

split([], [], []). 
split([H|[]], [H], []).

split([H, N|T], [H|New1], [N| New2]) :- 
    split(T, New1, New2).

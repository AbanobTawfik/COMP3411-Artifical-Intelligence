%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMP3411 Assignment One 2019 Term 1     %
% This code was written by Abanob Tawfik  %
% z5075490                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%% Question 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sumsq_even function that takes the sum of the square value of only even numbers in a list of integers
% sumsq_even([1,3,5,2,-4,6,8,-7], Sum). should return sum = 120


% case of empty list, our sum would be 0
% if our list is the empty list 
% then the sum is also 0
sumsq_even([], 0). 

% case of even number as Head of current list in recursive function
sumsq_even([H | T], Sum) :- 
    % if the head % 2 == 0 (from the assignment specification) then the number is even
    0 is H mod 2,
    % recursive call on the sumsq_even function with the remaining list and running sum
    sumsq_even(T, RunningSum),
    % update the sum to be the square of the EVEN head added to the current running sum
    Sum is H*H + RunningSum.

% case of odd number as Head of current list in recursive function
sumsq_even([H | T], Sum) :-
    % if the head % 2 == 1 (from the assignment specification) then the number is odd
    1 is H mod 2,
    % so we just make another call to the remaining list and current sum.
    sumsq_even(T, Sum). 

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Question 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% same_name function will return true if both arguements have the same family same_name
% parent(jim, brian).
% parent(brian, jenny).
% parent(pat, brian).
% female(pat).
% female(jenny).
% male(jim).
% male(brian).
% using this data
% same_name(jim,jenny) should return true
% same_name(pat,brian) should return false
% married women retain their original birthname
% all names originate from the fathers in this case
% now we just check all the FATHERS of each person and if either, one person is the ancestor or they both share a common ancestor
% then we return true
% else we return false

% basecase to check if we have a matching father for our recursion
check_fathers(Father, Person) :-
    %return true if the ancestor is the parent of person we are checking
    parent(Father, Person),
    %and he is a male (mothers dont pass their family names down)
    male(Father).

% now we perform our recursion search which will go up the tree searching for fathers
% this will recursively climb the tree searching for fathers of the current person in iteration
% it will use the father variable to find the highest root value father in the family tree
% for example in our tree we have jim - father -> brian - father -> jenny
% so it will first parse brian as jennys highest father
% next call it will parse jim as jennys highest father who is also brians father
check_fathers(Father, Person) :-
    % we first want to find a parent to the person we are searching 
    parent(Random, Person),
    % next we want to check the fathers of that parent recursively
    check_fathers(Father, Random),
    % return true if the ancestor is male (dont take mothers names)
    male(Random).

% now we want to call our samename function which will check the fathers of person 2 recursively
% this call will check if person 1 is the greatest father to person 2 so it will be our first check
same_name(Person1, Person2) :-
    check_fathers(Person1, Person2).

% now we want to call our samename function again which will check the fathers of person 1 recursively
% this call will check if person 2 is the greatest father to person 1.
same_name(Person1, Person2) :-
    check_fathers(Person2, Person1).

% next we want to check if both person1 and person2 share a common male father, in my input below
% tom has father jim, and jenny has grandfather jim so they share the same name from jim
% so we want to check if they both have the same father jim (CommonMaleAncestor would return true for BOTH)
same_name(Person1, Person2) :-
    check_fathers(CommonMaleAncestor, Person1),
    check_fathers(CommonMaleAncestor, Person2).

% test input which has uncle, brother, grandparent
% parent(jim, brian).
% parent(jim, tom).
% parent(brian, jenny).
% parent(brian,james).
% parent(pat, brian).
% female(pat).
% female(jenny).
% male(jim).
% male(brian).

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Question 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sqrt_list function will take a list of numbers as input, and will create a 
% list that contains a pair of (1. number from initial list, 2. square root of that number)
% essentially creating a list of pairs
% example 
% ?- sqrt_list([0,2,289], Result).
% Result = [[0, 0.0], [2, 1.4142135623730951], [289, 17.0]].

% the base case of our recursionw ill be that
% the sqrt_pair of an empty list will also be an empty list
sqrt_list([], []).

% now we want to go through the list recursively and each time we have an element
% that is >= 0 we want to add the pair to our result list
% added case that is our head is negative we will return false as the sqrt
% cannot handle negative number of the real number system.
sqrt_list([H | T], [H2 | T2]) :-
    % making sure that the value of the head is >= 0
    H >= 0,
    % calculate resultant sqrt value since head >= 0
    Resultant is sqrt(H),
    % set the next value in our result list to be the pair that is head and the sqrt(head)
    H2 = [H, Resultant],
    %recursively call the function on the rest of list till we hate base case
    sqrt_list(T, T2).

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Question 4 %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sign_runs function will take a list of numbers as input, it will iterate
% through the list of numbers adding a value to a sublist of our result list 
% until the sign of the next value changes
% upon sign changes it will create a new sublist in our result list
% for example
% input list = [8,-1,-3,0,2,0,-4]
% result list will be [[8], [-1, -3], [0, 2, 0], [-4]]
% at each sign change a new list is added to the end of  our result list
% note we need to update our RunList at the end of the recursion since
% prolog doesnt allow for us to do the following
% 1. check value is = []
% 2. if it is we can initalise the value to [5]
% this will return false
% if we perform the reverse recursion it will first gather all
% sublists, and then it will begin initalising RunList and updating it
% at the end. 
% my implementation will simply do the following
% first it will check the head of the list
% it will check the sign of the head
% then it will go across the list adding values it encouters next with the same sign
% when we reach a element in list with different sign we exit and dont add it in
% then we return to sign_runs and do the same procedure for the next element recursively

% base case for our recursion on empty list
 sign_runs([], []).

% case when next value is negative
sign_runs(List, RunList) :-
    % convert our variable List to a list which can be examined by 
    % the value at the start (Head), the tail value is omitted
    List = [H | _],
    % if the head of the list is negative
    H < 0,
    % then we want to iterate across the list adding items till we
    % hit a positive head value
    add_negatives(List, NegativeRun, RemainingList),
    % recursively call the sign_runs function on the remaining list after
    % our negative run 
    sign_runs(RemainingList, NewRun),
    % update the list after the recursion, since our list is a recursive data type
    % this will properly update the list creating the runs
    RunList = [NegativeRun | NewRun].

% case when next value is positive
sign_runs(List, RunList) :-
    % convert our variable List to a list which can be examined by 
    % the value at the start (Head), the tail value is omitted
    List = [H | _],
    % if the head of the list is positive
    H >= 0,
    % then we want to iterate across the list adding item till
    % we reach a negative head value
    add_positives(List, PositiveRun, RemainingList),
    % recursively call the sign_runs function on the remaining original list
    sign_runs(RemainingList, NewRun),
    % update the list after the recursion, since our list is a recursive data type
    % this will properly update the list creating the runs
    RunList = [PositiveRun | NewRun].

% base case for our negative run
add_negatives([], [], []).

% this will be the recursive case when we encouter negative values 
% for the list head
add_negatives(List,NegativeRun,RemainingList) :-
    % convert our variable list to a list which can be examined by
    % the value at the start (Head), and the remaining list (Tail)
    List = [H | T],
    % if the head value is still negative 
    H < 0,
    % then we want to recursively call the function with the remaining list
    % and update our runlist for the current negative run
    add_negatives(T,NegativeRun2,RemainingList),
    % at the end of the recursion we will update the list 
    % this allows us to properly initalise the list
    NegativeRun = [H | NegativeRun2].

% exit case for our negative run
add_negatives(List,NegativeRun,RemainingList) :-
    % convert our variable list to a list which can be examined by
    % the value at the start (Head), and the remaining list can be ignored
    List = [H | _],
    % if the head has a different sign to the current sign of our list values (positive head)
    H >= 0,
    % then we want to end the negative run
    NegativeRun = [],
    % set the remaining list to perform sign runs on to be the 
    % current list, since we are exiting at this point of the list
    RemainingList = List.

% base case for our positive run
add_positives([], [], []).

% this will be the recursive case when we encouter positive values
% for the list head
add_positives(List,PositiveRun,RemainingList) :-
    % convert our variable list to a list which can be examined by
    % the value at the start (Head), and the remaining list (Tail)
    List = [H | T],
    % if the head value is still positive
    H >= 0,
    % then we want to recursively call the function with the remaining list
    % and update our runlist for the positive negative run
    add_positives(T,PositiveRun2,RemainingList),
    % at the end of the recursion we will update the list 
    % this allows us to properly initalise the list 
    PositiveRun = [H | PositiveRun2].

% exit case for our positive run
add_positives(List,PositiveRun,RemainingList) :-
    % convert our variable list to a list which can be examined by
    % the value at the start (Head), and the remaining list can be ignored
    List = [H | _],
    % if the head has a different sign to the current sign of our list values (negative head)
    H < 0,
    % end the positive run
    PositiveRun = [],
    % set the remaining list to perform sign runs on to be the 
    % current list, since we are exiting at this point of the list
    RemainingList = List.



%%%%%%%%%%%%%%%%%%%%%%%%%%%% Question 5 %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% is_heap function will take in a tree as input, and then will return true
% if the tree satisfies the heap property and false if otherise
% the heap property states that the key of the current tree has a lower value
% than its two children
% and the heap property must be true for all trees inside our tree (since tree)
% is a recursive data structure
% for example
% tree(empty,3,tree(tree(empty,8,empty),5,tree(empty,7,empty)))
% obeys the heap property and returns true
% this is because our tree looks like the following
%                                       3
%                                        \
%                                          5
%                                         / \
%                                        8   7
% as can be observed at each node the heap property is preserved
% 3 < 5, 5 < 8 and 5 < 7
% however for the following tree
% tree(tree(tree(empty,4,empty), 3,tree(empty,5,empty)),6,tree(tree(empty,9,empty),7,empty))
% the tree  does not obey the heap property and returns false
% this is because our tree looks like the following
%                                       3
%                                     /    \
%                                    4      6
%                                          / \
%                                         5   8
%                                              \
%                                               7
% the heap property will break since on the subtree 5->6->7, the node 6 has a child less than the node value
% 6 is not < 5 

% this will check the property of the heap
% onto empty tree
% this will always return true
heap_property(empty,_).

% the heap property function which will make sure the node obeys the heap property
heap_property(tree(_,Key,_),Value) :-
    Key >= Value.

% base case 1 for our recursion
% the empty tree obeys the heap property, since all nodes are null meaning equal
is_heap(empty).

% the base case 2 for our recursion
% empty sub-trees obey the heap property since all nodes have same value
is_heap(tree(empty,empty,empty)).

% recursive case 
is_heap(tree(Left,Key,Right)) :-
    % we want to check the heap property is obeyeed
    % for the current node
    % check heap property for the left child
    heap_property(Left, Key),
    % check heap proeprty for the right child
    heap_property(Right, Key),
    % now we want to recursively check on the left and right sub-trees
    is_heap(Left),
    is_heap(Right).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMP3411 Assignment One 2019 Term 1     %
% This code was written by Abanob Tawfik  %
% z5075490                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%% Question 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sumsq_even function that takes the sum of the square value of only even numbers in a list of integers
% sumsq_even([1,3,5,2,-4,6,8,-7], Sum). should return sum = 120


% case of empty list, our sum would be 0
sumsq_even(Numbers, Sum) :-
	% if our list is the empty list 
	Numbers = [],
	% then the sum is also 0
	Sum = 0.

% case of even number as Head of current list in recursive function
sumsq_even(Numbers, Sum) :- 
	% convert our variable Numbers to a list which can be examined by 
	% the value at the start (Head) and the rest of the list (Tail)
	Numbers = [Head | Tail],
	% if the head % 2 == 0 (from the assignment specification) then the number is even
	0 is Head mod 2,
	% recursive call on the sumsq_even function with the remaining list and running sum
	sumsq_even(Tail, Result),
	% update the sum to be the square of the EVEN head added to the current running sum
	Sum is Head*Head + Result.

% case of odd number as Head of current list in recursive function
sumsq_even(Numbers, Sum) :-
	% convert our variable Numbers to a list which can be examined by 
	% the value at the start (Head) and the rest of the list (Tail)
	Numbers = [Head | Tail],
	% if the head % 2 == 1 (from the assignment specification) then the number is odd
	1 is Head mod 2,
	% so we just make another call to the remaining list and current sum.
	sumsq_even(Tail, Sum).	

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
% all names originate from the fathers in this case!
% now we just check all the FATHERS of each person and if either, one person is the ancestor or they both share a common ancestor
% then we return true
% else we return false

% basecase to check if we have a matching father for our recursion
check_fathers(Ancestor, Person) :-
	%return true if the ancestor is the parent of person we are checking
	parent(Ancestor, Person),
	%and he is a male (mothers dont pass their family names down)
	male(Ancestor).

% now we perform our recursion search which will go up the tree searching for matching ancestor
% this will recursively climb the tree searching for fathers of the person
% it will use the ancestor variable to find the highest root value father ancestor in the family tree
% for example in our tree we have jim - father -> brian - father -> jenny
% so it will first parse brian as jennys highest ancestor
% next call it will parse jim as jennys highest ancestor who is also brians ancestor
check_fathers(Ancestor, Person) :-
	% we first want to find a parent to the person we are searching 
	parent(Random, Person),
	% next we want to check the fathers of that parent recursively
	check_fathers(Ancestor, Random),
	% return true if the ancestor is male (dont take mothers names)
	male(Random).

% now we want to call our samename function which will check the fathers of person 2 recursively
% this call will check if person 1 is an ancestor to person 2 so it will be our first check
same_name(Person1, Person2) :-
	check_fathers(Person1, Person2).

% now we want to call our samename function again which will check the fathers of person 1 recursively
% this call will check if person 2 is an ancestor to person 1.
same_name(Person1, Person2) :-
	check_fathers(Person2, Person1).

% next we want to check if both person1 and person2 share a common male ancestor, in my input below
% tom has father jim, and jenny has grandfather jim so they share the same name from jim
% so we want to check if they both have the same ancestor jim (CommonAncestor would return true for BOTH)
same_name(Person1, Person2) :-
	check_fathers(CommonAncestor, Person1),
	check_fathers(CommonAncestor, Person2).

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
sqrt_list(NumberList, ResultList) :-
	NumberList = [],
	ResultList = [].

% now we want to go through the list recursively and each time we have an element
% that is >= 0 we want to add the pair to our result list
% added case that is our head is negative we will return false as the sqrt
% cannot handle negative number of the real number system.
sqrt_list(NumberList, ResultList) :-
	% convert our variable NumberList to a list which can be examined by 
	% the value at the start (Head) and the rest of the list (Tail)
	NumberList = [Head | Tail],
	% making sure that the value of the head is >= 0
	Head >= 0,
	% calculate resultant sqrt value since head >= 0
	Resultant is sqrt(Head),
	% convert our variable ResultList to a list which can be examine dby
	% the value at the start (Head2) and the rest of the list (Tail2)
	ResultList = [Head2 | Tail2],
	% set the next value in our result list to be the pair that is head and the sqrt(head)
	Head2 = [Head, Resultant],
	%recursively call the function on the rest of list till we hate base case
	sqrt_list(Tail, Tail2).

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Question 4 %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sign_runs function will take a list of numbers as input, it will iterate
% through the list of numbers adding a value to a sublist of our result list 
% until the sign of the next value changes
% upon sign changes it will create a new sublist in our result list
% for example
% input list = [8,-1,-3,0,2,0,-4]
% result list will be [[8], [-1, -3], [0, 2, 0], [-4]]
% at each sign change a new list is created to our result list

% base case for our recursion on empty list
 sign_runs([], RunList) :-
	RunList = [].

% case when next value is negative
sign_runs(List, RunList) :-
	% convert our variable List to a list which can be examined by 
	% the value at the start (Head) and the rest of the list (Tail)
	List = [Head | _],
    Head < 0,
    add_negatives(List, NegativeRun, RemainingList),
	sign_runs(RemainingList, NewRun),
    RunList = [NegativeRun | NewRun].

% case when next value is positive
sign_runs(List, RunList) :-
	% convert our variable List to a list which can be examined by 
	% the value at the start (Head) and the rest of the list (Tail)
	List = [Head | _],
    Head >= 0,
    add_positives(List, PositiveRun, RemainingList),
	sign_runs(RemainingList, NewRun),
    RunList = [PositiveRun | NewRun].

add_negatives([], [], []).

add_negatives(List,NegativeRun,RemainingList) :-
	List = [Head | Tail],
	Head < 0,
	add_negatives(Tail,NegativeRun2,RemainingList),
	NegativeRun = [Head | NegativeRun2].

add_negatives(List,NegativeRun,RemainingList) :-
	List = [Head | _],
	Head >= 0,
	NegativeRun = [],
	RemainingList = List.

add_positives([], [], []).

add_positives(List,PositiveRun,RemainingList) :-
	List = [Head | Tail],
	Head >= 0,
	add_positives(Tail,PositiveRun2,RemainingList),
	PositiveRun = [Head | PositiveRun2].

add_positives(List,PositiveRun,RemainingList) :-
	List = [Head | _],
	Head < 0,
	PositiveRun = [],
	RemainingList = List.

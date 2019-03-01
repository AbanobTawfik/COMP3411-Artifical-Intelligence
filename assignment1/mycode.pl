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
% now we just check all the FATHERS of each person and if either one links in the search
% then we return true
% else we return false

% helper function to check the fathers recursively up the tree to try to find common
% father ancestor where the family name is based off

% basecase to check if we have a matching father for our recursion

check_fathers(Ancestor, Person) :-
	%return true if the ancestor is the parent of person we are checking
	parent(Ancestor, Person),
	%and he is a male (mothers dont pass their family names down)
	male(Ancestor).

% now we perform our recursion search which will go up the tree searching for matching ancestor
% this will be done bi-directionally for example in our case above
% if input is jim, jenny and we only did it one direction, we would get it true, since jim is jennys ancestor
% but we do it bi-directionally incase input is jenny, jim and we need to ensure jim is still ancestor of jenny
check_fathers(Ancestor, Person) :-
	%we first want to find a parent to the person we are searching 
	parent(Random, Person),
	%next we want to check the fathers of that person recursively
	check_fathers(Ancestor, Random),
	%return true if the ancestor is male (dont take mothers names)
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


parent(jim, brian).
parent(jim, tom).
parent(brian, jenny).
parent(brian,james).
parent(pat, brian).
female(pat).
female(jenny).
male(jim).
male(brian).

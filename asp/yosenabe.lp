% Thicha Melissa Thephasdin na Ayuthya melissa.thephasdin@uni-potsdam.de
% Mariia Merzliakova mariia.merzliakova@uni-potsdam.de

% HINTS:
% - You may use the gaps of adjacent cells' coordinates to denote directions.
% - Develop your encoding incrementally and check the additions. If in doubt
%   whether rules are correct, the "--text" option of gringo/clingo allows
%   for investigating the instantiation, while small instances are advisable.

% cell(X,Y) - cells in the grid (define the size of the grid)
% area(X,Y,A) - (X,Y) belongs to area A
% number(X,Y,N) - initial position (X,Y) of the number N
% goal(A,G) - number G associated with the area A 
% target(X,Y,XX,YY) - number in the cell (X,Y) is moved to the cell (XX,YY)

% Your implementation please...

% Direction vectors for moving in straight lines
dir(0,1). dir(0,-1). dir(1,0). dir(-1,0).

% Define possible targets for each number to move to within its line of movement, considering only moves within the same area
{target(X, Y, X, YY, A, N) : number(X, Y, N), area(X, YY, A)}.
{target(X, Y, XX, Y, A, N) : number(X, Y, N), area(XX, Y, A)}.

% Define a move from one cell to an adjacent cell in one of the four directions
move(X, Y, X2, Y2, DX, DY) :- 
    number(X, Y, _),  
    dir(DX, DY), 
    X2 = X + DX, Y2 = Y + DY.

% Constraint to prevent more than one number from occupying the same target cell
:- target(X1, Y1, XX, YY, _, N1), 
    target(X2, Y2, XX, YY, _, N2), 
    (X1, Y1) != (X2, Y2), N1 != N2. 

% Ensure each number is moved exactly once and to one target only
:- number(X, Y, N), not 1 { target(X, Y, _, _, _, N) }.
:- number(X, Y, N), 
    target(X, Y, XX1, YY1, A1, N), 
    target(X, Y, XX2, YY2, A2, N), 
    (XX1, YY1, A1) != (XX2, YY2, A2).

% Record the path of a move to ensure paths do not cross or overlap
path(X..XX,Y..YY,X,Y) :- target(X,Y,XX,YY,_,_).
path(XX..X,Y..YY,X,Y) :- target(X,Y,XX,YY,_,_).
path(X..XX,YY..Y,X,Y) :- target(X,Y,XX,YY,_,_).
path(XX..X,YY..Y,X,Y) :- target(X,Y,XX,YY,_,_).

% Constraint to ensure paths do not intersect
:- path(X, Y, XX1, _), path(X, Y, XX2, _), XX1 != XX2.
:- path(X, Y, _, YY1), path(X, Y, _, YY2), YY1 != YY2.

% Ensure each gray area is populated with at least one moved number
:- area(X, Y, A), not 1 { target(_, _, XX, YY, A, _) : area(XX, YY, A) }.

% Ensure sums in areas with goals are met
:- goal(A, G), G != #sum{N,X,Y: number(X,Y,N), target(X,Y,XX,YY, _, N), area(XX,YY,A)}.

% Adjust the definition of target to only include necessary variables for output
target(X, Y, XX, YY) :- target(X, Y, XX, YY, A, N).

#show target/4.
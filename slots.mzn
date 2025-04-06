/*
Slot assignment problem, with mutually exclusive slots, and FCFS student signups.
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parameters assigned via external data (.dzn) file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% How many students per slot
int: students_per_slot;

% Defining all possible slot names
% The first slot name is required to refer to "no slot assigned". It has value 1, being the first enum value.
enum Slots;

% Defining all possible student names
enum Students;

% Indicates which slots each student wants.
array [Students, Slots] of bool: slot_preferences;

% Mutually exclusive list of lists that indicates which slots cannot be opened together.
array [Slots, Slots] of bool: slot_mutual_exclusiveness; 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Variable array for results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Final output - which student is assigned to which slot
array [Students] of var Slots: slot_assignments;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Constraints and costs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% No more than students_per_slot assignments for each slot
constraint forall(slot in Slots)(slot > 1 -> count(slot_assignments, slot) <= students_per_slot);

% If a student gets a slot, it must be in their slot preference
%   slot_preferences[student] gets the 1D array of their preferences
%   slot_assignments[student] gets their assigned slot
%   therefore, checking the expression below checks if the assigned slot is "true" in their preference list
constraint forall(student in Students)
  (slot_preferences[student, slot_assignments[student]]);

% Make sure that certain slots are mutually exclusive (i.e., if one slot is assigned, the other slot must be 0)
constraint forall(slot1 in Slots)
  (forall(slot2 in Slots)
      (count(slot_assignments, slot1) > 0 /\ slot_mutual_exclusiveness[slot1,slot2] ->
        count(slot_assignments, slot2) == 0));

% Ensure FCFS ordering: i.e., if a student that submitted later (higher student 'number') is assigned to a slot, all students with 'lower numbers' must be assigned. 
%   This is sometimes problematic since if any earlier student cannot get a slot (e.g., they want a mutually exclusive slot), noone else can get a slot.
%   Disable it if some students are too 'picky' and disallow every student after them from getting a slot.
% constraint forall(student1 in Students)
%   (forall(student2 in Students)
%     ((student1 > student2) /\ (slot_assignments[student1] > 1) -> slot_assignments[student2] > 1));
    

% Combined cost if any student is not assigned (+1 per student)
%  + a small cost (not worth any students being unassigned)
%  for not compressing into fewer slots.  
%  array2set of slot assignments finds set of all unique slot assignments, card gets the set size.
%  The max value of the cost of compressing slots is always less than 1
function var float: cost(array [Students] of var Slots: slot_assignments) = 
 count(slot_assignments, 1) + 
 (1/(card(Slots)+1))*card(array2set(slot_assignments));
 
% Cost for not assigning students in a FCFS-like order
%  Filter by students that have slots and add (card(Students) - sum_student_idxs_assigned) to the current score

%var float: fcfs_cost =  card(Students) - 
  
  
% Calculate the number of assignments for each slot that's not the no-slot.
array[int] of var int: slot_count = 
  [ sum(student in Students)(if slot_assignments[student] == slot then 1 else 0 endif) | slot in 2..card(Slots) ];
% Get only positive values
array[int] of var opt int: slot_count_positive = [i | i in slot_count where i > 0];
% Cost for minimizing imbalance between slots
var int: imbalance = max(slot_count_positive) - min(slot_count_positive);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Solve minimization problem and print results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Cost of assignments now includes imbalance (which is much less than the cost of any student not being assigned)
% I.e., solve to get all students a slot first, then try to correct slot imbalances.
solve minimize 10*cost(slot_assignments) + 0.0001*imbalance;

output [
  show(student) ++ "\t" ++ show(slot_assignments[student]) ++ "\n"
  | student in Students
];

output "Number of slots: (including no-slot): " ++ show(card(array2set(slot_assignments))) ++ "\n";
output ["Slots: " ++ show(Slots) ++ "\n"];
output ["No slot students: " ++ show(count(slot_assignments, 1)) ++ "\n"];
output ["Slot counts: " ++ show(slot_count_positive) ++ "\n"];
output ["Imbalance: " ++ show(imbalance) ++ "\n"];




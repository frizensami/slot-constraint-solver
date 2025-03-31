/*
Slot assignment problem, with mutually exclusive slots, and FCFS student signups.

There are some N slots available to students. There are a maximum number of students that can be assigned to any slot (say S).

*/

% How many students per slot
int: students_per_slot;

% Defining all possible slot names
%enum Slots = { thu_2pm, fri_2pm, fri_3pm, tue_2pm, tue_3pm, wed_2pm, wed_3pm };
%enum Slots = { thu_2pm, fri_2pm };
enum Slots;

% Defining all possible student names
%enum Students = { sriram, theo };
enum Students;

% Indicates if a student wanted a specific slot
array [Students, Slots] of bool: slot_preferences;

% Mutually exclusive list of lists
array [Slots, Slots] of bool: slot_mutual_exclusiveness; 

% Final output - which student is assigned to which slot
array [Students] of var Slots: slot_assignments;

% No more than students_per_slot assignments for each slot
constraint forall(slot in Slots)(slot > 1 -> count(slot_assignments, slot) <= students_per_slot);

% If a student gets a slot, it must be in their slot preference
% slot_preferences[student] gets the 1D array of their preferences
% slot_assignments[student] gets their assigned slot
% therefore, checking the expression below checks if the assigned slot is "true" in their preference list
constraint forall(student in Students)
  (slot_preferences[student, slot_assignments[student]]);

% Make sure that certain slots are mutually exclusive (i.e., if one slot is assigned, the other slot must be 0)
constraint forall(slot1 in Slots)
  (forall(slot2 in Slots)
      (count(slot_assignments, slot1) > 0 /\ slot_mutual_exclusiveness[slot1,slot2] ->
        count(slot_assignments, slot2) == 0));

% Ensure FCFS ordering: i.e., if a student that submitted later (higher student 'number') is assigned to a slot, all students with 'lower numbers' must be assigned. 
% This is problematic since if any earlier student cannot get a slot (e.g., they want a mutually exclusive slot), noone else can get a slot.
%constraint forall(student1 in Students)(forall(student2 in Students)((student1 > student2) /\ (slot_assignments[student1] > 1) -> slot_assignments[student2] > 1));

% First value of enum (none) is none
solve minimize count(slot_assignments, 1);

output [
  show(student) ++ "\t" ++ show(slot_assignments[student]) ++ "\n"
  | student in Students
];







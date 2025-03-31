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
% array [Students, Slots] of bool: slot_preferences = array2d(Students, Slots,
% [
% false, true, 
% true, false
% ]
% );
array [Students, Slots] of bool: slot_preferences;

% Final output - which student is assigned to which slot
array [Students] of var Slots: slot_assignments;

% No more than students_per_slot assignments for each slot
constraint forall(slot in Slots)(count(slot_assignments, slot) <= students_per_slot);

% If a student gets a slot, it was in their slot preference
constraint forall(student in Students)(slot_preferences[student, slot_assignments[student]]);

% Make sure that certain slots are mutually exclusive

% Ensure FCFS ordering: i.e., if a student that submitted later (higher student 'number') is assigned to a slot, all students with 'lower numbers' must be assigned. 

output [show(slot_preferences), "\n", show(slot_assignments)];






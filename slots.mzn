/*
Slot assignment problem, with mutually exclusive slots, and FCFS student signups.

There are some N slots available to students. There are a maximum number of students that can be assigned to any slot (say S).

*/

% Defining all possible slot names
%enum Slots = { thu_2pm, fri_2pm, fri_3pm, tue_2pm, tue_3pm, wed_2pm, wed_3pm };
enum Slots = { thu_2pm, fri_2pm };
% How many slots there are total
int: total_slots = 7;
% How many students per slot
int: students_per_slot = 20;
% How many students total
int: total_students = 2;


% Defining all possible student names
enum Students = { sriram, theo };

% Perhaps we want an array where each student is a row and the value is the slot they selected
array [Students, Slots] of bool: slot_preferences = [|false, false |false, false |];

output [show(slot_preferences)];






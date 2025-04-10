# Slot Contraint Solver

## Motivation

Some of my students have signed up to visit someplace. There are multiple slots available for this visit but there's a number of constraints and optimization parameters I want to place upon this to get equitable outcomes.

## Description Constraints

### Slots
- There are multiple slots for the visit (e.g., "[date] [time]")
- Each slot has a maximum number of students allowable, call it `S`
- Not every slot has to be 'enabled' - i.e., we can have (and prefer) students bunching up into fewer slots
- Some of these slots are mutually exclusive from each other (e.g., if slot A is 'enabled', slot B should not be)

### Students
- Students can pick one or more slots as their availability
- They can only be assigned to one slot at most
- We want as far as possible for a first-come-first-served solution: students who signed up first are guaranteed to get a slot vs anyone who signs up after

## Modelling

One approach is to use a high-level modelling language such as **MiniZinc** to describe the problem.

Then, the constraints are solved using some solver backend that speaks MiniZinc (specifically the intermediate language **FlatZinc**).

---

To describe my overall approach (more details in the code, this high level description is autogenerated by GPT):

### 1. Parameter Definition

The model begins by defining the problem parameters through an external data file (`.dzn`). This includes:

- The maximum number of students that can be assigned to any slot (`students_per_slot`).
- Enumerated types for both available slots (`Slots`) and students (`Students`). The first element of `Slots` represents `"no slot assigned"`.
- A two-dimensional boolean array (`slot_preferences`) that indicates each student's preferred slots.
- A boolean matrix (`slot_mutual_exclusiveness`) that specifies which slots are mutually exclusive.

---

### 2. Decision Variables

The core decision variable is an array `slot_assignments` that maps every student (from `Students`) to one of the slots (from `Slots`). A student being assigned the first enum value (i.e., `1`) means they are **unassigned**.

---

### 3. Constraints

Several constraints ensure the model adheres to real-world requirements:

- **Capacity Constraint:**  
  Limits the number of students per slot to the predefined maximum (`students_per_slot`), excluding the unassigned slot.

- **Preference Constraint:**  
  Guarantees that if a student is assigned to a slot, it must be one they prefer (i.e., the corresponding entry in `slot_preferences` is `true`).

- **Mutual Exclusiveness Constraint:**  
  Ensures that if a slot is assigned to any student, then any slot mutually exclusive with it must remain unused by any student.

- **FCFS Constraint (First-Come, First-Served):**  
  Enforces an ordering such that if a student who submitted later (i.e., a higher student number) is assigned a slot, then all students who submitted earlier must also be assigned a slot.  
  > ⚠️ **Note:** This is a *strict* constraint—if an earlier student cannot be assigned due to mutual exclusiveness or limited preferences, all later students will also remain unassigned.

---

### 4. Cost Function and Balancing

The objective function is designed to:

- **Minimize Unassigned Students:**  
  A penalty is applied for every student left unassigned, ensuring that the model prioritizes assigning as many students as possible.

- **Encourage Even Distribution:**  
  An *imbalance measure* is calculated as the difference between the maximum and minimum number of assignments across all used slots.  
  A small weighted penalty (`0.0001 × imbalance`) is added to the objective to encourage a more even distribution of students among the slots.

```minizinc
solve minimize cost(slot_assignments) + 0.0001 * imbalance;
```



## Running

1. Install `minizinc`
1. Convert a signup sheet (signups.csv) to dzn via `python process_csv_to_dzn.py`
	- Example of header row: `Id,Start time,Completion time,Email,Name,What is your full (passport) name?,What is your NUS email?,"Which slots can you make for the NSCC visit? Please select as many as possible since we're limited to 20 people per slot.�`
	- Example of a student row: `9,3/27/2025 18:35,3/27/2025 18:36,redacted@u.nus.edu,Redacted Redacted,REDACTED REDACTED,redacted@u.nus.edu,10th April (Thursday) 2pm;11th April (Friday) 2pm;11th April (Friday) 3pm;15th April (Tuesday) 2pm;15th April (Tuesday) 3pm;16th April (Wednesday) 2pm;16th April (Wednesday) 3pm;`
	- To manually do this, look at `test.dzn` for a minimal example
1. E.g, run `minizinc --solver highs slots.mzn signups.dzn` 

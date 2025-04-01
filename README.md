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

How do we model this? 

## Running

1. Install `minizinc`
1. Convert a signup sheet (signups.csv) to dzn via `python process_csv_to_dzn.py`
	- Example of header row: `Id,Start time,Completion time,Email,Name,What is your full (passport) name?,What is your NUS email?,"Which slots can you make for the NSCC visit? Please select as many as possible since we're limited to 20 people per slot.�`
	- Example of a student row: `9,3/27/2025 18:35,3/27/2025 18:36,redacted@u.nus.edu,Redacted Redacted,REDACTED REDACTED,redacted@u.nus.edu,10th April (Thursday) 2pm;11th April (Friday) 2pm;11th April (Friday) 3pm;15th April (Tuesday) 2pm;15th April (Tuesday) 3pm;16th April (Wednesday) 2pm;16th April (Wednesday) 3pm;`
	- To manually do this, look at `test.dzn` for a minimal example
1. E.g, run `minizinc --solver highs slots.mzn signups.dzn` 

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

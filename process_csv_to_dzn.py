import csv

data = []

NO_SLOT = "_no_slot"

date_map = {f"{NO_SLOT}":f"{NO_SLOT}",
            "11th April (Friday) 2pm": "apr_11_2pm",
            "11th April (Friday) 3pm": "apr_11_3pm",
            "10th April (Thursday) 2pm": "apr_10_2pm",
            "15th April (Tuesday) 2pm": "apr_15_2pm",
            "15th April (Tuesday) 3pm": "apr_15_3pm",
            "16th April (Wednesday) 3pm": "apr_16_3pm",
            "16th April (Wednesday) 2pm":"apr_16_2pm"}

slot_mutual_exclusive = {"apr_11_2pm": "apr_11_3pm",
                         "apr_11_3pm": "apr_11_2pm",
                         "apr_15_2pm": "apr_15_3pm",
                         "apr_15_3pm": "apr_15_2pm",
                         "apr_16_3pm": "apr_16_2pm",
                         "apr_16_2pm": "apr_16_3pm",
                         # Modelling slots that are now cancelled via reflexive exclusiveness
                         "apr_11_2pm": "apr_11_2pm",
                         "apr_11_3pm": "apr_11_3pm",
                         "apr_15_2pm": "apr_15_2pm",
                         "apr_15_3pm": "apr_15_3pm",
                         }

date_map_keys_sorted = sorted(date_map.keys())
date_map_items_sorted = sorted(date_map.values())
students = []
dates = []
with open('signups.csv', encoding='windows-1252') as f:
    reader = csv.reader(f, dialect='excel', delimiter=',')
    next(reader) # Skip header
    for row in reader:
        name = row[5].strip()
        # Append in order
        students.append("_".join(name.lower().split(' ')))
        # Split by semicolon
        times = sorted(row[-1].strip().split(";"))
        # Remove all empty strings
        times = list(filter(lambda x: x != "", times))
        print(times)
        # Map to our time variable names
        times = list(map(lambda d: date_map[d], times))
        data.append((name,times))


for d in data:
    print(d)
print(date_map_keys_sorted)
print(students)

# For a given student date availabilities
def slot_prefs_f(dates):
    original_dates = [str(d in dates).lower() for d in date_map_items_sorted]
    # Replace the first option by true (enable the 'none' option even though it didn't match
    original_dates[0] = "true"
    return ",".join(original_dates)

# Build a list of not-allowed slots given a particular slot
def build_mutual_exclusive(date):
    return ",".join(["true" if date == slot_mutual_exclusive.get(d, None) else "false" for d in date_map_items_sorted])

slot_mutual_exclusive_list = "|".join(map(build_mutual_exclusive, date_map_items_sorted))

with open('signups.dzn', 'w') as f:
    # Students per slot
    l0 = "students_per_slot = 19;\n"
    f.write(l0);
    # Write enum of students first
    l1 = f"Students = {{ {','.join(students)} }};\n"
    f.write(l1)
    l2 = f"Slots = {{ {','.join(date_map_items_sorted)} }};\n"
    f.write(l2)
    # For each student, we want a false/true boolean for each of the date_map_items_sorted if that's what is in their list
    slot_prefs = "|".join(list(map(lambda d: slot_prefs_f(d[1]), data)))
    print(slot_prefs)
    #l3 = f"slot_preferences = array2d(Students,Slots,[{slot_prefs}]);"
    l3 = f"slot_preferences = [|{slot_prefs}|];\n"
    f.write(l3)
    l4 = f"slot_mutual_exclusiveness = [|{slot_mutual_exclusive_list}|];\n"
    print(l4)
    f.write(l4)

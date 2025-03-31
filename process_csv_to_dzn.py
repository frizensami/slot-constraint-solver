import csv

data = []

date_map = {"11th April (Friday) 2pm": "apr_11_2pm",
            "11th April (Friday) 3pm": "apr_11_3pm",
            "10th April (Thursday) 2pm": "apr_10_2pm",
            "15th April (Tuesday) 2pm": "apr_15_2pm",
            "15th April (Tuesday) 3pm": "apr_15_3pm",
            "16th April (Wednesday) 3pm": "apr_16_3pm",
            "16th April (Wednesday) 2pm":"apr_16_2pm"}

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
        # Split by semicolon, remove last empty string
        times = list(map(lambda d: date_map[d],sorted(row[-1].strip().split(";")[:-1])))
        data.append((name,times))


for d in data:
    print(d)
print(date_map_keys_sorted)
print(students)

# For a given student date availabilities
def slot_prefs_f(dates):
    return ",".join([str(d in dates).lower() for d in date_map_items_sorted])



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
    #slot_prefs = ",".join(list(map(lambda d: slot_prefs_f(d[1]), data)))
    slot_prefs = "|".join(list(map(lambda d: slot_prefs_f(d[1]), data)))
    print(slot_prefs)
    #l3 = f"slot_preferences = array2d(Students,Slots,[{slot_prefs}]);"
    l3 = f"slot_preferences = [|{slot_prefs}|];"
    f.write(l3)

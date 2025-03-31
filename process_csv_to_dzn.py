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

with open('signups.dzn', 'w') as f:
    # Write enum of students first
    l1 = f"Students = {{ {','.join(students)} }};\n"
    f.write(l1)
    l2 = f"Slots = {{ {','.join(date_map_items_sorted)} }};\n"
    f.write(l2)
    # For each student, we want a false/true boolean for each of the date_map_items_sorted if that's what is in their list
    l3 = f"slot_preferences = [array2d(Students,Slots,[{slot_prefs}])];"
    f.write(l3)

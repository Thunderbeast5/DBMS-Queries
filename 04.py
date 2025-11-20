import pymysql

# Step 1: Connect to MySQL
con = pymysql.connect(
    host="localhost",
    user="vedant",
    password="Vedant@10323",
    database="prac"
)

cur = con.cursor()

# Step 2: Functions

def add_student():
    roll = int(input("Enter Roll No: "))
    name = input("Enter Name: ")
    course = input("Enter Course: ")
    marks = int(input("Enter Marks: "))
    
    cur.execute(
        "INSERT INTO student (rollno, name, course, marks) VALUES (%s, %s, %s, %s)",
        (roll, name, course, marks)
    )
    con.commit()
    print("Record Added Successfully!")

def display_students():
    cur.execute("SELECT * FROM student")
    data = cur.fetchall()
    
    print("\n--- STUDENT RECORDS ---")
    for row in data:
        print(row)

def update_student():
    roll = int(input("Enter Roll No to Update Marks: "))
    marks = int(input("Enter New Marks: "))
    
    cur.execute(
        "UPDATE student SET marks=%s WHERE rollno=%s",
        (marks, roll)
    )
    con.commit()
    print("Record Updated Successfully!")

def delete_student():
    roll = int(input("Enter Roll No to Delete: "))
    
    cur.execute("DELETE FROM student WHERE rollno=%s", (roll,))
    con.commit()
    print("Record Deleted Successfully!")

# Step 3: Menu

while True:
    print("\n--- STUDENT MENU ---")
    print("1. Add Student")
    print("2. Display Students")
    print("3. Update Marks")
    print("4. Delete Student")
    print("5. Exit")

    try:
        ch = int(input("Enter your choice: "))
    except ValueError:
        print("Please enter numbers only!")
        continue

    if ch == 1:
        add_student()
    elif ch == 2:
        display_students()
    elif ch == 3:
        update_student()
    elif ch == 4:
        delete_student()
    elif ch == 5:
        print("Exiting...")
        break
    else:
        print("Invalid Choice!")

cur.close()
con.close()

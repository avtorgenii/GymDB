from pymongo import MongoClient

# Connection
db_client = MongoClient('localhost', 27017)

# Create database
data = db_client.school # later setup connection in pycharm according to database name

# Create a collection
students = data.students

print(students.find())
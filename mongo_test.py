from pymongo import MongoClient

sensor_1 = {"id": "0001", "name": "Temp", "location": "Room10", "Value": 10}
sensor_2 = {"id": "0001", "name": "Temp", "Value": 10}

# Connection
db_client = MongoClient('localhost', 27017)

# Create database
data = db_client.details # later setup connection in pycharm according to database name

# Create a collection
storage = data.storage

# Insert data
status = storage.insert_one(sensor_2)
print(status)
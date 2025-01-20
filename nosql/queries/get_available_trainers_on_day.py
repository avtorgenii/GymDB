from datetime import datetime

from mongoengine import connect
from nosql.mongo_structure import Trainer

connect('gym')

query_date = datetime(2025, 1, 12)

result = Trainer.objects.aggregate([
    {
        '$match': {
            'availability.date': query_date
        }
    },
    {
        '$unwind': '$availability'
    },
    {
        '$match': {
            'availability.date': query_date
        }
    },
    {
        '$lookup': {
            'from': 'user',
            'localField': 'user',
            'foreignField': '_id',
            'as': 'user_details'
        }
    },
    {
        '$unwind': '$user_details'
    },
    {
        '$project': {
            '_id': 0,
            'firstname': '$user_details.first_name',
            'lastname': '$user_details.last_name',
            'starttime': '$availability.start_time',
            'endtime': '$availability.end_time'
        }
    },
    {
        '$sort': {
            'starttime': 1,
            'endtime': 1
        }
    }
])

print(list(result))

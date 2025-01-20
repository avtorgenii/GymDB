from mongoengine import connect
from nosql.mongo_structure import Trainer

connect('gym')

result = Trainer.objects.aggregate([
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
        '$lookup': {
            'from': 'department',
            'localField': 'user_details.managed_by',
            'foreignField': '_id',
            'as': 'department_details'
        }
    },
    {
        '$unwind': '$department_details'
    },
    {
        '$group': {
            '_id': '$department_details.name',
            'trainer_count': {'$sum': 1}
        }
    },
    {
        '$project': {
            '_id': 0,
            'department_name': '$_id',
            'trainer_count': 1
        }
    },
    {
        '$sort': {
            'department_name': 1
        }
    }
])

print(list(result))

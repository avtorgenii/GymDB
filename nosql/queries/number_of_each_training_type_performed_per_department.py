from mongoengine import connect
from nosql.mongo_structure import Training

connect('gym')

result = Training.objects.aggregate([
    {
        '$lookup': {
            'from': 'training_type',
            'localField': 'training_type',
            'foreignField': '_id',
            'as': 'training_type',
        }
    },
    {'$unwind': '$training_type'},
    {
        '$lookup': {
            'from': 'hall',
            'localField': 'hall',
            'foreignField': '_id',
            'as': 'hall',
        }
    },
    {'$unwind': '$hall'},
    {
        '$lookup': {
            'from': 'department',
            'localField': 'hall.department',
            'foreignField': '_id',
            'as': 'department',
        }
    },
    {'$unwind': '$department'},
    {
        '$group': {
            '_id': {
                'department': '$department.name',
                'training_type': '$training_type.name'
            },
            'number': {'$sum': 1}
        }
    },
    {
        '$sort': {
            '_id.department': 1,
            '_id.training_type': 1
        }
    }

])

print(list(result))

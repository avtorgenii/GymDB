from mongoengine import connect
from nosql.mongo_structure import Training

connect('gym')

result = Training.objects.aggregate([
    {
        '$lookup': {
            'from': 'training_type',
            'localField': 'training_type',
            'foreignField': '_id',
            'as': 'training_type_details'
        }
    },
    {
        '$unwind': '$training_type_details'
    },
    {
        '$group': {
            '_id': '$training_type_details.name',
            'training_count': {'$sum': 1}
        }
    },
    {
        '$project': {
            '_id': 0,
            'training_type': '$_id',
            'training_count': 1
        }
    },
    {
        '$sort': {
            'training_type': 1
        }
    }
])

print(list(result))

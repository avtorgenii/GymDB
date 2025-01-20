from mongoengine import connect
from nosql.mongo_structure import Training

connect('gym')

result = Training.objects.aggregate([
    {
        '$addFields': {
            'year_month': {
                '$dateTrunc': {
                    'date': '$date',
                    'unit': 'month'
                }
            }
        }
    },
    {
        '$lookup': {
            'from': 'training_type',
            'localField': 'training_type',
            'foreignField': '_id',
            'as': 'training_type_details'
        }
    },
    {'$unwind': '$training_type_details'},
    {
        '$group': {
            '_id': {
                'training_name': '$training_type_details.name',
                'year_month': '$year_month'
            },
            'count': {'$sum': 1}
        }
    },
    {
        '$project': {
            '_id': 0,
            'training_name': '$_id.training_name',
            'year_month': '$_id.year_month',
            'count': 1
        }
    },
    {
        '$sort': {
            'training_name': 1,
            'year_month': -1
        }
    }
])

print(list(result))

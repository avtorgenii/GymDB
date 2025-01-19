from mongoengine import connect
from nosql.mongo_structure import Locker

connect('gym')

result = Locker.objects.aggregate([
    {'$match': {'status': 'Free'}},
    {
        '$lookup': {
            'from': 'locker_room',
            'localField': 'locker_room',
            'foreignField': '_id',
            'as': 'locker_room',
        }
    },
    {'$unwind': '$locker_room'},
    {
        '$lookup': {
            'from': 'department',
            'localField': 'locker_room.department',
            'foreignField': '_id',
            'as': 'department',
        }
    },
    {'$unwind': '$department'},
    {
        '$group': {
            '_id': {
                'department': '$department.name',
                'sex': '$locker_room.type'
            },
            'number': {'$sum': 1}
        }
    },
    {
        '$sort': {
            '_id.department': 1,
            '_id.sex': 1
        }
    }
])






print(list(result))
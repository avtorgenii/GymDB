from mongoengine import connect
from nosql.mongo_structure import Fault

connect('gym')


result = Fault.objects.aggregate([
    {
        '$match': {
            'status': 'Cannot Be Repaired'
        }
    },
    {
        '$lookup': {
            'from': 'equipment',
            'localField': 'equipment',
            'foreignField': '_id',
            'as': 'equipment_info'
        }
    },
    {
        '$unwind': '$equipment_info'
    },
    {
        '$group': {
             '_id': '$equipment_info.name',
            'number': {'$sum': 1}
        }
    },
    {
        '$sort': {
            '_id.name': 1,
            'number': -1
        }
    },
    {
        '$project': {
            '_id': 0,
            'name': '$_id',
            'number': 1
        }
    }
])

print(list(result))
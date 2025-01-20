from mongoengine import connect
from nosql.mongo_structure import Membership

connect('gym')

result = Membership.objects.aggregate([
    {
        '$lookup': {
            'from': 'offer',
            'localField': 'offer',
            'foreignField': '_id',
            'as': 'offer_details'
        }
    },
    {'$unwind': '$offer_details'},
    {
        '$group': {
            '_id': '$offer_details._id',
            'name': {'$first': '$offer_details.name'},
            'total_revenue': {'$sum': '$offer_details.price'}
        }
    },
    {
        '$project': {
            '_id': 0
        }
    },
    {
        '$sort': {
            'total_revenue': -1
        }
    }
])

print(list(result))

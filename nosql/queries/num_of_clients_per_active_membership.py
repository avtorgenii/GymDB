from datetime import datetime, date

from mongoengine import connect
from nosql.mongo_structure import Membership

connect('gym')

today = datetime.combine(date.today(), datetime.min.time())

result = Membership.objects.aggregate([
    {
        '$match': {
            'end_date': {'$gte': today}
        }
    },
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
            'count': {'$sum': 1}
        }
    },
    {
        '$project': {
            '_id': 0
        }
    },
    {
        '$sort': {
            'count': 1
        }
    }
])

print(list(result))

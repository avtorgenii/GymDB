from mongoengine import connect
from nosql.mongo_structure import User

connect('gym')

result = User.objects.aggregate([
    {'$match': {'role.name': "Trainer"}},
    {
        '$project': {
            'truncatedDate': {
                '$dateTrunc': {
                    'date': "$registration_date",
                    'unit': "month"
                }
            }
        }
    },
    {
        '$group': {
            '_id': '$truncatedDate',  # Group by month
            'average_clients': {'$avg': 1}  # Average across all clients in that month
        }
    },
    {
        '$sort': {
            '_id': 1
        }
    },
    {
        '$project': {
            '_id': 0,
            'year_month': '$_id',  # Include the month in the output
            'average_clients': 1  # Include the average
        }
    }
])

print(list(result))

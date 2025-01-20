from mongoengine import connect
from nosql.mongo_structure import Trainer

connect('gym')

query_qualification = "Yoga"

result = Trainer.objects.aggregate([
    {
        '$lookup': {
            'from': 'training_type',
            'localField': 'qualifications',
            'foreignField': '_id',
            'as': 'qualifications_details'
        }
    },
    {
        '$unwind': '$qualifications_details'
    },
    {
        '$match': {
            'qualifications_details.name': query_qualification
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
            'trainer_first_name': '$user_details.first_name',
            'trainer_last_name': '$user_details.last_name',
            'qualification': '$qualifications_details.name'
        }
    }
])

# Print the results
print(list(result))

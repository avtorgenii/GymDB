import csv
from mongoengine import connect
from numpy import random
import random

from mongo_structure import *
from mongodb_aux import *

path_to_csv = "../csv/"
user_roles = ['Administrator', 'Manager', 'Technician', 'Trainer', 'Client']

#IMPORTANT
#This file requires subtle changes to csv files in order to work properly (at all)
#csv files as generated do no separate words, whereas this script requires for words to be separataed by '_'


def load_csv_data(file_name, model, reference_fields=None):
    try:
        with open(file_name, mode='r', encoding='utf=8') as csv_file:
            csv_reader = csv.DictReader(csv_file)

            for row in csv_reader:
                reference_iterator = 0
                result = {}
                for key, value in row.items():
                    if not (key.endswith('_id') or key.endswith('_by')):
                        if value == "Not available" and key == "status" and model == Locker:

                            result[key] = "Not Available"
                        elif key.endswith('_date') and value:  # Convert dates
                            result[key] = datetime.strptime(value, '%Y-%m-%d')
                        else:
                            result[key] = value
                    else:
                        if reference_fields:
                            field, ref_model= list(reference_fields.items())[reference_iterator]
                            if value != '':
                                result[field] = ref_model.objects[int(value)-1]
                            else:
                                result[field] = None

                            reference_iterator += 1
                        else:
                            pass

                # Save document
                document = model(**result)
                document.save()

            print(f"Data from {file_name} loaded successfully into {model.__name__}.")
    except Exception as e:
        print(f"Error loading data from {file_name} into {model.__name__}: {e}")

def add_trainers():
    qualifications_count = TrainingType.objects.count()
    source_items = list(TrainingType.objects)
    try:
        with open("../csv/trainer.csv", mode='r', encoding='utf=8') as csv_file:
            csv_reader = csv.DictReader(csv_file)

            for row in csv_reader:
                #getting random qualifications
                num_items = random.randint(1, qualifications_count)
                selected_items = random.sample(source_items, num_items)
                _, value = list(row.items())[0]
                result = {"user": User.objects[int(value) - 1], "qualifications": selected_items, "availability": get_random_availability()}
                trainer = Trainer(**result)
                trainer.save()
                print("Trainers loaded")
    except Exception as e:
        print(f"Error loading data into {Trainer.__name__}: {e}")

#due to differences between normal and non-relational databases trainers will need to be assigned randomly
def add_training():
    reference_iterator = 0

    with open("../csv/training.csv", mode='r', encoding='utf=8') as csv_file:
            csv_reader = csv.DictReader(csv_file)

            reference_fields = {"training_type": TrainingType, "hall": Hall, "trainer": User, "manager": User}

            try:
                for row in csv_reader:
                    reference_iterator = 0
                    result = {}
                    for key, value in row.items():
                        if not (key.endswith('_id') or key.endswith('_by')):
                            if key.endswith('_date') and value:  # Convert dates
                                result[key] = datetime.strptime(value, '%Y-%m-%d')
                            else:
                                result[key] = value
                        else:
                            if reference_fields:
                                field, ref_model = list(reference_fields.items())[reference_iterator]
                                if value != '':
                                    if field == "trainer":
                                        result[field] = get_random(Trainer)
                                    else:
                                        result[field] = ref_model.objects[int(value) - 1]
                                else:
                                    result[field] = None

                                reference_iterator += 1
                            else:
                                pass

                    # Save document
                    document = Training(**result)
                    document.save()
                print("Trainings loaded")
            except Exception as e:
                print(f"Error loading data into {Trainer.__name__}: {e}")

def add_user_types():
    options = ['Administrator', 'Manager', 'Technician', 'Trainer', 'Client']
    try:
        for document in User.objects:
            user_role = UserRole(user_role = random.choice(options))
            document.role = UserRole(Role=user_role)
            document.save()
            print("Roles added")
    except Exception as e:
        print(f"Error loading data into {User.__name__}: {e}")

def add_attendees():
    users = User.objects
    try:
        for document in Training.objects:
            document.attendees = random.sample(users, random.randint(1, 5))
            document.save()
        print("Attendees loaded")
    except Exception as e:
        print(f"Error loading data into {Training.__name__}: {e}")

def main():
    connect(db ='gym', host = '127.0.0.1', port = 27017)

    csv_model_map = {
        "user.csv": (User, None),
        "offer.csv": (Offer, None),
        "membership.csv": (Membership, {"offer": Offer, "owned_by": User}),
        "trainingtype.csv": (TrainingType, None),
        # Big difference between csv data and object structure, generating manually later "trainer.csv": (Trainer, {"user": User, "added_by": User}),
        "departmentlocation.csv": (Department, {"managed_by": User}),
        "hall.csv": (Hall, {"department": Department}),
        "equipment.csv": (Equipment, {"hall": Hall}),
        # Missing file "fault.csv": (Fault, None),
        "lockerroom.csv": (LockerRoom, {"department": Department}),
        "locker.csv": (Locker, {"locker_room": LockerRoom, "occupied_by": Membership}),
        # Will be added after adding trainers "training.csv": (Training, None),
    }

    for file_name, (model, reference_fields) in csv_model_map.items():
        load_csv_data(path_to_csv + file_name, model, reference_fields)

    #due to some changes in structure and generated data this is done separately :(
    add_trainers()
    add_training()
    #load_csv_data(path_to_csv + "training.csv", Training, {"training_type": TrainingType,"hall": Hall, "trainer": User, "manager": User})

    #now adding previously skipped fields of role in User and attendees in Trainig
    add_user_types()
    add_attendees()

if __name__ == '__main__':
    main()
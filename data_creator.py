from faker import Faker
import csv
import random
from datetime import datetime, timedelta

# Initialize Faker
def init_faker():
    fake = Faker('pl_PL')
    return fake

fake = init_faker()

# Helper function to write rows to CSV
def write_to_csv(filename, fieldnames, rows):
    with open(filename, mode='w', newline='', encoding='utf-8') as file:
        writer = csv.DictWriter(file, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)

# Helper function to
def get_duration(file_path, row_index):
    with open(file_path, mode='r') as file:
        reader = csv.DictReader(file)
        rows = list(reader)
        if row_index-1 < len(rows):
            #print('row_index: ', row_index, '\nduration: ', rows[row_index-1]["duration"])
            return rows[row_index-1]["duration"]
        else:
            raise IndexError("Row index out of range")

# Function to create users
def generate_users(num_rows):
    rows = []
    for _ in range(num_rows):
        rows.append({
            "email": fake.unique.email(),
            "firstname": fake.first_name(),
            "lastname": fake.last_name(),
            "phone": fake.unique.phone_number(),
            "password": fake.password(),
            "registrationdate": fake.date_this_decade(),
            "isactive": fake.boolean(),
        })
    write_to_csv("csv/user.csv", rows[0].keys(), rows)

# Function to create administrators
def generate_administrators(num_rows, user_ids):
    rows = []
    for _ in range(num_rows):
        rows.append({
            "userid": random.choice(user_ids),
            "createdat": fake.date_this_year(),
        })
    write_to_csv("csv/administrator.csv", rows[0].keys(), rows)

# Function to create managers
def generate_managers(num_rows, user_ids, admin_ids):
    rows = []
    for _ in range(num_rows):
        rows.append({
            "userid": random.choice(user_ids),
            "addedby": random.choice(admin_ids) if admin_ids else None,
            "createdat": fake.date_this_year(),
        })
    write_to_csv("csv/manager.csv", rows[0].keys(), rows)

# Function to create technicians
def generate_technicians(num_rows, user_ids, manager_ids):
    rows = []
    for _ in range(num_rows):
        rows.append({
            "userid": random.choice(user_ids),
            "addedby": random.choice(manager_ids) if manager_ids else None,
            "createdat": fake.date_this_year(),
        })
    write_to_csv("csv/technician.csv", rows[0].keys(), rows)

# Function to create trainers
def generate_trainers(num_rows, user_ids, manager_ids):
    rows = []
    for _ in range(num_rows):
        rows.append({
            "userid": random.choice(user_ids),
            "addedby": random.choice(manager_ids) if manager_ids else None,
            "createdat": fake.date_this_year(),
        })
    write_to_csv("csv/trainer.csv", rows[0].keys(), rows)

# Function to create clients
def generate_clients(num_rows, user_ids):
    rows = []
    for _ in range(num_rows):
        rows.append({
            "userid": random.choice(user_ids),  # Reference to User ID
        })
    write_to_csv("csv/client.csv", rows[0].keys(), rows)

# Function to create offers
def generate_offers(num_rows):
    rows = []
    for _ in range(num_rows):
        rows.append({
            "name": fake.word(),
            "description": fake.text(max_nb_chars=50),
            "price": round(random.uniform(10, 100), 2),
            "duration": random.randint(1, 12),
            "availabletopurchase": fake.boolean(),
        })
    write_to_csv("csv/offer.csv", rows[0].keys(), rows)

# Function to create memberships
def generate_memberships(num_rows, client_ids, offer_ids):
    rows = []
    for _ in range(num_rows):
        random_offer_id = random.choice(offer_ids)
        start_date = fake.date_this_year()
        end_date = (start_date + timedelta(days=int(get_duration("csv/offer.csv", random_offer_id))*random.randint(1, 20))).strftime("%Y-%m-%d")
        rows.append({
            "startdate": start_date.strftime("%Y-%m-%d"),
            "enddate": end_date,
            "offerid": random_offer_id,
            "ownedby": random.choice(client_ids),
        })
    write_to_csv("csv/membership.csv", rows[0].keys(), rows)

# Function to create training types
def generate_training_types(num_rows):
    training_types = ["Yoga", "Pilates", "CrossFit", "HIIT", "Strength Training", "Cardio", "Boxing"]
    rows = []
    for _ in range(num_rows):
        rows.append({
            "name": random.choice(training_types),
            "description": fake.text(max_nb_chars=100),
        })
    write_to_csv("csv/trainingtype.csv", rows[0].keys(), rows)


# Function to create trainer qualifications
def generate_trainer_qualifications(num_rows, trainer_ids, training_type_ids):
    rows = set()  # Use a set to avoid duplicate pairs
    while len(rows) < num_rows:
        pair = (random.choice(trainer_ids), random.choice(training_type_ids))
        rows.add(pair)  # Only unique pairs will be added to the set

    # Convert set to list of dictionaries
    rows = [{"trainerid": trainer_id, "trainingtypeid": training_type_id} for trainer_id, training_type_id in rows]
    write_to_csv("csv/trainerqualifications.csv", rows[0].keys(), rows)


def generate_trainings(num_rows, training_type_ids, hall_ids, trainer_ids, manager_ids):
    rows = []
    for _ in range(num_rows):
        start_time = fake.time_object()
        end_time = (datetime.combine(datetime.today(), start_time) + timedelta(hours=1)).time()
        rows.append({
            "date": fake.date_this_year(),
            "starttime": start_time.strftime("%H:%M:%S"),
            "endtime": end_time.strftime("%H:%M:%S"),
            "trainingtypeid": random.choice(training_type_ids),
            "hallid": random.choice(hall_ids) if hall_ids else None,
            "trainer": random.choice(trainer_ids) if trainer_ids else None,
            "manager": random.choice(manager_ids) if manager_ids else None,
        })
    write_to_csv("csv/training.csv", rows[0].keys(), rows)


def generate_training_attendance(num_rows, training_ids, client_ids):
    rows = set()  # Use a set to avoid duplicates
    while len(rows) < num_rows:
        training_id = random.choice(training_ids)
        client_id = random.choice(client_ids)
        rows.add((training_id, client_id))  # Adds only unique pairs

    rows = [{"trainingid": training_id, "clientid": client_id} for training_id, client_id in rows]
    write_to_csv("csv/trainingattendance.csv", ["trainingid", "clientid"], rows)


# Function to create department locations
def generate_department_locations(num_rows, manager_ids):
    rows = []
    for _ in range(num_rows):
        rows.append({
            "name": fake.company(),
            "city": fake.city(),
            "postalcode": fake.postcode(),
            "street": fake.street_name(),
            "buildingnumber": fake.building_number(),
            "managedby": random.choice(manager_ids) if manager_ids else None,
        })
    write_to_csv("csv/departmentlocation.csv", rows[0].keys(), rows)

# Function to create halls
def generate_halls(num_rows, department_location_ids):
    rows = []
    for _ in range(num_rows):
        rows.append({
            "name": fake.word(),
            "departmentlocationid": random.choice(department_location_ids),
        })
    write_to_csv("csv/hall.csv", rows[0].keys(), rows)

# Function to create equipment
def generate_equipment(num_rows, hall_ids):
    rows = []
    for _ in range(num_rows):
        rows.append({
            "name": fake.word(),
            "hallid": random.choice(hall_ids),
        })
    write_to_csv("csv/equipment.csv", rows[0].keys(), rows)

# Function to create locker rooms
def generate_locker_rooms(num_rows, department_location_ids):
    locker_room_types = ["Men", "Women", "Unisex"]
    rows = []
    for _ in range(num_rows):
        rows.append({
            "type": random.choice(locker_room_types),
            "departmentlocationid": random.choice(department_location_ids),
        })
    write_to_csv("csv/lockerroom.csv", rows[0].keys(), rows)


# Function to create lockers
def generate_lockers(num_rows, locker_room_ids, membership_ids):
    locker_statuses = ["Free", "Occupied", "Not available"]
    rows = []
    for _ in range(num_rows):
        status = random.choice(locker_statuses)
        rows.append({
            "number": random.randint(1, 100),
            "status": status,
            "lockerroomid": random.choice(locker_room_ids),
            "occupiedby": random.choice(membership_ids) if status == "Occupied" else None,
        })
    write_to_csv("csv/locker.csv", rows[0].keys(), rows)


# Function to create availability
def generate_availability(num_rows, trainer_ids):
    rows = []
    for _ in range(num_rows):
        start_time = fake.time_object(end_datetime=None)  # random time
        end_time = (datetime.combine(datetime.today(), start_time) + timedelta(hours=1)).time()  # add 1 hour
        rows.append({
            "trainerid": random.choice(trainer_ids),
            "date": fake.date_this_year(),
            "starttime": start_time.strftime("%H:%M:%S"),
            "endtime": end_time.strftime("%H:%M:%S"),
        })
    write_to_csv("csv/availability.csv", ["trainerid", "date", "starttime", "endtime"], rows)


if __name__ == '__main__':
    num_users = 100
    num_administrators = 10
    num_managers = 20
    num_technicians = 15
    num_trainers = 20
    num_clients = 50
    num_offers = 15
    num_memberships = 30
    num_training_types = 10
    num_department_locations = 5
    num_halls = 10
    num_equipment = 20
    num_lockers = 15
    num_trainer_qualifications = 20
    num_availability_records = 20
    num_training_sessions = 25
    num_training_attendance = 50

    generate_users(num_users)
    user_ids = list(range(1, num_users + 1))

    generate_administrators(num_administrators, user_ids)
    admin_ids = list(range(1, num_administrators + 1))

    generate_managers(num_managers, user_ids, admin_ids)
    manager_ids = list(range(1, num_managers + 1))

    generate_technicians(num_technicians, user_ids, manager_ids)
    technician_ids = list(range(1, num_technicians + 1))

    generate_trainers(num_trainers, user_ids, manager_ids)
    trainer_ids = list(range(1, num_trainers + 1))

    generate_offers(num_offers)
    offer_ids = list(range(1, num_offers + 1))

    generate_clients(num_clients, user_ids)
    client_ids = list(range(1, num_clients + 1))

    generate_memberships(num_memberships, client_ids, offer_ids)

    generate_training_types(num_training_types)
    training_type_ids = list(range(1, num_training_types + 1))

    generate_department_locations(num_department_locations, manager_ids)
    department_location_ids = list(range(1, num_department_locations + 1))

    generate_halls(num_halls, department_location_ids)
    hall_ids = list(range(1, num_halls + 1))

    generate_equipment(num_equipment, hall_ids)
    equipment_ids = list(range(1, num_equipment + 1))

    generate_locker_rooms(3, department_location_ids)
    locker_room_ids = list(range(1, 4))

    generate_lockers(num_lockers, locker_room_ids, list(range(1, num_memberships + 1)))

    generate_trainer_qualifications(num_trainer_qualifications, trainer_ids, training_type_ids)

    generate_availability(num_availability_records, trainer_ids)

    generate_trainings(num_training_sessions, training_type_ids, hall_ids, trainer_ids, manager_ids)
    training_ids = list(range(1, num_training_sessions + 1))

    generate_training_attendance(num_training_attendance, training_ids, client_ids)



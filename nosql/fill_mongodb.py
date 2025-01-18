from mongoengine import connect
from mongo_structure import *
from datetime import datetime, timezone

connect('gym')

# Create embedded role doc for user
user_role = UserRole(
    name='Trainer',
    added_by=None
)

# Create a User
user = User(
    email='john.doe@example.com',
    first_name='John',
    last_name='Doe',
    phone='1234567890',
    password='hashed_password',
    role=user_role
)
user.save()

# Create an Offer
offer = Offer(
    name='Premium Membership',
    description='Access to all gym facilities',
    price=100.0,
    duration=30
)
offer.save()

# Create a Membership
membership = Membership(
    start_date=datetime.now(timezone.utc),
    end_date=datetime(2023, 12, 31),
    offer=offer,
    owned_by=user
)
membership.save()

# Create a TrainingType
training_type = TrainingType(
    name='Yoga',
    description='A relaxing physical exercise class focusing on flexibility and mindfulness.'
)
training_type.save()

# Create a Trainer
trainer = Trainer(
    user=user,
    qualifications=[training_type],
    availability=[Availability(date=datetime.now(timezone.utc), start_time='08:00', end_time='09:00')]
)
trainer.save()

# Create a DepartmentLocation
department = Department(
    name='Main Gym',
    city='Warsaw',
    postal_code='00-001',
    street='Main Street',
    building_number='1A',
    managed_by=user
)
department.save()

# Create a Hall
hall = Hall(
    name='Yoga Hall',
    department=department
)
hall.save()

# Create an Equipment
equipment = Equipment(
    name='Yoga Mat',
    hall=hall
)
equipment.save()

# Create a Fault
fault = Fault(
    description='Mat is damaged.',
    equipment=equipment,
    handled_by=user,
    added_by=user
)
fault.save()

# Create a LockerRoom
locker_room = LockerRoom(
    type='Men',
    department=department
)
locker_room.save()

# Create a Locker
locker = Locker(
    number=1,
    locker_room=locker_room,
    occupied_by=membership
)
locker.save()

# Create a Training
training = Training(
    date=datetime.now(timezone.utc),
    start_time='10:00',
    end_time='11:00',
    training_type=training_type,
    hall=hall,
    trainer=trainer,
    manager=user,
    attendees=[user]
)
training.save()


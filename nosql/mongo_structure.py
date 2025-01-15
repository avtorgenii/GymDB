from mongoengine import Document, StringField, DateField, BooleanField, ReferenceField, ListField, EmbeddedDocument, \
    EmbeddedDocumentField, FloatField, IntField, EmailField
from datetime import datetime, timezone



# User collection
class User(Document):
    email = EmailField(max_length=100, unique=True, required=True)
    first_name = StringField(max_length=255)
    last_name = StringField(max_length=255)
    phone = StringField(max_length=25, unique=True)
    password = StringField(required=True)
    registration_date = DateField(default=datetime.now(timezone.utc))
    is_active = BooleanField(default=True)
    role = StringField(choices=['Administrator', 'Manager', 'Technician', 'Trainer', 'Client'], required=True) # May be modified in future if new roles appear
    created_at = DateField(default=datetime.now(timezone.utc))
    added_by = ReferenceField('User')


# Offer collection
class Offer(Document):
    name = StringField(max_length=50, required=True)
    description = StringField(max_length=255)
    price = FloatField(min_value=0.0, required=True)
    duration = IntField(min_value=0, required=True)
    available_to_purchase = BooleanField(default=True)


# Membership collection
class Membership(Document):
    start_date = DateField(default=datetime.now(timezone.utc))
    end_date = DateField()
    offer = ReferenceField(Offer, required=True)
    owned_by = ReferenceField(User, required=True)  # Client's reference


# TrainingType collection
class TrainingType(Document):
    name = StringField(required=True)
    description = StringField(max_length=500)


# Availability embedded document
class Availability(EmbeddedDocument):
    date = DateField(default=datetime.now)
    start_time = StringField()
    end_time = StringField()


# Trainer collection
class Trainer(Document): # Okay solution to make another collection for Trainer???
    user = ReferenceField(User, required=True)
    qualifications = ListField(ReferenceField(TrainingType))
    availability = ListField(EmbeddedDocumentField(Availability))


# DepartmentLocation collection
class DepartmentLocation(Document):
    name = StringField(max_length=255, required=True)
    city = StringField(max_length=255, required=True)
    postal_code = StringField(max_length=50, required=True)
    street = StringField(max_length=255, required=True)
    building_number = StringField(max_length=10, required=True)
    managed_by = ReferenceField(User, reverse_delete_rule='NULLIFY')


# Hall collection
class Hall(Document):
    name = StringField(max_length=255, required=True)
    department_location = ReferenceField(DepartmentLocation, required=True)


# Equipment collection
class Equipment(Document):
    name = StringField(max_length=255, required=True)
    hall = ReferenceField(Hall, required=True)


# Fault collection
class Fault(Document):
    description = StringField(max_length=255)
    date_reported = DateField(default=datetime.now(timezone.utc))
    status = StringField(choices=['Reported', 'Under Repair', 'Fixed', 'Cannot Be Repaired'], default='Reported')
    equipment = ReferenceField(Equipment, required=True)
    handled_by = ReferenceField(User, reverse_delete_rule='NULLIFY') # handled by technician role
    added_by = ReferenceField(User, reverse_delete_rule='NULLIFY') # added by technician or manager role


# LockerRoom collection
class LockerRoom(Document):
    type = StringField(choices=["Men", "Women", "Unisex"], max_length=50, required=True)
    department_location = ReferenceField(DepartmentLocation, required=True)


# Locker collection
class Locker(Document):
    number = IntField(required=True)
    status = StringField(choices=['Free', 'Occupied', 'Not Available'], default='Free')
    locker_room = ReferenceField(LockerRoom, required=True)
    occupied_by = ReferenceField(Membership)


# Training collection
class Training(Document):
    date = DateField(required=True)
    start_time = StringField(required=True, regex=r'^\d{2}:\d{2}(:\d{2})?$')  # HH:mm or HH:mm:ss
    end_time = StringField(required=True, regex=r'^\d{2}:\d{2}(:\d{2})?$')  # HH:mm or HH:mm:ss
    training_type = ReferenceField(TrainingType, required=True)
    hall = ReferenceField(Hall, required=True)
    trainer = ReferenceField(Trainer, required=True)
    manager = ReferenceField(User, required=True)
    attendees = ListField(ReferenceField(User))



# Trainer test
if __name__ == '__main__':
    user = User()
    trainer = Trainer()
    trainer.user = user
    trainer.user.first_name = 'John'

    print(trainer.user.created_at)
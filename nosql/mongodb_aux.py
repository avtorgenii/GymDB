from mongo_structure import *
from mongoengine import Document
from datetime import datetime, timezone
import random

availabilities = [
Availability(date=datetime.now(timezone.utc), start_time='08:00', end_time='09:00'),
Availability(date=datetime.now(timezone.utc), start_time='09:00', end_time='09:00'),
Availability(date=datetime.now(timezone.utc), start_time='10:00', end_time='10:30'),
Availability(date=datetime.now(timezone.utc), start_time='11:00', end_time='13:00'),
Availability(date=datetime.now(timezone.utc), start_time='12:00', end_time='14:00'),
Availability(date=datetime.now(timezone.utc), start_time='13:00', end_time='21:00'),
Availability(date=datetime.now(timezone.utc), start_time='14:00', end_time='20:00'),
Availability(date=datetime.now(timezone.utc), start_time='15:00', end_time='20:00'),
Availability(date=datetime.now(timezone.utc), start_time='16:00', end_time='20:00'),
Availability(date=datetime.now(timezone.utc), start_time='17:00', end_time='20:00'),
Availability(date=datetime.now(timezone.utc), start_time='18:00', end_time='19:00'),
Availability(date=datetime.now(timezone.utc), start_time='19:00', end_time='23:00'),
Availability(date=datetime.now(timezone.utc), start_time='20:00', end_time='23:00'),
Availability(date=datetime.now(timezone.utc), start_time='21:00', end_time='22:00'),
]

#for simple modifications, a method to get availability TEMPORARY SOLUTION PROBABLY SHOULD BE CHANGED
def get_random_availability():
    result = [random.choice(availabilities)]
    return result

def get_random(model):
    return random.choice(model.objects)
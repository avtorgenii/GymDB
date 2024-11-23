import pandas as pd
from sqlalchemy import create_engine, URL, text


# Init engine
def get_engine():
    connection_string = URL.create(
        'postgresql',
        'neondb_owner',
        'r9pbKuNMgOa0',
        'ep-tight-water-a2aw5dtw.eu-central-1.aws.neon.tech',
        database='gym',
        query={'sslmode': 'require', 'options': 'endpoint=ep-tight-water-a2aw5dtw'}
    )
    return create_engine(connection_string)



def fill_table(table_name, path, engine, reset_table=False):
    print(f"Filling table {table_name}...")
    df = pd.read_csv(path)

    # Clear table before filling
    if reset_table:
        with engine.connect() as connection:
            connection.execute(text(f'TRUNCATE TABLE "{table_name}" RESTART IDENTITY CASCADE;'))
            connection.commit()

    df.to_sql(table_name, engine, if_exists='append', index=False)

    print(f"Filled table {table_name}")

engine = get_engine()

# Filling tables
fill_table("User", "csv/user.csv", engine, True)
fill_table("Administrator", "csv/administrator.csv", engine, True)
fill_table("Manager", "csv/manager.csv", engine, True)
fill_table("Technician", "csv/technician.csv", engine, True)
fill_table("Trainer", "csv/trainer.csv", engine, True)
fill_table("Client", "csv/client.csv", engine, True)
fill_table("Offer", "csv/offer.csv", engine, True)
fill_table("Membership", "csv/membership.csv", engine, True)
fill_table("TrainingType", "csv/trainingtype.csv", engine, True)
fill_table("TrainerQualifications", "csv/trainerqualifications.csv", engine, True)
fill_table("DepartmentLocation", "csv/departmentlocation.csv", engine, True)
fill_table("Hall", "csv/hall.csv", engine, True)
fill_table("Equipment", "csv/equipment.csv", engine, True)
fill_table("LockerRoom", "csv/lockerroom.csv", engine, True)
fill_table("Locker", "csv/locker.csv", engine, True)
fill_table("Training", "csv/training.csv", engine, True)
fill_table("TrainingAttendance", "csv/trainingattendance.csv", engine, True)
fill_table("Availability", "csv/availability.csv", engine, True)
fill_table("Fault", "csv/fault.csv", engine, True)


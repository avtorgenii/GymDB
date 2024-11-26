create index if not exists idx_locker_status on "Locker" USING BTREE(status);

create index if not exists idx_fault_status_equipmentid on "Fault" (status, equipmentid);
create index if not exists idx_equipment_name_status on "Equipment" (name);

CREATE INDEX if not exists idx_availability_date ON "Availability" (date);

CREATE INDEX if not exists idx_user_email_hash ON "User" USING HASH (email);


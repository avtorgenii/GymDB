create index if not exists idx_locker_status on "Locker" (status);

create index if not exists idx_fault_status_equipmentid on "Fault" (status, equipmentid);
create index if not exists idx_equipment_name_status on "Equipment" (name);





-- Drop primary, unique and foreign key constraints 
alter table OPERACION.SECUENCIA_ESTADOS_AGENDA
  drop constraint PK_SEC_EST_AGE cascade;

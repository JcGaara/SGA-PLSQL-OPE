
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.SECUENCIA_ESTADOS_AGENDA
  add constraint pk_sec_Est_Age primary key (ESTAGENDAINI, ESTAGENDAFIN, TIPTRA);
  
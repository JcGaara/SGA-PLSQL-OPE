-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.MOT_SOLUCIONXFOR
  add constraint PK_MOT_SOLUCIONXFOR primary key (CODFOR, TIPTRA, CODMOT_SOLUCION);
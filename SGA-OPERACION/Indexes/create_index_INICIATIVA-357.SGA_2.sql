-- Create/Recreate indexes 

create index OPERACION.IDX_AGENDAMIENTO_DNITECNICO on OPERACION.AGENDAMIENTO (DNI_TECNICO)
  tablespace OPERACION_IDX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 52M
    next 1M
    minextents 1
    maxextents unlimited
  );
  
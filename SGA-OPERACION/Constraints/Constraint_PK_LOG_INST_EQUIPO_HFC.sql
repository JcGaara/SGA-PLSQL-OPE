alter table OPERACION.LOG_INST_EQUIPO_HFC
  add constraint PK_LOG_INST_EQUIPO_HFC primary key (log_id, idagenda)
  using index 
  tablespace OPERACION_IDX
  pctfree 10
  initrans 2
  maxtrans 255;
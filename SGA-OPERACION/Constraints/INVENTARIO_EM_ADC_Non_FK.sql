alter table OPERACION.INVENTARIO_EM_ADC
  add constraint PK_INVENTARIO_EM_ADC primary key (IDUNICO)
  using index 
  tablespace OPERACION_IDX;

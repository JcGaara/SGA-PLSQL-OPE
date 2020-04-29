alter table OPERACION.MATRIZ_TIPTRATIPSRVMOT_ADC
  add constraint PK_MATRIZ_TIPTRATIPSRVMOT_ADC primary key (ID_MATRIZ, ID_MOTIVO)
  using index 
  tablespace OPERACION_IDX;
  
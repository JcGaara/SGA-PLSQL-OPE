-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.OPE_SINERGIA_FILTROS_TMP
  add constraint PK_OPE_SINERGIA_FILTROS_TMP primary key (IDVALOR)
  using index 
  tablespace OPERACION_IDX;
  

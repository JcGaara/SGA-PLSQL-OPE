-- Create/Recreate primary, unique and foreign key constraints 
alter table operacion.shfct_det_tras_ext
  ADD CONSTRAINT pk_shfct_det_tras_ext primary key (SHFCN_CODSOLOT)
  using index 
  tablespace OPERACION_IDX;


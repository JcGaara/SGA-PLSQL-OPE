-- Create table
create table OPERACION.TRS_INTERFACE_IW_DET
(
  idtrs    NUMBER not null,
  atributo VARCHAR2(50) not null,
  valor    VARCHAR2(50),
  orden    NUMBER,
  fecusu   DATE default SYSDATE,
  codusu   VARCHAR2(30) default USER
)
tablespace OPERACION_DAT;
-- Add comments to the table 
comment on table OPERACION.TRS_INTERFACE_IW_DET
  is 'Detalla de transacciones enviadas a BSCS desde SGA';
-- Add comments to the columns 
comment on column OPERACION.TRS_INTERFACE_IW_DET.idtrs
  is 'Id Trs';
comment on column OPERACION.TRS_INTERFACE_IW_DET.atributo
  is 'Atributo';
comment on column OPERACION.TRS_INTERFACE_IW_DET.valor
  is 'Valor';
comment on column OPERACION.TRS_INTERFACE_IW_DET.orden
  is 'Orden';
comment on column OPERACION.TRS_INTERFACE_IW_DET.fecusu
  is 'Fecha Registro';
comment on column OPERACION.TRS_INTERFACE_IW_DET.codusu
  is 'Usuario Registro';
-- Create/Recreate indexes 
create index OPERACION.IDXINTIWDET on OPERACION.TRS_INTERFACE_IW_DET (IDTRS)
  tablespace OPERACION_DAT;
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.TRS_INTERFACE_IW_DET
  add constraint PK_TRS_INT_IW_DET primary key (IDTRS, ATRIBUTO)
  using index 
  tablespace OPERACION_DAT;

-- Create table
create table OPERACION.SGAT_CONTROL_APP
(
  controln_id       NUMBER(10) not null,
  controln_codsolot NUMBER(8),
  controlv_usureg   VARCHAR2(30),
  controld_fecreg   DATE
)
tablespace OPERACION_DAT
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
-- Add comments to the columns 
comment on column OPERACION.SGAT_CONTROL_APP.controln_id
  is 'Id del Control secuencial';
comment on column OPERACION.SGAT_CONTROL_APP.controln_codsolot
  is 'SOT registrada';
comment on column OPERACION.SGAT_CONTROL_APP.controlv_usureg
  is 'Usuario que creo el registro';
comment on column OPERACION.SGAT_CONTROL_APP.controld_fecreg
  is 'Fecha que se creo el registro';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.SGAT_CONTROL_APP
  add constraint PK_SGAT_CONTROL_APP primary key (CONTROLN_ID)
  using index 
  tablespace OPERACION_DAT
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table OPERACION.SGAT_CONTROL_APP
  add foreign key (CONTROLN_ID)
  references OPERACION.SGAT_CONTROL_APP (CONTROLN_ID);

-- Create table
create table OPERACION.SGAT_USU_DW
(
  usudv_usuario VARCHAR2(30) not null,
  usudv_usureg  VARCHAR2(30) default user,
  usudd_fecmod  DATE default sysdate,
  usudn_activo  NUMBER(1)
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
comment on column OPERACION.SGAT_USU_DW.usudv_usuario
  is 'Usuario';
comment on column OPERACION.SGAT_USU_DW.usudv_usureg
  is 'Usuario que realizo la modificación';
comment on column OPERACION.SGAT_USU_DW.usudd_fecmod
  is 'Fecha de modificación';
comment on column OPERACION.SGAT_USU_DW.usudn_activo
  is '0 usuario inactivo, 1 usuario activo';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.SGAT_USU_DW
  add constraint PK_USU_DW primary key (USUDV_USUARIO)
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
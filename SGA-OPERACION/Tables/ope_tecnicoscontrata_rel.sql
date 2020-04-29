-- Create table
create table OPERACION.OPE_TECNICOSCONTRATA_REL
(
  ID_TECNICO   NUMBER not null,
  CODCON       NUMBER(6),
  NOMBRE       VARCHAR2(200),
  RPC          NUMBER(10),
  ESTADO       NUMBER(1) default 1,
  CODCUADRILLA VARCHAR2(5),
  FECREG       DATE default SYSDATE not null,
  USUREG       VARCHAR2(30) default user not null,
  FECMOD       DATE default SYSDATE not null,
  USUMOD       VARCHAR2(30) default user not null
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
-- Add comments to the table 
comment on table OPERACION.OPE_TECNICOSCONTRATA_REL
  is 'TABLA QUE ALMACENA LOS TECNICOS POR CONTRATA';
-- Add comments to the columns 
comment on column OPERACION.OPE_TECNICOSCONTRATA_REL.ID_TECNICO
  is 'IDENTIFICADOR DEL TECNICO DE LA CONTRATA';
comment on column OPERACION.OPE_TECNICOSCONTRATA_REL.CODCON
  is 'Codigo de la contrata';
comment on column OPERACION.OPE_TECNICOSCONTRATA_REL.NOMBRE
  is 'NOMBRE DEL TECNICO';
comment on column OPERACION.OPE_TECNICOSCONTRATA_REL.RPC
  is 'TELEFONO DEL TECNICO';
comment on column OPERACION.OPE_TECNICOSCONTRATA_REL.ESTADO
  is 'ESTADO: 1 ACTIVO 0: INACTIVO';
comment on column OPERACION.OPE_TECNICOSCONTRATA_REL.CODCUADRILLA
  is 'Codigo de la cuadrilla';
comment on column OPERACION.OPE_TECNICOSCONTRATA_REL.FECREG
  is 'FECHA DE REGISTRO';
comment on column OPERACION.OPE_TECNICOSCONTRATA_REL.USUREG
  is 'USUARIO DE REGISTRO';
comment on column OPERACION.OPE_TECNICOSCONTRATA_REL.FECMOD
  is 'FECHA DE MODIFICACIÓN';
comment on column OPERACION.OPE_TECNICOSCONTRATA_REL.USUMOD
  is 'USUARIO DE MODIFICACIÓN';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.OPE_TECNICOSCONTRATA_REL
  add constraint PK_TECNICOSCONTRATA primary key (ID_TECNICO)
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

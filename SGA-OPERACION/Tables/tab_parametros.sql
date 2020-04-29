-- Create table
create table OPERACION.TAB_PARAMETROS
(
  clave       VARCHAR2(200),
  descripcion VARCHAR2(500),
  tipo        VARCHAR2(500),
  estado      NUMBER(2) default 0,
  data_n1     NUMBER,
  data_n2     NUMBER,
  data_n3     NUMBER,
  data_v1     VARCHAR2(4000),
  data_v2     VARCHAR2(4000),
  data_v3     VARCHAR2(4000),
  data_d1     DATE,
  data_d2     DATE,
  fecusu      DATE default SYSDATE not null,
  codusu      VARCHAR2(50) default USER not null
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
comment on table OPERACION.TAB_PARAMETROS
  is 'Listado de parametros.';
-- Add comments to the columns 
comment on column OPERACION.TAB_PARAMETROS.clave
  is 'Palabra clave';
comment on column OPERACION.TAB_PARAMETROS.descripcion
  is 'Descripcion del parametro.';
comment on column OPERACION.TAB_PARAMETROS.tipo
  is 'Tipo de parametro.';
comment on column OPERACION.TAB_PARAMETROS.estado
  is 'Estado del parametro.';
comment on column OPERACION.TAB_PARAMETROS.data_n1
  is 'Valor numérico 1.';
comment on column OPERACION.TAB_PARAMETROS.data_n2
  is 'Valor numérico 2.';
comment on column OPERACION.TAB_PARAMETROS.data_n3
  is 'Valor numérico 3.';
comment on column OPERACION.TAB_PARAMETROS.data_v1
  is 'Valor cadena 1.';
comment on column OPERACION.TAB_PARAMETROS.data_v2
  is 'Valor cadena 2.';
comment on column OPERACION.TAB_PARAMETROS.data_v3
  is 'Valor cadena 3.';
comment on column OPERACION.TAB_PARAMETROS.data_d1
  is 'Valor Fecha 1.';
comment on column OPERACION.TAB_PARAMETROS.data_d2
  is 'Valor Fecha 2.';
-- Create/Recreate indexes 
create index IDX_PARAMETROS_001 on OPERACION.TAB_PARAMETROS (CLAVE)
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
create index IDX_PARAMETROS_002 on OPERACION.TAB_PARAMETROS (CLAVE, DATA_N1)
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
create index IDX_PARAMETROS_003 on OPERACION.TAB_PARAMETROS (CLAVE, DATA_V1)
  tablespace OPERACION_DAT
  pctfree 10
  initrans 2
  maxtrans 159
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index IDX_PARAMETROS_004 on OPERACION.TAB_PARAMETROS (CLAVE, TIPO)
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
create index IDX_PARAMETROS_005 on OPERACION.TAB_PARAMETROS (TIPO)
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

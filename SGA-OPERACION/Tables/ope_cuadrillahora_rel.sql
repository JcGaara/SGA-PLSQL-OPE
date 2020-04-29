-- Create table
create table OPERACION.OPE_CUADRILLAHORA_REL
(
  ID_CUADRILLAHORA NUMBER not null,
  CODCUADRILLA     VARCHAR2(5),
  FECREG           DATE default SYSDATE not null,
  USUREG           VARCHAR2(30) default user not null,
  FECMOD           DATE default SYSDATE not null,
  USUMOD           VARCHAR2(30) default user not null,
  ESTADO           NUMBER(1) default 1,
  RECOSI           NUMBER,
  TIPTRA           NUMBER,
  CODCLI           CHAR(8),
  HORA_INI         VARCHAR2(15),
  HORA_FIN         VARCHAR2(15),
  HORAS            NUMBER,
  FECHA_TRABAJO    VARCHAR2(15),
  CODINCIDENCE     NUMBER(8),
  TRANSFERENCIA    NUMBER(1) default 1,
  HORA_INI_VAR     VARCHAR2(15),
  HORA_FIN_VAR     VARCHAR2(15),
  NUMEROVECES      NUMBER(2) default 0
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
comment on table OPERACION.OPE_CUADRILLAHORA_REL
  is 'TABLA QUE ALMACENA LA CUADRILLA Y EL HORARIO A TRABAJAR';
-- Add comments to the columns 
comment on column OPERACION.OPE_CUADRILLAHORA_REL.ID_CUADRILLAHORA
  is 'IDENTIFICADOR';
comment on column OPERACION.OPE_CUADRILLAHORA_REL.CODCUADRILLA
  is 'CODIGO DE CUADRILLA';
comment on column OPERACION.OPE_CUADRILLAHORA_REL.FECREG
  is 'FECHA DE REGISTRO';
comment on column OPERACION.OPE_CUADRILLAHORA_REL.USUREG
  is 'USUARIO DE REGISTRO';
comment on column OPERACION.OPE_CUADRILLAHORA_REL.FECMOD
  is 'FECHA DE MODIFICACIÓN';
comment on column OPERACION.OPE_CUADRILLAHORA_REL.USUMOD
  is 'USUARIO DE MODIFICACIÓN';
comment on column OPERACION.OPE_CUADRILLAHORA_REL.ESTADO
  is 'ESTADO: 1 ACTIVO 0: INACTIVO 2: REAGENDADA 3 : CANCELADA';
comment on column OPERACION.OPE_CUADRILLAHORA_REL.RECOSI
  is 'NUMERO DE TICKET';
comment on column OPERACION.OPE_CUADRILLAHORA_REL.TIPTRA
  is 'TIPO DE TRABAJO';
comment on column OPERACION.OPE_CUADRILLAHORA_REL.CODCLI
  is 'CODIGO DE CLIENTE';
comment on column OPERACION.OPE_CUADRILLAHORA_REL.HORA_INI
  is 'HORA DE INICIO';
comment on column OPERACION.OPE_CUADRILLAHORA_REL.HORA_FIN
  is 'HORA DE TERMINO';
comment on column OPERACION.OPE_CUADRILLAHORA_REL.HORAS
  is 'NUMERO DE HORAS';
comment on column OPERACION.OPE_CUADRILLAHORA_REL.FECHA_TRABAJO
  is 'FECHA DE TRABAJO DE LA CUADRILLA';
comment on column OPERACION.OPE_CUADRILLAHORA_REL.CODINCIDENCE
  is 'CODIGO DE LA INCIDENCIA';
comment on column OPERACION.OPE_CUADRILLAHORA_REL.TRANSFERENCIA
  is 'TRANSFERIDO: 2, GENERADO: 1 , ANULADA: 0 ';
comment on column OPERACION.OPE_CUADRILLAHORA_REL.HORA_INI_VAR
  is 'HORA DE INICIO VARIABLE';
comment on column OPERACION.OPE_CUADRILLAHORA_REL.HORA_FIN_VAR
  is 'HORA DE TERMINO VARIABLE';
comment on column OPERACION.OPE_CUADRILLAHORA_REL.NUMEROVECES
  is 'NUMERO DE VECES REAGENDADA';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.OPE_CUADRILLAHORA_REL
  add constraint PK_CUADRILLAHORA primary key (ID_CUADRILLAHORA)
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
alter table OPERACION.OPE_CUADRILLAHORA_REL
  add constraint IDX_CUADRILLA2 unique (CODCUADRILLA, HORA_INI, FECHA_TRABAJO, ESTADO, CODINCIDENCE)
  using index 
  tablespace OPERACION_IDX
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
alter table OPERACION.OPE_CUADRILLAHORA_REL
  add constraint IDX_CUADRILLA3 unique (CODINCIDENCE)
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

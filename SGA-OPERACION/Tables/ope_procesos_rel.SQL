-- Create table
create table OPERACION.OPE_PROCESOS_REL
(
  IDPROCESO      NUMBER not null,
  IDGRUPOMENSAJE NUMBER,
  PROCESO        VARCHAR2(30),
  ORDEN          NUMBER,
  TIPOPROCESO    CHAR(3),
  ESTADO         NUMBER,
  USUREG         VARCHAR2(30) default USER,
  FECREG         DATE default SYSDATE,
  USUMOD         VARCHAR2(30) default USER,
  FECMOD         DATE default SYSDATE
)
tablespace OPERACION_DAT
;
-- Add comments to the table 
comment on table OPERACION.OPE_PROCESOS_REL
  is 'TABLA RELACIONAL DE PROCESOS';
-- Add comments to the columns 
comment on column OPERACION.OPE_PROCESOS_REL.IDPROCESO
  is 'ID DEL PROCESO';
comment on column OPERACION.OPE_PROCESOS_REL.IDGRUPOMENSAJE
  is 'ID GRUPO DE MENSAJE';
comment on column OPERACION.OPE_PROCESOS_REL.PROCESO
  is 'PROCESO';
comment on column OPERACION.OPE_PROCESOS_REL.ORDEN
  is 'ORDEN';
comment on column OPERACION.OPE_PROCESOS_REL.TIPOPROCESO
  is 'TIPO DE PROCESO';
comment on column OPERACION.OPE_PROCESOS_REL.ESTADO
  is 'ESTADO';
comment on column OPERACION.OPE_PROCESOS_REL.USUREG
  is 'USUARIO DE REGISTRO';
comment on column OPERACION.OPE_PROCESOS_REL.FECREG
  is 'FECHA DE REGISTRO';
comment on column OPERACION.OPE_PROCESOS_REL.USUMOD
  is 'USAURIO DE MODIFICACION';
comment on column OPERACION.OPE_PROCESOS_REL.FECMOD
  is 'FECHA DE MODIFICACION';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.OPE_PROCESOS_REL
  add constraint PK_OPE_PROCESOS_REL primary key (IDPROCESO)
  using index 
  tablespace OPERACION_DAT
  ;

grant delete on operacion.OPE_PROCESOS_REL to R_PROD;

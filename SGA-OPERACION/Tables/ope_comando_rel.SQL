-- Create table
create table OPERACION.OPE_COMANDO_REL
(
  IDCOMANDO         NUMBER not null,
  COMANDO           NUMBER,
  ORDEN             NUMBER default 1,
  PROCEDIMIENTO     VARCHAR2(1000),
  IDSERVMENS        NUMBER,
  IDPARAMETRO       NUMBER,
  USUREG            VARCHAR2(30) default USER,
  FECREG            DATE default SYSDATE,
  USUMOD            VARCHAR2(30) default USER,
  FECMOD            DATE default SYSDATE,
  ESTADO            NUMBER(1) default 1,
  ID_INTERFASE_BASE VARCHAR2(30)
)
tablespace OPERACION_DAT
;
-- Add comments to the table 
comment on table OPERACION.OPE_COMANDO_REL
  is 'TABLA DE COMANDOS DE MENSAJES';
-- Add comments to the columns 
comment on column OPERACION.OPE_COMANDO_REL.IDCOMANDO
  is 'ID DE COMANDO';
comment on column OPERACION.OPE_COMANDO_REL.COMANDO
  is 'COMANDO';
comment on column OPERACION.OPE_COMANDO_REL.ORDEN
  is 'ORDEN';
comment on column OPERACION.OPE_COMANDO_REL.PROCEDIMIENTO
  is 'PROCEDIMIENTO';
comment on column OPERACION.OPE_COMANDO_REL.IDSERVMENS
  is 'ID SERVICIO DE MENSAJE';
comment on column OPERACION.OPE_COMANDO_REL.IDPARAMETRO
  is 'ID PARAMETRO';
comment on column OPERACION.OPE_COMANDO_REL.USUREG
  is 'USUARIO DE REGISTRO';
comment on column OPERACION.OPE_COMANDO_REL.FECREG
  is 'FECHA DE REGISTRO';
comment on column OPERACION.OPE_COMANDO_REL.USUMOD
  is 'USUARIO DE MODIFICACION';
comment on column OPERACION.OPE_COMANDO_REL.FECMOD
  is 'FECHA DE MODIFICACION';
comment on column OPERACION.OPE_COMANDO_REL.ESTADO
  is 'ESTADO';
comment on column OPERACION.OPE_COMANDO_REL.ID_INTERFASE_BASE
  is 'ID INTERFASE BASE';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.OPE_COMANDO_REL
  add constraint PK_OPE_COMANDO_REL primary key (IDCOMANDO)
  using index 
  tablespace OPERACION_DAT
 ;

grant delete on operacion.OPE_COMANDO_REL to R_PROD;

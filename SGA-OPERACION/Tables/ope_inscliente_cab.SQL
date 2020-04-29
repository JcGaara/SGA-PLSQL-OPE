-- Create table
create table OPERACION.OPE_INSCLIENTE_CAB
(
  ID_LOTE NUMBER not null,
  NOMBRE  VARCHAR2(30),
  FECREG  DATE default SYSDATE,
  USUREG  VARCHAR2(30) default USER,
  FECMOD  DATE default SYSDATE,
  USUMOD  VARCHAR2(30) default USER,
  ESTADO  NUMBER(1) default 1,
  TIPO    NUMBER
)
tablespace OPERACION_DAT
 ;
-- Add comments to the table 
comment on table OPERACION.OPE_INSCLIENTE_CAB
  is 'TABLA CABECERA DE LOTE';
-- Add comments to the columns 
comment on column OPERACION.OPE_INSCLIENTE_CAB.ID_LOTE
  is 'IDENTIFICADOR DE LOTE';
comment on column OPERACION.OPE_INSCLIENTE_CAB.NOMBRE
  is 'NOMBRE DEL LOTE';
comment on column OPERACION.OPE_INSCLIENTE_CAB.FECREG
  is 'FECHA DE REGISTRO';
comment on column OPERACION.OPE_INSCLIENTE_CAB.USUREG
  is 'USUARIO DE REGISTRO';
comment on column OPERACION.OPE_INSCLIENTE_CAB.FECMOD
  is 'FECHA DE MODIFICACION';
comment on column OPERACION.OPE_INSCLIENTE_CAB.USUMOD
  is 'USUARIO DE MODIFICACION';
comment on column OPERACION.OPE_INSCLIENTE_CAB.ESTADO
  is 'ESTADO';
comment on column OPERACION.OPE_INSCLIENTE_CAB.TIPO
  is 'TIPO';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.OPE_INSCLIENTE_CAB
  add constraint PK_INCLIENTE_CAB primary key (ID_LOTE)
  using index 
  tablespace OPERACION_DAT
 ;

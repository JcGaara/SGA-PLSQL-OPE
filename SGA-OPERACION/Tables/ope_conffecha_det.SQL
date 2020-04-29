-- Create table
create table OPERACION.OPE_CONFFECHA_DET
(
  CODFECHA   NUMBER not null,
  CAMPOFECHA VARCHAR2(15),
  USUREG     VARCHAR2(30) default USER,
  FECREG     DATE default SYSDATE,
  USUMOD     VARCHAR2(30) default USER,
  FECMOD     DATE default SYSDATE
)
tablespace OPERACION_DAT
;
-- Add comments to the table 
comment on table OPERACION.OPE_CONFFECHA_DET
  is 'TABLA DE CONFIGURACION DE FECHA';
-- Add comments to the columns 
comment on column OPERACION.OPE_CONFFECHA_DET.CODFECHA
  is 'CODIGO DE FECHA';
comment on column OPERACION.OPE_CONFFECHA_DET.CAMPOFECHA
  is 'CAMPO DE FECHA';
comment on column OPERACION.OPE_CONFFECHA_DET.USUREG
  is 'USUARIO DE REGISTRO';
comment on column OPERACION.OPE_CONFFECHA_DET.FECREG
  is 'FECHA DE REGISTRO';
comment on column OPERACION.OPE_CONFFECHA_DET.USUMOD
  is 'USUARIO DE MODIFICACION';
comment on column OPERACION.OPE_CONFFECHA_DET.FECMOD
  is 'FECHA DE MODIFICACION';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.OPE_CONFFECHA_DET
  add constraint PK_OPE_CONFFECHA_DET primary key (CODFECHA)
  using index 
  tablespace OPERACION_DAT
 ;

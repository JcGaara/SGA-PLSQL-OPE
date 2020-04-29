-- Create table
create table OPERACION.OPE_SEGMENTOMERCADO_REL
(
  IDMENSAJE  NUMBER not null,
  CODSEGMARK NUMBER(5) not null,
  USUREG     VARCHAR2(30) default USER not null,
  FECREG     DATE default SYSDATE not null,
  USUMOD     VARCHAR2(30) default USER not null,
  FECMOD     DATE default SYSDATE not null,
  ESTADO     NUMBER(1) default 1 not null
)
tablespace OPERACION_DAT
;
-- Add comments to the table 
comment on table OPERACION.OPE_SEGMENTOMERCADO_REL
  is 'Tabla de configuracion de segmentos automaticos por Mensajes';
-- Add comments to the columns 
comment on column OPERACION.OPE_SEGMENTOMERCADO_REL.IDMENSAJE
  is 'id del mensaje';
comment on column OPERACION.OPE_SEGMENTOMERCADO_REL.CODSEGMARK
  is 'Id del segmento del mercado';
comment on column OPERACION.OPE_SEGMENTOMERCADO_REL.USUREG
  is 'Usuario de creacion del registro';
comment on column OPERACION.OPE_SEGMENTOMERCADO_REL.FECREG
  is 'Fecha de creacion del resgitro';
comment on column OPERACION.OPE_SEGMENTOMERCADO_REL.USUMOD
  is 'Usuario ultima modificacion del registro';
comment on column OPERACION.OPE_SEGMENTOMERCADO_REL.FECMOD
  is 'Fecha ultima modificacion del registro';
comment on column OPERACION.OPE_SEGMENTOMERCADO_REL.ESTADO
  is 'ESTADO DEL SEGMENTO DE MERCADO';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.OPE_SEGMENTOMERCADO_REL
  add constraint PK_OPE_SEGMENTOMERCADO_REL primary key (CODSEGMARK, IDMENSAJE)
  using index 
  tablespace OPERACION_DAT
 ;
alter table OPERACION.OPE_SEGMENTOMERCADO_REL
  add constraint FK_OPE_SEGMENTOMERCADO_REL foreign key (IDMENSAJE)
  references OPERACION.OPE_MENSAJES_MAE (IDMENSAJE);

grant delete on operacion.OPE_SEGMENTOMERCADO_REL to R_PROD;

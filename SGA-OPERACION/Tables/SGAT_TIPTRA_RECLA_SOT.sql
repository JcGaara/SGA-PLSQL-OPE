-- Create table
create table OPERACION.SGAT_TIPTRA_RECLA_SOT
(
  ttrsv_producto     VARCHAR2(100) not null,
  ttrsn_tipo_trabajo NUMBER(4) not null,
  ttrsn_estado_sot   NUMBER(2) not null,
  ttrsv_genera_sot   VARCHAR2(10) default 'NO' not null,
  ttrsc_estado       CHAR(1) default 1 not null,
  ttrsv_usuario_reg  VARCHAR2(50) default user not null,
  ttrsd_fecha_reg    DATE default sysdate not null,
  ttrsv_usuario_act  VARCHAR2(50),
  ttrsd_usuario_act  DATE
)
tablespace OPERACION_DAT
;

-- Add comments to the columns 
comment on column OPERACION.SGAT_TIPTRA_RECLA_SOT.ttrsv_producto
  is 'Nombre de producto. Ejemplo: HFC, LTE, DTH, etc¿';
comment on column OPERACION.SGAT_TIPTRA_RECLA_SOT.ttrsn_tipo_trabajo
  is 'Tipo de trabajo';
comment on column OPERACION.SGAT_TIPTRA_RECLA_SOT.ttrsn_estado_sot
  is 'Estado de la SOT';
comment on column OPERACION.SGAT_TIPTRA_RECLA_SOT.ttrsv_genera_sot
  is 'SI / NO';
comment on column OPERACION.SGAT_TIPTRA_RECLA_SOT.ttrsc_estado
  is 'Estado lógico del registro:
1: Activo
0: Inactivo
';
comment on column OPERACION.SGAT_TIPTRA_RECLA_SOT.ttrsv_usuario_reg
  is 'Usuario de registro';
comment on column OPERACION.SGAT_TIPTRA_RECLA_SOT.ttrsd_fecha_reg
  is 'Fecha de registro';
comment on column OPERACION.SGAT_TIPTRA_RECLA_SOT.ttrsv_usuario_act
  is 'Usuario de actualización';
comment on column OPERACION.SGAT_TIPTRA_RECLA_SOT.ttrsd_usuario_act
  is 'Fecha de actualización';

-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.SGAT_TIPTRA_RECLA_SOT
  add constraint FK_TT_RECLA_SOT_ESTSOL foreign key (TTRSN_ESTADO_SOT)
  references OPERACION.ESTSOL (ESTSOL);
alter table OPERACION.SGAT_TIPTRA_RECLA_SOT
  add constraint FK_TT_RECLA_SOT_TIPTRABAJO foreign key (TTRSN_TIPO_TRABAJO)
  references OPERACION.TIPTRABAJO (TIPTRA);

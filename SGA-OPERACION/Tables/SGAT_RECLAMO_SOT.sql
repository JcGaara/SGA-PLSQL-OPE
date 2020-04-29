-- Create table
create table OPERACION.SGAT_RECLAMO_SOT
(
  rsotv_nro_sot     NUMBER(8) not null,
  rsotv_nro_caso    VARCHAR2(32) not null,
  rsotv_nro_reclamo VARCHAR2(32) not null,
  rsotc_estado      CHAR(1) default '1' not null,
  rsotv_usuario_reg VARCHAR2(50) default user not null,
  rsotd_fecha_reg   DATE default sysdate not null
)
tablespace OPERACION_DAT
;

-- Add comments to the columns 
comment on column OPERACION.SGAT_RECLAMO_SOT.rsotv_nro_sot
  is 'Número SOT';
comment on column OPERACION.SGAT_RECLAMO_SOT.rsotv_nro_caso
  is 'Número de Caso';
comment on column OPERACION.SGAT_RECLAMO_SOT.rsotv_nro_reclamo
  is 'Número de Reclamo';
comment on column OPERACION.SGAT_RECLAMO_SOT.rsotc_estado
  is 'Estado lógico del registro:
1: Activo
0: Inactivo';
comment on column OPERACION.SGAT_RECLAMO_SOT.rsotv_usuario_reg
  is 'Usuario de registro';
comment on column OPERACION.SGAT_RECLAMO_SOT.rsotd_fecha_reg
  is 'Fecha de registro ';

-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.SGAT_RECLAMO_SOT
  add constraint FK_RECLAMO_SOT_SOLOT foreign key (RSOTV_NRO_SOT)
  references OPERACION.SOLOT (CODSOLOT);

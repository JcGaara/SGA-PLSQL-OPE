-- Create table
create table OPERACION.SGAT_TIPTRA_RECLA
(
  ttrev_aplicacion   VARCHAR2(100) not null,
  ttrev_servicio     VARCHAR2(200) not null,
  ttren_tipo_trabajo NUMBER(4) not null,
  ttrec_estado       CHAR(1) default '1' not null,
  ttrev_usuario_reg  VARCHAR2(50) default USER not null,
  ttred_fecha_reg    DATE default sysdate not null,
  ttrev_usuario_act  VARCHAR2(50),
  ttred_usuario_act  DATE
)
tablespace OPERACION_DAT
;

-- Add comments to the columns 
comment on column OPERACION.SGAT_TIPTRA_RECLA.ttrev_aplicacion
  is 'Aplicación origen';
comment on column OPERACION.SGAT_TIPTRA_RECLA.ttrev_servicio
  is 'Descripción del servicio, tal y como se maneja en los aplicativos';
comment on column OPERACION.SGAT_TIPTRA_RECLA.ttren_tipo_trabajo
  is 'Tipo de trabajo';
comment on column OPERACION.SGAT_TIPTRA_RECLA.ttrec_estado
  is 'Estado lógica del registro:
1: Activo
0: Inactivo
';
comment on column OPERACION.SGAT_TIPTRA_RECLA.ttrev_usuario_reg
  is 'Usuario de registro';
comment on column OPERACION.SGAT_TIPTRA_RECLA.ttred_fecha_reg
  is 'Fecha de registro';
comment on column OPERACION.SGAT_TIPTRA_RECLA.ttrev_usuario_act
  is 'Usuario de actualización';
comment on column OPERACION.SGAT_TIPTRA_RECLA.ttred_usuario_act
  is 'Fecha de actualización';

-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.SGAT_TIPTRA_RECLA
  add constraint FK_TT_RECLA_TIPTRABAJO foreign key (TTREN_TIPO_TRABAJO)
  references OPERACION.TIPTRABAJO (TIPTRA);

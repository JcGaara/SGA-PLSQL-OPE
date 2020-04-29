-- Crear Tabla
create table OPERACION.CFG_ENV_CORREO_CONTRATA_DET
(
  IDCFGDET           NUMBER not null,
  IDCFGCON          NUMBER not null,
  CORREO          VARCHAR2(4000),
  ESTADO          NUMBER  default 1,
  FECUSU          DATE default SYSDATE,
  CODUSU          VARCHAR2(30) default USER
);
-- Comentarios
comment on column OPERACION.CFG_ENV_CORREO_CONTRATA_DET.IDCFGDET
  is 'Id Configuracion detalle';
comment on column OPERACION.CFG_ENV_CORREO_CONTRATA_DET.IDCFGCON
  is 'Id Configuracion detalle';
comment on column OPERACION.CFG_ENV_CORREO_CONTRATA_DET.CORREO
  is 'Correo de Usuario';
comment on column OPERACION.CFG_ENV_CORREO_CONTRATA_DET.ESTADO
  is 'Estado';
comment on column OPERACION.CFG_ENV_CORREO_CONTRATA_DET.FECUSU
  is 'Fecha Registro';
comment on column OPERACION.CFG_ENV_CORREO_CONTRATA_DET.CODUSU
  is 'Usuario Registro';
-- PK
alter table OPERACION.CFG_ENV_CORREO_CONTRATA_DET
  add constraint PK_IDCFG_ENV_CORREO_DET primary key (IDCFGDET);
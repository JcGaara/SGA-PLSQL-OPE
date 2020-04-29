-- Crear Tabla
create table HISTORICO.CFG_ENV_CONTRATA_DET_LOG
(  TIPO_ACC_LOG  CHAR(1),
  IDCFGDET           NUMBER ,
  IDCFGCON          NUMBER ,
  CORREO          VARCHAR2(4000),
  ESTADO          NUMBER  default 1,
  FECUSU          DATE default SYSDATE,
  CODUSU          VARCHAR2(30) default USER
);
-- Comentarios
comment on column HISTORICO.CFG_ENV_CONTRATA_DET_LOG.TIPO_ACC_LOG
  is 'Tipo de accion que se realizo';
comment on column HISTORICO.CFG_ENV_CONTRATA_DET_LOG.IDCFGDET
  is 'Id Configuracion detalle';
comment on column HISTORICO.CFG_ENV_CONTRATA_DET_LOG.IDCFGCON
  is 'Id Configuracion detalle';
comment on column HISTORICO.CFG_ENV_CONTRATA_DET_LOG.CORREO
  is 'Correo de Usuario';
comment on column HISTORICO.CFG_ENV_CONTRATA_DET_LOG.ESTADO
  is 'Estado';
comment on column HISTORICO.CFG_ENV_CONTRATA_DET_LOG.FECUSU
  is 'Fecha Registro';
comment on column HISTORICO.CFG_ENV_CONTRATA_DET_LOG.CODUSU
  is 'Usuario Registro';

-- Crear Tabla
create table HISTORICO.CFG_ENV_CONTRATA_CON_LOG
( TIPO_ACC_LOG  CHAR(1),
  IDCFGCON           NUMBER ,
  IDCFG          NUMBER ,
  CODCON   NUMBER ,
  ESTADO          NUMBER  default 1,
  FECUSU          DATE default SYSDATE,
  CODUSU          VARCHAR2(30) default USER
);
-- Comentarios
comment on column HISTORICO.CFG_ENV_CONTRATA_CON_LOG.TIPO_ACC_LOG
  is 'Tipo de accion que se realizo';
comment on column HISTORICO.CFG_ENV_CONTRATA_CON_LOG.IDCFGCON
  is 'Id Configuracion detalle';
comment on column HISTORICO.CFG_ENV_CONTRATA_CON_LOG.IDCFG
  is 'Id Configuracion';
comment on column HISTORICO.CFG_ENV_CONTRATA_CON_LOG.CODCON
  is 'Correo de Usuario';
comment on column HISTORICO.CFG_ENV_CONTRATA_CON_LOG.ESTADO
  is 'Estado';
comment on column HISTORICO.CFG_ENV_CONTRATA_CON_LOG.FECUSU
  is 'Fecha Registro';
comment on column HISTORICO.CFG_ENV_CONTRATA_CON_LOG.CODUSU
  is 'Usuario Registro';

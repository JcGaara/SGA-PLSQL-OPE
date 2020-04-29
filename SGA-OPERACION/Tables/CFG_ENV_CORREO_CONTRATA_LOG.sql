-- Crear Tabla
create table HISTORICO.CFG_ENV_CORREO_CONTRATA_LOG
( TIPO_ACC_LOG  CHAR(1),
  IDCFG         NUMBER ,
  FASE          VARCHAR2(30),
  NOMARCH       VARCHAR2(100),
  CUERPO        VARCHAR2(4000),
  QUERY         VARCHAR2(4000),
  CABECERA      VARCHAR2(300),
  DETALLE1      VARCHAR2(4000),
  DETALLE2      VARCHAR2(4000),
  CANT_COLUMNAS NUMBER default 0,
  GRUPO         VARCHAR2(300),
  TABLA         VARCHAR2(300),
  ESTADO        NUMBER default 1,
  FECUSU        DATE default SYSDATE,
  CODUSU        VARCHAR2(30) default USER
) ;
-- Comentarios
comment on column HISTORICO.CFG_ENV_CORREO_CONTRATA_LOG.TIPO_ACC_LOG
  is 'Tipo de accion que se realizo';
comment on column HISTORICO.CFG_ENV_CORREO_CONTRATA_LOG.IDCFG
  is 'Id Configuracion';
comment on column HISTORICO.CFG_ENV_CORREO_CONTRATA_LOG.FASE
  is 'Fase o tipo';
comment on column HISTORICO.CFG_ENV_CORREO_CONTRATA_LOG.ESTADO
  is 'Estado de configuracion';
comment on column HISTORICO.CFG_ENV_CORREO_CONTRATA_LOG.NOMARCH
  is 'Nombre de archivo';
comment on column HISTORICO.CFG_ENV_CORREO_CONTRATA_LOG.CUERPO
  is 'Cuerpo de Correo';
comment on column HISTORICO.CFG_ENV_CORREO_CONTRATA_LOG.QUERY
  is 'Query de Caso';
comment on column HISTORICO.CFG_ENV_CORREO_CONTRATA_LOG.CABECERA
  is 'Cabecera de Correo';
comment on column HISTORICO.CFG_ENV_CORREO_CONTRATA_LOG.DETALLE1
  is 'Primer Detalle';
comment on column HISTORICO.CFG_ENV_CORREO_CONTRATA_LOG.DETALLE2
  is 'Segundo Detalle';
comment on column HISTORICO.CFG_ENV_CORREO_CONTRATA_LOG.CANT_COLUMNAS
  is 'Cantidad de Columnas a tomar por el proceso';
comment on column HISTORICO.CFG_ENV_CORREO_CONTRATA_LOG.FECUSU
  is 'Fecha Registro';
comment on column HISTORICO.CFG_ENV_CORREO_CONTRATA_LOG.CODUSU
  is 'Usuario Registro';
comment on column HISTORICO.CFG_ENV_CORREO_CONTRATA_LOG.GRUPO
  is 'Grupo de Envio';
comment on column HISTORICO.CFG_ENV_CORREO_CONTRATA_LOG.TABLA
  is 'Tabla';

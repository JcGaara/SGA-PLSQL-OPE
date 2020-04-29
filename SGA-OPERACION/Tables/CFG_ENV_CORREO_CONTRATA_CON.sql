-- Crear Tabla
create table OPERACION.CFG_ENV_CORREO_CONTRATA_CON
(
  IDCFGCON           NUMBER not null,
  IDCFG          NUMBER not null,
  CODCON   NUMBER ,
  ESTADO          NUMBER  default 1,
  FECUSU          DATE default SYSDATE,
  CODUSU          VARCHAR2(30) default USER
);
-- Comentarios
comment on column OPERACION.CFG_ENV_CORREO_CONTRATA_CON.IDCFGCON
  is 'Id Configuracion detalle';
comment on column OPERACION.CFG_ENV_CORREO_CONTRATA_CON.IDCFG
  is 'Id Configuracion';
comment on column OPERACION.CFG_ENV_CORREO_CONTRATA_CON.CODCON
  is 'Correo de Usuario';
comment on column OPERACION.CFG_ENV_CORREO_CONTRATA_CON.ESTADO
  is 'Estado';
comment on column OPERACION.CFG_ENV_CORREO_CONTRATA_CON.FECUSU
  is 'Fecha Registro';
comment on column OPERACION.CFG_ENV_CORREO_CONTRATA_CON.CODUSU
  is 'Usuario Registro';
-- PK
alter table OPERACION.CFG_ENV_CORREO_CONTRATA_CON
  add constraint PK_IDCFG_ENV_CORREO_CON primary key (IDCFGCON);
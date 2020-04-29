-- Create table
create table HISTORICO.OPE_SERVICIOMENSAJE_REL_LOG
(
  IDSERVMENS  NUMBER,
  IDMENSAJE   NUMBER,
  TIPSRV      CHAR(4),
  DESCRIPCION VARCHAR2(50),
  ESTADO      NUMBER,
  USUREG      VARCHAR2(30) default USER,
  FECREG      DATE default SYSDATE,
  ACCLOG      CHAR(1)
)
tablespace HISTORICO_DAT
;
-- Add comments to the table 
comment on table HISTORICO.OPE_SERVICIOMENSAJE_REL_LOG
  is 'TABLA HISTORICA DE OPE_SERVICIOMENSAJE_RE';
-- Add comments to the columns 
comment on column HISTORICO.OPE_SERVICIOMENSAJE_REL_LOG.IDSERVMENS
  is 'id del servicio de mensaje';
comment on column HISTORICO.OPE_SERVICIOMENSAJE_REL_LOG.IDMENSAJE
  is 'id de mensaje';
comment on column HISTORICO.OPE_SERVICIOMENSAJE_REL_LOG.TIPSRV
  is 'tipo de servicio';
comment on column HISTORICO.OPE_SERVICIOMENSAJE_REL_LOG.DESCRIPCION
  is 'descripcion';
comment on column HISTORICO.OPE_SERVICIOMENSAJE_REL_LOG.ESTADO
  is 'estado';
comment on column HISTORICO.OPE_SERVICIOMENSAJE_REL_LOG.USUREG
  is 'usuario de regsitro';
comment on column HISTORICO.OPE_SERVICIOMENSAJE_REL_LOG.FECREG
  is 'fecha de registro';
comment on column HISTORICO.OPE_SERVICIOMENSAJE_REL_LOG.ACCLOG
  is 'IDENTIFICADOR DE ACTUALIZACION';

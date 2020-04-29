-- Create table
create table HISTORICO.TYSTIPSRVGRUPOCORTE_LOG
(
  IDGRUPOCORTE NUMBER not null,
  TIPSRV       VARCHAR2(4) not null,
  IPAPLICACION VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  USUARIOAPP   VARCHAR2(30) default USER,
  FECUSU       DATE default SYSDATE,
  PCAPLICACION VARCHAR2(100) default SYS_CONTEXT('USERENV', 'TERMINAL'),
  TIPO_ACC_LOG CHAR(1)
)
tablespace HISTORICO_DAT ;
-- Add comments to the table 
comment on table HISTORICO.TYSTIPSRVGRUPOCORTE_LOG
  is 'Tabla para excluir los proyectos por tipo de servicio.';
-- Add comments to the columns 
comment on column HISTORICO.TYSTIPSRVGRUPOCORTE_LOG.IDGRUPOCORTE
  is 'Id grupo corte';
comment on column HISTORICO.TYSTIPSRVGRUPOCORTE_LOG.TIPSRV
  is 'Tipo de Servicio';
comment on column HISTORICO.TYSTIPSRVGRUPOCORTE_LOG.IPAPLICACION
  is 'IP Aplicacion';
comment on column HISTORICO.TYSTIPSRVGRUPOCORTE_LOG.USUARIOAPP
  is 'Usuario APP';
comment on column HISTORICO.TYSTIPSRVGRUPOCORTE_LOG.FECUSU
  is 'Fecha de Registro';
comment on column HISTORICO.TYSTIPSRVGRUPOCORTE_LOG.PCAPLICACION
  is 'PC Aplicacion';
comment on column HISTORICO.TYSTIPSRVGRUPOCORTE_LOG.TIPO_ACC_LOG
  is 'Tipo de accion que se realizo'; 
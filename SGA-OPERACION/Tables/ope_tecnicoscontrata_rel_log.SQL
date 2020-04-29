-- Create table
create table HISTORICO.OPE_TECNICOSCONTRATA_REL_LOG
(
  ID_TECNICO   NUMBER,
  CODCON       NUMBER(6),
  NOMBRE       VARCHAR2(200),
  RPC          NUMBER(10),
  ESTADO       NUMBER(1) default 1,
  CODCUADRILLA VARCHAR2(5),
  USUREG       VARCHAR2(30) default USER,
  FECREG       DATE default SYSDATE,
  ACCLOG       CHAR(1)
)
tablespace HISTORICO_DAT
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
-- Add comments to the table 
comment on table HISTORICO.OPE_TECNICOSCONTRATA_REL_LOG
  is 'TABLA HISTORICA DE ope_tecnicoscontrata_rel';
-- Add comments to the columns 
comment on column HISTORICO.OPE_TECNICOSCONTRATA_REL_LOG.ID_TECNICO
  is 'IDENTIFICADOR DEL TECNICO DE LA CONTRATA';
comment on column HISTORICO.OPE_TECNICOSCONTRATA_REL_LOG.CODCON
  is 'Codigo de la contrata';
comment on column HISTORICO.OPE_TECNICOSCONTRATA_REL_LOG.NOMBRE
  is 'NOMBRE DEL TECNICO';
comment on column HISTORICO.OPE_TECNICOSCONTRATA_REL_LOG.RPC
  is 'TELEFONO DEL TECNICO';
comment on column HISTORICO.OPE_TECNICOSCONTRATA_REL_LOG.ESTADO
  is 'ESTADO: 1 ACTIVO 0: INACTIVO';
comment on column HISTORICO.OPE_TECNICOSCONTRATA_REL_LOG.CODCUADRILLA
  is 'Codigo de la cuadrilla';
comment on column HISTORICO.OPE_TECNICOSCONTRATA_REL_LOG.USUREG
  is 'USUARIO DE REGISTRO';
comment on column HISTORICO.OPE_TECNICOSCONTRATA_REL_LOG.FECREG
  is 'FECHA DE REGSITRO';
comment on column HISTORICO.OPE_TECNICOSCONTRATA_REL_LOG.ACCLOG
  is 'IDENTIFICADOR DE ACTUALIZACION';

CREATE TABLE OPERACION.OPE_CONFIG_ACCION_JANUS
(
  codigo      NUMBER not null,
  tipo_accion CHAR(3),
  est_prov    VARCHAR2(2) default '0',
  action_id   INTEGER,
  mensaje     VARCHAR2(200),
  sentencia   VARCHAR2(4000),
  estado      CHAR(1),
  tip_svr     VARCHAR2(25),
  usu_cre     VARCHAR2(30) default user,
  fec_cre     DATE default sysdate,
  usu_mod     VARCHAR2(30),
  fec_mod     DATE
)

tablespace OPERACION_DAT
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
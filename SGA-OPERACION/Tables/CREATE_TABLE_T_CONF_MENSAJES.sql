create table OPERACION.T_CONF_MENSAJES
(
COD_ERROR NUMBER,
MSJ_TECNICO VARCHAR2(300),
MSJ_USUARIO VARCHAR2(300)
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

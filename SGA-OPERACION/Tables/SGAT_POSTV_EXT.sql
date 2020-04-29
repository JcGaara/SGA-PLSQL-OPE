-- CREATE TABLE
CREATE TABLE OPERACION.SGAT_POSTV_EXT
(
  IDPROCESS    		NUMBER NOT NULL,
  POSTV_ATRIBUTO    VARCHAR2(50) NOT NULL,
  POSTV_VALOR       VARCHAR2(50),
  POSTN_ORDEN       NUMBER,
  POSTD_FECUSU      DATE DEFAULT SYSDATE,
  POSTV_CODUSU      VARCHAR2(30) DEFAULT USER
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
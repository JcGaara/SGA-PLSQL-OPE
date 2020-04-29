CREATE TABLE OPERACION.DETTRANSACCIONES
(
  NOMABR            VARCHAR2(50 BYTE),
  CODINSSRV         NUMBER(10),
  IDTRANS           NUMBER,
  IDENTIFICADORCLC  NUMBER,
  ESTADO            NUMBER                      DEFAULT 1,
  CODUSU            VARCHAR2(50 BYTE)           DEFAULT user,
  FECUSU            DATE                        DEFAULT sysdate
);

COMMENT ON COLUMN OPERACION.DETTRANSACCIONES.IDENTIFICADORCLC IS 'identificador para cortes x limite de credito';

COMMENT ON COLUMN OPERACION.DETTRANSACCIONES.ESTADO IS 'flag de transferencia activa  ---1 trans activa  -- 0 trans cancelada';



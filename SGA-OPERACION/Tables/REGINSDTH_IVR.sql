CREATE TABLE OPERACION.REGINSDTH_IVR
(
  NUMREGISTRO  CHAR(10 BYTE)                    NOT NULL,
  TELEFONO1    VARCHAR2(20 BYTE),
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user,
  FECREG       DATE                             DEFAULT sysdate,
  ESTADO_IVR   NUMBER(1)                        DEFAULT null
);

COMMENT ON COLUMN OPERACION.REGINSDTH_IVR.ESTADO_IVR IS '0= No Contesta; 1 = Ocupado; 2 = Contestó';



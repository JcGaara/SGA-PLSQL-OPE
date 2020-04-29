CREATE TABLE OPERACION.USUARIOXCONTRATA
(
  USUARIO  VARCHAR2(30 BYTE)                    NOT NULL,
  CODCON   NUMBER(6)                            NOT NULL,
  CODUSU   VARCHAR2(30 BYTE)                    DEFAULT user,
  FECUSU   DATE                                 DEFAULT SYSDATE
);



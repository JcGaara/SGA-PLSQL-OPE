CREATE TABLE OPERACION.OPE_SOLOT_PROVISIONAMIENTO
(
  CODSOLOT       NUMBER                         NOT NULL,
  OPCION         NUMBER                         NOT NULL,
  ESTADO         NUMBER                         DEFAULT 1,
  USUARIO        VARCHAR2(30 BYTE)              DEFAULT user,
  FECHACREACION  DATE                           DEFAULT sysdate
);



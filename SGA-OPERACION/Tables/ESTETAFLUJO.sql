CREATE TABLE OPERACION.ESTETAFLUJO
(
  ID          NUMBER                            NOT NULL,
  FASEINI     NUMBER                            NOT NULL,
  ESTADODISP  NUMBER                            NOT NULL,
  HABILITADO  CHAR(1 BYTE)                      DEFAULT 'S',
  FECUSU      DATE,
  CODUSU      VARCHAR2(30 BYTE)
);



CREATE TABLE OPERACION.SERVICIOXMATERIAL
(
  CODSRV     CHAR(4 BYTE)                       NOT NULL,
  CODMAT     CHAR(15 BYTE)                      NOT NULL,
  CANT       NUMBER                             NOT NULL,
  ESPAQUETE  CHAR(1 BYTE)                       NOT NULL,
  FECUSU     DATE                               DEFAULT SYSDATE               NOT NULL,
  CODUSU     CHAR(30 BYTE)                      DEFAULT USER                  NOT NULL
);



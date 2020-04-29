CREATE TABLE OPERACION.ACTXACT
(
  CODACT      NUMBER(5)                         NOT NULL,
  CODACT_DES  NUMBER(5)                         NOT NULL,
  FACTOR      NUMBER(8,2)                       DEFAULT 1                     NOT NULL,
  CODUSU      VARCHAR2(30 BYTE)                 DEFAULT user                  NOT NULL,
  FECUSU      DATE                              DEFAULT SYSDATE               NOT NULL
);

COMMENT ON TABLE OPERACION.ACTXACT IS 'No es usada';

COMMENT ON COLUMN OPERACION.ACTXACT.CODACT IS 'Codigo de la actividad';

COMMENT ON COLUMN OPERACION.ACTXACT.CODACT_DES IS 'Codigo de la actividad destino';

COMMENT ON COLUMN OPERACION.ACTXACT.FACTOR IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.ACTXACT.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.ACTXACT.FECUSU IS 'Fecha de registro';



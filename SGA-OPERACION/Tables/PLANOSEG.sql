CREATE TABLE OPERACION.PLANOSEG
(
  IDSEQ        NUMBER(10)                       NOT NULL,
  IDPLANO      NUMBER(8)                        NOT NULL,
  OBSERVACION  VARCHAR2(4000 BYTE),
  FECUSU       DATE                             DEFAULT sysdate               NOT NULL,
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL
);

COMMENT ON TABLE OPERACION.PLANOSEG IS 'Comentarios para los Planos.Solo pueden ser insertados mas no actualizados.';

COMMENT ON COLUMN OPERACION.PLANOSEG.IDSEQ IS 'PK de la tabla.';

COMMENT ON COLUMN OPERACION.PLANOSEG.IDPLANO IS 'ID del Plano.';

COMMENT ON COLUMN OPERACION.PLANOSEG.OBSERVACION IS 'Observación del cambio de estado.';

COMMENT ON COLUMN OPERACION.PLANOSEG.FECUSU IS 'Fecha de inserción del registro.';

COMMENT ON COLUMN OPERACION.PLANOSEG.CODUSU IS 'Usuario que inserto el registro.';



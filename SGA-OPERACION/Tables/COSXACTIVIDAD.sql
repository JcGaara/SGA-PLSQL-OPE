CREATE TABLE OPERACION.COSXACTIVIDAD
(
  CODACT     NUMBER(5)                          NOT NULL,
  PERIODO    VARCHAR2(10 BYTE)                  NOT NULL,
  COSTO      NUMBER(10,2)                       DEFAULT 0                     NOT NULL,
  MONEDA_ID  NUMBER(10)                         NOT NULL,
  CODUSUMOD  VARCHAR2(30 BYTE)                  DEFAULT user                  NOT NULL,
  FECUSUMOD  DATE                               DEFAULT SYSDATE               NOT NULL,
  CODUSU     VARCHAR2(30 BYTE)                  DEFAULT user                  NOT NULL,
  FECUSU     DATE                               DEFAULT SYSDATE               NOT NULL
);

COMMENT ON TABLE OPERACION.COSXACTIVIDAD IS 'No es usada';

COMMENT ON COLUMN OPERACION.COSXACTIVIDAD.CODACT IS 'Codigo de la actividad';

COMMENT ON COLUMN OPERACION.COSXACTIVIDAD.PERIODO IS 'Periodo ';

COMMENT ON COLUMN OPERACION.COSXACTIVIDAD.COSTO IS 'Costo de la actividad';

COMMENT ON COLUMN OPERACION.COSXACTIVIDAD.MONEDA_ID IS 'Codigo de la moneda';

COMMENT ON COLUMN OPERACION.COSXACTIVIDAD.CODUSUMOD IS 'Registra el usuario que modifica un dato';

COMMENT ON COLUMN OPERACION.COSXACTIVIDAD.FECUSUMOD IS 'Fecha de modificacion';

COMMENT ON COLUMN OPERACION.COSXACTIVIDAD.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.COSXACTIVIDAD.FECUSU IS 'Fecha de registro';



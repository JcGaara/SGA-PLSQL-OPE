CREATE TABLE OPERACION.CTRLDOC
(
  CODCTRLDOC   NUMBER(8)                        NOT NULL,
  CODCLI       CHAR(8 BYTE)                     NOT NULL,
  NUMSLC       CHAR(10 BYTE)                    NOT NULL,
  FECAPR       DATE,
  ESTDOCXCLI   NUMBER(2)                        NOT NULL,
  OBSERVACION  VARCHAR2(500 BYTE),
  RESPONSABLE  VARCHAR2(30 BYTE),
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT USER                  NOT NULL,
  CODUSUMOD    VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL,
  FECUSUMOD    DATE                             DEFAULT sysdate               NOT NULL
);

COMMENT ON TABLE OPERACION.CTRLDOC IS 'No es usada';

COMMENT ON COLUMN OPERACION.CTRLDOC.CODCTRLDOC IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.CTRLDOC.CODCLI IS 'Codigo del cliente';

COMMENT ON COLUMN OPERACION.CTRLDOC.NUMSLC IS 'Numero de proyecto';

COMMENT ON COLUMN OPERACION.CTRLDOC.FECAPR IS 'Fecha aprobacion';

COMMENT ON COLUMN OPERACION.CTRLDOC.ESTDOCXCLI IS 'Estado del documento';

COMMENT ON COLUMN OPERACION.CTRLDOC.OBSERVACION IS 'Observacion';

COMMENT ON COLUMN OPERACION.CTRLDOC.RESPONSABLE IS 'Responsable';

COMMENT ON COLUMN OPERACION.CTRLDOC.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.CTRLDOC.CODUSUMOD IS 'Registra el usuario que modifica un dato';

COMMENT ON COLUMN OPERACION.CTRLDOC.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.CTRLDOC.FECUSUMOD IS 'Fecha de modificacion';



CREATE TABLE OPERACION.TIPTRABAJO
(
  TIPTRA              NUMBER(4)                 NOT NULL,
  TIPTRS              NUMBER(2),
  DESCRIPCION         VARCHAR2(200 BYTE)        NOT NULL,
  FECUSU              DATE                      DEFAULT SYSDATE               NOT NULL,
  CODUSU              VARCHAR2(30 BYTE)         DEFAULT user                  NOT NULL,
  CUENTA              CHAR(6 BYTE),
  CODDPT              CHAR(6 BYTE),
  FLGCOM              NUMBER(1)                 DEFAULT 0                     NOT NULL,
  FLGPRYINT           NUMBER(1)                 DEFAULT 0                     NOT NULL,
  CODMOTINSSRV        NUMBER(3),
  SOTFACTURABLE       NUMBER(1)                 DEFAULT 0,
  BLOQUEO_DESBLOQUEO  CHAR(1 BYTE)
);

COMMENT ON TABLE OPERACION.TIPTRABAJO IS 'Tipo de trabajo de la orden de trabajo';

COMMENT ON COLUMN OPERACION.TIPTRABAJO.TIPTRA IS 'Codigo del tipo de trabajo';

COMMENT ON COLUMN OPERACION.TIPTRABAJO.TIPTRS IS 'Codigo del tipo de transaccion';

COMMENT ON COLUMN OPERACION.TIPTRABAJO.DESCRIPCION IS 'Descripcion del tipo de trabajo';

COMMENT ON COLUMN OPERACION.TIPTRABAJO.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.TIPTRABAJO.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.TIPTRABAJO.CUENTA IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.TIPTRABAJO.CODDPT IS 'Codigo del departamento (reemplazado por el codigo del area)';

COMMENT ON COLUMN OPERACION.TIPTRABAJO.FLGCOM IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.TIPTRABAJO.FLGPRYINT IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.TIPTRABAJO.CODMOTINSSRV IS 'Codigo del motivo de la instancia de servicio';

COMMENT ON COLUMN OPERACION.TIPTRABAJO.BLOQUEO_DESBLOQUEO IS 'Indentifica: B = Bloqueos D= Desbloqueos';



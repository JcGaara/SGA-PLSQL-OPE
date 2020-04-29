CREATE TABLE OPERACION.PREDOC
(
  IDDOC     NUMBER(10)                          NOT NULL,
  CODPRE    NUMBER(8),
  IDUBI     NUMBER(10),
  CODETA    NUMBER(5),
  TIPDOC    NUMBER(2),
  CODDOC    NUMBER(8),
  MOTOBR    VARCHAR2(100 BYTE),
  TEXTO_A   VARCHAR2(4000 BYTE),
  TEXTO_B   VARCHAR2(4000 BYTE),
  TEXTO_C   VARCHAR2(4000 BYTE),
  TEXTO_D   VARCHAR2(4000 BYTE),
  FECEMI    DATE,
  CODOT     NUMBER(8),
  ESTDOC    NUMBER(2),
  PERREV    VARCHAR2(30 BYTE),
  PERAPR    VARCHAR2(30 BYTE),
  CODUSU    VARCHAR2(30 BYTE)                   DEFAULT USER,
  FECUSU    DATE                                DEFAULT SYSDATE,
  DISOBR    CHAR(10 BYTE),
  DIROBR    VARCHAR2(480 BYTE),
  CONTROL   NUMBER(8),
  TIPFOR    VARCHAR2(100 BYTE),
  CODSOLOT  NUMBER(8),
  PUNTO     NUMBER(10)
);

COMMENT ON TABLE OPERACION.PREDOC IS 'Memorias descriptivas de una orden de mantenimiento';

COMMENT ON COLUMN OPERACION.PREDOC.IDDOC IS 'Llava primaria de la tabla';

COMMENT ON COLUMN OPERACION.PREDOC.CODPRE IS 'Codigo del presupuesto';

COMMENT ON COLUMN OPERACION.PREDOC.IDUBI IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.PREDOC.CODETA IS 'Codigo de la etapa';

COMMENT ON COLUMN OPERACION.PREDOC.TIPDOC IS 'Tipo de documento';

COMMENT ON COLUMN OPERACION.PREDOC.CODDOC IS 'Codigo del documento';

COMMENT ON COLUMN OPERACION.PREDOC.MOTOBR IS 'Motivo de la obra';

COMMENT ON COLUMN OPERACION.PREDOC.TEXTO_A IS 'Texto A';

COMMENT ON COLUMN OPERACION.PREDOC.TEXTO_B IS 'Texto B';

COMMENT ON COLUMN OPERACION.PREDOC.TEXTO_C IS 'Texto C';

COMMENT ON COLUMN OPERACION.PREDOC.TEXTO_D IS 'Texto D';

COMMENT ON COLUMN OPERACION.PREDOC.FECEMI IS 'Fecha de emision';

COMMENT ON COLUMN OPERACION.PREDOC.CODOT IS 'Codigo de la orden de trabajo';

COMMENT ON COLUMN OPERACION.PREDOC.ESTDOC IS 'Estado del documento';

COMMENT ON COLUMN OPERACION.PREDOC.PERREV IS 'Persona encargada de revisar';

COMMENT ON COLUMN OPERACION.PREDOC.PERAPR IS 'Persona encargada de aprobar';

COMMENT ON COLUMN OPERACION.PREDOC.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.PREDOC.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.PREDOC.DISOBR IS 'Distrito de la obra';

COMMENT ON COLUMN OPERACION.PREDOC.DIROBR IS 'Direccion de la obra';

COMMENT ON COLUMN OPERACION.PREDOC.CONTROL IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.PREDOC.TIPFOR IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.PREDOC.CODSOLOT IS 'Codigo de la solicitud de orden de trabajo';

COMMENT ON COLUMN OPERACION.PREDOC.PUNTO IS 'Punto de la solicitud de ot';



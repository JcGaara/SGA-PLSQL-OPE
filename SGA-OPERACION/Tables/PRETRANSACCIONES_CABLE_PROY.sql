CREATE TABLE OPERACION.PRETRANSACCIONES_CABLE_PROY
(
  NOMABR       VARCHAR2(50 BYTE),
  SLDACT       NUMBER(18,4)                     NOT NULL,
  CODCLI       CHAR(8 BYTE)                     NOT NULL,
  NOMCLI       VARCHAR2(150 BYTE),
  CATEGORIA    VARCHAR2(50 BYTE),
  IDFAC        CHAR(10 BYTE)                    NOT NULL,
  NUMDOC       CHAR(12 BYTE),
  FECEMI       DATE,
  FECVEN       DATE,
  IDCATEGORIA  NUMBER,
  TIPO         NUMBER
);

COMMENT ON TABLE OPERACION.PRETRANSACCIONES_CABLE_PROY IS 'GENERACION DE CORTES PROYECTADOS';

COMMENT ON COLUMN OPERACION.PRETRANSACCIONES_CABLE_PROY.NOMABR IS 'Linea actual del cliente';

COMMENT ON COLUMN OPERACION.PRETRANSACCIONES_CABLE_PROY.SLDACT IS 'Saldo Actual';

COMMENT ON COLUMN OPERACION.PRETRANSACCIONES_CABLE_PROY.CODCLI IS 'Codigo del cliente';

COMMENT ON COLUMN OPERACION.PRETRANSACCIONES_CABLE_PROY.NOMCLI IS 'Nombre del cliente';

COMMENT ON COLUMN OPERACION.PRETRANSACCIONES_CABLE_PROY.CATEGORIA IS 'Categoria';

COMMENT ON COLUMN OPERACION.PRETRANSACCIONES_CABLE_PROY.IDFAC IS 'Identificador del Documento';

COMMENT ON COLUMN OPERACION.PRETRANSACCIONES_CABLE_PROY.NUMDOC IS 'Numero de Documento';

COMMENT ON COLUMN OPERACION.PRETRANSACCIONES_CABLE_PROY.FECEMI IS 'Fecha de Emision';

COMMENT ON COLUMN OPERACION.PRETRANSACCIONES_CABLE_PROY.FECVEN IS 'Fecha de Vencimiento';

COMMENT ON COLUMN OPERACION.PRETRANSACCIONES_CABLE_PROY.IDCATEGORIA IS 'IdCategoria';

COMMENT ON COLUMN OPERACION.PRETRANSACCIONES_CABLE_PROY.TIPO IS 'Tipo';



CREATE TABLE OPERACION.EF
(
  CODEF                  NUMBER(8)              NOT NULL,
  NUMSLC                 CHAR(10 BYTE)          NOT NULL,
  DOCID                  NUMBER(10)             NOT NULL,
  CODCLI                 CHAR(8 BYTE)           NOT NULL,
  ESTEF                  NUMBER(2)              NOT NULL,
  COSMO                  NUMBER(10,2)           DEFAULT 0                     NOT NULL,
  COSMAT                 NUMBER(10,2)           DEFAULT 0                     NOT NULL,
  COSEQU                 NUMBER(10,2)           DEFAULT 0                     NOT NULL,
  COSMATCLI              NUMBER(10,2)           DEFAULT 0                     NOT NULL,
  COSMOCLI               NUMBER(10,2)           DEFAULT 0                     NOT NULL,
  FECFIN                 DATE,
  NUMDIAPLA              NUMBER(3),
  OBSERVACION            VARCHAR2(1000 BYTE),
  FECUSU                 DATE                   DEFAULT SYSDATE               NOT NULL,
  CODUSU                 VARCHAR2(30 BYTE)      DEFAULT user                  NOT NULL,
  FECAPR                 DATE,
  TIPSRV                 CHAR(4 BYTE),
  TIPSOLEF               NUMBER(4),
  REQ_AR                 NUMBER(1),
  RENTABLE               NUMBER(1),
  FRR                    NUMBER(8,5),
  EFESTRA                NUMBER(1),
  COSMO_S                NUMBER(10,2)           DEFAULT 0                     NOT NULL,
  COSMAT_S               NUMBER(10,2)           DEFAULT 0                     NOT NULL,
  CLIINT                 CHAR(3 BYTE),
  FLG_CLIPOT             NUMBER(2),
  CODPREC                NUMBER(8),
  PC_FLAG_TRANSFERENCIA  NUMBER                 DEFAULT 0,
  ESTCODCONPIN           NUMBER(1)
);

COMMENT ON TABLE OPERACION.EF IS 'Estudio de factibilidad';

COMMENT ON COLUMN OPERACION.EF.CODEF IS 'Codigo del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.EF.NUMSLC IS 'Numero de proyecto';

COMMENT ON COLUMN OPERACION.EF.DOCID IS 'id de documento';

COMMENT ON COLUMN OPERACION.EF.CODCLI IS 'Codigo del cliente';

COMMENT ON COLUMN OPERACION.EF.ESTEF IS 'Estado del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.EF.COSMO IS 'Costo de mano de obra';

COMMENT ON COLUMN OPERACION.EF.COSMAT IS 'Costo del material';

COMMENT ON COLUMN OPERACION.EF.COSEQU IS 'Costo del equipo';

COMMENT ON COLUMN OPERACION.EF.COSMATCLI IS 'Costo del material';

COMMENT ON COLUMN OPERACION.EF.COSMOCLI IS 'Costo de mano de obra';

COMMENT ON COLUMN OPERACION.EF.FECFIN IS 'Fecha de fin';

COMMENT ON COLUMN OPERACION.EF.NUMDIAPLA IS 'Numero de dias de plazo';

COMMENT ON COLUMN OPERACION.EF.OBSERVACION IS 'OBSERVACION';

COMMENT ON COLUMN OPERACION.EF.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.EF.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.EF.FECAPR IS 'Fecha de aprobación';

COMMENT ON COLUMN OPERACION.EF.TIPSRV IS 'Codigo del tipo de servicio';

COMMENT ON COLUMN OPERACION.EF.TIPSOLEF IS 'Tipo de solicitud de estudio de factibilidad';

COMMENT ON COLUMN OPERACION.EF.REQ_AR IS 'Indica si el proyecto requiere analisis de rentabilidad';

COMMENT ON COLUMN OPERACION.EF.RENTABLE IS 'Indica si el proyecto es rentable';

COMMENT ON COLUMN OPERACION.EF.FRR IS 'Factor rapido de rentabilidad';

COMMENT ON COLUMN OPERACION.EF.EFESTRA IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.EF.COSMO_S IS 'Costo de mano de obra en soles';

COMMENT ON COLUMN OPERACION.EF.COSMAT_S IS 'Costo del material en soles';

COMMENT ON COLUMN OPERACION.EF.CLIINT IS 'Codigo del cliente interno';

COMMENT ON COLUMN OPERACION.EF.FLG_CLIPOT IS 'Indica si el cliente es potencial';



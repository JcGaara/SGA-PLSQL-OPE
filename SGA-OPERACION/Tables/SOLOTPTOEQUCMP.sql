CREATE TABLE OPERACION.SOLOTPTOEQUCMP
(
  CODSOLOT          NUMBER(8)                   NOT NULL,
  PUNTO             NUMBER(10)                  NOT NULL,
  ORDEN             NUMBER(4)                   NOT NULL,
  ORDENCMP          NUMBER(4)                   NOT NULL,
  TIPEQU            NUMBER(6)                   NOT NULL,
  CANTIDAD          NUMBER(8,2)                 DEFAULT 1                     NOT NULL,
  COSTO             NUMBER(8,2)                 DEFAULT 0                     NOT NULL,
  NUMSERIE          VARCHAR2(30 BYTE),
  FECINS            DATE,
  INSTALADO         NUMBER(1),
  ESTADO            NUMBER(2),
  OBSERVACION       VARCHAR2(240 BYTE),
  CODUSU            VARCHAR2(30 BYTE)           DEFAULT user                  NOT NULL,
  FECUSU            DATE                        DEFAULT SYSDATE               NOT NULL,
  FLGSOL            NUMBER(3)                   DEFAULT 0                     NOT NULL,
  FLGREQ            NUMBER(3)                   DEFAULT 0                     NOT NULL,
  ID_SOL            NUMBER,
  CODETA            NUMBER,
  TRAN_SOLMAT       NUMBER,
  NRO_RES           NUMBER,
  NRO_RES_L         NUMBER,
  PEP               VARCHAR2(40 BYTE),
  PEP_LEASING       VARCHAR2(40 BYTE),
  FECGENRESERVA     DATE,
  USUGENRESERVA     VARCHAR2(30 BYTE),
  FLG_RECUPERACION  NUMBER(1)                   DEFAULT 0
);

COMMENT ON TABLE OPERACION.SOLOTPTOEQUCMP IS 'Listado de componentes por cada equipo del detalle de la solicitud';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQUCMP.FECGENRESERVA IS 'Fecha que realiza la solicitud de materiales';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQUCMP.USUGENRESERVA IS 'Codigo de Usuario que realiza la solicitud de materiales';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQUCMP.CODSOLOT IS 'Codigo de la solicitud de orden de trabajo';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQUCMP.PUNTO IS 'Punto de la solicitud de ot';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQUCMP.ORDEN IS 'Orden de la tabla';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQUCMP.ORDENCMP IS 'Orden del componente de la tabla';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQUCMP.TIPEQU IS 'Codigo del tipo de equipo';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQUCMP.CANTIDAD IS 'Cantidad del componente del equipo';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQUCMP.COSTO IS 'Costo del componente';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQUCMP.NUMSERIE IS 'Numero de serie del componente';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQUCMP.FECINS IS 'Fecha de instalacion del componente';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQUCMP.INSTALADO IS 'Identificador que indica si esta instalado';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQUCMP.ESTADO IS 'Codigo de estado del componente';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQUCMP.OBSERVACION IS 'Observacion';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQUCMP.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQUCMP.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQUCMP.FLG_RECUPERACION IS 'Indica si el equipo fue recuperado:0:No Recuperado,1:Recuperado';



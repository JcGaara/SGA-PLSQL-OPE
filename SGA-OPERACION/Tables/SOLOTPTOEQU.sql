CREATE TABLE OPERACION.SOLOTPTOEQU
(
  CODSOLOT               NUMBER(8)              NOT NULL,
  PUNTO                  NUMBER(10)             NOT NULL,
  ORDEN                  NUMBER(4)              NOT NULL,
  TIPEQU                 NUMBER(6)              NOT NULL,
  CANTIDAD               NUMBER(8,2)            DEFAULT 0                     NOT NULL,
  TIPPRP                 NUMBER(2)              NOT NULL,
  COSTO                  NUMBER(8,2)            DEFAULT 0                     NOT NULL,
  NUMSERIE               VARCHAR2(2000 BYTE),
  FECINS                 DATE,
  INSTALADO              NUMBER(1),
  ESTADO                 NUMBER(2),
  CODEQUCOM              CHAR(4 BYTE),
  TIPO                   NUMBER(2),
  FLGINV                 NUMBER(1)              DEFAULT 0,
  FECINV                 DATE,
  TIPCOMPRA              NUMBER(2),
  OBSERVACION            VARCHAR2(240 BYTE),
  CODUSU                 VARCHAR2(30 BYTE)      DEFAULT user                  NOT NULL,
  FECUSU                 DATE                   DEFAULT SYSDATE               NOT NULL,
  CODOT                  NUMBER(8),
  ENACTA                 NUMBER(1)              DEFAULT 0,
  PCCODTAREA             NUMBER(15),
  PCTIPGASTO             VARCHAR2(30 BYTE),
  PCIDORGGASTO           NUMBER(15),
  FLGSOL                 NUMBER(3)              DEFAULT 0                     NOT NULL,
  FLGREQ                 NUMBER(3)              DEFAULT 0                     NOT NULL,
  CODETA                 NUMBER(5),
  CODALMACEN             NUMBER(10),
  FLG_VENTAS             INTEGER                DEFAULT 0,
  CODALMOF               NUMBER,
  FECFINS                DATE,
  FECFDIS                DATE,
  ID_SOL                 NUMBER,
  TRAN_SOLMAT            NUMBER,
  CODUSUDIS              VARCHAR2(30 BYTE),
  NRO_RES                NUMBER,
  NRO_RES_L              NUMBER,
  PEP                    VARCHAR2(40 BYTE),
  PEP_LEASING            VARCHAR2(40 BYTE),
  MAC                    VARCHAR2(30 BYTE),
  FECGENRESERVA          DATE,
  USUGENRESERVA          VARCHAR2(30 BYTE),
  FLG_INGRESO            NUMBER                 DEFAULT 0,
  CENTROSAP              VARCHAR2(4 BYTE),
  ALMACENSAP             VARCHAR2(4 BYTE),
  FLG_DESPACHO           NUMBER                 DEFAULT 0,
  VALIDA_ALMACEN         NUMBER                 DEFAULT 0,
  TRANS_DESPACHO         NUMBER,
  IMSI                   NUMBER,
  NRO_PIN                NUMBER,
  FLG_RECUPERACION       NUMBER(1)              DEFAULT 0,
  RECUPERABLE            NUMBER                 DEFAULT 0,
  APLICA_CLIENTE         NUMBER                 DEFAULT 0,
  IDAGENDA               NUMBER,
  CODSOLOT_RECUPERACION  NUMBER(8),
  ACTA                   VARCHAR2(30 BYTE)
);

COMMENT ON TABLE OPERACION.SOLOTPTOEQU IS 'Listado de equipo del detalle de la solicitud';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQU.FLG_INGRESO IS '0:Usuario, 1:Mesa Validacion,2:Proceso Interno';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQU.FLG_DESPACHO IS 'Indica si se realizo el despacho de esta linea de Equipo';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQU.VALIDA_ALMACEN IS 'Validar que el equipo descargado pertenezca al almacén de la contrata asignada';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQU.CODSOLOT IS 'Codigo de la solicitud de orden de trabajo';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQU.PUNTO IS 'Punto de la solicitud de ot';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQU.ORDEN IS 'Orden del equipo en el punto de la solicitud de la ot';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQU.TIPEQU IS 'Codigo del tipo de equipo';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQU.CANTIDAD IS 'Cantidad de equipo';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQU.TIPPRP IS 'Tipo de propiedad';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQU.COSTO IS 'Costo del equipo';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQU.NUMSERIE IS 'Numero de serie';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQU.FECINS IS 'Fecha de instalación';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQU.INSTALADO IS 'Indica si el equipo esta instalado';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQU.ESTADO IS 'Estado del equipo en el punto';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQU.CODEQUCOM IS 'Codigo del equipo comercial';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQU.TIPO IS 'Tipo';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQU.FLGINV IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQU.FECINV IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQU.TIPCOMPRA IS 'Tipo de compra';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQU.OBSERVACION IS 'Observación';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQU.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQU.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQU.CODOT IS 'Codigo de la orden de trabajo';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQU.ENACTA IS 'Indica si el equipo esta registrado en un acta';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQU.PCCODTAREA IS 'Task ID del proyecto';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQU.PCTIPGASTO IS 'Tipo de Gasto del proyecto';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQU.PCIDORGGASTO IS 'Organización de gasto del proyecto';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQU.CODALMACEN IS 'Codigo del almacen origen';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQU.CODALMOF IS 'Codigo de alamacen OF';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQU.FECGENRESERVA IS 'Fecha que realiza la solicitud de materiales';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQU.USUGENRESERVA IS 'Codigo de Usuario que realiza la solicitud de materiales';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQU.TRANS_DESPACHO IS 'Ticket de Transacción para identificar el grupo de registros a Despachar';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQU.IMSI IS 'Numero de IMSI';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQU.FLG_RECUPERACION IS 'Indica si el equipo fue recuperado:0:No Recuperado,1:Recuperado';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQU.RECUPERABLE IS 'Indica si el Equipo o Material sera recuperable';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQU.APLICA_CLIENTE IS 'Para identificar si el cargo de este equipo se le carga al Cliente';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQU.IDAGENDA IS 'Id Agenda, para identificar que contrata liquida los materiales en casos de mas de una agenda por SOT';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQU.NRO_PIN IS 'PIN que se le entrega al cliente.';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQU.CODSOLOT_RECUPERACION IS 'Codigo de SOT que realizó la recuperación del equipo';

COMMENT ON COLUMN OPERACION.SOLOTPTOEQU.ACTA IS 'Acta de Instalacisn';



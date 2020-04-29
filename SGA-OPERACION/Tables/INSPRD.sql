CREATE TABLE OPERACION.INSPRD
(
  PID           NUMBER(10)                      NOT NULL,
  DESCRIPCION   VARCHAR2(100 BYTE),
  ESTINSPRD     NUMBER(2)                       DEFAULT 4                     NOT NULL,
  CODSRV        CHAR(4 BYTE),
  CODINSSRV     NUMBER(10),
  FECINI        DATE,
  FECFIN        DATE,
  CANTIDAD      NUMBER(6)                       DEFAULT 1,
  FLGPRINC      NUMBER(1)                       DEFAULT 0                     NOT NULL,
  FECUSU        DATE                            DEFAULT sysdate               NOT NULL,
  CODUSU        VARCHAR2(30 BYTE)               DEFAULT user                  NOT NULL,
  FECUSUMOD     DATE                            DEFAULT sysdate,
  CODUSUMOD     VARCHAR2(30 BYTE)               DEFAULT user,
  NUMSLC        CHAR(10 BYTE),
  NUMPTO        CHAR(5 BYTE),
  CODEQUCOM     CHAR(4 BYTE),
  TIPCON        NUMBER(1)                       DEFAULT 0                     NOT NULL,
  IDDET         NUMBER(10),
  IDPLATAFORMA  NUMBER,
  FLG_CNR       NUMBER(1),
  ID            NUMBER(5)
);

COMMENT ON TABLE OPERACION.INSPRD IS 'Listado de las instancias de producto (PID)';

COMMENT ON COLUMN OPERACION.INSPRD.PID IS 'Numero de la instancia de producto';

COMMENT ON COLUMN OPERACION.INSPRD.DESCRIPCION IS 'Descripcion de la instancia de servicio';

COMMENT ON COLUMN OPERACION.INSPRD.ESTINSPRD IS 'Codigo del estado de la instancia de producto';

COMMENT ON COLUMN OPERACION.INSPRD.CODSRV IS 'Codigo de servicio';

COMMENT ON COLUMN OPERACION.INSPRD.CODINSSRV IS 'Codigo de instancia de servicio';

COMMENT ON COLUMN OPERACION.INSPRD.FECINI IS 'Fecha de inicio';

COMMENT ON COLUMN OPERACION.INSPRD.FECFIN IS 'Fecha de fin';

COMMENT ON COLUMN OPERACION.INSPRD.CANTIDAD IS 'Cantidad de instancia de producto';

COMMENT ON COLUMN OPERACION.INSPRD.FLGPRINC IS 'Indica si la instancia de producto es principal';

COMMENT ON COLUMN OPERACION.INSPRD.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.INSPRD.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.INSPRD.FECUSUMOD IS 'Fecha de modificacion';

COMMENT ON COLUMN OPERACION.INSPRD.CODUSUMOD IS 'Registra el usuario que modifica un dato';

COMMENT ON COLUMN OPERACION.INSPRD.NUMSLC IS 'Numero de proyecto';

COMMENT ON COLUMN OPERACION.INSPRD.NUMPTO IS 'Punto del proyecto';

COMMENT ON COLUMN OPERACION.INSPRD.CODEQUCOM IS 'Codigo del equipo comercial';

COMMENT ON COLUMN OPERACION.INSPRD.TIPCON IS 'Tipo de contrato (Demo, Contrato)';

COMMENT ON COLUMN OPERACION.INSPRD.IDDET IS 'Id Detalle de Paquetes de Producto';

COMMENT ON COLUMN OPERACION.INSPRD.IDPLATAFORMA IS 'Identificador de la plataforma';

COMMENT ON COLUMN OPERACION.INSPRD.ID IS 'ID de la transacción instanciada';

COMMENT ON COLUMN OPERACION.INSPRD.FLG_CNR IS 'Flag de cargo no recurrente';



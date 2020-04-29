CREATE TABLE OPERACION.INSSRV_HIS
(
  CODINSSRV     NUMBER(10)                      NOT NULL,
  FECUSUMOD     DATE                            DEFAULT SYSDATE               NOT NULL,
  CODUSUMOD     VARCHAR2(30 BYTE)               DEFAULT user                  NOT NULL,
  CODCLI        CHAR(8 BYTE),
  CODSRV        CHAR(4 BYTE),
  ESTINSSRV     NUMBER(2),
  TIPINSSRV     NUMBER(2),
  DESCRIPCION   VARCHAR2(100 BYTE),
  DIRECCION     VARCHAR2(480 BYTE),
  FECINI        DATE,
  FECACTSRV     DATE,
  FECFIN        DATE,
  NUMERO        VARCHAR2(20 BYTE),
  CODSUC        CHAR(10 BYTE),
  BW            NUMBER(10,2),
  POP           NUMBER(10),
  NUMSLC        CHAR(10 BYTE),
  NUMPTO        CHAR(5 BYTE),
  CODELERED     NUMBER(10),
  CODUBI        CHAR(10 BYTE),
  TIPSRV        CHAR(4 BYTE),
  CID           NUMBER(10),
  IDPLATAFORMA  NUMBER
);

COMMENT ON TABLE OPERACION.INSSRV_HIS IS 'Log de las intancias de servicio';

COMMENT ON COLUMN OPERACION.INSSRV_HIS.CODINSSRV IS 'Codigo de instancia de servicio';

COMMENT ON COLUMN OPERACION.INSSRV_HIS.FECUSUMOD IS 'Fecha de modificacion';

COMMENT ON COLUMN OPERACION.INSSRV_HIS.CODUSUMOD IS 'Registra el usuario que modifica un dato';

COMMENT ON COLUMN OPERACION.INSSRV_HIS.CODCLI IS 'Codigo del cliente';

COMMENT ON COLUMN OPERACION.INSSRV_HIS.CODSRV IS 'Codigo de servicio';

COMMENT ON COLUMN OPERACION.INSSRV_HIS.ESTINSSRV IS 'Codigo del estado de la instancia de servicio';

COMMENT ON COLUMN OPERACION.INSSRV_HIS.TIPINSSRV IS 'Tipo de instancia de servicio';

COMMENT ON COLUMN OPERACION.INSSRV_HIS.DESCRIPCION IS 'Descripcion de la instancia de servicio';

COMMENT ON COLUMN OPERACION.INSSRV_HIS.DIRECCION IS 'Direccion';

COMMENT ON COLUMN OPERACION.INSSRV_HIS.FECINI IS 'Fecha de inicio';

COMMENT ON COLUMN OPERACION.INSSRV_HIS.FECACTSRV IS 'Fecha de acta de servcio';

COMMENT ON COLUMN OPERACION.INSSRV_HIS.FECFIN IS 'Fecha de fin';

COMMENT ON COLUMN OPERACION.INSSRV_HIS.NUMERO IS 'Numero';

COMMENT ON COLUMN OPERACION.INSSRV_HIS.CODSUC IS 'Codigo de la sucursal';

COMMENT ON COLUMN OPERACION.INSSRV_HIS.BW IS 'Ancho de banda';

COMMENT ON COLUMN OPERACION.INSSRV_HIS.POP IS 'Pop';

COMMENT ON COLUMN OPERACION.INSSRV_HIS.NUMSLC IS 'Numero de proyecto';

COMMENT ON COLUMN OPERACION.INSSRV_HIS.NUMPTO IS 'Punto del proyecto';

COMMENT ON COLUMN OPERACION.INSSRV_HIS.CODELERED IS 'Codigo de elemento de red';

COMMENT ON COLUMN OPERACION.INSSRV_HIS.CODUBI IS 'Codigo del distrito';

COMMENT ON COLUMN OPERACION.INSSRV_HIS.TIPSRV IS 'Codigo del tipo de servicio';

COMMENT ON COLUMN OPERACION.INSSRV_HIS.CID IS 'Circuito id';

COMMENT ON COLUMN OPERACION.INSSRV_HIS.IDPLATAFORMA IS 'Identificador de la plataforma';



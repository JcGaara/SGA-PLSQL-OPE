CREATE TABLE OPERACION.OPE_TVSAT_SLTD_BOUQUETE_DET
(
  IDSOL     NUMBER(20)                          NOT NULL,
  SERIE     VARCHAR2(30 BYTE)                   NOT NULL,
  BOUQUETE  VARCHAR2(10 BYTE)                   NOT NULL,
  TIPO      NUMBER(1)                           NOT NULL,
  USUREG    VARCHAR2(30 BYTE)                   DEFAULT user                  NOT NULL,
  FECREG    DATE                                DEFAULT SYSDATE               NOT NULL,
  USUMOD    VARCHAR2(30 BYTE)                   DEFAULT user                  NOT NULL,
  FECMOD    DATE                                DEFAULT SYSDATE               NOT NULL,
  IDDET     NUMBER(20)                          NOT NULL
);

COMMENT ON TABLE OPERACION.OPE_TVSAT_SLTD_BOUQUETE_DET IS 'Tabla donde se registran los bouquetes incluidos dentro de cada una de las tarjetas incluidas en la solicitud. Esta tabla debe ser llenada desde una tarea del workflow de suspension / activacion de servicios en el conax';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_SLTD_BOUQUETE_DET.IDSOL IS 'Identificador de la solicitud suspension/reconexion conax';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_SLTD_BOUQUETE_DET.SERIE IS 'Numero de tarjeta equiposdth';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_SLTD_BOUQUETE_DET.BOUQUETE IS 'Bouquete';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_SLTD_BOUQUETE_DET.TIPO IS 'Tipo de bouquete 0:Adicional, 1:Principal';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_SLTD_BOUQUETE_DET.USUREG IS 'Usuario que creo el registro';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_SLTD_BOUQUETE_DET.FECREG IS 'Fecha de creacion del registro';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_SLTD_BOUQUETE_DET.USUMOD IS 'Usuario de modificacion del registro';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_SLTD_BOUQUETE_DET.FECMOD IS 'Fecha de modificacion del registro';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_SLTD_BOUQUETE_DET.IDDET IS 'Identificador de Detalle de Bouquet en Solicitud';



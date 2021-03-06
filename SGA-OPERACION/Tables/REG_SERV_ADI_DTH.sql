CREATE TABLE OPERACION.REG_SERV_ADI_DTH
(
  NUMREGISTRO            VARCHAR2(10 BYTE),
  IDDET                  NUMBER(10),
  CODSRV                 CHAR(4 BYTE),
  CODEQUCOM              CHAR(4 BYTE),
  IDPAQ                  NUMBER(10),
  ESTADO                 NUMBER,
  USUREG                 VARCHAR2(30 BYTE)      DEFAULT USER,
  FECREG                 DATE                   DEFAULT SYSDATE,
  USUMOD                 VARCHAR2(30 BYTE)      DEFAULT USER,
  FECMOD                 DATE                   DEFAULT SYSDATE,
  FECHA_INICIO_VIGENCIA  DATE,
  FECHA_FIN_VIGENCIA     DATE
);

COMMENT ON COLUMN OPERACION.REG_SERV_ADI_DTH.NUMREGISTRO IS 'Regsitro de Instalaci�n de DTH';

COMMENT ON COLUMN OPERACION.REG_SERV_ADI_DTH.IDDET IS 'Detalle del paquete';

COMMENT ON COLUMN OPERACION.REG_SERV_ADI_DTH.CODSRV IS 'C�digo de servicio';

COMMENT ON COLUMN OPERACION.REG_SERV_ADI_DTH.CODEQUCOM IS 'C�digp de equipo ';

COMMENT ON COLUMN OPERACION.REG_SERV_ADI_DTH.IDPAQ IS 'Id. del paquete';

COMMENT ON COLUMN OPERACION.REG_SERV_ADI_DTH.ESTADO IS 'Estado';

COMMENT ON COLUMN OPERACION.REG_SERV_ADI_DTH.USUREG IS 'Usuario de registro';

COMMENT ON COLUMN OPERACION.REG_SERV_ADI_DTH.FECREG IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.REG_SERV_ADI_DTH.USUMOD IS 'Usuario modificador';

COMMENT ON COLUMN OPERACION.REG_SERV_ADI_DTH.FECMOD IS 'Fecha de modificacion';

COMMENT ON COLUMN OPERACION.REG_SERV_ADI_DTH.FECHA_INICIO_VIGENCIA IS 'Fecha Inicio de Vigencia del Bouquet adicional';

COMMENT ON COLUMN OPERACION.REG_SERV_ADI_DTH.FECHA_FIN_VIGENCIA IS 'Fecha Fin de Vigencia del Bouquet adicional';



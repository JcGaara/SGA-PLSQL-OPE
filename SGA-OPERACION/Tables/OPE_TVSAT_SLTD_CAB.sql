CREATE TABLE OPERACION.OPE_TVSAT_SLTD_CAB
(
  IDSOL          NUMBER(20)                     NOT NULL,
  TIPOSOLICITUD  VARCHAR2(1 BYTE),
  IDLOTE         NUMBER(10),
  CODINSSRV      NUMBER(10),
  CODCLI         VARCHAR2(8 BYTE),
  CODSOLOT       NUMBER(10),
  IDWF           NUMBER(8),
  IDTAREAWF      NUMBER(8),
  NUMREGISTRO    VARCHAR2(10 BYTE),
  ESTADO         NUMBER(1),
  USUREG         VARCHAR2(30 BYTE)              DEFAULT user                  NOT NULL,
  FECREG         DATE                           DEFAULT SYSDATE               NOT NULL,
  USUMOD         VARCHAR2(30 BYTE)              DEFAULT user                  NOT NULL,
  FECMOD         VARCHAR2(30 BYTE)              DEFAULT SYSDATE               NOT NULL,
  FLG_RECARGA    NUMBER(1)                      DEFAULT 0
);

COMMENT ON TABLE OPERACION.OPE_TVSAT_SLTD_CAB IS 'Tabla de cabecera de solicitudes de activacion / suspension a enviar al conax. Las solicitudes deben ser llenadas por una de las tareas del workflow de suspension / activacion de servcios en el conax';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_SLTD_CAB.IDSOL IS 'Identificador de la solicitud de suspension/reconexion al conax';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_SLTD_CAB.TIPOSOLICITUD IS '1:Suspension,2:Reconexion';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_SLTD_CAB.IDLOTE IS 'Identificar del lote dentro del cual sea procesada la solicitud';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_SLTD_CAB.CODINSSRV IS 'Codigo de la instancia de servicio';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_SLTD_CAB.CODCLI IS 'Codigo del cliente';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_SLTD_CAB.CODSOLOT IS 'Codigo solot';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_SLTD_CAB.IDWF IS 'Identificador del workflow asignado';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_SLTD_CAB.IDTAREAWF IS 'Id de la tarea del workflow';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_SLTD_CAB.NUMREGISTRO IS 'Numero de registro reginsdth';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_SLTD_CAB.ESTADO IS 'Estado de la solicitud: 1: PEND_EJECUCION,2: LOTIZADA,3:CONFIRMADA_OK,4: CONFIRMADA_ERR';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_SLTD_CAB.USUREG IS 'Usuario que creo el registro';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_SLTD_CAB.FECREG IS 'Fecha de creacion del registro';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_SLTD_CAB.USUMOD IS 'Usuario de modificacion del registro';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_SLTD_CAB.FECMOD IS 'Fecha de modificacion del registro';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_SLTD_CAB.FLG_RECARGA IS 'Flag que indica si la solicitud corresponde a un registro recargable(1) o facturable(0)';



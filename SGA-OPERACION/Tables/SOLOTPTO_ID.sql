CREATE TABLE OPERACION.SOLOTPTO_ID
(
  CODSOLOT          NUMBER(8)                   NOT NULL,
  PUNTO             NUMBER(10)                  NOT NULL,
  MEDIO             VARCHAR2(50 BYTE),
  ESTADO            VARCHAR2(30 BYTE),
  FECASIG_COM       DATE,
  RESPONSABLE_COM   VARCHAR2(30 BYTE),
  FECASIG_PI        DATE,
  RESPONSABLE_PI    VARCHAR2(30 BYTE),
  FECPEX            DATE,
  FECDIS_PI         DATE,
  FECFIN_PI         DATE,
  FECLINK_PI        DATE,
  FLG_COM           NUMBER(1)                   DEFAULT 0,
  FLG_PI            NUMBER(1)                   DEFAULT 0,
  FECCFG_DAT        DATE,
  FECCFG_VOZ        DATE,
  FECPRU_SRV        DATE,
  FECINS_EQU_TMP    DATE,
  FECINS_EQU_DEF    DATE,
  FECRET_EQU        DATE,
  FECVIS_PI         DATE,
  FECVIS_COM        DATE,
  FECACTA_INS       DATE,
  FECACTA_SRV       DATE,
  FECACTA_RET       DATE,
  FECDOC            DATE,
  FLGDOC            NUMBER(1)                   DEFAULT 0                     NOT NULL,
  RESPONSABLE_DOC   VARCHAR2(30 BYTE),
  ESTDOCOPE         NUMBER(2),
  FLGDOC_CONF       NUMBER(1)                   DEFAULT 0                     NOT NULL,
  FLGDOC_DESC       NUMBER(1)                   DEFAULT 0                     NOT NULL,
  FLGDOC_GRAF       NUMBER(1)                   DEFAULT 0                     NOT NULL,
  FECDOC_CONF       DATE,
  FECDOC_DESC       DATE,
  FECDOC_GRAF       DATE,
  FECPROG           DATE,
  PRIORIZADO        VARCHAR2(30 BYTE),
  FECPRIOR          DATE,
  NROREQ            VARCHAR2(100 BYTE),
  SITEMANAGER       VARCHAR2(30 BYTE),
  SITEMANAGER_DES   VARCHAR2(30 BYTE),
  ESTPROV           NUMBER(2),
  CODCON            NUMBER(6),
  FECINISRV         DATE,
  FECPOS            DATE,
  OBSERVACION       VARCHAR2(4000 BYTE),
  NROSERVICIOMT     VARCHAR2(50 BYTE),
  PRIORIZAR_SOT     NUMBER(1),
  FECOFRECIDA       DATE,
  FECCOMCONT        DATE,
  MEDIOTX           NUMBER(2),
  PROVISION         VARCHAR2(30 BYTE),
  ESTINV            NUMBER(1),
  ESTCOS            NUMBER(1),
  CODUSUINV         VARCHAR2(30 BYTE),
  FECUSUINV         DATE,
  CODUSUCOS         VARCHAR2(30 BYTE),
  FECUSUCOS         DATE,
  FECPERMISO        DATE,
  FLG_DIS           NUMBER(1)                   DEFAULT 0,
  ESTADO_DIS        NUMBER(2),
  FECPROG_DIS       DATE,
  CODCON_DIS        NUMBER(6),
  OBSERVACION_DIS   VARCHAR2(400 BYTE),
  FECDISENO         DATE,
  ESTREQUISIC       NUMBER(2),
  FECMODESTREQ      DATE                        DEFAULT NULL,
  MOTPOSTERGA       NUMBER(2),
  FECPOSTERGA       DATE                        DEFAULT NULL,
  CODUSUESTPROG     VARCHAR2(30 BYTE),
  FECESTPROG        DATE,
  CODUSURESPROG     VARCHAR2(30 BYTE),
  FECRESPROG        DATE,
  CODUSUESTREQU     VARCHAR2(30 BYTE),
  FEC_CULMINACION   DATE,
  ACTA_INSTALACION  VARCHAR2(50 BYTE),
  NROSERIE          VARCHAR2(100 BYTE),
  FECASIGCON        DATE
);

COMMENT ON TABLE OPERACION.SOLOTPTO_ID IS 'Programacion de instalaciones';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.NROSERIE IS 'Numero de Serie para los Routers';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.CODSOLOT IS 'Codigo de la solicitud de orden de trabajo';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.PUNTO IS 'Punto de la solicitud';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.MEDIO IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.ESTADO IS 'Estado de la programación';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.FECASIG_COM IS 'Fecha de asignación de comunicación';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.RESPONSABLE_COM IS 'Responsable de comunicacion';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.FECASIG_PI IS 'Fecha de asignación de planta interna';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.RESPONSABLE_PI IS 'Responsable de planta interna';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.FECPEX IS 'Fecha de planta externa';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.FECDIS_PI IS 'Fecha de diseño de planta interna';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.FECFIN_PI IS 'Fecha de fin de planta interna';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.FECLINK_PI IS 'Fecha de instalacion del equipo';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.FLG_COM IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.FLG_PI IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.FECCFG_DAT IS 'Fecha de configuración de datos';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.FECCFG_VOZ IS 'Fecha de configuración de voz';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.FECPRU_SRV IS 'Fecha de prueba del servicio';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.FECINS_EQU_TMP IS 'Fecha de instalacion del equipo temporal';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.FECINS_EQU_DEF IS 'Fecha de instalacion del equipo';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.FECRET_EQU IS 'Fecha de retiro del equipo';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.FECVIS_PI IS 'Fecha de visita de planta interna';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.FECVIS_COM IS 'Fecha de visita de comunicacion';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.FECACTA_INS IS 'Fecha de acta de instalacion';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.FECACTA_SRV IS 'Fecha de acta de servcio';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.FECACTA_RET IS 'Fecha de acta de retiro';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.FECDOC IS 'Fecha de documento';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.FLGDOC IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.RESPONSABLE_DOC IS 'Responsable de la documentación';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.ESTDOCOPE IS 'Estado del documento de operaciones';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.FLGDOC_CONF IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.FECDOC_CONF IS 'Fecha de documento de configuración';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.FLGDOC_DESC IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.FLGDOC_GRAF IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.FECDOC_DESC IS 'Fecha de documento de descripcion';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.FECDOC_GRAF IS 'Fecha de documento de grafico';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.FECPROG IS 'Fecha de programación';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.PRIORIZADO IS 'Indica la priorizacion';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.FECPRIOR IS 'Fecha de priorización';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.NROREQ IS 'Numero de requerimiento';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.SITEMANAGER IS 'Site Manager';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.SITEMANAGER_DES IS 'Site Manager destino';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.ESTPROV IS 'Estado de provisioning';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.CODCON IS 'Codigo del contratista';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.FECINISRV IS 'Fecha de inicio de servicio';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.FECPOS IS 'Fecha de postergacion';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.OBSERVACION IS 'Observación';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.NROSERVICIOMT IS 'Numero de servicio de medios de terceros';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.PRIORIZAR_SOT IS 'Priorización de la solicitud de ot';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.FECOFRECIDA IS 'Fecha ofrecida';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.FECCOMCONT IS 'Fecha de compromiso de contrato';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.MEDIOTX IS 'Medio de transporte ';

COMMENT ON COLUMN OPERACION.SOLOTPTO_ID.FECASIGCON IS 'Fecha de Asignacion de Contrata';



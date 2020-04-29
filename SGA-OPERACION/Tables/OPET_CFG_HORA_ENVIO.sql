CREATE TABLE operacion.OPET_CFG_HORA_ENVIO(
CFGHN_IDCFGENV  NUMBER       NOT NULL,
CFGHN_IDCFG     NUMBER       NOT NULL ,
CFGHD_HORAENV   DATE         NULL,
CFGHN_ESTADO    NUMBER       DEFAULT 1 NULL ,
CFGHD_FECUSU    DATE         DEFAULT SYSDATE NULL ,
CFGHV_CODUSU    VARCHAR2(30) DEFAULT USER NULL );

COMMENT ON TABLE  operacion.OPET_CFG_HORA_ENVIO                IS 'Tabla de Configuracion de horas de envio';
COMMENT ON COLUMN operacion.OPET_CFG_HORA_ENVIO.CFGHN_IDCFGENV IS 'Secuencial de registro';
COMMENT ON COLUMN operacion.OPET_CFG_HORA_ENVIO.CFGHN_IDCFG    IS 'Id de Configuracion';
COMMENT ON COLUMN operacion.OPET_CFG_HORA_ENVIO.CFGHD_HORAENV  IS 'Hora de envio';
COMMENT ON COLUMN operacion.OPET_CFG_HORA_ENVIO.CFGHN_ESTADO   IS 'Estado del registro 1:Activo 0:Inactivo';
COMMENT ON COLUMN operacion.OPET_CFG_HORA_ENVIO.CFGHD_FECUSU   IS 'Fecha de registro del usuario';
COMMENT ON COLUMN operacion.OPET_CFG_HORA_ENVIO.CFGHV_CODUSU   IS 'Codigo de usuario que registra';

ALTER TABLE operacion.OPET_CFG_HORA_ENVIO
add CONSTRAINT OPET_CFG_HORA_ENVIO_PK PRIMARY KEY (CFGHN_IDCFGENV);




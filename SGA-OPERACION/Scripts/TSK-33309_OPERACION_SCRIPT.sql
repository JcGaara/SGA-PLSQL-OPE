ALTER TABLE OPERACION.RECONEXION_APC ADD TIPSRV    CHAR(4)      NULL;
ALTER TABLE OPERACION.RECONEXION_APC ADD TIPODEMO  CHAR(1)      NULL;
   
COMMENT ON COLUMN OPERACION.RECONEXION_APC.TIPSRV  IS 'C�digo del Tipo de Servicio';
COMMENT ON COLUMN OPERACION.RECONEXION_APC.TIPODEMO  IS 'Indicador si es proyecto demo 1: Si 0 o nulo: No';


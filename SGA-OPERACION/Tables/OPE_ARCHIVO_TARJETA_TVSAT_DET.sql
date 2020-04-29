CREATE TABLE OPERACION.OPE_ARCHIVO_TARJETA_TVSAT_DET
(
  IDREG_TARJETA   NUMBER(18)                    NOT NULL,
  IDARCHIVO       NUMBER(18)                    NOT NULL,
  TARJETA         VARCHAR2(50 BYTE),
  USUREG          VARCHAR2(30 BYTE)             DEFAULT USER,
  FECREG          DATE                          DEFAULT SYSDATE,
  USUMOD          VARCHAR2(30 BYTE)             DEFAULT USER,
  FECMOD          DATE                          DEFAULT SYSDATE,
  IDPROGRAMACION  NUMBER(18)
);

COMMENT ON TABLE OPERACION.OPE_ARCHIVO_TARJETA_TVSAT_DET IS 'Permite la carga de los numeros de serie de las tarjetas a las que se afectaran con el envio de los comandos a CONAX';

COMMENT ON COLUMN OPERACION.OPE_ARCHIVO_TARJETA_TVSAT_DET.IDREG_TARJETA IS 'Numero identificador de la tarjeta enviada en el archivo ';

COMMENT ON COLUMN OPERACION.OPE_ARCHIVO_TARJETA_TVSAT_DET.IDARCHIVO IS 'Número identificador de la programación del mensaje a enviar por el deco de TV Satelital';

COMMENT ON COLUMN OPERACION.OPE_ARCHIVO_TARJETA_TVSAT_DET.TARJETA IS 'Número de serie de la tarjeta';

COMMENT ON COLUMN OPERACION.OPE_ARCHIVO_TARJETA_TVSAT_DET.USUREG IS 'Usuario que insertó el registro';

COMMENT ON COLUMN OPERACION.OPE_ARCHIVO_TARJETA_TVSAT_DET.FECREG IS 'Fecha que inserto el registro';

COMMENT ON COLUMN OPERACION.OPE_ARCHIVO_TARJETA_TVSAT_DET.USUMOD IS 'Usuario que modificó el registro';

COMMENT ON COLUMN OPERACION.OPE_ARCHIVO_TARJETA_TVSAT_DET.FECMOD IS 'Fecha que se modificó el registro';



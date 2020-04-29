CREATE TABLE OPERACION.RECONEXIONPORPAGO
(
  IDRECPAGO       NUMBER                        NOT NULL,
  IDFAC           NUMBER,
  CODCLI          CHAR(8 BYTE),
  NOMABR          VARCHAR2(50 BYTE),
  FECREG          DATE                          DEFAULT SYSDATE,
  USUREG          VARCHAR2(30 BYTE),
  FLGLEIDO        CHAR(1 BYTE)                  DEFAULT 0,
  FLGRECONECTADO  CHAR(1 BYTE)                  DEFAULT 0,
  OBS             VARCHAR2(200 BYTE)
);

COMMENT ON TABLE OPERACION.RECONEXIONPORPAGO IS 'Almacena las l�neas para reconexi�n autom�tica por cancelaci�n de docuemntos de pago.';

COMMENT ON COLUMN OPERACION.RECONEXIONPORPAGO.IDFAC IS 'id del documento de pago';

COMMENT ON COLUMN OPERACION.RECONEXIONPORPAGO.CODCLI IS 'id del cliente';

COMMENT ON COLUMN OPERACION.RECONEXIONPORPAGO.NOMABR IS 'l�nea correspondiente al documento cancelado';

COMMENT ON COLUMN OPERACION.RECONEXIONPORPAGO.FLGLEIDO IS 'indicador de si el registro fue le�do por el proceso que invoca el job';

COMMENT ON COLUMN OPERACION.RECONEXIONPORPAGO.FLGRECONECTADO IS 'indicador de si la l�nea fue env�adad a reconectar';

COMMENT ON COLUMN OPERACION.RECONEXIONPORPAGO.OBS IS 'observaci�n';



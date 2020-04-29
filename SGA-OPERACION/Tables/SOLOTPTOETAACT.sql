CREATE TABLE OPERACION.SOLOTPTOETAACT
(
  CODSOLOT        NUMBER(8),
  PUNTO           NUMBER(10),
  ORDEN           NUMBER(4),
  IDACT           NUMBER(10)                    NOT NULL,
  MONEDA_ID       NUMBER(10),
  CODACT          NUMBER(5)                     NOT NULL,
  CANDIS          NUMBER(8,2)                   DEFAULT 0,
  COSDIS          NUMBER(10,2)                  DEFAULT 0,
  UNIMETINS       VARCHAR2(30 BYTE),
  TPOCROINS       VARCHAR2(30 BYTE),
  FLGCASOINS      NUMBER(1),
  CANLIQ          NUMBER(8,2)                   DEFAULT 0,
  COSLIQ          NUMBER(10,2)                  DEFAULT 0,
  UNIMETLIQ       VARCHAR2(30 BYTE),
  TPOCROLIQ       VARCHAR2(30 BYTE),
  FLGASOLIQ       NUMBER(1),
  CONTRATA        NUMBER(1)                     DEFAULT 0,
  OBSERVACION     VARCHAR2(400 BYTE),
  CODUSU          VARCHAR2(30 BYTE)             DEFAULT user                  NOT NULL,
  FECUSU          DATE                          DEFAULT SYSDATE               NOT NULL,
  UNIMETDIS       VARCHAR2(30 BYTE),
  TPOCRODIS       VARCHAR2(30 BYTE),
  FLGASODIS       NUMBER(1),
  FECINI          DATE,
  FECFIN          DATE,
  CODPRECDIS      NUMBER(8),
  CODPRECLIQ      NUMBER(8),
  CANINS          NUMBER(8,2),
  PEP             VARCHAR2(40 BYTE),
  CANAUD          NUMBER(8,2)                   DEFAULT 0,
  COSAUD          NUMBER(10,2)                  DEFAULT 0,
  FLG_SPGENERADO  NUMBER                        DEFAULT 0,
  FLG_PRELIQ      NUMBER(1)                     DEFAULT 0
);

COMMENT ON TABLE OPERACION.SOLOTPTOETAACT IS 'Listado de actividades por cada etapa del detalle de la solicitud';

COMMENT ON COLUMN OPERACION.SOLOTPTOETAACT.FLG_PRELIQ IS 'Identifica la actividad que Preliquida la Contrata';

COMMENT ON COLUMN OPERACION.SOLOTPTOETAACT.CODSOLOT IS 'Codigo de la solicitud de orden de trabajo';

COMMENT ON COLUMN OPERACION.SOLOTPTOETAACT.PUNTO IS 'Punto de la solicitud';

COMMENT ON COLUMN OPERACION.SOLOTPTOETAACT.ORDEN IS 'Orden de la etapa ingresada';

COMMENT ON COLUMN OPERACION.SOLOTPTOETAACT.IDACT IS 'Pk de la tabla';

COMMENT ON COLUMN OPERACION.SOLOTPTOETAACT.MONEDA_ID IS 'Codigo de moneda';

COMMENT ON COLUMN OPERACION.SOLOTPTOETAACT.CODACT IS 'Codigo de la actividad';

COMMENT ON COLUMN OPERACION.SOLOTPTOETAACT.CANDIS IS 'Cantidad en la fase de dise�o de la actividad';

COMMENT ON COLUMN OPERACION.SOLOTPTOETAACT.COSDIS IS 'Costo de dise�o de la actividad';

COMMENT ON COLUMN OPERACION.SOLOTPTOETAACT.UNIMETINS IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.SOLOTPTOETAACT.TPOCROINS IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.SOLOTPTOETAACT.FLGCASOINS IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.SOLOTPTOETAACT.CANLIQ IS 'Cantidad en la fase de liquidaci�n de la actividad';

COMMENT ON COLUMN OPERACION.SOLOTPTOETAACT.COSLIQ IS 'Costo de liquidaci�n de la actividad';

COMMENT ON COLUMN OPERACION.SOLOTPTOETAACT.UNIMETLIQ IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.SOLOTPTOETAACT.TPOCROLIQ IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.SOLOTPTOETAACT.FLGASOLIQ IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.SOLOTPTOETAACT.CONTRATA IS 'Identifica si la actividad es realizada por un contratista';

COMMENT ON COLUMN OPERACION.SOLOTPTOETAACT.OBSERVACION IS 'Observacion';

COMMENT ON COLUMN OPERACION.SOLOTPTOETAACT.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.SOLOTPTOETAACT.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.SOLOTPTOETAACT.UNIMETDIS IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.SOLOTPTOETAACT.TPOCRODIS IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.SOLOTPTOETAACT.FLGASODIS IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.SOLOTPTOETAACT.FECINI IS 'Fecha inicial de la actividad de la etapa';

COMMENT ON COLUMN OPERACION.SOLOTPTOETAACT.FECFIN IS 'Fecha fin de la actividad de la etapa';

COMMENT ON COLUMN OPERACION.SOLOTPTOETAACT.CANINS IS 'Cantidad instalada';

COMMENT ON COLUMN OPERACION.SOLOTPTOETAACT.CANAUD IS 'Cantidad en la fase de auditor�a de la actividad';

COMMENT ON COLUMN OPERACION.SOLOTPTOETAACT.COSAUD IS 'Costo de auditor�a de la actividad';

COMMENT ON COLUMN OPERACION.SOLOTPTOETAACT.FLG_SPGENERADO IS '0 = NO; 1 = En cola; 2= Error; 3 = Procesado';


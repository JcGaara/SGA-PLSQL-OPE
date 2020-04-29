CREATE TABLE OPERACION.ESTAGENDA
(
  ESTAGE       NUMBER(2)                        NOT NULL,
  DESCRIPCION  VARCHAR2(100 BYTE)               NOT NULL,
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL,
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  ABREVI       CHAR(4 BYTE),
  ACTIVO       NUMBER(1)                        DEFAULT 0,
  ESTFINAL     NUMBER(1)                        DEFAULT 0,
  ENVIA_MAIL   NUMBER(1)                        DEFAULT 0,
  REAGENDA     NUMBER(1)                        DEFAULT 0,
  TIPESTAGE    NUMBER,
  PRE_PROC     VARCHAR2(200 BYTE),
  POS_PROC     VARCHAR2(200 BYTE)
);

COMMENT ON COLUMN OPERACION.ESTAGENDA.ESTAGE IS 'Estado de la Agenda de Tareas';

COMMENT ON COLUMN OPERACION.ESTAGENDA.DESCRIPCION IS 'Descripcion del Estado';

COMMENT ON COLUMN OPERACION.ESTAGENDA.FECUSU IS 'Fecha de Registro';

COMMENT ON COLUMN OPERACION.ESTAGENDA.CODUSU IS 'Usuario de Registro';

COMMENT ON COLUMN OPERACION.ESTAGENDA.ABREVI IS 'Abreviatura del Estado';



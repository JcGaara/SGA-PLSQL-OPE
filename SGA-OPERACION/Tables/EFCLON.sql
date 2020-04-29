CREATE TABLE OPERACION.EFCLON
(
  IDSEC           NUMBER(15),
  NUMSLC_ORIGEN   VARCHAR2(10 BYTE)             NOT NULL,
  CODEF_ORIGEN    NUMBER(8)                     NOT NULL,
  NUMSLC_DESTINO  VARCHAR2(10 BYTE)             NOT NULL,
  CODEF_DESTINO   NUMBER(8)                     NOT NULL,
  CODUSU          VARCHAR2(30 BYTE)             NOT NULL,
  FECCLON         DATE                          NOT NULL 
);

COMMENT ON TABLE OPERACION.EFCLON IS 'Tabla de Control de las Clonaciones de estudio de factibilidad';

COMMENT ON COLUMN OPERACION.EFCLON.IDSEC IS 'Identificador de Secuencia para la tabla Efclon';

COMMENT ON COLUMN OPERACION.EFCLON.NUMSLC_ORIGEN IS 'Nº de Proyecto Origen';

COMMENT ON COLUMN OPERACION.EFCLON.CODEF_ORIGEN IS 'Código de Estudio de Factibilidad Origen';

COMMENT ON COLUMN OPERACION.EFCLON.NUMSLC_DESTINO IS 'Nº de Proyecto Origen';

COMMENT ON COLUMN OPERACION.EFCLON.CODEF_DESTINO IS 'Código de Estudio de Factibilidad Destino';

COMMENT ON COLUMN OPERACION.EFCLON.CODUSU IS 'Código de usuario creador';

COMMENT ON COLUMN OPERACION.EFCLON.FECCLON IS 'Fecha de la clonación';


--  There is no statement for index OPERACION.SYS_C00276915.
--  The object is created when the parent object is created.

ALTER TABLE OPERACION.EFCLON ADD (
  PRIMARY KEY
  (IDSEC)
  USING INDEX
    TABLESPACE OPERACION_IDX
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
                BUFFER_POOL      DEFAULT
               )
  ENABLE VALIDATE);


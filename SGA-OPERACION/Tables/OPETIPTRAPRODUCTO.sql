CREATE TABLE OPERACION.OPETIPTRAPRODUCTO
(
  IDPRODUCTO  NUMBER(10)                        NOT NULL,
  TIPTRA      NUMBER(4)                         NOT NULL,
  ESTADO      NUMBER(1)                         DEFAULT 0                     NOT NULL,
  CODUSU      VARCHAR2(30 BYTE)                 DEFAULT user                  NOT NULL,
  FECUSU      DATE                              DEFAULT SYSDATE               NOT NULL
);

COMMENT ON TABLE OPERACION.OPETIPTRAPRODUCTO IS 'Mantenimiento entre Producto Comercial y Tipo de Trabajo';

COMMENT ON COLUMN OPERACION.OPETIPTRAPRODUCTO.IDPRODUCTO IS 'Codigo del producto comercial';

COMMENT ON COLUMN OPERACION.OPETIPTRAPRODUCTO.TIPTRA IS 'Codigo del tipo de trabajo';

COMMENT ON COLUMN OPERACION.OPETIPTRAPRODUCTO.ESTADO IS 'Estado de la configuracion';

COMMENT ON COLUMN OPERACION.OPETIPTRAPRODUCTO.CODUSU IS 'Codigo del usuario';

COMMENT ON COLUMN OPERACION.OPETIPTRAPRODUCTO.FECUSU IS 'Fecha de creacion del registro';



CREATE TABLE OPERACION.ACCUSUESTETA
(
  CODUSU      VARCHAR2(30 BYTE)                 DEFAULT user                  NOT NULL,
  ESTETA      NUMBER(2)                         NOT NULL,
  TIPOPLANTA  CHAR(2 BYTE)                      NOT NULL,
  FECUSU      DATE                              DEFAULT sysdate               NOT NULL
);

COMMENT ON TABLE OPERACION.ACCUSUESTETA IS 'Usuarios que permiten realizar el cambio de estado a las etapas.';

COMMENT ON COLUMN OPERACION.ACCUSUESTETA.CODUSU IS 'Codigo de Usuario';

COMMENT ON COLUMN OPERACION.ACCUSUESTETA.ESTETA IS 'Estado de la Etapa a la que se puede modificar';

COMMENT ON COLUMN OPERACION.ACCUSUESTETA.TIPOPLANTA IS 'Tipo de Planta a la que pertenece el Usuario: PI: Planta Interna, PE: Planta Externa';

COMMENT ON COLUMN OPERACION.ACCUSUESTETA.FECUSU IS 'Fecha de registro';



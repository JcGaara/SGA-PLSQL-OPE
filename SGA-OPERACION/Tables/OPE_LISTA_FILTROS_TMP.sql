CREATE TABLE OPERACION.OPE_LISTA_FILTROS_TMP
(
  IDVALOR  NUMBER                               NOT NULL,
  DW       VARCHAR2(200 BYTE),
  TIPO     NUMBER,
  VALOR    VARCHAR2(10 BYTE),
  USUREG   VARCHAR2(30 BYTE)                    DEFAULT USER,
  FECREG   DATE                                 DEFAULT SYSDATE,
  USUMOD   VARCHAR2(30 BYTE)                    DEFAULT USER,
  FECMOD   DATE                                 DEFAULT SYSDATE
);

COMMENT ON TABLE OPERACION.OPE_LISTA_FILTROS_TMP IS 'Tabla que guarda los valores a filtrar en un datawindow';

COMMENT ON COLUMN OPERACION.OPE_LISTA_FILTROS_TMP.IDVALOR IS 'Numero identificador del valor a filtrar en una ventana';

COMMENT ON COLUMN OPERACION.OPE_LISTA_FILTROS_TMP.DW IS 'Datawindow de referencia para el filtro';

COMMENT ON COLUMN OPERACION.OPE_LISTA_FILTROS_TMP.TIPO IS 'Codigo identificador del tipo de filtro. 1:SOT, 2:Proyecto, 3:Numero Telefonico, 4:SID, 5:SID a Procesar, 6:Codincidence';

COMMENT ON COLUMN OPERACION.OPE_LISTA_FILTROS_TMP.VALOR IS 'Valor del filtro';

COMMENT ON COLUMN OPERACION.OPE_LISTA_FILTROS_TMP.USUREG IS 'Usuario que insertó el registro';

COMMENT ON COLUMN OPERACION.OPE_LISTA_FILTROS_TMP.FECREG IS 'Fecha que inserto el registro';

COMMENT ON COLUMN OPERACION.OPE_LISTA_FILTROS_TMP.USUMOD IS 'Usuario que modificó el registro';

COMMENT ON COLUMN OPERACION.OPE_LISTA_FILTROS_TMP.FECMOD IS 'Fecha que se modificó el registro';



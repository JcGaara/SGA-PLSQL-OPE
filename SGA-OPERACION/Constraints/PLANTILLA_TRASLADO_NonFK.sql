ALTER TABLE OPERACION.PLANTILLA_TRASLADO ADD (
  CONSTRAINT PK_PLANTILLA_TRASLADO
 PRIMARY KEY
 (IDPLANTILLA),
  CONSTRAINT AK_PLANTILLA_TRASLADO
 UNIQUE (TIPEQU, CENTRO_ORI, ALMACEN_ORI, CENTRO_DES, ALMACEN_DES));

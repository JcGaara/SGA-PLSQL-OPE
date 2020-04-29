/*****************************************************************************************************
'* Nombre Secuencia : OPERACION.MIGRSEQ_DATAPRI
'* Prop�sito : Obtiene el valor para el campo DATAN_ID que es PK de la Tabla OPERACION.MIGRT_DATAPRINC
'* Output : Codigo Secuencial de tabla OPERACION.MIGRT_DATAPRINC
'* Creado por : Jimmy Calle / Edwin Vasquez
'* Fec Creaci�n : 05-05-2016
'* Fec Actualizaci�n : 05-05-2016
'*****************************************************************************************************/
CREATE SEQUENCE OPERACION.MIGRSEQ_DATAPRI
  START WITH 1
  INCREMENT BY 1
  NOMAXVALUE
  NOCACHE;
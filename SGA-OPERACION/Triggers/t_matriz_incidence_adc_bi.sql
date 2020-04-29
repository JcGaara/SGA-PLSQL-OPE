CREATE OR REPLACE TRIGGER operacion.t_matriz_incidence_adc_bi
  BEFORE INSERT ON operacion.matriz_incidence_adc
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
/************************************************************************************************
  REVISIONES:
   Versión     Fecha           Autor         Solicitado por               Descripcion
  ---------  ----------  ----------------  -----------------  ----------------------------------
     1.0     16/03/2016  Jorge Rivas       NALDA AROTINCO     PROY-22818 Adm Manejo de Cuadrillas
  ************************************************************************************************/

/************************************************************************************************
  *Tipo               : Trigger
  *Descripci?n        : Obtiene El secuencial
  *Autor              : Jorge Rivas
  *Proyecto o REQ     : PROY-22818 Adm Manejo de Cuadrillas
  *Fecha de Creación  : 16/03/2016
  ************************************************************************************************/
DECLARE
  lv_ip operacion.matriz_incidence_adc.ipcre%TYPE;

BEGIN
  IF :new.ipcre IS NULL THEN 
	SELECT SYS_CONTEXT('userenv', 'ip_address') INTO lv_ip FROM dual;
    :new.ipcre := lv_ip;
  END IF;
END;
/
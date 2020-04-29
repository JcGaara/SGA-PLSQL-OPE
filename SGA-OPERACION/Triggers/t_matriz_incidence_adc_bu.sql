CREATE OR REPLACE TRIGGER operacion.t_matriz_incidence_adc_bu
  BEFORE UPDATE ON operacion.matriz_incidence_adc
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
  lv_ip operacion.matriz_incidence_adc.ipmod%TYPE;

BEGIN
  SELECT SYS_CONTEXT('userenv', 'ip_address') INTO lv_ip FROM dual;

  :new.ipmod  := lv_ip;
  :new.usumod := USER;
  :new.fecmod := SYSDATE;
END;
/
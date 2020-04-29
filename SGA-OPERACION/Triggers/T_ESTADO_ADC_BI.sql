CREATE OR REPLACE TRIGGER OPERACION.T_ESTADO_ADC_BI
  BEFORE INSERT ON OPERACION.ESTADO_ADC
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
/***********************************************************************
  REVISIONES:
   Versi?n     Fecha         Autor              Solicitado por             Descripcion
  ---------  -----------   ----------------     -----------------    ----------------------------------
     1.0      12/05/2015   Jorge Rivas          NALDA AROTINCO         PROY-17652 Adm Manejo de Cuadrillas
  ************************************************************************/
DECLARE
	lv_ip            operacion.estado_ADC.ipcre%type;
BEGIN
	SELECT sys_context('userenv', 'ip_address') 
	  INTO lv_ip 
	  FROM dual;

	:new.ipcre := lv_ip;
END;
/

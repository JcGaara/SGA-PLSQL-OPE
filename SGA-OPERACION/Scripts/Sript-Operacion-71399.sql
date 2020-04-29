declare
l_cant       number;

begin
 --razones del bscs
 SELECT count(*)
    INTO l_cant
     FROM tipopedd t
    WHERE t.abrev = 'RAZON_BSCS_BAJAS';
    
    IF l_cant=0 THEN
      
      insert into tipopedd (TIPOPEDD, DESCRIPCION, ABREV)
      values ((select max(TIPOPEDD) + 1 from tipopedd), 'RAZONES EN BSCS', 'RAZON_BSCS_BAJAS');
      
      insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
      values ((select max(IDOPEDD) + 1 from opedd), NULL,125, 'Anulación de SOT en SGA', 'ANUL_SOT',
      (select MAX(tipopedd) from tipopedd where upper(abrev)='RAZON_BSCS_BAJAS'), null);
      
      insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
      values ((select max(IDOPEDD) + 1 from opedd), NULL,126, 'Baja Líneas Masivas en SGA', 'BAJA_MAS',
      (select MAX(tipopedd) from tipopedd where upper(abrev)='RAZON_BSCS_BAJAS'), null);
      
    END IF;
	
--tipos trabajo anulación/alineación
 SELECT count(*)
    INTO l_cant
     FROM tipopedd t
    WHERE t.abrev = 'TIP_TRABAJO';
    
    IF l_cant=0 THEN
      
      insert into tipopedd (TIPOPEDD, DESCRIPCION, ABREV)
      values ((select max(TIPOPEDD) + 1 from tipopedd), 'CONFIGURACIIÓN TIPO TRABAJO', 'TIP_TRABAJO');
      
      insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
      values ((select max(IDOPEDD) + 1 from opedd),null,368, 'INSTALACIÓN PAQUETES',null,
      (select MAX(tipopedd) from tipopedd where upper(abrev)='TIP_TRABAJO'), null);
	  
	  insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
      values ((select max(IDOPEDD) + 1 from opedd),null,658, 'HFC - SISACT INSTALACION PAQUETES TODO CLARO DIGITAL',null,
      (select MAX(tipopedd) from tipopedd where upper(abrev)='TIP_TRABAJO'), null);
      
    END IF;
	
 --Configuracion de Alineacion 
   SELECT count(*)
    INTO l_cant
     FROM tipopedd t
    WHERE t.abrev = 'CONFI_ALINEA';
    
    IF l_cant=0 THEN
      
     insert into tipopedd (TIPOPEDD, DESCRIPCION, ABREV)
      values ((select max(TIPOPEDD) + 1 from tipopedd), 'CONFIGURACIÓN ALINEACION', 'CONFI_ALINEA');
      
      insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
      values ((select max(IDOPEDD) + 1 from opedd),null,0, 'VALIDA ALINEACION',null,
      (select MAX(tipopedd) from tipopedd where upper(abrev)='CONFI_ALINEA'), null);
      
    END IF;
	
--Parametro de dias en anulacion masiva
   SELECT count(*)
    INTO l_cant
     FROM tipopedd t
    WHERE t.abrev = 'DIA_MASIVO';
    
    IF l_cant=0 THEN
      
      insert into tipopedd (TIPOPEDD, DESCRIPCION, ABREV)
      values ((select max(TIPOPEDD) + 1 from tipopedd), 'CONFIGURACIÓN DIA MASIVO', 'DIA_MASIVO');
      
      insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
      values ((select max(IDOPEDD) + 1 from opedd),'02/07/2015',0, 'DIA INICIAL','DIA_INI',
      (select MAX(tipopedd) from tipopedd where upper(abrev)='DIA_MASIVO'), null);
	  
	  insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
      values ((select max(IDOPEDD) + 1 from opedd),'02/07/2015',0, 'DIA FINAL','DIA_FIN',
      (select MAX(tipopedd) from tipopedd where upper(abrev)='DIA_MASIVO'), null);
     
    insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
      values ((select max(IDOPEDD) + 1 from opedd),'sysdate-1',1, 'DIA ANTERIOR','DIA_ANT',
      (select MAX(tipopedd) from tipopedd where upper(abrev)='DIA_MASIVO'), null);
      
    END IF;
  commit;	
End;
/
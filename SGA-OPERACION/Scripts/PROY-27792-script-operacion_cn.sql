-- INSERT TIPO DE TRABAJO

INSERT INTO OPERACION.tiptrabajo (TIPTRA, TIPTRS,Descripcion)
VALUES((SELECT MAX(TIPTRA)+1 FROM OPERACION.tiptrabajo), 1, 'WLL/SIAC – CAMBIO DE NUMERO');

INSERT INTO OPERACION.tiptrabajo (TIPTRA, TIPTRS,Descripcion)
VALUES((SELECT MAX(TIPTRA)+1 FROM OPERACION.tiptrabajo), 1, 'HFC/SIAC – CAMBIO DE NUMERO');

commit;
-- MOTIVO 
INSERT INTO OPERACION.motot (codmotot, descripcion) values ((SELECT max(codmotot)+1 FROM OPERACION.motot),'WLL – A solicitud del cliente');

INSERT INTO operacion.mototxtiptra (tiptra, codmotot) values
((SELECT tiptra FROM OPERACION.tiptrabajo WHERE descripcion ='WLL/SIAC – CAMBIO DE NUMERO'),
 (SELECT codmotot FROM OPERACION.motot WHERE descripcion = 'WLL – A solicitud del cliente') );
 
INSERT INTO operacion.mototxtiptra (tiptra, codmotot) values
((SELECT tiptra FROM OPERACION.tiptrabajo WHERE descripcion ='HFC/SIAC – CAMBIO DE NUMERO'),684 );

COMMIT;
-- CONFIGURACION de WF y TIPTRA
 insert into OPERACION.tipopedd (TIPOPEDD, DESCRIPCION, ABREV)
  values ((select max(TIPOPEDD) + 1 from OPERACION.tipopedd), 'CAMBIO DE NUMERO SIAC UNICO', 'CAMBIO_NUMERO_SIAC_UNICO');
      
  insert into OPERACION.opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values ((select max(IDOPEDD) + 1 from OPERACION.opedd), 'LTE',
  (SELECT tiptra FROM OPERACION.tiptrabajo WHERE descripcion ='WLL/SIAC – CAMBIO DE NUMERO'),
  'CAMBIO NUMERO LTE', 'CAMBIO_NUMERO_LTE',(select MAX(tipopedd) from OPERACION.tipopedd where upper(abrev)='CAMBIO_NUMERO_SIAC_UNICO'),
  (SELECT wfdef FROM OPEWF.wfdef WHERE DESCRIPCION = 'WLL/SIAC - CAMBIO DE NUMERO'));
      
  insert into OPERACION.opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values ((select max(IDOPEDD) + 1 from OPERACION.opedd), 'HFC',
  (SELECT tiptra FROM OPERACION.tiptrabajo WHERE descripcion ='HFC/SIAC – CAMBIO DE NUMERO'),
  'CAMBIO NUMERO HFC', 'CAMBIO_NUMERO_HFC',(select MAX(tipopedd) from OPERACION.tipopedd where upper(abrev)='CAMBIO_NUMERO_SIAC_UNICO'),
  (SELECT wfdef FROM OPEWF.wfdef WHERE DESCRIPCION = 'HFC/SIAC - CAMBIO DE NUMERO'));
 
 -- CONFIGURACION DE CORREOS
insert into OPERACION.tipopedd (TIPOPEDD, DESCRIPCION, ABREV)
      values ((select max(TIPOPEDD) + 1 from OPERACION.tipopedd), 'LOCUCION CAMBIONUMERO SIAC_UNI', 'LOCUCION_SIAC_CAMBIONUMERO');
      
insert into OPERACION.opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
      values ((select max(IDOPEDD) + 1 from OPERACION.opedd), 'atencionalcliente@claro.com.pe', null,'DL-PE-Conmutacion@claro.com.pe', 'LOCUCION_SIAC_CAMBIONUMERO',
	  (select MAX(tipopedd) from OPERACION.tipopedd where upper(abrev)='LOCUCION_SIAC_CAMBIONUMERO'),null); 
	  
--CONFIGURACION DE TIPTRA SISAC
insert into OPERACION.opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
      values ((select max(IDOPEDD) + 1 from OPERACION.opedd), '1',
              (SELECT tiptra FROM OPERACION.tiptrabajo WHERE descripcion ='HFC/SIAC – CAMBIO DE NUMERO'),
              'HFC/SIAC – CAMBIO DE NUMERO','HFC_SIAC_CAMBIO_NUMERO',
              (select MAX(tipopedd) from OPERACION.tipopedd where upper(abrev)='TIPO_TRANS_SIAC'),null);

insert into OPERACION.opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
      values ((select max(IDOPEDD) + 1 from OPERACION.opedd), '1',
              (SELECT tiptra FROM OPERACION.tiptrabajo WHERE descripcion ='WLL/SIAC – CAMBIO DE NUMERO'),
              'WLL/SIAC – CAMBIO DE NUMERO','WLL_SIAC_CAMBIO_NUMERO',
              (select MAX(tipopedd) from OPERACION.tipopedd where upper(abrev)='TIPO_TRANS_SIAC'),null); 			  

--CONFIGURACION DE LA WF
insert into OPERACION.opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
      values ((select max(IDOPEDD) + 1 from opedd), NULL,
              (SELECT tiptra FROM OPERACION.tiptrabajo WHERE descripcion ='HFC/SIAC – CAMBIO DE NUMERO'),
              'HFC/SIAC – CAMBIO DE NUMERO','HFC_SIAC_CAMBIO_NUMERO',
              (select MAX(tipopedd) from OPERACION.tipopedd where upper(abrev)='ASIGNARWFBSCS'),6);
              
insert into OPERACION.opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
      values ((select max(IDOPEDD) + 1 from opedd), NULL,
              (SELECT tiptra FROM OPERACION.tiptrabajo WHERE descripcion ='WLL/SIAC – CAMBIO DE NUMERO'),
              'WLL/SIAC – CAMBIO DE NUMERO','WLL_SIAC_CAMBIO_NUMERO',
              (select MAX(tipopedd) from OPERACION.tipopedd where upper(abrev)='ASIGNARWFBSCS'),6); 	
			  
--CONFIGURACION DE LOS MOTIVOS
insert into OPERACION.tipopedd (TIPOPEDD, DESCRIPCION, ABREV)
      values ((select max(TIPOPEDD) + 1 from OPERACION.tipopedd), 'Motivo Cambio Numero HFC/LTE', 'MOTIVO_CAMBIO_NUMERO');
      
insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
      values ((select max(IDOPEDD) + 1 from OPERACION.opedd), NULL,
       (SELECT codmotot FROM OPERACION.motot WHERE descripcion = 'WLL – A solicitud del cliente'),
       'WLL – A solicitud del cliente', 'LTE',
	  (select MAX(tipopedd) from OPERACION.tipopedd where upper(abrev)='MOTIVO_CAMBIO_NUMERO'),null); 
	  
insert into OPERACION.opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
      values ((select max(IDOPEDD) + 1 from OPERACION.opedd), NULL, 684,'HFC - A solicitud del cliente', 'HFC',
	  (select MAX(tipopedd) from OPERACION.tipopedd where upper(abrev)='MOTIVO_CAMBIO_NUMERO'),null); 			  
COMMIT;

/
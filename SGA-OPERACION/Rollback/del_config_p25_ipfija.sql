--PUERTO 25
DELETE from tareawfdef where DESCRIPCION = 'Generacion de Transaccion IW' AND WFDEF=(select wfdef from wfdef where descripcion = 'HFC/SIAC - PUERTO25');


DELETE FROM tareawfdef where DESCRIPCION = 'Configuración Intraway' AND WFDEF=(select wfdef from wfdef where descripcion = 'HFC/SIAC - PUERTO25');

DELETE from wfdef where DESCRIPCION = 'HFC/SIAC - PUERTO25';


---IP FIJA 

DELETE from tareawfdef where DESCRIPCION = 'Generacion de Transaccion IW' AND WFDEF=(select wfdef from wfdef where descripcion = 'HFC/SIAC - IPFIJA CONFIGURACION');


DELETE from tareawfdef where DESCRIPCION = 'Configuración Intraway' AND WFDEF=(select wfdef from wfdef where descripcion = 'HFC/SIAC - IPFIJA CONFIGURACION');

DELETE from wfdef where DESCRIPCION = 'HFC/SIAC - IPFIJA CONFIGURACION';

DELETE from OPEWF.tareadef where DESCRIPCION = 'Generacion de Transaccion IW' and pre_proc='intraway.pq_provision_itw.p_genera_xml_adc' ;

COMMIT; 

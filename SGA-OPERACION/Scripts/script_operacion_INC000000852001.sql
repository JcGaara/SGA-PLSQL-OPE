-- script_INC000000852001

-- TIPOPEDD
insert into tipopedd (tipopedd,     descripcion,        abrev )
        values ( (select MAX(tipopedd) + 1 from tipopedd), 
                      'PORTABILIDAD NUM FIJA',   'PORTABILIDAD_NUM_FIJA');

-- OPEDD                     
insert into opedd ( idopedd,     codigoc,   codigon,     descripcion, 
                    abreviacion, tipopedd,  codigon_aux )
     values ( ( select MAX(idopedd) + 1 from opedd ), '0002', null, 'LDN', 'VALIDA_NUM_FIJO_LDN',
              (select MAX(tipopedd) from tipopedd where UPPER(abrev)='PORTABILIDAD_NUM_FIJA'), null);
			  
commit;
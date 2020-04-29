-- script_INC000001069631

-- TIPOPEDD
insert into tipopedd (tipopedd,     descripcion,        abrev )
        values ( (select MAX(tipopedd) + 1 from tipopedd),'VALIDA_PRIXHUNTING','VALIDA_PRIXHUNTING');

-- OPEDD                     
insert into opedd ( idopedd,     codigoc,   codigon,     descripcion, 
                    abreviacion, tipopedd,  codigon_aux )
     values ( ( select MAX(idopedd) + 1 from opedd ), 'VALIDA PRIXHUNTING', null, 'Validando PRIXHUNTING, Error, No se encontro registro.', 'VALIDA PRIXHUNTING',
              (select MAX(tipopedd) from tipopedd where UPPER(abrev)='VALIDA_PRIXHUNTING'), null);
commit;
			  
delete from operacion.opedd 
       where codigon_aux = (select idgrupocorte from  collections.cxc_grupocorte where DESABR = 'FTTH BSCS')
             and tipopedd = (select tipopedd from operacion.tipopedd where descripcion = 'Grupo Corte-Tipo de Tecnologia' and abrev = 'GRUPOCORTE_TIPTEC');
			 
delete from operacion.tipopedd where DESCRIPCION = 'Grupo Corte-Tipo de Tecnologia' and ABREV = 'GRUPOCORTE_TIPTEC';
commit;
/

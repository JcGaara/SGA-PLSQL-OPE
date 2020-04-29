insert into operacion.tipopedd (DESCRIPCION, ABREV)
values ('Grupo Corte-Tipo de Tecnologia', 'GRUPOCORTE_TIPTEC');
 
insert into operacion.opedd (codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
values ('FTTH', null, 'Grupo Corte por Tipo de Tecnologia FTTH', 'GRUCORTE_TIPTEC_FTTH',
   (select tipopedd from operacion.tipopedd where descripcion = 'Grupo Corte-Tipo de Tecnologia' and abrev = 'GRUPOCORTE_TIPTEC'),
   (select idgrupocorte from  collections.cxc_grupocorte where DESABR = 'FTTH BSCS' and DESCRIPCION = 'Servicios FTTH venta SISACT'));

commit; 
/

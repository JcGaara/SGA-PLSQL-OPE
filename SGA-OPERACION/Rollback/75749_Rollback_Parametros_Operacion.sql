delete from operacion.opedd where tipopedd=(select tipopedd from operacion.tipopedd where abrev='TIPEQU_LTE_TLF');
delete from operacion.tipopedd where abrev='TIPEQU_LTE_TLF';

delete from operacion.opedd where tipopedd=(select tipopedd from tipopedd where abrev='TIPTRABAJO') and codigon=(select tiptra
      from operacion.tiptrabajo
     where descripcion = 'INSTALACION 3 PLAY INALAMBRICO');

delete from operacion.opedd where tipopedd=197 and abreviacion='LTE';
delete from operacion.opedd where tipopedd=380 and abreviacion='LTE';
commit;
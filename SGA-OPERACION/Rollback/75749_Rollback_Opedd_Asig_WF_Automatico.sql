delete from operacion.opedd where tipopedd=260 and codigon=(select wfdef from opewf.wfdef where descripcion='INSTALACION 3 PLAY INALAMBRICO');
commit;
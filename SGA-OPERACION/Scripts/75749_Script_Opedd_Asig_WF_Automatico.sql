insert into operacion.opedd(codigon,descripcion,tipopedd) values ((select wfdef from opewf.wfdef where descripcion='INSTALACION 3 PLAY INALAMBRICO'),'INSTALACION 3 PLAY INALAMBRICO',260);
commit;
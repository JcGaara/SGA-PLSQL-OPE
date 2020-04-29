insert into operacion.tipopedd (tipopedd,descripcion,abrev) values ((select max(tipopedd)+1 from operacion.tipopedd),'Email Transf. bundles Prom','EMAIL_TRANS_BUNDLE_PROM');
insert into operacion.opedd (codigoc,codigon,descripcion,tipopedd) values ('ACTIVO',0,'MesadeControl@claro.com.pe',(select max(tipopedd) from operacion.tipopedd));
insert into operacion.opedd (codigoc,codigon,descripcion,tipopedd) values ('ACTIVO',1,'Luis.rojas@claro.com.pe',(select max(tipopedd) from operacion.tipopedd));
insert into operacion.opedd (codigoc,codigon,descripcion,tipopedd) values ('ACTIVO',2,'raul.marcelo@claro.com.pe',(select max(tipopedd) from operacion.tipopedd));
insert into operacion.opedd (codigoc,codigon,descripcion,tipopedd) values ('ACTIVO',3,'Jose.quezada@claro.com.pe',(select max(tipopedd) from operacion.tipopedd));

commit;

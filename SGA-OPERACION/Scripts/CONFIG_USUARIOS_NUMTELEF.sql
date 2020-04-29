insert into operacion.tipopedd(descripcion,abrev)
values('ACCESO NUMERO USUARIO','ACCESONUMU');

insert into operacion.tipopedd(descripcion,abrev)
values('ACCESO NUMERO ROL','ACCESONUMR');

insert into operacion.opedd (codigoc,codigon,descripcion,abreviacion,tipopedd,codigon_aux)
values('C17292',null,'ACCESO NUMERO USUARIO','ACCESONUMU',(select tipopedd from operacion.tipopedd where abrev = 'ACCESONUMU'),1);

insert into operacion.opedd (codigoc,codigon,descripcion,abreviacion,tipopedd,codigon_aux)
values('JRIVASY',null,'ACCESO NUMERO USUARIO','ACCESONUMU',(select tipopedd from operacion.tipopedd where abrev = 'ACCESONUMU'),1);

insert into operacion.opedd (codigoc,codigon,descripcion,abreviacion,tipopedd,codigon_aux)
values('OPE-OPERADOR ACTIVACIONES AMG',null,'ACCESO NUMERO ROL','ACCESONUMR',(select tipopedd from operacion.tipopedd where abrev = 'ACCESONUMR'),1);

commit;



declare

begin

insert into OPERACION.TIPOPEDD (DESCRIPCION, ABREV)
values ('Secuencial DTH Pre Pago', 'SECUENCIA_PREPAGO');
     
 commit;
end;
/

declare
ln_tipopedd number;

begin
select TIPOPEDD into ln_tipopedd from operacion.TIPOPEDD where abrev='SECUENCIA_PREPAGO';

insert into "OPEDD" (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('4', 1, 'Secuencial 1', 'SECUENCIA_PREPAGO', ln_tipopedd, null);
commit;
end;
/

declare

begin

insert into OPERACION.TIPOPEDD (DESCRIPCION, ABREV)
values ('Secuencial DTH Post Pago', 'SECUENCIA_POSTPAGO');
     
 commit;
end;
/


declare
ln_tipopedd number;

begin
select TIPOPEDD into ln_tipopedd from operacion.TIPOPEDD where abrev='SECUENCIA_POSTPAGO';

insert into "OPEDD" (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('5', 1, 'Secuencial 1', 'SECUENCIA_POSTPAGO', ln_tipopedd, null);
  commit;
end;
/

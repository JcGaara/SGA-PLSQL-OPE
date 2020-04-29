insert into operacion.tipopedd (tipopedd,descripcion,abrev) 
select nvl(max(t.tipopedd),0) + 1  ,'VALIDAR ESTADO DE SOT','ESTADO_SOT' from operacion.tipopedd t;
COMMIT;

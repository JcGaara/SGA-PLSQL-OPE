CREATE OR REPLACE FUNCTION OPERACION.F_GEN_SQL_UNA_CONDICION(a_columna varchar2, a_condicion varchar2,a_valor varchar2, a_tipo char)
RETURN varchar2 IS
lc_sql varchar2(4000);
lc_valor varchar2(500);
ln_like number(1);
ln_null number(1);
BEGIN
   if a_condicion like '%LIKE%' then
      ln_like := 1;
   end if;

  if a_condicion like '%NULL%' then
      ln_null := 1;
   end if;

   -- Si es null no hay necesidad de dar formato al valor
   if ln_null = 1 then
      lc_sql := a_columna || a_condicion;
      return lc_sql;
   end if;

   if a_tipo = 'C' then
      if ln_like = 1 then
	     lc_valor := '''%' || a_valor || '%''';
	  else
	     lc_valor := '''' || a_valor || '''';
	  end if;
   elsif a_tipo = 'D' then
   	  lc_valor := '''' || a_valor || '''';
   else
   	  lc_valor := a_valor;
   end if;

   lc_sql := a_columna || a_condicion || lc_valor;
   return lc_sql;

END;
/



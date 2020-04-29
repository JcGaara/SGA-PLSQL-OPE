CREATE OR REPLACE FUNCTION OPERACION.F_GEN_SQL_REPORTE (A_CODRPT IN NUMBER) RETURN VARCHAR2 IS
lc_sql reporte.consulta%type;
lc_columnas reporte.consulta%type;
lc_condicion reporte.consulta%type;
lc_una_condicion reporte.consulta%type;
lc_sql_orden reporte.consulta%type;
ln_distinct reporte.con_distinct%type;
lc_tabla reporte.tabla%type;
lc_columna colxreporte.columna%type;
lc_orden colxreporte.columna%type;
i number;
j number;
k number;
lc_coma varchar2(6);



cursor cur_col is
select COLUMNA, POSICION, ORDEN from colxreporte where codrpt = a_codrpt order by posicion asc;

cursor cur_cond is
select COLUMNA, CONDICION, VALOR, TIPO from condxreporte where codrpt = a_codrpt;

BEGIN
   i := 0;
   j := 0;
   k := 0;

   -- Se obtiene inf sobre el reporte
   select CON_DISTINCT, TABLA into ln_distinct, lc_tabla from reporte where codrpt = a_codrpt;

   if ln_distinct = 1 then
      lc_sql := 'SELECT DISTINCT ';
   else
      lc_sql := 'SELECT ';
   end if;

   -- Se obtiene las columnas y el orden
   lc_columnas := '';
   lc_sql_orden := '';
   for lcur_col in cur_col loop
       select decode(i,0,'',', ') into lc_coma from dual;
       lc_columnas := lc_columnas || lc_columna || lc_coma;
	   i := i + 1;
	   if lc_orden is not null then
          select decode(j,0,'',', ') into lc_coma from dual;
		  --lc_coma := ', ';
          lc_sql_orden := lc_sql_orden || lc_coma || lc_columna || ' ' || lc_orden  ;
		  j := j + 1;
	   end if;
   	   lc_columna := lcur_col.columna;
   	   lc_orden := lcur_col.orden;

   end loop;
   lc_columnas := lc_columnas || lc_columna;
   if lc_orden is not null then
      lc_sql_orden := lc_SQL_orden || lc_columna || ' ' || lc_orden;
   end if;

   -- Se da formato a las columnas
   lc_columnas := rtrim(ltrim(lc_columnas));
   select decode(lc_columnas,'',NULL,lc_columnas) into lc_columnas from dual;

   if lc_columnas is null then
   	  lc_condicion := ' * ';
   end if;

   -- Dando formato a la parte del ORDEN
   lc_sql_orden := rtrim(ltrim(lc_sql_orden));
   select decode(lc_sql_orden,'',NULL,lc_sql_orden) into lc_sql_orden from dual;
   if lc_sql_orden is not null then
   	  lc_sql_orden := ' ORDER BY ' || lc_sql_orden;
   end if;

   -- Calculando las condiciones
   lc_condicion := '';
   for lcur_cond in cur_cond loop
       select decode(k,0,'',' AND ') into lc_coma from dual;
   	   lc_condicion := lc_condicion || lc_una_condicion || lc_coma;
	   k := k + 1;
   	   lc_una_condicion := F_GEN_SQL_UNA_CONDICION(lcur_cond.columna, lcur_cond.condicion, lcur_cond.valor, lcur_cond.tipo);
   end loop;
   lc_condicion := lc_condicion || lc_una_condicion;

   lc_condicion := rtrim(ltrim(lc_condicion));
   select decode(lc_condicion,'',NULL,lc_condicion) into lc_condicion from dual;

   if lc_condicion is not null then
   	  lc_condicion := ' WHERE ' || lc_condicion;
   end if;

   lc_sql := lc_sql || lc_columnas || ' FROM ' || lc_tabla || lc_condicion || lc_sql_orden;

   return lc_sql;


END;
/



CREATE OR REPLACE FUNCTION OPERACION.f_requisiciones_multasuma (
num_codpre in   mulcon.codpre%type,
num_idubi  in   mulcon.idubi%type,
num_codeta in   mulcon.codeta%type,
tipo_cambio in float,
moneda        in integer
)
return number

is

   monto_multas  number;
   moneda_multas number;
   total_multas  number;

   cursor cursor_multas is
   select cosmul, moneda
   from mulcon
   where
   mulcon.codpre     = num_codpre
   and mulcon.idubi  = num_idubi
   and mulcon.codeta = num_codeta;


begin

   total_multas := 0.00;

       --Monto de Multas
       open cursor_multas;
       fetch cursor_multas into monto_multas, moneda_multas;

       loop
           if moneda = 1 and moneda_multas = 2 then
                 monto_multas := monto_multas*tipo_cambio;
           end if;

           if moneda = 2 and moneda_multas = 1 then
                 monto_multas := monto_multas/tipo_cambio;
           end if;

           if monto_multas is not null then
              total_multas := total_multas + monto_multas;
           end if;

           monto_multas := 0.0;

       fetch cursor_multas into monto_multas, moneda_multas;
       exit when  cursor_multas %NOTFOUND;
       end loop;

       close cursor_multas;

   if total_multas is null then
      total_multas := 0.0;
   end if;

   return round(total_multas,2);

end;
/



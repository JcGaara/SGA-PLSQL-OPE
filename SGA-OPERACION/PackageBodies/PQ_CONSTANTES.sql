CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_CONSTANTES AS

/*  Funciones que faltan implementar */
function f_get_frr return number is
tmpvar constante.valor%type;
begin
   select valor into tmpvar from constante where constante = 'FRR';
   return to_number(tmpvar);
exception
   when no_data_found then
      raise_application_error(-20500,'No se encontro el valor para FRR');
   when others then
      raise_application_error(-20500,'El valor de FRR no es numerico');
end;


/*  Funciones que faltan implementar */
function f_get_numcircuitos return number is
tmpvar constante.valor%type;
begin
   select valor into tmpvar from constante where constante = 'NUMCIRCUITOS';
   return to_number(tmpvar);
exception
   when no_data_found then
      raise_application_error(-20500,'No se encontro el valor para FRR');
   when others then
      raise_application_error(-20500,'El valor de FRR no es numerico');
end;

/*  Funciones que faltan implementar */
function f_get_numtelefonos return number is
tmpvar constante.valor%type;
begin
   select valor into tmpvar from constante where constante = 'NUMLINEAS';
   return to_number(tmpvar);
exception
   when no_data_found then
      raise_application_error(-20500,'No se encontro el valor para FRR');
   when others then
      raise_application_error(-20500,'El valor de FRR no es numerico');
end;

/*  Funciones que faltan implementar */
function f_get_cfg_wf return number is
tmpvar constante.valor%type;
begin
   select valor into tmpvar from constante where constante = 'CFG_WF';
   return to_number(tmpvar);
exception
   when no_data_found then
      raise_application_error(-20500,'No se encontro el valor para CFG_WF');
   when others then
      raise_application_error(-20500,'El valor de CFG_WF no es numerico');
end;

/*  Devuelve la configuracion del SGA
PER
BRA
 */
function f_get_cfg return char is
tmpvar constante.valor%type;
begin
   select valor into tmpvar from constante where constante = 'CFG';
   return tmpvar;
exception
   when no_data_found then
      raise_application_error(-20500,'No se encontro el valor para CFG');
   when others then
      raise_application_error(-20500,'El valor de CFG no es numerico');
end;

/*  Devuelve Si se ejecutara sutomaticamente la SOT al aprobarla
1 Si AUTO
0
 */
function f_get_cfg_solot_auto_exe return number is
tmpvar constante.valor%type;
begin
   select valor into tmpvar from constante where constante = 'SOLOT_AUTO_EXE';
   return to_number(tmpvar);
exception
   when no_data_found then
      raise_application_error(-20500,'No se encontro el valor para SOLOT_AUTO_EXE');
   when others then
      raise_application_error(-20500,'El valor de SOLOT_AUTO_EXE no es numerico');
end;

/*  Devuelve el codigo dde cliente ATT
Para clientes Internos
 */
function f_get_cliatt return char is
tmpvar constante.valor%type;
begin
   select valor into tmpvar from constante where constante = 'CLIATT';
   return tmpvar;
exception
   when no_data_found then
      raise_application_error(-20500,'No se encontro el valor para CLIATT');
   when others then
      raise_application_error(-20500,'El valor de CLIATT no es numerico');
end;

/*  Devuelve el codigo del Pais
51:Peru
1:Brasil ??
*/
function f_get_codpai return varchar2 is
tmpvar constante.valor%type;
begin
   select valor into tmpvar from constante where constante = 'CODPAI';
   return tmpvar;
exception
   when no_data_found then
      raise_application_error(-20500,'No se encontro el valor para CODPAI');
   when others then
      raise_application_error(-20500,'El valor de CODPAI no es numerico');
end;


function f_get_size_pwd return number is
tmpvar constante.valor%type;
begin
   select valor into tmpvar from constante where constante = 'SIZE_PWD';
   return to_number(tmpvar);
exception
   when no_data_found then
      return 6;
   when others then
      raise_application_error(-20500,'El valor de SIZE_PWD no es numerico');
end;


END;
/



CREATE OR REPLACE PROCEDURE OPERACION.P_ACT_POP(
an_tipo in number,
an_codelered in out number,
as_descripcion in char,
as_codpop in char,
an_codestpop in number) IS
tmpVar NUMBER;
BEGIN
if an_tipo = 1 then

   select nvl(max(codelered),0)+1 into tmpvar from elered;

   insert into elered(codelered,codtipelered,descripcion)
   values (tmpvar,1,as_descripcion);


   insert into pop(codpop,codelered,codestpop)
   values (as_codpop,tmpvar,1);

   an_codelered := tmpvar;
elsif an_tipo = 2 then
   update elered set descripcion = as_descripcion where codelered = an_codelered;

   update pop set codpop = as_codpop, codestpop = an_codestpop where codelered = an_codelered;
--   raise_application_error(-20500,'error'||to_char(an_codelered)||'*'||as_codpop||'*'||as_descripcion);
end if;

END;
/



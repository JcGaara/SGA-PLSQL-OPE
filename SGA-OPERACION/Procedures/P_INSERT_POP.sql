CREATE OR REPLACE PROCEDURE OPERACION.P_INSERT_POP(
an_codelered in out number, as_descripcion in char,
as_codpop in char) IS
tmpVar NUMBER;
BEGIN

select nvl(max(codelered),0)+1 into tmpvar from elered;

insert into elered(codelered,codtipelered,descripcion)
values (tmpvar,1,as_descripcion);


insert into pop(codpop,codelered,codestpop)
values (as_codpop,tmpvar,1);

an_codelered := tmpvar;

END P_INSERT_POP;
/



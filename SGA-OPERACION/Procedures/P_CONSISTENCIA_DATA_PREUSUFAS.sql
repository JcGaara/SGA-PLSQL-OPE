CREATE OR REPLACE PROCEDURE OPERACION.P_CONSISTENCIA_DATA_PREUSUFAS is
Filas number;
cursor CursorLlave IS
select distinct codusu, codfas, codeta
from preusufas;


BEGIN
  for row_equ in CursorLlave loop
    select count(*) into Filas from preusufas where codusu=row_equ.codusu and codfas=row_equ.codfas and codeta=row_equ.codeta;

	if Filas >1 then
	  delete from preusufas where codusu=row_equ.codusu and codfas=row_equ.codfas and codeta=row_equ.codeta;
	end if;

  end loop;
END;
/



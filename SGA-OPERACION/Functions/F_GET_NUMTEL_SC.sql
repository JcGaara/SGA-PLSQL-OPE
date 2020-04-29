create or replace function operacion.f_get_numtel_sc(ls_numero varchar2)
  return number is
  ln_count   number;
  ln_ciudad  number;
  ls_retorna numtel.numero%type;
begin
    --11/06/2012 inicio
 /* ln_count := Length(ls_numero);
  ln_ciudad := Substr(ls_numero, 1, 1);

  if ln_ciudad = 1 then
 ls_retorna := Substr(ls_numero, 2, ln_count - 1);
    ls_retorna := ls_numero ;
  
  else
    --16/04/2009 inicio - para provincias se incluye el codigo de localidad
    ls_retorna := ls_numero ;
    --ls_retorna := Substr(ls_numero, 3, ln_count - 2);
    --16/04/2009 fin
  end if;*/
      ls_retorna := ls_numero ;
      --11/06/2012 fin
  return ls_retorna;
end;

/

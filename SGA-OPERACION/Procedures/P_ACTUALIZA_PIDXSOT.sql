CREATE OR REPLACE PROCEDURE OPERACION.P_actualiza_pidxsot
as

CURSOR c_codsolot Is
select distinct s.codsolot from solot s, solotpto p 
where s.codsolot = p.codsolot 
and p.pid is null 
and s.estsol = 17
and codinssrv is not null ;

begin
  for reg in c_codsolot loop
      update solotpto s
      set s.pid = (select max(i.pid) from insprd i where i.codinssrv = s.codinssrv and i.codsrv = s.codsrvnue)
      where s.pid is null and s.codsolot = reg.codsolot;
  end loop;
  commit;
end;
/



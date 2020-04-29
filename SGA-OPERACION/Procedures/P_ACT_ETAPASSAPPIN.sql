CREATE OR REPLACE PROCEDURE OPERACION.P_ACT_ETAPASSAPPIN( an_codef ef.codef%type ) IS

begin

insert into efptoeta(codef,punto,codeta,fecini,fecfin,cosmo,cosmocli,cosmat,cosmatcli,cosmo_s,cosmat_s,pccodtarea)
select codef,punto,645,fecini,fecfin,cosmo,cosmocli,cosmat,cosmatcli,cosmo_s,cosmat_s,pccodtarea
from efptoeta where  codef= an_codef and codeta = 5;  

insert into efptoetamat(codef,punto,codeta,codmat,cantidad,costo,fecusu,codusu)
select codef,punto,645,codmat,cantidad,costo,fecusu,codusu
from efptoetamat where  codef= an_codef and codeta = 5;  

insert into efptoetaact(codef,punto,codeta,codact,costo,cantidad,observacion,fecusu,codusu,moneda,moneda_id,codprec)
select codef,punto,645,codact,costo,cantidad,observacion,fecusu,codusu,moneda,moneda_id,codprec
from efptoetaact where  codef= an_codef and codeta = 5;  

insert into efptoetafor(codef,punto,codeta,codfor,cantidad,fecusu,codusu)
select codef,punto,645,codfor,cantidad,fecusu,codusu
from efptoetafor where  codef= an_codef and codeta = 5; 

delete efptoetaact where codef= an_codef and codeta = 5;  
delete efptoetamat where codef= an_codef and codeta = 5;
delete efptoetafor where codef= an_codef and codeta = 5;
delete efptoeta where codef= an_codef and codeta = 5;


----------------------------------------------------------------------

insert into efptoeta(codef,punto,codeta,fecini,fecfin,cosmo,cosmocli,cosmat,cosmatcli,cosmo_s,cosmat_s,pccodtarea)
select codef,punto,644,fecini,fecfin,cosmo,cosmocli,cosmat,cosmatcli,cosmo_s,cosmat_s,pccodtarea
from efptoeta where  codef= an_codef and codeta = 22;  

insert into efptoetamat(codef,punto,codeta,codmat,cantidad,costo,fecusu,codusu)
select codef,punto,644,codmat,cantidad,costo,fecusu,codusu
from efptoetamat where  codef= an_codef and codeta = 22;  

insert into efptoetaact(codef,punto,codeta,codact,costo,cantidad,observacion,fecusu,codusu,moneda,moneda_id,codprec)
select codef,punto,644,codact,costo,cantidad,observacion,fecusu,codusu,moneda,moneda_id,codprec
from efptoetaact where  codef= an_codef and codeta = 22;  

insert into efptoetafor(codef,punto,codeta,codfor,cantidad,fecusu,codusu)
select codef,punto,644,codfor,cantidad,fecusu,codusu
from efptoetafor where  codef= an_codef and codeta = 22; 

delete efptoetaact where codef= an_codef and codeta = 22;  
delete efptoetamat where codef= an_codef and codeta = 22;
delete efptoetafor where codef= an_codef and codeta = 22;
delete efptoeta where codef= an_codef and codeta = 22;

----------------------------------------------------------------------

insert into efptoeta(codef,punto,codeta,fecini,fecfin,cosmo,cosmocli,cosmat,cosmatcli,cosmo_s,cosmat_s,pccodtarea)
select codef,punto,648,fecini,fecfin,cosmo,cosmocli,cosmat,cosmatcli,cosmo_s,cosmat_s,pccodtarea
from efptoeta where  codef= an_codef and codeta = 1;  

insert into efptoetamat(codef,punto,codeta,codmat,cantidad,costo,fecusu,codusu)
select codef,punto,648,codmat,cantidad,costo,fecusu,codusu
from efptoetamat where  codef= an_codef and codeta = 1;  

insert into efptoetaact(codef,punto,codeta,codact,costo,cantidad,observacion,fecusu,codusu,moneda,moneda_id,codprec)
select codef,punto,648,codact,costo,cantidad,observacion,fecusu,codusu,moneda,moneda_id,codprec
from efptoetaact where  codef= an_codef and codeta = 1;  

insert into efptoetafor(codef,punto,codeta,codfor,cantidad,fecusu,codusu)
select codef,punto,648,codfor,cantidad,fecusu,codusu
from efptoetafor where  codef= an_codef and codeta = 1; 

delete efptoetaact where codef= an_codef and codeta = 1;  
delete efptoetamat where codef= an_codef and codeta = 1;
delete efptoetafor where codef= an_codef and codeta = 1;
delete efptoeta where codef= an_codef and codeta = 1;




END;
/



declare
ln_tipatc number;

begin

select t.tipcrmdd 
into ln_tipatc 
from sales.tipcrmdd t
where t.abrev='EDITCANT_VTAMENOR';

DELETE FROM sales.crmdd WHERE TIPCRMDD=ln_tipatc;
  
select t.tipcrmdd 
into ln_tipatc 
from sales.tipcrmdd t
where t.abrev='SELSRVVTAMENOR';

DELETE FROM sales.crmdd WHERE TIPCRMDD=ln_tipatc;

DELETE FROM sales.tipcrmdd WHERE abrev='EDITCANT_VTAMENOR';

DELETE FROM sales.tipcrmdd WHERE abrev='SELSRVVTAMENOR';

COMMIT;

end;
/
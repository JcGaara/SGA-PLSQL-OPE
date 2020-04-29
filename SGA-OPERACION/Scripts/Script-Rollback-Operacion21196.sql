delete crmdd
where tipcrmdd = (Select tipcrmdd from tipcrmdd where abrev = 'OTROSPROYCRED');
commit;

delete tipcrmdd
where abrev = 'OTROSPROYCRED';
commit;


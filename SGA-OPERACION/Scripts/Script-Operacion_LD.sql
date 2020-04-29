--Tiptra
insert into tipopedd (abrev) values ('TiptraLD');

insert into opedd
  (codigon, abreviacion, tipopedd)
values
  (441, 'TIPTRASOT',
   (select tipopedd from tipopedd where abrev = 'TiptraLD'));

insert into opedd
  (codigon, abreviacion, tipopedd)
values
  (442, 'TIPTRASOT',
   (select tipopedd from tipopedd where abrev = 'TiptraLD'));

insert into opedd
  (codigon, abreviacion, tipopedd)
values
  (443, 'TIPTRASOT',
   (select tipopedd from tipopedd where abrev = 'TiptraLD'));

insert into opedd
  (codigon, abreviacion, tipopedd)
values
  (448, 'TIPTRASOT',
   (select tipopedd from tipopedd where abrev = 'TiptraLD'));

commit;

--Estados
insert into tipopedd (abrev) values ('EssotLD');

insert into opedd
  (codigon, abreviacion, tipopedd)
values
  (10,'ESTSOT',
   (select tipopedd from tipopedd where abrev = 'EssotLD'));

insert into opedd
  (codigon, abreviacion, tipopedd)
values
  (12,'ESTSOT',
   (select tipopedd from tipopedd where abrev = 'EssotLD'));

insert into opedd
  (codigon, abreviacion, tipopedd)
values
  (17,'ESTSOT',
   (select tipopedd from tipopedd where abrev = 'EssotLD'));

insert into opedd
  (codigon, abreviacion, tipopedd)
values
  (29,'ESTSOT',
   (select tipopedd from tipopedd where abrev = 'EssotLD'));

commit;














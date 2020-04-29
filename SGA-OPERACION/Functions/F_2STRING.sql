CREATE OR REPLACE FUNCTION OPERACION.F_2string (
a1 in number default null,
a2 in number default null,
a3 in number default null,
a4 in number default null,
a5 in number default null,
a6 in number default null,
a7 in number default null,
a8 in number default null,
a9 in number default null,
a10 in number default null,
a11 in number default null,
a12 in number default null,
a13 in number default null,
a14 in number default null,
a15 in number default null,
a16 in number default null,
a17 in number default null,
a18 in number default null,
a19 in number default null,
a20 in number default null
 ) RETURN varchar2 IS
tmpVar NUMBER;

BEGIN
   return
   a1||'  '||
   a2||'  '||
   a3||'  '||
   a4||'  '||
   a5||'  '||
   a6||'  '||
   a7||'  '||
   a8||'  '||
   a9||'  '||
   a10||'  '||
   a11||'  '||
   a12||'  '||
   a13||'  '||
   a14||'  '||
   a15||'  '||
   a16||'  '||
   a17||'  '||
   a18||'  '||
   a19||'  '||
   a20;
END;
/



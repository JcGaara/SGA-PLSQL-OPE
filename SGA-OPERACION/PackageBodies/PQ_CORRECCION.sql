CREATE OR REPLACE PACKAGE BODY OPERACION.pq_correccion is
  -- Author  : Willy Mestanza
  -- Created : 12/12/2005 15:00:03 PM
  -- Purpose : Procedimiento creado para actualizar los tipos de servicio que se encuentran nulos
  --           en las instancias de servicios de Operaciones
  PROCEDURE p_actualiza_tipo_serv_inssrv is
         vTipsrv inssrv.tipsrv%type;
         cursor cur_instanciasServicioOpe
         is
         select codinssrv,codsrv from inssrv where tipsrv is null and codsrv is not null;
  begin
       for cur in cur_instanciasServicioOpe loop
  		     select tipsrv into vTipsrv from tystabsrv where codsrv=cur.codsrv;
           update inssrv set tipsrv=vTipsrv where codinssrv=cur.codinssrv;
       end loop;
       exception
          when others then
               rollback;
               RAISE_APPLICATION_ERROR(-20500, 'ERROR:.' || sqlerrm);
       commit;
  end;
  -- Author  : Willy Mestanza
  -- Created : 16/12/2005 15:00:03 PM
  -- Purpose : Procedimiento creado para registrar en la tabla CORRECCION_LOG las actualizaciones en la correccion de informacion
  PROCEDURE p_registra_log_correccion(a_codinssrv inssrv.codinssrv%type,
                                      a_pid insprd.pid%type,
                                      a_codsrv inssrv.codsrv%type,
                                      a_tipsrv inssrv.tipsrv%type,
                                      a_codsuc inssrv.codsuc%type,
                                      a_codubi inssrv.codubi%type,
                                      a_codusu inssrv.codusu%type) is
  begin
       insert into OPERACION.CORRECCION_LOG (CODINSSRV,PID,CODSRV,TIPSRV,CODSUC,CODUBI,FECUSU,CODUSU)
       values(a_codinssrv,a_pid,a_codsrv,a_tipsrv,a_codsuc,a_codubi,sysdate,a_codusu);
       commit;
       exception
          when others then
               rollback;
               RAISE_APPLICATION_ERROR(-20500, 'ERROR:.' || sqlerrm);
       commit;
  end;
  -- Author  : Willy Mestanza
  -- Created : 06/01/2006 15:00:03 PM
  -- Purpose : Procedimiento creado para actualizar las fecha de inicio para las cancelaciones de los servicios

  PROCEDURE p_actualiza_instservicio_can is
         vFecini insprd.fecini%type;
         cursor cur_instanciaServicioBill
         is
         select distinct ISR.IDINSTSERV,ISR.fecini,obserr from trssolot TR,instxproducto IPP,instanciaservicio ISR
         where TR.Pid=IPP.Pid and IPP.Idcod=ISR.IDINSTSERV and
         codsolot in
         (60925,60950,64547,65108,67311,68132,68133,68228,68778,68965,68967,68970,68972,69814,69885,70332,70335,70541,71312,71661,72314,72384,73739,77267,77270,77272,77500,77678,77980,78000,78863,79367,80031,81856,81857,84041,88367,88368,88989,89439,89440,90048,90997,91481,91555,92306,92603,93053,93618,93815,93816)
         and obserr like '%La fecha de cancelamiento debe ser mayor que fecha inicio. IdInstS%' ;
  begin
       for cur in cur_instanciaServicioBill loop
           select distinct fecini into vFecini from insprd where pid in (select distinct pid from instxproducto where idcod=cur.IDINSTSERV);
           update instanciaservicio set fecini=vFecini where idinstserv=cur.IDINSTSERV;
       end loop;
       exception
          when others then
               rollback;
               RAISE_APPLICATION_ERROR(-20500, 'ERROR:.' || sqlerrm);
       commit;
  end;
  -- Author  : Willy Mestanza
  -- Created : 20/01/2006 03:37:38 p.m.
  -- Purpose : Procedimiento creado para Regularizar las fechas fin de las instancias de productos en billing

  PROCEDURE p_actualiza_instxprod_activo is
            cursor cur_instanciaProdBill is
            select ISR.Codcli,ISR.Cid,ISR.Numero,IP.PID,TT.Dsctipsrv,decode(IP.ESTINSPRD,3,'CANCELADO') ESTADO,IP.CODINSSRV,IPR.Nomabr,IP.FECINI,IP.FECFIN,IP.Codusumod,IPR.idinstprod,DECODE(IPR.estado,1,'ACTIVO')
            from insprd IP,instxproducto IPR , inssrv ISR, tystipsrv TT, cr CR
            where IPR.PID=IP.Pid and ISR.CODINSSRV=IP.Codinssrv and TT.Tipsrv(+)=ISR.Tipsrv and CR.Idinstprod(+)=IPR.Idinstprod and IP.estinsprd=3 and IPR.Fecini is not null and IPR.Fecfin is null and IPR.estado=1
            and IPR.Idinstprod in (113549,113560,113562,113564,113566,113568,113570,113572,113574,113576,113578,113580,113582,113584,113586,113588,113590,
            113592,113594,113596,113598,113600,113602,113604,170634,174004,178587,180142,197521,670863,670864,682141,682142,670866,670865,200609,200615,
            418229,203728,203748,203746,203744,387875,387877,388296,382440,391118,391120,410076,410078,414541,418458,415387,419705,419706,419966,420043,
            420394,463936,423216,426748,427386,429361,433379,433380,448633,448634,446192,446193,446194,446196,446195,446197,446198,446200,446199,446201,
            446203,446202,446204,446205,446206,446207,446208,446209,446210,446211,446212,446214,446215,446213,446218,446216,446217,446219,446220,446221,
            446224,446222,446223,446225,446226,446227,446228,446229,446230,446231,446232,446233,446234,446235,446236,446237,446238,446239,446240,446241,
            446242,446243,446244,446245,446248,446246,446247,446249,446250,446251,446254,446253,446252,446257,446256,446255,446258,446259,446260,446261,
            446262,446263,446264,446265,446266,446267,446268,446269,446270,446271,446272,446273,446274,446275,446278,446277,446276,446281,446280,446279,
            447794,447797,447800,447803,447806,447809,447812,447815,447818,447821,447824,447827,447830,447833,447836,447839,447842,447845,447848,447851,
            447854,447857,447860,447863,447866,447869,447872,447875,447878,454656,454658,454669,454671,492958,468687,468786,468814,469990,471082,476413,
            471086,476414,476415,476417,476416,476419,476420,476418,476423,476422,476421,476426,476425,476424,476429,476428,476427,476432,476431,476430,
            476435,476434,476433,476436,476437,476438,476441,476440,476439,476444,476443,476442,476447,476446,476445,476450,476449,476448,476453,476452,
            476451,476456,476455,476454,476459,476458,476457,476462,476461,476460,476465,476464,476463,476468,476467,476466,476469,476470,476471,476472,
            476473,476474,476477,476476,476475,476480,476479,476478,476483,476482,476481,476486,476485,476484,476489,476488,476487,476492,476491,476490,
            476493,476495,476494,476496,476497,476498,476501,476499,476500,476504,476503,476502,472389,479091,472789,632176,632174,478532,484932,482173,
            484290,484409,484833,484834,486413,486809,487429,487430,489486,492282,497236,497238,500855,667915,502936,504040,505804,528115,528116,528117,
            528118,528119,528120,528121,528122,528123,528124,528125,528126,528127,528128,528129,528130,528131,528132,528133,528134,528135,528136,528137,
            528138,528139,528140,528141,528142,528143,528144,528145,528146,528147,528148,528149,528150,528151,528152,528153,528154,528155,528156,528157,
            528158,528159,528160,528161,528162,528163,528164,528165,528166,528167,528168,528169,528170,528171,528172,528173,528174,528175,528176,528177,
            528178,528179,528180,528181,528182,528183,528184,528185,528186,528187,528188,528189,528190,528191,528192,528193,528194,528195,528196,528197,
            528198,528199,528200,528201,528202,528203,528204,528205,528206,528207,528208,528209,528210,528211,528212,528213,528214,528215,528216,528217,
            528218,528219,528220,528221,528222,528223,528224,528225,528226,528227,528228,528229,528230,528231,528232,528233,528234,528235,528236,528237,
            528238,528239,528240,528241,528242,528243,528244,528245,528246,528247,528248,528249,528250,528251,528252,528253,528254,528255,528256,528257,
            528258,528259,528260,528261,528262,528263,528264,528265,528266,528267,528268,528269,528270,528271,528272,528273,528274,528275,528276,528277,
            528278,528279,528280,528281,528282,528283,528284,528285,528286,528287,528288,528289,528290,528291,528292,528293,528294,528295,528296,528297,
            528298,528299,528300,528301,528302,528303,528304,528305,528306,528307,528308,528309,528310,528311,528312,528313,528314,528315,528316,528317,
            528318,528319,528320,528321,528322,528323,528324,528325,528326,528327,528328,528329,528330,528331,528332,528333,528334,528335,528336,528337,
            528338,528339,528340,528341,528342,528343,528344,528345,528346,528347,528348,528349,528350,528351,528352,528353,528354,528355,528356,528357,
            528358,528359,528360,528361,528362,528363,528364,528365,528366,528367,528368,528369,528370,528371,528372,528373,528374,528375,528376,528377,
            528378,528379,528380,528381,528382,528383,528384,528385,528386,528387,528388,528389,528390,528391,528392,528393,528394,528395,528396,528397,
            528398,528399,528400,528401,528402,528403,528404,528405,528406,528407,528408,528409,528410,528411,528412,528413,528414,528415,528416,528417,
            528418,528419,528420,528421,528422,528423,528424,528425,528426,528427,528428,528429,528430,528431,528432,528433,528434,528435,528436,528437)
            union all
            select ISR.Codcli,ISR.Cid,ISR.Numero,IP.PID,TT.Dsctipsrv,decode(IP.ESTINSPRD,3,'CANCELADO') ESTADO,IP.CODINSSRV,IPR.Nomabr,IP.FECINI,IP.FECFIN,IP.Codusumod,IPR.idinstprod,DECODE(IPR.estado,1,'ACTIVO')
            from insprd IP,instxproducto IPR , inssrv ISR, tystipsrv TT, cr CR
            where IPR.PID=IP.Pid and ISR.CODINSSRV=IP.Codinssrv and TT.Tipsrv(+)=ISR.Tipsrv and CR.Idinstprod(+)=IPR.Idinstprod and IP.estinsprd=3 and IPR.Fecini is not null and IPR.Fecfin is null and IPR.estado=1
            and IPR.Idinstprod in (528438,528439,528440,528441,528442,528443,528444,528445,528446,528447,528448,528449,528450,528451,528452,528453,528454,528455,528456,528457,
            528458,528459,528460,528461,528462,528463,528464,528465,528466,528467,528468,528469,528470,528471,528472,528473,528474,528475,528476,528477,
            528478,528479,528480,528481,528482,528483,528484,528485,528486,528487,528488,528489,528490,528491,528492,528493,528494,528495,528496,528497,
            528498,528499,528500,528501,528502,528503,528504,528505,528506,528507,528508,528509,528510,528511,528512,528513,528514,528515,528516,528517,
            528518,528519,528520,528521,528522,528523,528524,528525,528526,528527,528528,528529,528530,528531,528532,528533,528534,528535,528536,528537,
            528538,528539,528540,528541,528542,528543,528544,528545,528546,528547,528548,528549,528550,528551,528552,528553,528554,528555,528556,528557,
            528558,528559,528560,528561,528562,528563,528564,528565,528566,528567,528568,528569,528570,528571,528572,528573,528574,528575,528576,528577,
            528578,528579,528580,528581,528582,528583,528584,528585,528586,528587,528588,528589,528590,528591,528592,528593,528594,528595,528596,528597,
            528598,528599,528600,528601,528602,528603,528604,528605,528606,528607,528608,528609,528610,528611,528612,528613,528614,528615,528616,528617,
            528618,528619,528620,528621,528622,528623,528624,528625,528626,528627,528628,528629,528630,528631,528632,528633,528634,528635,528636,528637,
            528638,528639,528640,528641,528642,528643,528644,528645,528646,528647,528648,528649,528650,528651,528652,528653,528654,528655,528656,528657,
            528658,528659,528660,528661,528662,528663,528664,528665,528666,528667,528668,528669,528670,528671,528672,528673,528674,528675,528676,528677,
            528678,528679,528680,528681,528682,528683,528684,528685,528686,528687,528688,528689,528690,528691,528692,528693,528694,528695,528696,528697,
            528698,528699,528700,528701,528702,528703,528704,528705,528706,528707,528708,528709,528710,528711,528712,528713,528714,528715,528716,528717,
            528718,528719,528720,528721,528722,528723,528724,528725,528726,528727,528728,528729,528730,528731,528732,528733,528734,528735,528736,528737,
            528738,528739,528740,528741,528742,528743,528744,528745,528746,528747,528748,528749,528750,528751,528752,528753,528754,528755,528756,528757,
            528758,528759,528760,528761,528762,528763,528764,528765,528766,528767,528768,528769,528770,528771,528772,528773,528774,528775,528776,528777,
            528778,528779,528780,528781,528782,528783,528784,528785,528786,528787,528788,528789,528790,528791,528792,528793,528794,528795,528796,528797,
            528798,528799,528800,528801,528802,528803,528804,528805,528806,528807,528808,528809,528810,528811,528812,528813,528814,528815,528816,528817,
            528818,528819,528820,528821,528822,528823,528824,528825,528826,528827,528828,528829,528830,528831,528832,528833,528834,528835,528836,528837,
            528838,528839,528840,528841,528842,528843,528844,528845,528846,528847,528848,528849,528850,528851,528852,528853,528854,528855,528856,528857,
            528858,528859,528860,528861,528862,528863,528864,528865,528866,528867,528868,528869,528870,528871,528872,528873,528874,528875,528876,528877,
            528878,528879,528880,528881,528882,528883,528884,528885,528886,528887,528888,528889,528890,528891,528892,528893,528894,528895,528896,528897,
            528898,528899,528900,528901,528902,528903,528904,528905,528906,528907,528908,528909,528910,528911,528912,528913,528914,528915,528916,546720,
            530357,547271,561410,561409,561408,561413,561412,561411,561416,561415,561414,561419,561418,561417,561422,561421,561420,561424,561423,561425,
            561426,561427,561428,561430,561431,561429,561434,561432,561433,561435,561437,561436,561438,561439,561440,561441,561442,561443,561445,561444,
            561446,561448,561449,561447,561450,561452,561451,561455,561454,561453,561456,561457,561458,561459,561460,561461,561464,561463,561462,561467,
            561466,561465,561470,561469,561468,561473,561472,561471,561476,561475,561474,561479,561478,561477,561482,561481,561480,561483,561485,561484,
            561488,561487,561486,561491,561490,561489,561494,561493,561492,569538,569537,571971,571970,596913,594416,613349,613345,613347,613346,613348,
            679834,679833,679832,629667,629666,629668,663745,663743,663744,658378,674992,674993,687041,687042,687043,687047,687046,687045,687050,687049,
            687048,687053,687052,687051,687056,687055,687054,687059,687058,687057,687062,687061,687060,687065,687064,687063,687068,687067,687066,687071,
            687070,687069,687074,687073,687072,687077,687076,687075,687080,687079,687078,687083,687082,687081,687086,687085,687084,687089,687088,687087,
            687092,687091,687090,687095,687094,687093,687098,687097,687096,687101,687099,687100,687104,687103,687102,687107,687106,687105,687110,687109,
            687108,687113,687112,687111,687116,687115,687114,687119,687118,687117,687122,687121,687120,687125,687124,687123,687128,687127,687126,687131,
            687130,687129,687134,687133,687132,687137,687136,687135,687140,687139,687138,687143,687142,687141,687146,687145,687144,687149,687148,687147,
            687152,687151,687150,687155,687154,687153,687158,687157,687156,687161,687160,687159,687164,687163,687162,687167,687166,687165,687170,687169,
            687168,687365,687364,687363,687368,687367,687366,687173,687172,687171,687176,687175,687174,687179,687178,687177,687182,687181,687180,687185,
            687184,687183,687188,687187,687186,687191,687190,687189,687194,687193,687192,687197,687196,687195,687199,687198,687200,687203,687202,687201,
            687206,687205,687204,687209,687208,687207,687210,687211,687212,687213,687214,687215,687216,687217,687218,687219,687220,687221,687223,687222,
            687224,687225,687226,687227,687228,687229,687230,687231,687232,687233,687234,687235,687236,687237,687238,687239,687240,687241,687242,687243,
            687244,687245,687248,687247,687246,687251,687250,687249,687254,687253,687252,687255,687256,687257,687258,687259,687260,687261,687262,687263,
            687264,687265,687266,687267,687268,687269,687270,687271,687272,687273,687274,687275,687276,687277,687278,687279,687280,687281,687282,687283,
            687284,687285,687286,687287,687290,687289,687288,687293,687292,687291,687294,687295,687296,687299,687298,687297,687302,687301,687300,687303,
            687304,687305,687308,687307,687306,687311,687310,687309,687314,687313,687312,687315,687316,687317,687318,687319,687320,687323,687322,687321,
            687371,687370,687369,687372,687373,687374,687326,687325,687324,687327,687328,687329,687330,687331,687332,687333,687334,687335,687336,687337,
            687338,687341,687340,687339,687344,687343,687342,687345,687346,687347,687350,687349,687348,687353,687352,687351,687356,687355,687354,687357,
            687358,687359,687360,687361,687362);

  begin
       for cur in cur_instanciaProdBill loop
            if cur.fecfin is not null then
               update instxproducto set fecfin=cur.fecfin where idinstprod=cur.idinstprod;
            end if;
       end loop;
       exception
          when others then
               rollback;
               RAISE_APPLICATION_ERROR(-20500, 'ERROR:.' || sqlerrm);
       commit;
  end;

END pq_correccion;
/


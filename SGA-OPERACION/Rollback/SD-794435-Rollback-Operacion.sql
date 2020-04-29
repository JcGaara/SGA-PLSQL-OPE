delete opedd where tipopedd = (Select tipopedd from tipopedd where abrev = 'USR_EBONDING');

commit;

delete tipopedd where abrev = 'USR_EBONDING';

commit;

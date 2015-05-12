function [iport,tnext] = radix_2_div_tb(oport,~,~)
% radix_2_div_tb_modelsim  a matlabtb M-function executed by hdldaemon on request from the HDL simulator.
%   
%     matlabt(OPORT,TNOW,PORTINFO)
%     matlabt(OPORT,TNOW)
%     Where
%       OPORT      - Structure containing current output HDL signal values
%       TNOW       - Current simulation time (in seconds) 
%       PORTINFO   - Structure of port information (first invocation)
%       IPORT      - Structure containing current input HDL signal values
%       TNEXT      - time to schedule next callback 
%
%   Copyright 2006-2009 The MathWorks, Inc.
%   $Revision: 1.0.0 $  $Date: 2013/08/02 16:42:41 $
persistent hdldividend;
persistent hdldivisor;
persistent hdlquotient;
persistent hdlexp
global     ticks;

if(ticks == 0)
	hdldividend = [];
	hdlquotient	= [];
	hdldivisor	= [];
	hdlexp		= [];
end

ticks = ticks + 1;
iport = struct();
tnext = [];

dend = randi(255);
sor  = randi(255);

iport.dividend = dec2bin(dend,8);
iport.divisor  = dec2bin(sor,8);

hdldividend = [hdldividend dend];
hdldivisor  = [hdldivisor sor];
hdlquotient = [hdlquotient mvl2dec(oport.quotient,false)];
hdlexp		= [hdlexp mvl2dec(oport.quoexp,false)];

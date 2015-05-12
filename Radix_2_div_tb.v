/*******************************************************

--Module Name:Radix_2_div_tb
--Project Name:
--Chinese Description:
	»ù2³ý·¨ tb
--English Description:
	unsigned Radix-2 SRT division
--Version:VERA.1.0.0
--Data modified:
--author:Young ÎâÃ÷
--E-mail: wmy367@Gmail.com
--Data created:2013-7-26 15:31:21
________________________________________________________
********************************************************/
`timescale 1ns/1ps
module Radix_2_div_tb;
reg signed[7:0]	TMP = 129;
reg signed[7:0]	tmp_data;

initial begin
	tmp_data	= TMP <<< 1;
end

localparam PSIZE = 8;
localparam DSIZE = 8;

reg	clock	= 0;
reg	rst		= 0;
always #10 clock	= ~clock;
initial	begin
	repeat(10)	@(posedge clock);
	rst	= 1;
	repeat(5) 	@(posedge clock);
	rst = 0;
end

reg	[DSIZE-1:0]		divisor;
reg [DSIZE-1:0]		dividend;
wire[PSIZE-1:0]		quotient;
wire[DSIZE-1:0]		exp;
real			KK;
real			QQ;

always@(posedge clock)begin
	divisor		= $random/256;
	dividend	= $random/256;
	repeat(2)	@(posedge clock);
end

Radix_2_div #(
	.DSIZE		(DSIZE),
	.PSIZE		(PSIZE)
)Radix_2_div_inst(
	.clock		(clock),
	.rst		(rst),
	.divisor	(divisor),
	.dividend	(dividend),
	
	.quotient	(quotient),
	.quoexp		(exp)
);
always@(*)begin
	KK = quotient*(2**(exp));
	QQ = KK/(2**(PSIZE-1));
end 

reg	[DSIZE-1:0]		divisorQ	[PSIZE+1:0];
reg [DSIZE-1:0]		dividendQ	[PSIZE+1:0];
always@(posedge clock,posedge rst)begin:GEN_LACT
integer II;
	 dividendQ[0]	<= dividend;
	 divisorQ[0]	<= divisor;
	for(II=0;II<PSIZE+1;II=II+1)begin
		divisorQ[II+1]	<= divisorQ[II];
		dividendQ[II+1]<= dividendQ[II];
	end
end

real   MM;
real   MD;
real   MR;
always@(*)begin
	MD	= dividendQ[PSIZE+1];
	MR	= divisorQ[PSIZE+1];
	MM  = MD/MR;
end
	
endmodule

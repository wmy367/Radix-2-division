/*******************************************************

--Module Name:Radix_2_div_int
--Project Name:
--Chinese Description:
	基2除法非浮点输出
--English Description:
	radix-2 division ，and output is not float 
--Version:VERA.1.0.0
--Data modified:
--author:Young 吴明
--E-mail: wmy367@gmail.com
--Data created:2013-8-1 15:00:08
________________________________________________________
********************************************************/
`timescale 1ns/1ps
module Radix_2_div_int #(
parameter	DSIZE	= 8,
parameter	PSIZE	= 8
)(
	input					clock,
	input					rst,
	input [DSIZE-1:0]		divisor,
	input [DSIZE-1:0]		dividend,
	
	output[DSIZE+PSIZE-1:0]	quotient
);


wire[PSIZE-1:0]				Rquo;
wire[3:0]					quoexp;

Radix_2_div #(
	.DSIZE		(DSIZE),
	.PSIZE		(PSIZE)				//latency psize+2 cycles
)Radix_2_div_inst(
	.clock				(clock),
	.rst				(rst),
	.divisor			(divisor),
	.dividend			(dividend),
	
	.quotient			(Rquo),
	.quoexp				(quoexp)		//0.000_0000
);

reg [DSIZE+PSIZE-1:0]	QUO,Qq;

always@(*)	float2int(	quoexp,	Rquo,	QUO);

always@(posedge clock,posedge rst)begin
	if(rst)		Qq		<= {(DSIZE+PSIZE){1'b0}};
	else 		Qq		<= QUO;
end

assign	quotient	= Qq;

task float2int;
input [3:0]				num;
input [PSIZE-1:0]		idata;
output[PSIZE+DSIZE-1:0]	odata;
begin
	casex(num)
	/**********************正数**********************/
	4'd0:					odata	= idata;		//前9位为整数
	4'd1:	if(DSIZE>=1)	odata	= idata<<1; 	else odata	= {(DSIZE+PSIZE){1'b1}};
	4'd2:	if(DSIZE>=2)	odata	= idata<<2; 	else odata	= {(DSIZE+PSIZE){1'b1}};
	4'd3:	if(DSIZE>=3)	odata	= idata<<3; 	else odata	= {(DSIZE+PSIZE){1'b1}};
	4'd4:	if(DSIZE>=4)	odata	= idata<<4; 	else odata	= {(DSIZE+PSIZE){1'b1}};
	4'd5:	if(DSIZE>=5)	odata	= idata<<5; 	else odata	= {(DSIZE+PSIZE){1'b1}};
	4'd6:	if(DSIZE>=6)	odata	= idata<<6; 	else odata	= {(DSIZE+PSIZE){1'b1}};
	4'd7:	if(DSIZE>=7)	odata	= idata<<7; 	else odata	= {(DSIZE+PSIZE){1'b1}};
	4'd8:	if(DSIZE>=8)	odata	= idata<<8; 	else odata	= {(DSIZE+PSIZE){1'b1}};
	4'd9:	if(DSIZE>=9)	odata	= idata<<9;		else odata	= {(DSIZE+PSIZE){1'b1}};
	4'd10:	if(DSIZE>=10)	odata	= idata<<10;	else odata	= {(DSIZE+PSIZE){1'b1}};
	4'd11:	if(DSIZE>=11)	odata	= idata<<11;	else odata	= {(DSIZE+PSIZE){1'b1}};
	4'd12:	if(DSIZE>=12)	odata	= idata<<12;	else odata	= {(DSIZE+PSIZE){1'b1}};
	4'd13:	if(DSIZE>=13)	odata	= idata<<13;	else odata	= {(DSIZE+PSIZE){1'b1}};
	4'd14:	if(DSIZE>=14)	odata	= idata<<14;	else odata	= {(DSIZE+PSIZE){1'b1}};	
	4'd15:	if(DSIZE>=15)	odata	= idata<<15;	else odata	= {(DSIZE+PSIZE){1'b1}};
	default:															odata	= {(DSIZE+PSIZE){1'b1}};
	endcase
end
endtask

endmodule

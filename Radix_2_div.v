/*******************************************************

--Module Name:Radix_2_div
--Project Name:
--Chinese Description:
	»ù2³ý·¨
--English Description:
	unsigned Radix-2 SRT division
--Version:VERA.1.0.0
--Data modified:
--author:Young ÎâÃ÷
--E-mail: wmy367@gmail.com
--Data created:2013-7-26 10:10:33
________________________________________________________
********************************************************/
`timescale 1ns/1ps
module Radix_2_div #(
parameter[3:0]	DSIZE	= 8,
parameter[3:0]	PSIZE	= 8
)(
	input				clock,
	input				rst,
	input [DSIZE-1:0]	divisor,
	input [DSIZE-1:0]	dividend,
	
	output[PSIZE-1:0]	quotient,
	output[3:0]			quoexp
);


reg	[DSIZE:0]		divisor_r2	[PSIZE:0];
reg	[DSIZE:0]		dividend_r2	[PSIZE:0];
reg	[3:0]			divisor_exp	[PSIZE:0];
reg [PSIZE-1:0]		LQ			[PSIZE-1:0];
reg [PSIZE-1:0]		UQ			[PSIZE-1:0];

always@(posedge clock,posedge rst)begin
	if(rst)begin
		divisor_exp[PSIZE]	<= {4{1'b0}};
		divisor_r2[PSIZE] 	<= 1'b1<<(DSIZE-1);
	end else begin
		casex(divisor)
		'b0:begin			divisor_exp[PSIZE]	<= {4{1'b1}};divisor_r2[PSIZE] <= 1'b1<<(DSIZE-1); end 
		/*------------------------------------------------------------------*/
		'b1:begin			divisor_exp[PSIZE]	<= DSIZE-4'd1;	divisor_r2[PSIZE]	<= divisor << (DSIZE-1); end
		'b1x:begin			divisor_exp[PSIZE]	<= DSIZE-4'd2;	divisor_r2[PSIZE]	<= divisor << (DSIZE-2); end
		'b1xx:begin			divisor_exp[PSIZE]	<= DSIZE-4'd3;	divisor_r2[PSIZE]	<= divisor << (DSIZE-3); end
		'b1xxx:begin		divisor_exp[PSIZE]	<= DSIZE-4'd4;	divisor_r2[PSIZE]	<= divisor << (DSIZE-4); end
		'b1xxxx:begin		divisor_exp[PSIZE]	<= DSIZE-4'd5;	divisor_r2[PSIZE]	<= divisor << (DSIZE-5); end
		'b1xxxxx:begin		divisor_exp[PSIZE]	<= DSIZE-4'd6;	divisor_r2[PSIZE]	<= divisor << (DSIZE-6); end
		'b1xxxxxx:begin		divisor_exp[PSIZE]	<= DSIZE-4'd7;	divisor_r2[PSIZE]	<= divisor << (DSIZE-7); end
		'b1xxxxxxx:begin	divisor_exp[PSIZE]	<= DSIZE-4'd8;	divisor_r2[PSIZE]	<= divisor << (DSIZE-8); end
		/*------------------------------------------------------------------*/
		'b1_xxxxxxxx:begin			divisor_exp[PSIZE]	<= DSIZE-4'd9;		divisor_r2[PSIZE]	<= divisor << (DSIZE-9); end
		'b1x_xxxxxxxx:begin			divisor_exp[PSIZE]	<= DSIZE-4'd10;	divisor_r2[PSIZE]	<= divisor << (DSIZE-10); end
		'b1xx_xxxxxxxx:begin		divisor_exp[PSIZE]	<= DSIZE-4'd11;	divisor_r2[PSIZE]	<= divisor << (DSIZE-11); end
		'b1xxx_xxxxxxxx:begin		divisor_exp[PSIZE]	<= DSIZE-4'd12;	divisor_r2[PSIZE]	<= divisor << (DSIZE-12); end
		'b1xxxx_xxxxxxxx:begin		divisor_exp[PSIZE]	<= DSIZE-4'd13;	divisor_r2[PSIZE]	<= divisor << (DSIZE-13); end
		'b1xxxxx_xxxxxxxx:begin		divisor_exp[PSIZE]	<= DSIZE-4'd14;	divisor_r2[PSIZE]	<= divisor << (DSIZE-14); end
		'b1xxxxxx_xxxxxxxx:begin	divisor_exp[PSIZE]	<= DSIZE-4'd15;	divisor_r2[PSIZE]	<= divisor << (DSIZE-15); end
		'b1xxxxxxx_xxxxxxxx:begin	divisor_exp[PSIZE]	<= DSIZE-5'd16;	divisor_r2[PSIZE]	<= divisor << (DSIZE-16); end
		default:;
		endcase
end end

always@(posedge clock,posedge rst)begin
	if(rst)	dividend_r2[PSIZE]	<= {(DSIZE+1){1'b0}};
	else 	dividend_r2[PSIZE]	<= {1'b0,dividend};
end

genvar II;
generate 
for(II=1;II<=PSIZE;II=II+1)begin:GEN_TRANS
	always@(posedge clock,posedge rst)begin
		if(rst)	begin
			LQ[II-1][II-1]	<= 1'b0;
			UQ[II-1][II-1]	<= 1'b0;
		end else begin
			SRT_trans(dividend_r2[II],divisor_r2[II],
					{LQ[II-1][II-1],UQ[II-1][II-1]},dividend_r2[II-1]);
//			$stop;
	end end 
	
	always@(posedge clock,posedge rst)begin
		if(rst)		divisor_exp[II-1]	<= {4{1'b0}};
		else		divisor_exp[II-1]	<= divisor_exp[II];
	end
	
	always@(posedge clock,posedge rst)begin
		if(rst)		divisor_r2[II-1]	<= {(DSIZE+1){1'b0}};
		else		divisor_r2[II-1]	<= divisor_r2[II];
	end
end
endgenerate

generate 
for(II=PSIZE;II>0;II=II-1)begin:GEN_SHIFT_LUQ
	always@(posedge clock,posedge rst)begin:GEN_SHIFT_Q
	integer	KK;
		if(rst)begin
			for(KK=PSIZE;KK>1;KK=KK-1)begin
				if((KK-2) != (II-1))begin
					LQ[KK-2][II-1]	<= 1'b0;
					UQ[KK-2][II-1]	<= 1'b0;
				end
			end
		end else begin
			for(KK=II;KK>1;KK=KK-1)begin
				LQ[KK-2][II-1]	<= LQ[KK-1][II-1];
				UQ[KK-2][II-1]	<= UQ[KK-1][II-1];
			end
	end	end
end
endgenerate

initial begin
	LQ[PSIZE-1][PSIZE-2:0]	= 0;
	UQ[PSIZE-1][PSIZE-2:0]	= 0;
end	

reg [PSIZE-1:0]	Qu;
always@(posedge clock,posedge rst)begin
	if(rst)		Qu	<= {PSIZE{1'b0}};
	else		Qu	<=  UQ[0][PSIZE-1:0]- {LQ[0][PSIZE-1:0]<<1};
end

reg	[3:0]	exp;
always@(posedge clock,posedge rst)begin
	if(rst)		exp	<= {4{1'b0}};
	else		exp	<= divisor_exp[0];
end
assign	quoexp		= exp;
assign	quotient	= Qu;
		
task SRT_trans;
input [DSIZE:0]		Z;
input [DSIZE:0]		D;
output[1:0]			Q;
output[DSIZE:0]		S;
begin
	if(Z[DSIZE:DSIZE-1] == 2'b01)		Q	= 2'b01;
	else if(Z[DSIZE:DSIZE-1] == 2'b10)	Q	= 2'b11;
	else								Q	= 2'b00;
	
	if(Q==2'b01)		S = (Z-D)<<1;
	else if(Q==2'b11)	S = (Z+D)<<1;
	else				S = Z<<1;
//	if(Q==2'b11)	$display("Z=%b,D=%b,Q=%b,S=%b",Z,D,Q,S);
end 
endtask	


endmodule


		
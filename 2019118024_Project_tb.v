module tb;
//input : reg or net
wire [511:0] SHA1IN;
reg CLK;
reg nRST, START;
//output : net
wire [159: 0] SHA1OUT;
wire DONE;

assign SHA1IN = 512'h74657374800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020;

assign DONE = 0;
initial
begin
CLK = 0;
nRST = 0;
START = 0;
end
prac pra1(.SHA1IN(SHA1IN), .SHA1OUT(SHA1OUT),.CLK(CLK), .nRST(nRST), .START(START), .DONE(DONE));

always
begin
#5 CLK = ~CLK;
end

initial
begin
 #20 nRST = 1;
 #10 START = 1;
 #10 START = 0;

#2000 $finish;
end

endmodule
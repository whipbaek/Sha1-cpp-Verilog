`timescale 1ns / 1ps

module prac(SHA1IN, SHA1OUT, CLK, nRST, START, DONE);

//in module -> input : net
input [511:0]SHA1IN; // 512bit input
input CLK, nRST, START;

//in module -> output : reg or net
output [159:0] SHA1OUT;
output DONE;
reg [159:0] SHA1OUT;

reg DONE;
reg [31:0] W[79:0];
reg [31:0] H[4:0];
reg state;

always@(negedge nRST)
state = 0;

initial
begin
DONE = 0;
state= 0;
end
//initalize H
initial
begin
H[0] = 32'h67452301;
H[1] = 32'hEFCDAB89;
H[2] = 32'h98BADCFE;
H[3] = 32'h10325476;
H[4] = 32'hC3D2E1F0;
end

initial
begin
W[0] = SHA1IN[511:480];
W[1] = SHA1IN[479:448];
W[2] = SHA1IN[447:416];
W[3] = SHA1IN[415:384];
W[4] = SHA1IN[383:352];
W[5] = SHA1IN[351:320];
W[6] = SHA1IN[319:288];
W[7] = SHA1IN[287:256];
W[8] = SHA1IN[255:224];
W[9] = SHA1IN[223:192];
W[10] = SHA1IN[191:160];
W[11] = SHA1IN[159:128];
W[12] = SHA1IN[127:96];
W[13] = SHA1IN[95:64];
W[14] = SHA1IN[63:32];
W[15] = SHA1IN[31:0];
end

always@(posedge CLK)
begin
if(START)
begin
state = 1;
end
end
//Calculate W[16]  ~ W[79]

integer i;
always@(posedge CLK && START)

begin
for(i = 16; i<80; i = i+1) 
    begin
        W[i] = W[i-3] ^ W[i-8] ^ W[i-14] ^ W[i-16];
        W[i] = (W[i] << 1) | (W[i] >> (32 - 1) ); //rotate shift 
    end

end

reg [31:0] A, B, C, D, E;
reg [31:0] F, K;
reg [31:0] temp;

initial
begin
A = H[0];
B = H[1];
C = H[2];
D = H[3];
E = H[4];

$display("initalize A : %h, B : %h, C : %h, D: %h, E : %h",A,B,C,D,E);
end

reg[7:0] t;
initial t=8'b0000_0000; //



always@(posedge CLK && state) // excute 1operation when CLK is posedge -> at least need 80 CLK (number of full operation is 80)
    begin
            if(0 <= t && t<=19)
                begin
                    F = (B & C) | ((~B) & D);
                    K = 32'h5A827999;
                end
            
            else if(20 <= t && t <= 39)
                begin
                    F = B ^ C ^ D;
                    K = 32'h6ED9EBA1;
                end
                
            else if(40 <= t && t<=59)
                begin
                    F = ((B & C) | (B & D) | (C & D));
                    K = 32'h8F1BBCDC;
                end
                
            else if(60<= t && t<=79)
                begin
                    F = (B ^ C ^ D);
                    K = 32'hCA62C1D6;
                end
                
            
            temp = (A << 5) | (A >> (32-5) );
            temp = temp + F + E + K + W[t];
            $display("[%d] : temp : %h ", t, temp);
            E = D;
            D = C;
            C = ( B << 30) | ( B >> (32-30) );
            B = A;
            A = temp;
            $display(" A : %h, B : %H, C : %H, D : %H, E : %H",A,B,C,D,E);
            
            t = t+8'b0000_0001;
            
    end // end of Always

initial $display("Final A : %h, B : %H, C : %H, D : %H, E : %H",A,B,C,D,E);


reg [159:0] final;
always@(posedge CLK)
begin
if(t==80 && DONE == 0)
    begin
    $display("before : %H %H %H %H %H",H[0], H[1], H[2], H[3], H[4]);
    
        H[0] = H[0] + A;
        H[1] = H[1] + B;
        H[2] = H[2] + C;
        H[3] = H[3] + D;
        H[4] = H[4] + E;
    
        $display("after : %H %H %H %H %H",H[0], H[1], H[2], H[3], H[4]);
        DONE = 1;
        final = {H[0],H[1],H[2],H[3],H[4]};
        SHA1OUT = final;
    end
end

//just one cycle
always@(posedge CLK) if(t==81) DONE = 0;


endmodule
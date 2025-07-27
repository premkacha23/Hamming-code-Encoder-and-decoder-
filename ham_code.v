module ham_code( 
    input       [3:0]  i_data, 
    output  reg [6:0]  hamming_code, 
    input       [6:0]  error_bit, 
    output  reg [6:0]  temp_hamming_code, 
    output  reg [3:0]  o_data, 
    output  reg [2:0]  z_BIT, 
  output  reg two_bit_error, 
  output  reg [6:0]  seg 
); 
 
//PARITY BIT GENERATION  
reg p1, p2, p4; 
 
always@(*) 
begin 
    p1 = i_data[0] ^ i_data[1] ^ i_data[3]; 
    p2 = i_data[0] ^ i_data[2] ^ i_data[3]; 
    p4 = i_data[1] ^ i_data[2] ^ i_data[3]; 
end  
 
 
// HAMMING CODE  
// INPUT  I3 I2 I1 -  -  I0 -          
// CODE   I3 I2 I1 P2 P1 I0 P0 
always@(*) 
begin 
    hamming_code = {i_data[3:1],p4,i_data[0],p2,p1}; 
end 
 
 
 
always@(*)  
begin 
    temp_hamming_code = hamming_code;  
    if (error_bit[0] == 1) begin 
       temp_hamming_code[0] = ~temp_hamming_code[0]; 
    end 
    if (error_bit[1] == 1) begin 
       temp_hamming_code[1] = ~temp_hamming_code[1]; 
    end 
    if (error_bit[2] == 1) begin 
       temp_hamming_code[2]= ~temp_hamming_code[2]; 
    end 
    if (error_bit[3] == 1) begin 
       temp_hamming_code[3] = ~temp_hamming_code[3]; 
    end 
    if (error_bit[4] == 1) begin 
       temp_hamming_code[4] = ~temp_hamming_code[4]; 
    end 
    if (error_bit[5] == 1) begin 
       temp_hamming_code[5] = ~temp_hamming_code[5]; 
    end 
    if (error_bit[6] == 1) begin 
       temp_hamming_code[6] = ~temp_hamming_code[6];  
    end 
end 
      
 
// ERROR CORRECTION      
reg z4, z2, z1; 
      
always @(*) begin 
    z1 = temp_hamming_code[2] ^ temp_hamming_code[4] ^ temp_hamming_code[6] ^ 
temp_hamming_code[0]; 
    z2 = temp_hamming_code[2] ^ temp_hamming_code[5] ^ temp_hamming_code[6] ^ 
temp_hamming_code[1]; 
    z4 = temp_hamming_code[4] ^ temp_hamming_code[5] ^ temp_hamming_code[6] ^ 
temp_hamming_code[3]; 
 
end 
 
 
// ORIGINAL 4-INPUT DATA AS THE OUTPUT  
always @(*) begin 
        o_data[0] = temp_hamming_code[2] ^ (~z4 & z2 & z1); 
        o_data[1] = temp_hamming_code[4] ^ (z4 & ~z2 & z1); 
        o_data[2] = temp_hamming_code[5] ^ (z4 & z2 & ~z1); 
        o_data[3] = temp_hamming_code[6] ^ (z4 & z2 & z1); 
end 
 
always @(*) begin 
        if (o_data == i_data) 
    two_bit_error =0; 
    else 
    two_bit_error =1; 
end 
 
always @(*) begin 
z_BIT ={z4,z2,z1}; 
end 
 
// ERROR DISPLAY ON SEVEN SEGMENT  
always @(*) begin 
if (two_bit_error == 1) 
begin 
seg = 7'b0000110; 
end 
else begin 
        case (z_BIT) 
            3'b000: seg = 7'b1000000; 
            3'b001: seg = 7'b1111001; 
            3'b010: seg = 7'b0100100; 
            3'b011: seg = 7'b0110000; 
            3'b100: seg = 7'b0011001; 
            3'b101: seg = 7'b0010010; 
            3'b110: seg = 7'b0000010; 
            3'b111: seg = 7'b1111000; 
            default:seg = 7'b1111111; 
        endcase 
end 
end 
endmodule 
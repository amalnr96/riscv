// Company           :   tud                      
// Author            :   naam21            
// E-Mail            :   <email>                    
//                    			
// Filename          :   pram_modules.v                
// Project Name      :   prz    
// Subproject Name   :   task    
// Description       :   <short description>            
//
// Create Date       :   Sun Apr  3 23:27:56 2022 
// Last Change       :   $Date$
// by                :   $Author$                  			
//------------------------------------------------------------
`timescale 1ns/10ps

module pram_modules (
    clk,
    w_en,
    pram_en,
    adr_p_mem,
    data_in,
    data_out,
    bm_sel
);

    parameter INITFILE0 = "mem.txt";
     parameter INITFILE1 = "none"; parameter INITFILE2 = "none"; parameter INITFILE3 = "none";
   
    input            clk;
    input            pram_en;
    input            w_en;
    input     [15:0] adr_p_mem;
    input     [31:0] data_in;
    input     [31:0] bm_sel;
      
    output    [31:0] data_out;

    
    wire      [31:0] data_a;
    wire      [31:0] data_b;
    wire      [31:0] data_c;
    wire      [31:0] data_d;
    reg       [3:0]  cs;
    reg      [31:0] data_reg;
    

	//parameter bm_sel = 32'hffff_0000;
	parameter S0 =2'b00;   
	parameter S1 =2'b01;   
	parameter S2 =2'b10;  
	parameter S3 =2'b11; 
	parameter LOW=2'b00;
	
	
	HM_1P_GF28SLP_1024x32_1cr #( .INITFILE (INITFILE0) ) HM_1P_GF28SLP_1024x32_1cr_1 (
					.CLK_I  (clk),
					.ADDR_I (adr_p_mem[11:2]),   //address
					.DW_I   (data_in),          //data to be written
					.BM_I   (bm_sel),            //selects which bit positions to be written
					.WE_I   (w_en),              //write enable
					.RE_I   (w_en),              //read enable
					.CS_I   (cs[0]),
					.DR_O   (data_a),
					.DLYL   (LOW),
					.DLYH   (LOW),
					.DLYCLK (LOW)
				);
				
              
	HM_1P_GF28SLP_1024x32_1cr #( .INITFILE (INITFILE1))  HM_1P_GF28SLP_1024x32_1cr_2 (
					.CLK_I  (clk),
					.ADDR_I (adr_p_mem[11:2]),   //address
					.DW_I   (data_in),          //data to be written
					.BM_I   (bm_sel),            //selects which bit positions to be written
					.WE_I   (w_en),              //write enable
					.RE_I   (w_en),              //read enable
					.CS_I   (cs[1]),             //chip select
					.DR_O   (data_b),
					.DLYL   (LOW),
					.DLYH   (LOW),
					.DLYCLK (LOW)
				);
				

            
	HM_1P_GF28SLP_1024x32_1cr #( .INITFILE (INITFILE2)) HM_1P_GF28SLP_1024x32_1cr_3 (
					.CLK_I  (clk),
					.ADDR_I (adr_p_mem[11:2]), 
					.DW_I   (data_in),        
					.BM_I   (bm_sel),  
					.WE_I   (w_en), 
					.RE_I   (w_en), 
					.CS_I   (cs[2]),
					.DR_O   (data_c),
					.DLYL   (LOW),
					.DLYH   (LOW),
					.DLYCLK (LOW)
				);
				
				
			
	HM_1P_GF28SLP_1024x32_1cr #( .INITFILE (INITFILE3))  HM_1P_GF28SLP_1024x32_1cr_4 (
					.CLK_I  (clk),
					.ADDR_I (adr_p_mem[11:2]),
					.DW_I   (data_in),       
					.BM_I   (bm_sel),  
					.WE_I   (w_en), 
					.RE_I   (w_en), 
					.CS_I   (cs[3]),
					.DR_O   (data_d),
					.DLYL   (LOW),
					.DLYH   (LOW),
					.DLYCLK (LOW)
				);
				
		/*
		always @(posedge clk) begin
        if (prog_en_h) begin
		    sel_pram <= adr_p_mem[13:12];
		    sel_adr <= adr_p_mem[1:0];
			end
		end 
		*/
		
		always @( adr_p_mem or data_a or data_b or data_c or data_d)
		begin
		if    (pram_en) begin
            case (adr_p_mem[13:12])
				S0: begin
				cs= 4'b0001;
				data_reg = data_a;
				end
				S1:begin
				cs= 4'b0010;
				data_reg = data_b;
				end
				S2:begin 
				cs= 4'b0100;
				data_reg = data_c;
				end
				S3:begin 
				cs= 4'b1000;
				data_reg = data_d;
				end
			endcase				
            end
         else cs=4'b0;   
         end
         
	    assign data_out = data_reg;
		
endmodule


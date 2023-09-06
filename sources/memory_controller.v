`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.09.2023 13:39:46
// Design Name: 
// Module Name: mem_cr
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module memory_controller(
         input wire clk, input wire rst,
         //core 
         input wire core_en, input wire [15:0] mem_adr,input wire [15:0] inst_adr, //,input wire [1:0] opType,
         //external        
		 output reg ex_en,//output reg i_bus_we,output reg i_bus_rdy_ex, output reg[15:0] i_bus_addr, output reg[31:0] i_bus_write_data, 
		 //input [31:0] o_bus_read_data,
         //pram         
		 output reg pram_en_inst//,output reg pram_w_en,output reg [15:0] adr_p_mem,output reg [31:0] pram_data_in,input pram_data_out,output  bm_sel
		 ,output reg pram_en_data);
   
 
   
   
   
   always @(posedge clk or negedge rst) begin
        if (!rst) begin
            	    pram_en_data  <=  1'b0;  
		            pram_en_inst  <=  1'b0;
		            ex_en      <=  1'b0;
            end

        else begin
                    if (core_en) begin
		              if (|mem_adr[15:14]) begin
		                  pram_en_data  <=  1'b0;  
		                  ex_en      <=  1'b1;
		              end
		              else if (|inst_adr[15:14]) begin 
		                  pram_en_inst  <=  1'b0;
		                  ex_en      <=  1'b1;
		              end
		              else begin
		                  pram_en_data  <=  1'b1;  
		                  pram_en_inst  <=  1'b1;
		                  ex_en      <=  1'b0;
		              end
		              end
         end
  end
  
  

endmodule


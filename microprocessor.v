`timescale 1ns / 1ps
`define OUTPUT_REG 8'h04
`define MAX_PC 8'h0b
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:50:38 04/10/2024 
// Design Name: 
// Module Name:    microprocessor 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`define OUTPUT_REG 8'h04
`define MAX_PC 8'h0b
module microprocessor(clk, data_out);
	input clk;

	output [7:0] data_out;
	wire [7:0] data_out;
	reg [31:0] instruction_memory [10:0];
	reg [7:0] data_memory [2:0];
	reg [7:0] register_file [31:0];

	reg [7:0] pc;
	reg [31:0] instruction;
	reg [5:0] opcode;
	reg [4:0] rs;
	reg [4:0] rt;
	reg [4:0] rd;
	reg [4:0] shift;
	reg [5:0] function_field;
	reg [7:0] immediate;
	reg [7:0] register_operand_1;
	reg [7:0] register_operand_2;
	reg [7:0] address;
	reg [7:0] lw_read_data;
	reg [2:0] state = 0;

	

	initial begin
		data_memory[0] = 8'b11110110;  // a = -20
		data_memory[1] = 8'b00001010;  // b = 10
		data_memory[2] = 8'b00000010;  // c = 2
	end 

	initial begin
		register_file[0] = 8'b00000000;  // r0 = 0
		register_file[1] = 8'b00000000;  // r1 = 0
		register_file[2] = 8'b00000000;  // r2 = 0
		register_file[3] = 8'b00000000;  // r3 = 0
		register_file[4] = 8'b00000000;  // r4 = 0
		register_file[5] = 8'b00000000;  // r5 = 0
		register_file[6] = 8'b00000000;  // r6 = 0
		register_file[7] = 8'b00000000;  // r7 = 0
		register_file[8] = 8'b00000000;  // r8 = 0
		register_file[9] = 8'b00000000;  // r9 = 0
		register_file[10] = 8'b00000000;  // r10 = 0
		register_file[11] = 8'b00000000;  // r11 = 0
		register_file[12] = 8'b00000000;  // r12 = 0
		register_file[13] = 8'b00000000;  // r13 = 0
		register_file[14] = 8'b00000000;  // r14 = 0
		register_file[15] = 8'b00000000;  // r15 = 0
		register_file[16] = 8'b00000000;  // r16 = 0
		register_file[17] = 8'b00000000;  // r17 = 0
		register_file[18] = 8'b00000000;  // r18 = 0
		register_file[19] = 8'b00000000;  // r19 = 0
		register_file[20] = 8'b00000000;  // r20 = 0
		register_file[21] = 8'b00000000;  // r21 = 0
		register_file[22] = 8'b00000000;  // r22 = 0
		register_file[23] = 8'b00000000;  // r23 = 0
		register_file[24] = 8'b00000000;  // r24 = 0
		register_file[25] = 8'b00000000;  // r25 = 0
		register_file[26] = 8'b00000000;  // r26 = 0
		register_file[27] = 8'b00000000;  // r27 = 0
		register_file[28] = 8'b00000000;  // r28 = 0
		register_file[29] = 8'b00000000;  // r29 = 0
		register_file[30] = 8'b00000000;  // r30 = 0
		register_file[31] = 8'b00000000;  // r31 = 0
	end

	initial begin
		pc = 8'b00000000;
	end

	initial begin
		instruction_memory[0] = 32'b100011_00000_00001_0000000000000000;
		instruction_memory[1] = 32'b100011_00000_00010_0000000000000001;
		instruction_memory[2] = 32'b100011_00000_00011_0000000000000010;
		instruction_memory[3] = 32'b001001_00000_00100_0000000000000000;
		instruction_memory[4] = 32'b001001_00001_00101_0000000000000000;
		instruction_memory[5] = 32'b000000_00101_00010_00110_00000_101010;
		instruction_memory[6] = 32'b000100_00110_00000_0000000000000101;
		instruction_memory[7] = 32'b000000_00100_00101_00100_00000_100001;
		instruction_memory[8] = 32'b000000_00101_00011_00101_00000_100001;
		instruction_memory[9] = 32'b000000_00101_00010_00110_00000_101010;
		instruction_memory[10] = 32'b000101_00110_00000_1111111111111101;
	end

	always @(posedge clk) begin
		case(state) 
			0 :
			begin
				instruction = instruction_memory[pc];
				state = state + 1;
			end
			1 : 
			begin
				opcode = instruction[31:26];
				case(opcode)
					0 : 
					begin
						rs = instruction[25:21];
						rt = instruction[20:16];
						rd = instruction[15:11];
						shift = instruction[10:6];
						function_field = instruction[5:0];
					end
					default : 
					begin
						rs = instruction[25:21];
						rt = instruction[20:16];
						immediate = instruction[7:0];
					end
				endcase
				state = state + 1;
			end
			2 : 
			begin
				register_operand_1 = register_file[rs];
				register_operand_2 = register_file[rt];
				state = state + 1;
			end
			3 :
			begin
				case(opcode)
					0 : begin
							case(function_field)
								6'h2a : begin
									register_file[rd] = $signed(register_operand_1) < $signed(register_operand_2) ? 8'b00000001 : 8'b00000000;
								end
								6'h21 : begin
									register_file[rd] = register_operand_1 + register_operand_2;
								end
							endcase
							pc = pc + 1;
						end
					6'h09 : begin
						register_file[rt] = register_operand_1 + immediate;
						pc = pc + 1;
					end
					6'h05 : begin
						if(register_operand_1 != register_operand_2) begin
							pc = pc + immediate;
						end
						else begin
							pc = pc + 1;
						end
					end
					6'h04 : begin
						if(register_operand_1 == register_operand_2) begin
							pc = pc + immediate;
						end
						else begin
							pc = pc + 1;
						end
					end
					6'h23 : begin
						address = register_operand_1 + immediate;
						pc = pc + 1;
					end
				endcase
				state = state + 1;
			end
			4 : 
			begin
				case(opcode) 
					6'h23 : begin
						lw_read_data = data_memory[address];
					end
				endcase
				state = state + 1;
			end
			5 : 
			begin
				case(opcode)
					6'h23 : begin
						register_file[rt] = lw_read_data;
					end
				endcase
				if(pc >= `MAX_PC) begin
					state = 6;
				end
				else begin
					state = 0;
				end
			end
			6 :
			begin
				$display("%d",$signed(register_file[`OUTPUT_REG]));
				state = state + 1;
			end
		endcase
	end

   assign data_out = register_file[`OUTPUT_REG];
	

endmodule
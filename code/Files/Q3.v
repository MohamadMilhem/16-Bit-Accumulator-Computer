module Q3 (Clk, PC, IR, MBR, MAR, state, TestR);

input Clk;
output PC, IR, MBR, MAR, state, TestR;
reg [15:0] IR, MBR;
reg [7:0] PC, MAR;
reg signed [15:0] Memory [0:127];
reg signed [15:0] GeneralRegs [0:7], TestR;
reg [2:0] state;

parameter dirMem = 2'b00, dirReg = 2'b01, indirReg =  2'b10, constant = 2'b11;
parameter load = 3'b000, store = 3'b001, add = 3'b010, sub = 3'b011, mul = 3'b100, div = 3'b101;

initial begin

	// instructions 
	Memory[10] = 16'b000_000_00_00011111; // load R0, [31]
	Memory[11] = 16'b100_000_00_00100000; // Mul R0, [32]
	Memory[12] = 16'b010_000_00_00011110; // Add R0, [30]
	Memory[13] = 16'b011_000_11_00000001; // Sub R0, +1
	Memory[14] = 16'b000_001_00_00100001; // load R1, [33]
	Memory[15] = 16'b011_001_00_00100010; // Sub R1, [34] 
	Memory[16] = 16'b101_001_01_00000000; // Div R1, R0
	Memory[17] = 16'b001_001_00_00100011; // Store R1, [35]

	
	// data
	Memory[30] = 16'b1111111111111111;  //A = -1
	Memory[31] = 16'b0000000000000011;  //B = 3
	Memory[32] = 16'b0000000000000101;  //C = 5
	Memory[33] = 16'b0000000000001000;  //D = 8
	Memory[34] = 16'b0000000000000100;  //E = 4
		
	// set the program counter to the start of the program
	PC = 10; state = 0;	
end


always @(posedge Clk)begin

	if (state == 0)begin // Calculations for instruction address, moving the address of the next instruction from PC to MAR.

		MAR <= PC;
		state = 1;

	end
	
	else if (state == 1)begin // Fetching instruction.
		
		MBR <= Memory[MAR];
		PC <= PC + 1;
		state = 2;
		
	end


	else if (state == 2)begin // Moving the instruction from MBR to IR.
	
		IR <= MBR;
		state = 3;

	end
	
	
	else if (state == 3)begin // Decode the insturction (execution if there is no memory access / fetching operand if there is momeory access).
	
		if (IR[9:8] == constant)begin // Execution, MODE is constant.
	
			if (IR[15:13] == load)begin
				GeneralRegs[IR[12:10]] <= {{8{IR[7]}}, IR[7:0]}; 
			end
			
			if (IR[15:13] == store)begin
				// there is no store with mode.
			end
			
			if (IR[15:13] == add)begin
				GeneralRegs[IR[12:10]] <= GeneralRegs[IR[12:10]] + {{8{IR[7]}}, IR[7:0]};
			end
			
			if (IR[15:13] == sub)begin
				GeneralRegs[IR[12:10]] <= GeneralRegs[IR[12:10]] - {{8{IR[7]}}, IR[7:0]};
			end
			
			if (IR[15:13] == mul)begin
				GeneralRegs[IR[12:10]] <= GeneralRegs[IR[12:10]] * {{8{IR[7]}}, IR[7:0]};
			end
			
			if (IR[15:13] == div)begin
				GeneralRegs[IR[12:10]] <= {{8{IR[7]}}, IR[7:0]} / GeneralRegs[IR[12:10]];
			end
			state = 0;
			
		end
		
		
		else if (IR[9:8] == dirReg)begin // Execution, MODE is Direct Register.
		
			if (IR[15:13] == load)begin
				GeneralRegs[IR[12:10]] <= GeneralRegs[IR[7:0]];
			end
			
			if (IR[15:13] == store)begin
				// there is no store with this mode.
			end
			
			if (IR[15:13] == add)begin
				GeneralRegs[IR[12:10]] <= GeneralRegs[IR[12:10]] + GeneralRegs[IR[7:0]];
			end
			
			if (IR[15:13] == sub)begin
				GeneralRegs[IR[12:10]] <= GeneralRegs[IR[12:10]] - GeneralRegs[IR[7:0]];
			end
			
			if (IR[15:13] == mul)begin
				GeneralRegs[IR[12:10]] <= GeneralRegs[IR[12:10]] * GeneralRegs[IR[7:0]];
			end
			
			if (IR[15:13] == div)begin
				GeneralRegs[IR[12:10]] <= GeneralRegs[IR[7:0]] / GeneralRegs[IR[12:10]];
			end
			state = 0;			
	
		end
		
		else begin // Memory access is needed, calculation for operand address.
			
			if (IR[9:8] == indirReg)
				MAR <= GeneralRegs[IR[7:0]];
				
			if (IR[9:8] == dirMem)
				MAR <= IR[7:0];
		
			state = 4;
		end
		

	end
	
	
	else if (state == 4)begin // Feching operand from memory / preparations to send data to memory.
	
		if (IR[15:13] == store)
			MBR <= GeneralRegs[IR[12:10]];
	
	
		else 
			MBR <= Memory[MAR];
			
		state = 5;
		
	end
	
	else if (state == 5)begin // executing instruction with memory access.
		
			if (IR[15:13] == load)begin
				GeneralRegs[IR[12:10]] <= MBR;
			end
			
			if (IR[15:13] == store)begin
				TestR <= MBR; // to test store in TestR, Memory[MAR]
			end
			
			if (IR[15:13] == add)begin
				GeneralRegs[IR[12:10]] <= GeneralRegs[IR[12:10]] + MBR;
			end
			
			if (IR[15:13] == sub)begin
				GeneralRegs[IR[12:10]] <= GeneralRegs[IR[12:10]] - MBR;
			end
			
			if (IR[15:13] == mul)begin
				GeneralRegs[IR[12:10]] <= GeneralRegs[IR[12:10]] * MBR;
			end
			
			if (IR[15:13] == div)begin
				GeneralRegs[IR[12:10]] <= MBR / GeneralRegs[IR[12:10]];
			end
			state = 0;			
	
	end		
		

	

end

endmodule

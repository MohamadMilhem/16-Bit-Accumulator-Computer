module Q2 (Clk, PC, IR, MBR, MAR, state, TestR);

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
	Memory[10] = 16'b000_000_00_00010100; // Load R0, [20]
	Memory[11] = 16'b000_001_11_00010101; // Load R1,21
	Memory[12] = 16'b010_000_10_00000001; // add R0, [R1]
	Memory[13] = 16'b000_001_00_00010110; // load R1, [22]
	Memory[14] = 16'b011_001_11_00001000; // Sub R1, +8
	Memory[15] = 16'b010_000_01_00000001; // Add R0,R1
	Memory[16] = 16'b001_000_00_00010111; // Store R0, [23]
	
	
	// data
	Memory[20] = 16'd6;
	Memory[21] = 16'd4;
	Memory[22] = 16'd13;
	Memory[23] = 16'd0;
	Memory[24] = 16'd0;
	
	
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
	
	else if (state == 5)begin 	// executing instruction with memory access.
		
			if (IR[15:13] == load)begin
				GeneralRegs[IR[12:10]] <= MBR;
			end
			
			if (IR[15:13] == store)begin
				TestR <= MBR; // we should store in Memory[MAR] but to test we store in TestR. 
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

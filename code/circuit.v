module circuit(cout, sum, A, B, cin, sel);
	
	input A, B, cin, sel;
	
	output sum, cout;
	
	wire muxOutput;
	
	
	mux2to1(muxOutput, B, ~B, sel);
	Full_Adder(cout, sum, A, muxOutput, cin);
	



endmodule

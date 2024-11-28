module mux2to1(F, A, B, S);
input A,B,S;
output reg F;

always@(A,B,S)begin
	if (S == 0)
		F = A;
	else
		F = B;
end

endmodule

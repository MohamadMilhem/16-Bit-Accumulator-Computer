module FA(I0, I1, Cin, sum, Cout);
input I0,I1, Cin;
output reg sum, Cout;


always @(*)
begin
	{Cout, sum} = I0 + I1 + Cin;
end

endmodule

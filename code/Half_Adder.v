module Half_Adder(cout, sum, A,B);
input A,B;
output cout, sum;

xor(sum , A, B);
and(cout, A, B);

endmodule

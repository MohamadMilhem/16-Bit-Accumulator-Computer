module Full_Adder(cout, sum, A,B, cin);

input A,B,cin;
output sum, cout;
wire firstCarry, firstSum, secondCarry;

Half_Adder(firstCarry, firstSum, A, B);
Half_Adder(secondCarry, sum , firstSum, cin);
or(cout, firstCarry, secondCarry);



endmodule 

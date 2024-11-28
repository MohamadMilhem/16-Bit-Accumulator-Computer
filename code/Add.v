module Add(A, B, C);

input A,B;
output C;

wire [15:0] A,B;
reg [15:0] C;

always @(A,B) begin
	if (A[15] == 1) begin
		if (B[15] == 1)begin
			C <= {1'b1, A[14:0] + B[14:0]};
		end
		else begin
			if (A[14:0] > B[14:0])begin
				C <= {1'b1, A[14:0] - B[14:0]};
			end
			else begin
				C <= {1'b0, B[14:0] - A[14:0]};
			end
		end
	end
	else begin
		if (B[15] == 0)begin
			C <= {1'b0, A[14:0] + B[14:0]};
		end
		else begin
			if (A[14:0] >= B[14:0]) begin
				C <= {1'b0, A[14:0] - B[14:0]};
			end
			else begin
				C <= {1'b1, B[14:0] - A[14:0]};
			end
		end
	end
		

end
endmodule

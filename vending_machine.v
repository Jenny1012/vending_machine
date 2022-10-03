module vending_machine(clk, reset, howManyTicket, origin, destination, money, costOfTicket, moneyToPay, totalMoney);
parameter s0 = 3'd0 ;
parameter s1 = 3'd1 ;
parameter s2 = 3'd2 ;
parameter s3 = 3'd3 ;
input clk, reset ;
input[2:0] howManyTicket, origin, destination ;
input[5:0] money ;
output[6:0] costOfTicket, moneyToPay, totalMoney ;
reg[6:0]  costOfTicket, moneyToPay, totalMoney, giveChange ;
reg [2:0] state, next_state ;

always @(posedge clk or posedge reset )  // 做狀態的改變
begin
	if(reset)
	begin
		state = s0 ;
	end
	else
	begin
		//if(moneyToPay>0)  // 若還沒付夠錢
		//begin
		//	state = s1 ;
		//end
		
		//else                        // 付夠了or還沒付
		//begin
			state = next_state ;
		//end
	end
	
end

always @(state)
begin
	case(state)
	s0:   //全部歸零
	begin
		moneyToPay = 0 ;
		costOfTicket = 0 ;
		totalMoney = 0 ;
	end
	s1: 
	begin
		if(destination-origin<0)  //若終點站比起始站小
		begin
			costOfTicket = howManyTicket * ((origin-destination)*5 + 5 );
		end
		else
		begin
			costOfTicket = howManyTicket * ((destination-origin)*5 + 5 );
		end
	end
	
	s2: 
	begin
		totalMoney = money + totalMoney ;
		if(costOfTicket<totalMoney) // 沒有欠錢
		begin
			moneyToPay = 0 ; 
		end
		
		else
		begin
			moneyToPay = costOfTicket - totalMoney ;  // 還沒付完
		end
		$display( "totalMoney = %d,    moneyToPay =  %d \n", totalMoney, moneyToPay );
	end
	
	s3:
	begin
	    if(totalMoney >= costOfTicket)
		begin
			giveChange = totalMoney - costOfTicket ;  // 找錢
		end
		$display( "giveChange = %d \n", giveChange );
		$display( "howManyTicket = %d \n", howManyTicket );
	end
	endcase

end

always @(state)
begin
	case(state)
		s0: 
		begin
			if(origin && destination)  // 若有起終點站
			begin
			next_state = s1 ;
			end
			else
			begin
				next_state = next_state ;
			end
		end
		
		s1:
		begin
			if(howManyTicket>0 && howManyTicket < 6)  // 張數要為1~5張
			begin
				next_state = s2 ;
			end
			
			else
			begin
				next_state = next_state ;
			end
		end
		
		s2: 
		begin
			if(totalMoney>=costOfTicket)  // 付完錢了
			begin
				next_state = s3 ;
			end
			
			else
			begin
				next_state = next_state ;
			end
		end
		
		s3: next_state = s0 ;
	endcase

end

endmodule



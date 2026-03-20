`default_nettype none

module tt_um_verilog_test (
    input  wire [7:0] ui_in,    // ui_in[3:0] είναι ο δυαδικός αριθμός (0-9)
    output wire [7:0] uo_out,   // uo_out[6:0] ελέγχει τα τμήματα a-g της οθόνης
    input  wire [7:0] uio_in,   
    output wire [7:0] uio_out,  
    output wire [7:0] uio_oe,   
    input  wire       ena,      
    input  wire       clk,      
    input  wire       rst_n     
);

   // Ελέγχουμε εάν ο αριθμός είναι μεγαλύτερος απο την τιμή 9 στην είσοδο ui_in[3:0] (δηλ. 1010 έως 1111)
  wire invalid = (ui_in[3] & ui_in[1]) | (ui_in[3] & ui_in[2]);

  // Αντιστοιχούμε τον 4-bit αριθμό στα 7 segments (a,b,c,d,e,f,g)
  reg [6:0] segments;

  always @(*) begin
    case (ui_in[3:0])
      4'h0: segments = 7'b0111111; // 0
      4'h1: segments = 7'b0000110; // 1
      4'h2: segments = 7'b1011011; // 2
      4'h3: segments = 7'b1001111; // 3
      4'h4: segments = 7'b1100110; // 4
      4'h5: segments = 7'b1101101; // 5
      4'h6: segments = 7'b1111101; // 6
      4'h7: segments = 7'b0000111; // 7
      4'h8: segments = 7'b1111111; // 8
      4'h9: segments = 7'b1101111; // 9
      default: segments = 7'b1000000; // Παύλα (-) για λάθος είσοδο
    endcase
  end

  // Ανάθεση εξοδου: Τα 7 segments στα LED και το 8ο LED δείχνει αν η είσοδος είναι > 9
  assign uo_out[6:0] = segments;
  assign uo_out[7]   = invalid; 

  // Λοιπές υποχρεωτικές αναθέσεις
  assign uio_out = 8'b0;
  assign uio_oe  = 8'b0;
  wire _unused = &{ena, clk, rst_n, uio_in, 1'b0};

endmodule

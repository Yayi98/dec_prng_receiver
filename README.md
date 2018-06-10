# dec_prng_receiver

This is a design for calculating BER by receiving an input of LVDS stream of serialized random data using the same prng module used in
enc_prng_transmitter repository with the same seed. The incoming data is deserialized using the xilinx primitive ISERDESE2 with 10:1
deserialization using the primitive in a master slave configuration and the deserialized data is 'xor'ed with the output of the prng
module to count the number of bits transmitted incorrectly.

NOTE :-
  

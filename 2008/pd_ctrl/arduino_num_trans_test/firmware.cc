void setup(){
	Serial.begin(9600);
}

void loop(){
	byte * byteptr;
	int incomByte;

	if( Serial.available() > 0 ){
		incomByte = Serial.read();

		switch (incomByte){
			case 'p':
				{				
				Serial.print("rec p");
				break;
				}
			case 'v':
				{
				Serial.print("rec v");
				break;
				}
			case 'b':
				{
				int test_si = -77;
				byteptr = (byte*) &test_si;
				Serial.print(byteptr[0],BYTE);
				Serial.print(byteptr[1],BYTE);
				break;
				}
			case 'u':
				{
				unsigned int test_ui = 55111;
				byteptr = (byte*) &test_ui;
				Serial.print(byteptr[0],BYTE);
				Serial.print(byteptr[1],BYTE);
				break;
				}
			case 'f':
				{
				float testf = 15.019;
				byteptr = (byte*) &testf;

				Serial.print(byteptr[0], BYTE);
				Serial.print(byteptr[1], BYTE);
				Serial.print(byteptr[2], BYTE);
				Serial.print(byteptr[3], BYTE);
				break;
				}
			case 'x':
				{
				Serial.print("rec x");
				while(Serial.available() < 2){

				}
				if(Serial.available() >= 2){
					int sint;
					byte* sintptr = (byte*) &sint;
					byte incomdata[2];
					for(int i = 0; i < 2; i++){
						incomdata[i] = Serial.read();
						sintptr[i] = incomdata[i];
					}
					Serial.print("sint: ");
					Serial.println(sint,DEC);
				}
				else{
					Serial.print("not enough bytes to convert");
				}
				break;
				}
		}
	}

}

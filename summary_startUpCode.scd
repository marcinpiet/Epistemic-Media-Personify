//code for everyone

(
~cycleLength = 8;
//start up code for everyone
//start the server
s.waitForBoot({
	//level meeter
	s.meter;
	//how many seconds are we listening to?
	~memorySize = 6; //set it to desired value
	//buffer
	~buffer = Buffer.alloc(s, s.sampleRate * ~memorySize);
	//load all the processes
	"processes.scd".loadRelative;
	//visualise the buffer if there is anything recording
	//server window
	s.makeWindow;
	//recording and visualisation task defined at the start up
	//visualise the recording buffer
	Tdef(\bufferVisualisation, {
		loop{
			~buffer.getToFloatArray(wait:0.01,action:{arg array; { p.value = array; }.defer;});
			0.01.wait;
		}
	});
	Tdef(\record, {
		//we are running the process once for given duration
		1.do{
			~buffer.free;
			0.1.wait;
			~buffer = Buffer.alloc(s, s.sampleRate * ~memorySize);

			//listener is defined here, it's hacky
		Ndef(\listener, {arg rate=1;
			//listens to incoming audio
			var in = SoundIn.ar(0);
			//writes into a buffer
			BufWr.ar(
				inputArray: in,
				bufnum:  ~buffer,
				phase: Phasor.ar(
					trig: 0,
					rate:  BufRateScale.kr(~buffer) * rate,
					start: 0, end: BufFrames.kr(~buffer)),
				loop: 0);
			//doesn't play anything only listens
			0.0 //quiet
		}).play;
			//play the visualisation of the buffer
		Tdef(\bufferVisualisation).play;
		"recording".postln;
		~memorySize.wait;
			//free the listener, stop recording, stop visualisation
		Ndef(\listener).free; Tdef(\bufferVisualisation).stop; "recording stopped".postln;
		{ b.valueAction = 0 }.defer;
	} }
	);
	//listener GUI
	w = Window("_LISTENER", bounds: Rect(10, 600, 300, 300), resizable: false);
	//set the recording time
	t = StaticText(w, Rect(5, 5, 100, 40));
	t.string = "_set recording time (seconds)";
	t.background = Color.white;
	n = NumberBox(w, Rect(110, 5, 30, 20));
	n.value = ~memorySize;
	n.action = {arg numb;
		~memorySize = numb.value;
		Ndef(\granular).addSpec(\pos, [0, ~memorySize, \lin]);
	};
	//record button
	b = Button(w, Rect(110, 25, 180, 20));
	b.states = [["RECORD", Color.grey, Color.white], ["RECORDING", Color.white, Color.red]];
	b.action = {|button|
		var st = button.value; st.postln;
		switch(st,
			0, {},
			1, {Tdef(\record).play;}
		)
	};
	p = Plotter("live buffer monitor", Rect(5, 50, 290, 200), w);
	p.plotMode = \linear;
	p.plotColor = Color.red;
	p.normalized = 1;

	w.front;

});
);

///include this in the record function
(
Routine({
    var i = 0;
    while({ i < ((~cycleLength * 60)+2) }, {
        i.postln; // gibt die Zahlen von 0 bis 9 aus
        i = i + 1;
        1.wait; // wartet 1 Sekunde
		if (i > (~cycleLength*60)) {
			Ndef.clear;
        }
    });
}).play;
)



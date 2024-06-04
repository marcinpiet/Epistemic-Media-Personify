~data = [
	[ 0.97, 0.05, -0.22, 0.19, 0.53, -0.21, 0.54, 0.1, -0.35, 0.04 ],
	[ -0.07, 0.19,  0.67, 0.05, -0.91, 0.1,  -0.8, -0.21, 1, -0.17 ],
	[ 0.67, -0.05, -0.07, -0.05, 0.97, -0.65, -0.21, -0.8, 0.79, 0.75 ]
]; 

//quering the data
~data.size;
//check methods for the Array object;
//cmd + d
Array;
//.shape method gives the number of dimensions and number of elements in each dimension
~data.shape;
//check what kind of objects the data set holds, only first dimension
~data.dump;

//to look inside each dimension
~data[0]; //returns level 0
~data[1]; //returns level 1
~data[2]; //returns level 2
~data[3]; //returns nil because the ~data Array is composed of 3 objects

//we need to iterate over them
//size of each layer
~data.size.collect{|i| ~data[i].size };
//check the type of objects inside each of the layers
~data.size.collect{arg i; ~data[i].dump };
//check the smallest and the biggest value of the inner arrays
~data[0].minItem; //smallest
~data[0].maxItem; //maximum 

//iterate over all of the arrays and return minimum and maximum
~data.size.collect{arg i; [~data[i].minItem, ~data[i].maxItem]  };

//plot sub arrays
//by default plot draws continuous lines
~data.size.collect{|i|  ~data[i].plot(name: "data subset " + (1 + i), discrete: false ) };
//change the plot to dicrete points
~data.size.collect{|i|  ~data[i].plot(name: "data subset " + (1 + i), discrete: true ) };
//use Plotter for more visualisation possibilities
~plotter = Plotter("the plot", Rect(600, 30, 800, 250));
~plotter.value = ~data[0];
//change the plot mode and refresh the view
(
~plotter.plotMode = \bars; 
~plotter.refresh;
);

//plot all arrays on one gui
plot(~data).plotMode_(\bars);

//sonification!!!!!

//start the audio server
//three ways
//1. in the code
s.boot;
//2.from top menu - Server/boot server
//3.as a shortcut cmd + b

//define the synthesis
(
SynthDef(\sine, { 
	arg freq = 440, amp = 0.1, sustain = 1.0, out = 0;
	var sound = LFSaw.ar(freq);
	//var env = EnvGen.kr(Env.perc(0.01, sustain, amp), doneAction: 2);
	Out.ar(out, sound);
}).add;
);

//test the synth
Synth(\sine);

// define a mapping from number value to frequency:
//mapping rescalles values of the original data into the desired range
~mapping = { arg val; val.linexp(-1, 1, 250, 1000) };
//an example of mapping, rescalling of values
~data[0].linlin(-1, 1, 20, 200);

//define a task to iterate over data and map it into synthesis argument
(
~sonificationTask = Task {
	//declare a variable
	var dimension = ~data[0]; // first dimension of data
	
	//iterate over values, rescalle them and set the frequency argument of the SynthDef \sine
	//.do = one iteration
	dimension.do { |val|
		(instrument: \sine, freq: ~mapping.value(val)).play;
		//wait between each step of the iteration
		0.03.wait;
	}
};
)

~sonificationTask.play;

//looping Task
(
~sonificationTask = Task {
	//declare a variable
	var dimension = ~data[0]; // first dimension of data
	
	//iterate over values, rescalle them and set the frequency argument of the SynthDef \sine
	
	//loop over iterations 
	loop{
		dimension.do { |val|
			(instrument: \sine, freq: ~mapping.value(val)).play;
			//wait between each step of the iteration
			0.5.wait;
		};
		//wait between relooping
		1.wait;
	};
};
);

~sonificationTask.play;
~sonificationTask.pause;
~sonificationTask.resume;
~sonificationTask.stop;

(
~sonificationTask = Task {
	
	loop{
	~data.do { |dimension|
		dimension.do { |val|
			(instrument: \sine, freq: ~mapping.value(val) * 2.0.rand2).play;
			0.001.wait;
		};
		0.1.wait;
	};
		0.5.wait;
	}
	
};
)

~sonificationTask.play;
~sonificationTask.pause;
~sonificationTask.resume;
~sonificationTask.stop;

//mapping swap
~mapping = { arg val; val.linexp(-1, 1, 250, 1000) };
//variation
~mapping = { |x| x.linexp(-1, 1, 250, 1000) }; // mapping as it was
~mapping = { |x| x.linexp(-1, 1, 500, 1000) };  // narrower
~mapping = { |x| x.linexp(-1, 1, 50, 10000) }; // much wider
//super narrow in upper spectra
~mapping = { |x| x.linexp(-1, 1, 500, 510) }; // much wider




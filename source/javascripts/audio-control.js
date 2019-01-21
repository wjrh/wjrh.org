

var audioElement = document.createElement('audio');
//audioElement.src = "http://wjrh.org:8000/WJRHlow";
audioElement.src = "http://wjrh.org:8000/RoboDJ";
audioElement.preload = 'none';

var playClicked = false;
var loaded = false;

//plays wjrh audio
function PlayAudio()
{
	var listenButton = document.getElementById('listen-button');
	playClicked = true;
	listenButton.innerHTML = "<i class=\"fa fa-2x fa-fw fa-spinner fa-spin\"></i>";
	audioElement.load;
	audioElement.play();
	if(loaded){
		liveOnAir();
	}
}

//pauses wjrh audio
function PauseAudio()
{
	var listenButton = document.getElementById('listen-button');
	audioElement.pause();
	listenButton.innerHTML = "<i class=\"fa fa-2x fa-fw fa-play\"></i>";
}

//this is the action that comes from the toggle button
function togglePlay() {
	if (audioElement.paused) {
		PlayAudio();
	} else {
		PauseAudio();
	}
}

//called when we want "live on air" displayed on the button
function liveOnAir(){
	var listenButton = document.getElementById('listen-button');
	listenButton.innerHTML = "<i class=\"fa fa-2x fa-fw fa-pause\"></i>";
}

//called by the audio element when the data is loaded enough to play
audioElement.onloadeddata = function() {
	loaded = true;
	if (playClicked){
		liveOnAir();
	}
};
$(document).on('page:change', function(event) {
	var listenButton = document.getElementById('listen-button');
	if (audioElement.paused) {
		listenButton.innerHTML = "<i class=\"fa fa-2x fa-fw fa-play\"></i>";
	} else {
		listenButton.innerHTML = "<i class=\"fa fa-2x fa-fw fa-pause\"></i>";
	}
});

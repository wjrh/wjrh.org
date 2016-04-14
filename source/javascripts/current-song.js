// var source = new EventSource("https://api.teal.cool/organizations/wjrh/live");
// source.onmessage = function(update) {
// 		if update.data.update.type == "track-log" {
//     	document.getElementById("djdata").innerHTML = update.data.update.episode.program.name + " with " + update.data.update.episode.program.author;
//     	document.getElementById("songdata").innerHTML = update.data.update.track.title + " by " + update.data.update.track.artist;
//     } else if update.data.update.type == "episode-start" {
//     	document.getElementById("djdata").innerHTML = update.data.update.episode.program.name + " with " + update.data.update.episode.program.author;
//     } else if update.data.update.type == "episode-end"{
//     	//epsode has ended do something to respond to that.
//     } else {
//     	//probably a ping?
//     }
// };

//recurring refreshes
setInterval( "updateSongInfo();", 4000 );

$(function() {
	updateSongInfo = function(){

		var djdata = document.getElementById('djdata');
		$('#djdata').load("http://wjrh.org/show_dj.php").fadeIn("slow");
		$('#songdata').load("http://wjrh.org/show_song.php").fadeIn("slow");
	}
});

//first refresh
$(document).ready(function(){
	var djdata = document.getElementById('djdata');
	$('#djdata').load("http://wjrh.org/show_dj.php").fadeIn("slow");
	$('#songdata').load("http://wjrh.org/show_song.php").fadeIn("slow");
});


var checkData = function(){
	if (($("#songdata").text().length + $("#djdata").text().length > 160) || $("#djdata").text() == "WJRH RoboDJ\n"){
		$("#nowplaying-dj").hide();
	} else {
		$("#nowplaying-dj").show();
	}
}


$( document ).ajaxComplete(function() {
  checkData();
});

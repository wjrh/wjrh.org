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

		// var djdata = document.getElementById('djdata');
		// $('#djdata').load("https://wjrh.org/show_dj.php").fadeIn("slow");
		// $('#songdata').load("https://wjrh.org/show_song.php").fadeIn("slow");

		$.getJSON("https://api.teal.cool/organizations/wjrh/latest", function( data ) {
			println(data);
		  if (data.event === "track-log") {
		  	$("#nowplaying-dj").show();
		  	$("#nowplaying-song").show();
		  	$('#djdata').html(data.program.author);
		  	$('#songdata').html(track.artist + " - " + track.title);
		  } else if (data.event === "episode-start") {
		  	$("#nowplaying-dj").show();
		  	$("#nowplaying-song").hide();
				$('#djdata').html(data.program.author);
		  } else if (data.event === "episode-end"){
		  	$("#nowplaying-dj").hide();
		  	$("#nowplaying-song").hide();
		  } else {}
	  });
});

//first refresh
	updateSongInfo();
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

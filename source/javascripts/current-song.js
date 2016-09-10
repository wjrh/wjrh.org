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


var updateSongInfo = function(){
		$.getJSON("https://api.teal.cool/organizations/wjrh/latest", function( data ) {
			console.log("latest events updated");
		  if (data.event === "track-log") {
		  	$("#nowplaying-dj").show();
		  	$("#nowplaying-song").show(); 
		  	$('#djdata').html(data.program.name + " with " + data.program.author);
		  	$('#songdata').html(data.track.artist + " - " + data.track.title);
		  } else if (data.event === "episode-start") {
		  	$("#nowplaying-dj").show();
		  	$("#nowplaying-song").hide();
				$('#djdata').html(data.program.name + " with " + data.program.author);
		  } else if (data.event === "episode-end"){
		  	$("#nowplaying-dj").show();
		  	$("#nowplaying-song").hide();
		  	$('#djdata').html("WJRH RoboDJ");
		  } else {}
	  })
	}

$(document).ready(function(){
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
